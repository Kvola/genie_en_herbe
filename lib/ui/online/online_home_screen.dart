import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../online/models.dart';
import '../../online/online_providers.dart';
import '../common.dart';
import 'create_match_screen.dart';
import 'create_tournament_screen.dart';
import '../profile/groups_screen.dart';
import 'match_screen.dart';
import 'online_common.dart';
import 'projection_screen.dart';
import 'scan_screen.dart';
import 'sign_in_screen.dart';
import 'tournament_screen.dart';

/// Ce que l'écran d'accueil du jeu en ligne charge à chaque ouverture.
class _Lobby {
  _Lobby(this.open, this.invitations, this.tournaments);

  final ({List<OpenMatch> matches, List<OpenTournament> tournaments}) open;
  final ({List<Invitation> teams, List<MatchInvitation> matches}) invitations;
  final List<OpenTournament> tournaments;
}

final _lobbyProvider = FutureProvider.autoDispose<_Lobby>((ref) async {
  final service = ref.watch(onlineServiceProvider);
  // Rechargé à chaque événement du joueur (invitation reçue…).
  ref.watch(playerEventsProvider);
  // Rechargé quand la situation du joueur change (fin d'un match, inscription à un tournoi…).
  ref.watch(onlineMeProvider.select((me) {
    final p = me.value?.player;
    return (p?.matchId, p?.tournamentId, p?.played);
  }));
  final results = await Future.wait([service.openGames(), service.invitations(), service.myTournaments()]);
  return _Lobby(
    results[0] as ({List<OpenMatch> matches, List<OpenTournament> tournaments}),
    results[1] as ({List<Invitation> teams, List<MatchInvitation> matches}),
    results[2] as List<OpenTournament>,
  );
});

/// Onglet « Jouer » : partie en cours, créer / rejoindre, matchs et tournois ouverts.
class OnlineHomeScreen extends ConsumerWidget {
  const OnlineHomeScreen({super.key});

  static Future<void> open(BuildContext context) {
    // Le profil a pu changer depuis la dernière visite (match fini, tournoi terminé).
    unawaited(ProviderScope.containerOf(context, listen: false).read(onlineMeProvider.notifier).refresh());
    return Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnlineHomeScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final me = ref.watch(onlineMeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.onlineTitle),
        actions: [
          IconButton(
            tooltip: l.onlineProjection,
            icon: const Icon(Icons.cast),
            onPressed: () => ProjectionScreen.open(context),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: switch (me) {
          AsyncData(value: final m) when m?.player != null => _PlayerHome(player: m!.player!),
          AsyncData() => const _Welcome(),
          AsyncError(:final error) => _Retry(
            message: onlineError(context, error),
            onRetry: () => ref.invalidate(onlineMeProvider),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 40),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    ),
  );
}

/// Pas encore joueur : ce qu'est le jeu en ligne, et comment y entrer.
class _Welcome extends ConsumerWidget {
  const _Welcome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(Icons.groups, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(l.onlineIntro, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(l.onlineOptional),
        const SizedBox(height: 8),
        Text(l.onlineAccountHint, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 20),
        FilledButton.icon(
          icon: const Icon(Icons.person_add),
          label: Text(l.onlineBecomePlayer),
          onPressed: () => SignInScreen.open(context),
        ),
        const SizedBox(height: 8),
        // On vous montre un QR code de partie : le scanner fait devenir joueur, puis entrer.
        OutlinedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(l.scanQr),
          onPressed: () => scanAndJoin(context, ref),
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cast),
            title: Text(l.onlineProjection),
            subtitle: Text(l.onlineProjectionHint),
            onTap: () => ProjectionScreen.open(context),
          ),
        ),
      ],
    );
  }
}

class _PlayerHome extends ConsumerWidget {
  const _PlayerHome({required this.player});

  final PlayerProfile player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lobby = ref.watch(_lobbyProvider);
    Future<void> refresh() async {
      await ref.read(onlineMeProvider.notifier).refresh();
      ref.invalidate(_lobbyProvider);
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Text(player.pseudo.characters.first.toUpperCase())),
            title: Text(player.pseudo, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(l.onlineStats(player.played, player.won)),
          ),
          if (player.matchId != null)
            _ResumeCard(
              title: l.onlineCurrentMatch,
              subtitle: player.matchCode ?? '',
              onTap: () => MatchScreen.open(context, player.matchId!),
            ),
          if (player.tournamentId != null)
            _ResumeCard(
              title: l.onlineCurrentTournament(player.tournamentName ?? ''),
              onTap: () => TournamentScreen.open(context, player.tournamentId!),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l.onlineCreateMatch),
                onPressed: () => CreateMatchScreen.open(context),
              ),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.login),
                label: Text(l.onlineJoin),
                onPressed: () => joinByCode(context, ref),
              ),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l.scanQr),
                onPressed: () => scanAndJoin(context, ref),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.emoji_events_outlined),
                label: Text(l.onlineCreateTournament),
                onPressed: () => CreateTournamentScreen.open(context),
              ),
            ],
          ),
          ...switch (lobby) {
            AsyncData(:final value) => _lists(context, ref, value),
            AsyncError(:final error) => [
              const SizedBox(height: 24),
              _Retry(message: onlineError(context, error), onRetry: () => ref.invalidate(_lobbyProvider)),
            ],
            _ => [const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))],
          },
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l.onlineHistory),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _HistoryScreen())),
          ),
        ],
      ),
    );
  }

  List<Widget> _lists(BuildContext context, WidgetRef ref, _Lobby data) {
    final l = context.l10n;
    return [
      if (data.invitations.teams.isNotEmpty || data.invitations.matches.isNotEmpty) ...[
        SectionTitle(l.onlineInvitations),
        for (final inv in data.invitations.matches)
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.mail_outline),
              title: Text(l.inviteReceived(inv.inviter)),
              subtitle: Text('${inv.pagesLabel} · ${l.invitePlayersIn(inv.players)}'),
              trailing: Wrap(
                children: [
                  IconButton(
                    tooltip: l.teamDecline,
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      await runOnline(context, () => ref.read(onlineServiceProvider).answerInvitation(inv.id, accept: false));
                      ref.invalidate(_lobbyProvider);
                    },
                  ),
                  IconButton(
                    tooltip: l.teamAccept,
                    icon: const Icon(Icons.check),
                    onPressed: () => acceptMatchInvitation(context, ref, inv.id),
                  ),
                ],
              ),
            ),
          ),
        for (final inv in data.invitations.teams)
          Card(
            child: ListTile(
              leading: const Icon(Icons.mail_outline),
              title: Text(l.teamInvitation(inv.captain, inv.teamName)),
              subtitle: Text(inv.tournamentName ?? inv.matchCode ?? ''),
              trailing: Wrap(
                children: [
                  IconButton(
                    tooltip: l.teamDecline,
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      await runOnline(context, () => ref.read(onlineServiceProvider).teamAction('decline', inv.teamId));
                      ref.invalidate(_lobbyProvider);
                    },
                  ),
                  IconButton(
                    tooltip: l.teamAccept,
                    icon: const Icon(Icons.check),
                    onPressed: () => _acceptInvitation(context, ref, inv),
                  ),
                ],
              ),
            ),
          ),
      ],
      SectionTitle(l.onlineOpenMatches),
      if (data.open.matches.isEmpty)
        Text(l.onlineNoOpenMatch, style: Theme.of(context).textTheme.bodySmall)
      else
        for (final m in data.open.matches)
          Card(
            child: ListTile(
              leading: Icon(m.mode == 'team' ? Icons.groups_outlined : Icons.person_outline),
              title: Text(m.pagesLabel),
              subtitle: Text('${l.onlineBy(m.creator)} · ${l.onlinePlayers(m.players, m.maxPlayers)} · '
                  '${l.questionsCount(m.questionCount)} · ${m.lang.toUpperCase()}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => joinByCode(context, ref, code: m.code),
            ),
          ),
      if (data.open.tournaments.isNotEmpty) ...[
        SectionTitle(l.onlineOpenTournaments),
        for (final t in data.open.tournaments)
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: Text(t.name),
              subtitle: Text('${t.mode == 'team' ? l.onlineModeTeam : l.onlineModeSolo} · ${t.pagesLabel} · '
                  '${t.entries}/${t.maxEntries}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => TournamentScreen.open(context, t.id),
            ),
          ),
      ],
      if (data.tournaments.isNotEmpty) ...[
        SectionTitle(l.onlineMyTournaments),
        for (final t in data.tournaments)
          Card(
            child: ListTile(
              leading: Icon(t.state == 'finished' ? Icons.emoji_events : Icons.emoji_events_outlined),
              title: Text(t.name),
              subtitle: Text(t.winner != null ? '🏆 ${t.winner}' : t.organizer),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => TournamentScreen.open(context, t.id),
            ),
          ),
      ],
    ];
  }

  Future<void> _acceptInvitation(BuildContext context, WidgetRef ref, Invitation inv) async {
    final r = await runOnline(context, () => ref.read(onlineServiceProvider).teamAction('accept', inv.teamId));
    ref.invalidate(_lobbyProvider);
    if (r == null || !context.mounted) return;
    unawaited(ref.read(onlineMeProvider.notifier).refresh());
    if (r['match'] is Map) {
      final env = MatchEnvelope.parse(r);
      await MatchScreen.open(context, env.match.id, seed: env);
    } else if (r['tournament'] is Map) {
      final env = TournamentEnvelope.parse(r);
      await TournamentScreen.open(context, env.tournament.id, seed: env);
    }
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({required this.title, this.subtitle, required this.onTap});

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: ListTile(
      leading: const Icon(Icons.play_circle_fill),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle == null || subtitle!.isEmpty ? null : Text(subtitle!),
      trailing: FilledButton(onPressed: onTap, child: Text(context.l10n.onlineResume)),
      onTap: onTap,
    ),
  );
}

/// Rejoindre par un code (saisi, ou reçu par lien) : ouvre le match ou la fiche du tournoi.
Future<void> joinByCode(BuildContext context, WidgetRef ref, {String? code}) async {
  final l = context.l10n;
  code ??= await askGameCode(context, l.onlineJoinTitle);
  if (code == null || code.isEmpty || !context.mounted) return;
  final r = await runOnline(context, () => ref.read(onlineServiceProvider).join(code!));
  if (r == null || !context.mounted) return;
  unawaited(ref.read(onlineMeProvider.notifier).refresh());
  if (r.group != null) {
    context.toast(l.groupJoined(r.group!.name));
    await GroupScreen.open(context, r.group!.id);
  } else if (r.match != null) {
    await MatchScreen.open(context, r.match!.match.id, seed: r.match);
  } else if (r.tournament != null) {
    await TournamentScreen.open(context, r.tournament!.tournament.id, seed: r.tournament);
  }
}

/// Accepter une invitation à un match : on entre dans sa salle d'attente.
Future<void> acceptMatchInvitation(BuildContext context, WidgetRef ref, int invitationId) async {
  final env = await runOnline(context, () => ref.read(onlineServiceProvider).answerInvitation(invitationId, accept: true));
  if (env == null || !context.mounted) return;
  unawaited(ref.read(onlineMeProvider.notifier).refresh());
  await MatchScreen.open(context, env.match.id, seed: env);
}

/// Scanner le QR code d'une partie : rejoindre (match ou tournoi) ou regarder (projection).
///
/// Pas encore joueur : on le devient d'abord, puis la partie scannée s'ouvre.
Future<void> scanAndJoin(BuildContext context, WidgetRef ref) async {
  final scan = await ref.read(gameScannerProvider)(context);
  if (scan == null || !context.mounted) return;
  if (scan.watch != null) {
    await ProjectionScreen.open(context, code: scan.watch);
    return;
  }
  final me = await ref.read(onlineMeProvider.future).catchError((_) => null);
  if (!context.mounted) return;
  if (me?.player == null && !await SignInScreen.open(context)) return;
  if (context.mounted) await joinByCode(context, ref, code: scan.join);
}

// ------------------------------------------------------------------ historique

final _historyProvider = FutureProvider.autoDispose<List<PastMatch>>(
  (ref) => ref.watch(onlineServiceProvider).history(),
);

class _HistoryScreen extends ConsumerWidget {
  const _HistoryScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final history = ref.watch(_historyProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.onlineHistory)),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: history,
          onRetry: () => ref.invalidate(_historyProvider),
          builder: (items) => items.isEmpty
              ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(l.onlineNoHistory)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final m in items)
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: m.won ? const Icon(Icons.emoji_events) : Text(l.resultRank(m.rank)),
                          ),
                          title: Text(m.pagesLabel),
                          subtitle: Text([
                            if (m.tournament != null) m.tournament!,
                            if (m.finishedAt != null) m.finishedAt!.substring(0, 10),
                            l.onlinePlayers(m.players, m.players),
                          ].join(' · ')),
                          trailing: Text(l.playPoints(m.score), style: const TextStyle(fontWeight: FontWeight.w700)),
                          onTap: () => MatchScreen.open(context, m.matchId),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
