import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/whatsapp.dart';
import '../../online/api.dart';
import '../../online/doc_models.dart';
import '../../online/models.dart';
import '../../online/online_providers.dart';
import '../../online/realtime.dart';
import '../common.dart';
import '../documents/page_picker_screen.dart';

/// Message d'erreur à montrer : traduit pour les refus connus, sinon celui du serveur.
String onlineError(BuildContext context, Object error) {
  final l = context.l10n;
  if (error is! ApiException) return l.errServer;
  return switch (error.code) {
    'NETWORK' || 'TIMEOUT' => l.errNetwork,
    'SERVER' => l.errServer,
    'HAND_TAKEN' => l.errHandTaken,
    'LOCKED' => l.errLocked,
    'TOO_LATE' || 'NOT_OPEN' => l.errTooLate,
    'NO_HAND' => l.errNoHand,
    'FULL' => l.errFull,
    'SERVER_BUSY' => l.errServerBusy,
    'UNKNOWN_CODE' => l.errUnknownCode,
    'BAD_CODE' => l.errBadCode,
    'BANNED' => l.errBanned,
    'AUTH_010' => l.errRateLimited,
    'QUESTIONS' => l.errQuestions,
    'QUESTIONS_PENDING' => l.errQuestionsPending,
    'PAGES' => l.errPages,
    'HOST' => l.errHost,
    'FORBIDDEN' => error.message,
    _ => error.message,
  };
}

/// Lance [action] et montre l'éventuel refus du serveur. Rend le résultat, ou null en cas d'échec.
Future<T?> runOnline<T>(BuildContext context, Future<T> Function() action) async {
  try {
    return await action();
  } catch (e) {
    if (context.mounted) context.toast(onlineError(context, e));
    return null;
  }
}

/// Lien d'invitation (page du serveur : ouvre l'application, le navigateur ou l'installation).
String inviteLink(WidgetRef ref, String code, String lang) {
  final server = ref.read(serverUrlProvider).replaceAll(RegExp(r'/+$'), '');
  return lang == 'en' ? '$server/genie-en-herbe/join/$code' : '$server/genie-en-herbe/rejoindre/$code';
}

/// Le code d'une partie, en grand, avec son QR code et les boutons d'invitation.
class CodeShareCard extends ConsumerWidget {
  const CodeShareCard({super.key, required this.code, required this.shareText, this.title});

  final String code;
  final String shareText;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final link = inviteLink(ref, code, context.lang);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title ?? l.lobbyCode, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            SelectableText(
              code,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 6,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            // Le QR code reste noir sur blanc (lisible par tous les appareils photo, même en thème sombre).
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: QrImageView(data: link, size: 150, backgroundColor: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(l.lobbyShareHint, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.chat),
                  label: Text(l.lobbyShareWhatsApp),
                  onPressed: () async {
                    final text = '$shareText\n$link';
                    if (!await openWhatsApp(text)) await SharePlus.instance.share(ShareParams(text: text));
                  },
                ),
                IconButton(
                  tooltip: l.share,
                  icon: const Icon(Icons.share),
                  onPressed: () => SharePlus.instance.share(ShareParams(text: '$shareText\n$link')),
                ),
                IconButton(
                  tooltip: l.copy,
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) context.toast(l.copied);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compte à rebours d'après l'horloge du SERVEUR ; se redessine dix fois par seconde.
class ServerCountdown extends StatefulWidget {
  const ServerCountdown({super.key, required this.clock, required this.deadline, required this.builder});

  final ServerClock clock;
  final int? deadline;
  final Widget Function(BuildContext context, int remainingMs) builder;

  @override
  State<ServerCountdown> createState() => _ServerCountdownState();
}

class _ServerCountdownState extends State<ServerCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.clock.remaining(widget.deadline));
}

// ------------------------------------------------------------------ pages au programme

/// Les pages choisies pour un match ou un tournoi : libellé, nombre de questions prêtes,
/// bouton pour les changer ([PagePickerScreen]). Prépare les questions des pages choisies.
class PagesField extends ConsumerStatefulWidget {
  const PagesField({super.key, required this.selection, required this.onChanged, this.requiredCount});

  final PageSelection selection;
  final ValueChanged<PageSelection> onChanged;

  /// Nombre de questions voulu : affiche si les pages en donnent assez.
  final int? requiredCount;

  @override
  ConsumerState<PagesField> createState() => _PagesFieldState();
}

class _PagesFieldState extends ConsumerState<PagesField> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(covariant PagesField old) {
    super.didUpdateWidget(old);
    _schedule();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  /// Tant que l'IA prépare des questions de ces pages, leur état est relu régulièrement.
  void _schedule() {
    final pending = widget.selection.pendingAi > 0;
    if (!pending) {
      _poll?.cancel();
      _poll = null;
      return;
    }
    _poll ??= Timer.periodic(const Duration(seconds: 8), (_) async {
      try {
        final fresh = await ref.read(onlineServiceProvider).questionStatus(widget.selection.pageIds);
        if (mounted) widget.onChanged(widget.selection.refreshed(fresh));
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sel = widget.selection;
    final ready = sel.readyQuestions;
    final enough = widget.requiredCount == null || ready >= widget.requiredCount!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sel.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.createNoPages, style: Theme.of(context).textTheme.bodySmall),
          )
        else
          Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(sel.label(context)),
              subtitle: Text(sel.pendingAi > 0 ? l.pagesAiPending(ready, sel.pendingAi) : l.pagesReady(ready)),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                tooltip: l.pagesClear,
                onPressed: () => widget.onChanged(PageSelection.empty),
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: Icon(sel.isEmpty ? Icons.add : Icons.edit_outlined),
            label: Text(sel.isEmpty ? l.createChoosePages : l.createChangePages),
            onPressed: () async {
              final picked = await PagePickerScreen.open(context, initial: sel);
              if (picked != null) widget.onChanged(picked);
            },
          ),
        ),
        if (!sel.isEmpty && !enough)
          Text(
            sel.pendingAi > 0 ? l.createWaitQuestions : l.createNotEnough,
            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
          ),
      ],
    );
  }
}

// ------------------------------------------------------------------ joueurs, équipes

/// Recherche d'un joueur par pseudo (pour l'inviter dans une équipe).
class PlayerSearchDialog extends ConsumerStatefulWidget {
  const PlayerSearchDialog({super.key});

  static Future<({int id, String pseudo})?> show(BuildContext context) =>
      showDialog<({int id, String pseudo})>(context: context, builder: (_) => const PlayerSearchDialog());

  @override
  ConsumerState<PlayerSearchDialog> createState() => _PlayerSearchDialogState();
}

class _PlayerSearchDialogState extends ConsumerState<PlayerSearchDialog> {
  List<({int id, String pseudo, bool busy})> _found = const [];
  Timer? _debounce;
  String _q = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String q) {
    _q = q;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (q.trim().length < 2) {
        setState(() => _found = const []);
        return;
      }
      try {
        final r = await ref.read(onlineServiceProvider).searchPlayers(q.trim());
        if (mounted && q == _q) setState(() => _found = r);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.teamInvite),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: l.teamInviteSearch, prefixIcon: const Icon(Icons.search)),
              onChanged: _search,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final p in _found)
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(p.pseudo),
                      subtitle: p.busy ? Text(l.teamInviteBusy) : null,
                      onTap: () => Navigator.pop(context, (id: p.id, pseudo: p.pseudo)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel))],
    );
  }
}

/// Demande un nom (équipe, tournoi). Rend null si annulé.
Future<String?> askName(BuildContext context, String title, {String initial = '', String? label}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 40,
        decoration: InputDecoration(labelText: label),
        onSubmitted: (v) => Navigator.pop(c, v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(c.l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(c, controller.text.trim()), child: Text(c.l10n.confirm)),
      ],
    ),
  );
}

Future<bool> confirmDialog(BuildContext context, String title, {String? body, String? action}) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: body == null ? null : Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(c.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(action ?? c.l10n.confirm)),
        ],
      ),
    ) ==
    true;

/// Une équipe, avec ce que le joueur courant peut y faire (capitaine, membre, extérieur).
///
/// [onAction] reçoit `invite`, `request`, `accept`, `decline`, `leave`, `rename` et,
/// pour `accept` / `decline`, le joueur concerné (null = soi-même).
class TeamPanel extends StatelessWidget {
  const TeamPanel({
    super.key,
    required this.team,
    required this.myPlayerId,
    required this.onAction,
    this.open = true,
    this.canAsk = false,
    this.maxSize,
    this.score,
    this.highlight = false,
  });

  final TeamState team;
  final int? myPlayerId;
  final void Function(String action, {int? playerId}) onAction;

  /// Inscriptions ouvertes (sinon lecture seule).
  final bool open;

  /// Le joueur courant, sans équipe, peut demander à entrer.
  final bool canAsk;
  final int? maxSize;
  final int? score;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final captain = team.captainId == myPlayerId;
    final member = team.hasMember(myPlayerId ?? -1);
    final myPending = team.pending.where((p) => p.playerId == myPlayerId).firstOrNull;
    final full = maxSize != null && team.members.length >= maxSize!;
    return Card(
      shape: highlight
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.groups_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(team.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                if (score != null) Text(l.playPoints(score!), style: const TextStyle(fontWeight: FontWeight.w700)),
                if (open && captain)
                  IconButton(
                    tooltip: l.teamRename,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () => onAction('rename'),
                  ),
              ],
            ),
            for (final m in team.members)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        m.id == team.captainId ? '${m.pseudo} (${l.teamCaptain})' : m.pseudo,
                        style: TextStyle(fontWeight: m.id == myPlayerId ? FontWeight.w700 : null),
                      ),
                    ),
                    if (open && captain && m.id != myPlayerId)
                      TextButton(onPressed: () => onAction('decline', playerId: m.id), child: Text(l.teamRemove)),
                  ],
                ),
              ),
            if (open)
              for (final p in team.pending)
                if (captain || p.playerId == myPlayerId)
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      Expanded(
                        child: Text(
                          '${p.pseudo} — ${p.kind == 'invited' ? l.teamInvited : l.teamRequested}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      // Le capitaine accepte une demande ; l'invité accepte son invitation.
                      if ((captain && p.kind == 'requested') || (p.playerId == myPlayerId && p.kind == 'invited'))
                        TextButton(
                          onPressed: () => onAction('accept', playerId: captain ? p.playerId : null),
                          child: Text(l.teamAccept),
                        ),
                      TextButton(
                        onPressed: () => onAction('decline', playerId: captain ? p.playerId : null),
                        child: Text(l.teamDecline),
                      ),
                    ],
                  ),
            if (open)
              Wrap(
                spacing: 4,
                children: [
                  if (captain && !full)
                    TextButton.icon(
                      icon: const Icon(Icons.person_add_alt),
                      label: Text(l.teamInvite),
                      onPressed: () => onAction('invite'),
                    ),
                  if (canAsk && !member && myPending == null && !full)
                    TextButton.icon(
                      icon: const Icon(Icons.login),
                      label: Text(l.teamAskJoin),
                      onPressed: () => onAction('request'),
                    ),
                  if (member)
                    TextButton(onPressed: () => onAction('leave'), child: Text(l.teamLeave)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Exécute une action d'équipe demandée par [TeamPanel] (invitation, acceptation…).
///
/// [call] envoie l'action au serveur (`/team/<action>`) avec les paramètres donnés.
Future<void> handleTeamAction(
  BuildContext context,
  TeamState team,
  String action,
  int? playerId,
  Future<bool> Function(String action, Map<String, dynamic> extra) call,
) async {
  final l = context.l10n;
  switch (action) {
    case 'invite':
      final p = await PlayerSearchDialog.show(context);
      if (p != null) await call('invite', {'player_id': p.id});
    case 'rename':
      final name = await askName(context, l.teamRename, initial: team.name, label: l.teamName);
      if (name != null && name.length >= 2) await call('rename', {'name': name});
    case 'leave':
      if (context.mounted && await confirmDialog(context, l.teamLeave)) await call('leave', const {});
    default:
      await call(action, {'player_id': ?playerId});
  }
}
