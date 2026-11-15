import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../online/models.dart';
import '../../online/online_providers.dart';
import '../common.dart';

/// Les joueurs et groupes que l'on peut inviter : « Mes joueurs » et « Mes groupes ».
final inviteSourcesProvider = FutureProvider.autoDispose<({List<Contact> contacts, List<PlayerGroup> groups})>((ref) async {
  final service = ref.watch(onlineServiceProvider);
  final r = await Future.wait([service.contacts(), service.groups()]);
  final c = r[0] as ({List<Contact> contacts, List<({int id, String pseudo})> blocked, String invitePolicy});
  return (contacts: c.contacts, groups: r[1] as List<PlayerGroup>);
});

/// Ce que l'utilisateur a choisi d'inviter.
class InviteChoice {
  const InviteChoice(this.playerIds, this.groupId);

  final List<int> playerIds;
  final int? groupId;
}

/// Résumé lisible d'un envoi : « 3 invités · Ben est déjà dans une partie · 1 n'accepte pas les invitations ».
String inviteSummary(BuildContext context, InviteResult r) {
  final l = context.l10n;
  final parts = <String>[
    if (r.invited.isNotEmpty) l.inviteSent(r.invited.length) else l.inviteNone,
    if (r.busy.isNotEmpty) l.inviteBusy(r.busy.join(', ')),
  ];
  final byReason = <String, int>{};
  for (final s in r.skipped) {
    byReason[s.reason] = (byReason[s.reason] ?? 0) + 1;
  }
  for (final e in byReason.entries) {
    parts.add(switch (e.key) {
      'already' => l.inviteSkipAlready(e.value),
      'limit' => l.inviteSkipLimit,
      'group' => l.inviteSkipGroup(e.value),
      'self' => '',
      _ => l.inviteSkipRefused(e.value),
    });
  }
  return parts.where((p) => p.isNotEmpty).join(' · ');
}

/// Feuille d'invitation : chercher un pseudo, cocher des joueurs, ou inviter tout un groupe.
class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({super.key, this.exclude = const {}});

  /// Joueurs déjà présents (non proposés).
  final Set<int> exclude;

  static Future<InviteChoice?> show(BuildContext context, {Set<int> exclude = const {}}) => showModalBottomSheet<InviteChoice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => InviteSheet(exclude: exclude),
  );

  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet> {
  final _selected = <int, String>{};
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
        if (mounted) setState(() => _found = const []);
        return;
      }
      try {
        final r = await ref.read(onlineServiceProvider).searchPlayers(q.trim());
        if (mounted && q == _q) setState(() => _found = r);
      } catch (_) {}
    });
  }

  Widget _playerTile(int id, String pseudo, {bool busy = false, String? subtitle, Widget? trailing}) => CheckboxListTile(
    value: _selected.containsKey(id),
    onChanged: (v) => setState(() => v == true ? _selected[id] = pseudo : _selected.remove(id)),
    title: Text(pseudo),
    subtitle: busy || subtitle != null ? Text([?subtitle, if (busy) context.l10n.teamInviteBusy].join(' · ')) : null,
    secondary: trailing,
    controlAffinity: ListTileControlAffinity.leading,
    dense: true,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sources = ref.watch(inviteSourcesProvider);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(labelText: l.teamInviteSearch, prefixIcon: const Icon(Icons.search)),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView(
              controller: scroll,
              children: [
                for (final p in _found.where((p) => !widget.exclude.contains(p.id)))
                  _playerTile(p.id, p.pseudo, busy: p.busy),
                ...switch (sources) {
                  AsyncData(:final value) => [
                    if (value.groups.isNotEmpty) ...[
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SectionTitle(l.groupsTitle)),
                      for (final g in value.groups)
                        ListTile(
                          leading: const Icon(Icons.groups_outlined),
                          title: Text(g.name),
                          subtitle: Text(l.groupMembers(g.memberCount)),
                          trailing: FilledButton.tonal(
                            onPressed: () => Navigator.pop(context, InviteChoice(_selected.keys.toList(), g.id)),
                            child: Text(l.inviteGroup),
                          ),
                        ),
                    ],
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SectionTitle(l.contactsTitle)),
                    if (value.contacts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(l.contactsEmpty, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    for (final c in value.contacts.where((c) => !widget.exclude.contains(c.playerId)))
                      _playerTile(
                        c.playerId,
                        c.pseudo,
                        busy: c.busy,
                        subtitle: l.contactMatches(c.matchesTogether),
                        trailing: c.favorite ? const Icon(Icons.star, size: 20) : null,
                      ),
                  ],
                  AsyncError() => [Padding(padding: const EdgeInsets.all(16), child: Text(l.errNetwork))],
                  _ => [const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))],
                },
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.send),
                  label: Text(l.inviteSelected(_selected.length)),
                  onPressed: _selected.isEmpty ? null : () => Navigator.pop(context, InviteChoice(_selected.keys.toList(), null)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
