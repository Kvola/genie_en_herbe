/// États du jeu en ligne tels que le serveur les envoie (lecture seule).
///
/// Le serveur est le seul arbitre : l'application n'a jamais la bonne
/// réponse avant que la question soit close ([QuestionState.answer]).
library;

import 'doc_models.dart';

int _int(Object? v, [int fallback = 0]) => v is num ? v.toInt() : fallback;
int? _intOrNull(Object? v) => v is num ? v.toInt() : null;
String _str(Object? v) => v == null ? '' : '$v';
List<Map<String, dynamic>> _maps(Object? v) =>
    v is List ? v.whereType<Map>().map((m) => m.cast<String, dynamic>()).toList() : const [];

class PlayerProfile {
  PlayerProfile(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get pseudo => _str(json['pseudo']);
  String get lang => _str(json['lang']).isEmpty ? 'fr' : _str(json['lang']);
  String get channel => _str(json['channel']);
  int? get matchId => _intOrNull(json['match_id']);
  String? get matchCode => json['match_code'] as String?;
  String? get matchState => json['match_state'] as String?;
  int? get tournamentId => _intOrNull(json['tournament_id']);
  String? get tournamentName => json['tournament_name'] as String?;
  Map<String, dynamic> get stats => (json['stats'] as Map?)?.cast<String, dynamic>() ?? const {};
  int get played => _int(stats['played']);
  int get won => _int(stats['won']);
  int get tournamentsWon => _int(stats['tournaments_won']);
}

/// Le compte connecté : un numéro vérifié, et (peut-être) déjà un profil de joueur.
class OnlineMe {
  OnlineMe(this.json);

  final Map<String, dynamic> json;

  String get phone => _str(json['phone']);
  PlayerProfile? get player => json['player'] is Map ? PlayerProfile((json['player'] as Map).cast()) : null;
}

class Participant {
  Participant(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  int get playerId => _int(json['player_id']);
  String get pseudo => _str(json['pseudo']);
  int? get teamId => _intOrNull(json['team_id']);
  int get score => _int(json['score']);
  int get correct => _int(json['correct']);
  int get wrong => _int(json['wrong']);
  bool get left => json['left'] == true;
  bool get online => json['online'] == true;
  bool get ready => json['ready'] == true;
  int? get rank => _intOrNull(json['rank']);
}

class PendingMember {
  PendingMember(this.json);

  final Map<String, dynamic> json;

  int get playerId => _int(json['player_id']);
  String get pseudo => _str(json['pseudo']);

  /// `invited` (le capitaine a invité) ou `requested` (le joueur a demandé).
  String get kind => _str(json['kind']);
}

class TeamState {
  TeamState(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get name => _str(json['name']);
  int get captainId => _int(json['captain_id']);
  int get score => _int(json['score']);
  List<({int id, String pseudo})> get members =>
      [for (final m in _maps(json['members'])) (id: _int(m['id']), pseudo: _str(m['pseudo']))];
  List<PendingMember> get pending => [for (final m in _maps(json['pending'])) PendingMember(m)];

  bool hasMember(int playerId) => members.any((m) => m.id == playerId);
}

class AnswerLog {
  AnswerLog(this.json);

  final Map<String, dynamic> json;

  int get participantId => _int(json['participant_id']);

  /// `correct`, `wrong` ou `timeout`.
  String get kind => _str(json['kind']);
  int get choice => _int(json['choice'], -1);
  int get points => _int(json['points']);
}

class QuestionState {
  QuestionState(this.json);

  final Map<String, dynamic> json;

  int get index => _int(json['index']);
  int get total => _int(json['total']);
  bool get tiebreak => json['tiebreak'] == true;
  String get prompt => _str(json['prompt']);
  List<String> get options => (json['options'] as List? ?? const []).map((e) => '$e').toList();
  /// « Titre — Page 3 » : la page dont la question est tirée.
  String get refLabel => _str(json['ref_label']);
  int? get pageId => _intOrNull(json['page_id']);

  /// `ai` (rédigée par l'IA), `offline` (tirée du texte sans IA) ou `manual` (écrite par le propriétaire).
  String get source => _str(json['source']);
  List<String> get locked => (json['locked'] as List? ?? const []).map((e) => '$e').toList();

  /// Échéance de la question (horloge du serveur, ms) quand elle est ouverte.
  int? get deadline => _intOrNull(json['deadline']);

  /// Temps de question restant, mis en pause pendant une main.
  int? get remainingMs => _intOrNull(json['remaining_ms']);
  int? get handParticipantId => json['hand'] is Map ? _intOrNull((json['hand'] as Map)['participant_id']) : null;
  int? get handDeadline => json['hand'] is Map ? _intOrNull((json['hand'] as Map)['deadline']) : null;

  // Après la clôture seulement :
  int? get answer => _intOrNull(json['answer']);
  String get explain => _str(json['explain']);
  String get ref => _str(json['ref']);

  /// Passage de la page qui justifie la réponse.
  String get quote => _str(json['quote']);
  int? get winnerParticipantId => _intOrNull(json['winner_participant_id']);
  List<AnswerLog> get answers => [for (final m in _maps(json['answers'])) AnswerLog(m)];
}

class MatchResult {
  MatchResult(this.json);

  final Map<String, dynamic> json;

  /// `played`, `tiebreak`, `tiebreak_rule`, `abandon`, `idle`.
  String get outcome => _str(json['outcome']);
  int? get winnerParticipantId => _intOrNull(json['winner_participant_id']);
  int? get winnerTeamId => _intOrNull(json['winner_team_id']);
}

class MatchState {
  MatchState(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get code => _str(json['code']);
  int get version => _int(json['version']);
  int get serverNow => _int(json['server_now']);

  /// `free` (match libre) ou `duel` (tournoi).
  String get kind => _str(json['kind']);

  /// `solo` ou `team`.
  String get mode => _str(json['mode']);
  bool get isTeam => mode == 'team';

  /// `lobby`, `running`, `finished`, `cancelled`.
  String get state => _str(json['state']);

  /// `countdown`, `open`, `hand`, `reveal` (pendant `running`).
  String? get phase => json['phase'] as String?;
  String get lang => _str(json['lang']);
  int? get creatorId => _intOrNull(json['creator_id']);
  String get creatorPseudo => _str(json['creator_pseudo']);

  /// Le créateur dirige le match sans y jouer.
  bool get hostOnly => json['host_only'] == true;
  bool get isPublic => json['is_public'] == true;
  List<PageRef> get pages => PageRef.list(json['pages']);
  String get pagesLabel => _str(json['pages_label']);

  /// Invitations envoyées pour ce match (salle d'attente).
  List<SentInvitation> get invitations => [for (final m in _maps(json['invitations'])) SentInvitation(m)];
  Map<String, dynamic> get settings => (json['settings'] as Map?)?.cast<String, dynamic>() ?? const {};
  int get questionCount => _int(settings['question_count']);
  int get questionSeconds => _int(settings['question_seconds']);
  int get handSeconds => _int(settings['hand_seconds']);
  int get maxPlayers => _int(settings['max_players']);
  List<Participant> get participants => [for (final m in _maps(json['participants'])) Participant(m)];
  List<TeamState> get teams => [for (final m in _maps(json['teams'])) TeamState(m)];
  int? get phaseUntil => _intOrNull(json['phase_until']);
  QuestionState? get question => json['question'] is Map ? QuestionState((json['question'] as Map).cast()) : null;
  MatchResult? get result => json['result'] is Map ? MatchResult((json['result'] as Map).cast()) : null;
  Map<String, dynamic>? get tournament => (json['tournament'] as Map?)?.cast<String, dynamic>();

  List<Participant> get active => participants.where((p) => !p.left).toList();

  Participant? participant(int? id) => participants.where((p) => p.id == id).firstOrNull;
  Participant? participantOfPlayer(int? playerId) => participants.where((p) => p.playerId == playerId).firstOrNull;
  TeamState? team(int? id) => teams.where((t) => t.id == id).firstOrNull;

  /// Clé de blocage d'un participant (lui seul, ou toute son équipe).
  String lockKey(Participant p) => isTeam ? 't${p.teamId}' : 'p${p.id}';
}

/// État renvoyé par le serveur : l'état public, mon participant, le canal temps réel.
class MatchEnvelope {
  MatchEnvelope(this.match, this.me, this.channel);

  final MatchState match;
  final int? me;
  final String channel;

  static MatchEnvelope parse(Map<String, dynamic> r) =>
      MatchEnvelope(MatchState((r['match'] as Map).cast()), _intOrNull(r['me']), _str(r['channel']));
}

class HistoryQuestion {
  HistoryQuestion(this.json);

  final Map<String, dynamic> json;
  QuestionState get q => QuestionState(json);
}

// ------------------------------------------------------------------ tournois

class TournamentEntry {
  TournamentEntry(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get name => _str(json['name']);

  /// `in`, `eliminated`, `winner`.
  String get state => _str(json['state']);
  int? get eliminatedRound => _intOrNull(json['eliminated_round']);
  int? get playerId => json['player'] is Map ? _intOrNull((json['player'] as Map)['id']) : null;
  TeamState? get team => json['team'] is Map ? TeamState((json['team'] as Map).cast()) : null;
}

class Duel {
  Duel(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  int get round => _int(json['round']);
  int get position => _int(json['position']);

  /// `pending`, `ready_wait`, `playing`, `done`.
  String get state => _str(json['state']);

  /// `played`, `bye`, `forfeit`, `double_forfeit`.
  String? get result => json['result'] as String?;
  int? get entryA => _intOrNull(json['entry_a_id']);
  int? get entryB => _intOrNull(json['entry_b_id']);
  bool get readyA => json['ready_a'] == true;
  bool get readyB => json['ready_b'] == true;
  int? get winner => _intOrNull(json['winner_entry_id']);
  int? get matchId => _intOrNull(json['match_id']);
  int? get deadline => _intOrNull(json['deadline']);
  int get scoreA => _int(json['score_a']);
  int get scoreB => _int(json['score_b']);

  bool involves(int? entryId) => entryId != null && (entryA == entryId || entryB == entryId);
}

class TournamentState {
  TournamentState(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get code => _str(json['code']);
  String get name => _str(json['name']);
  int get version => _int(json['version']);
  int get serverNow => _int(json['server_now']);
  String get mode => _str(json['mode']);
  bool get isTeam => mode == 'team';

  /// `registration`, `running`, `finished`, `cancelled`.
  String get state => _str(json['state']);
  int? get organizerId => _intOrNull(json['organizer_id']);
  String get organizerPseudo => _str(json['organizer_pseudo']);
  String get lang => _str(json['lang']);
  String get pagesLabel => _str(json['pages_label']);
  List<PageRef> get pages => PageRef.list(json['pages']);

  /// Tournoi réservé aux membres d'un groupe.
  String? get groupName => json['group'] is Map ? _str((json['group'] as Map)['name']) : null;

  /// Pages propres à un tour : {tour: (ids, libellé)}.
  Map<String, ({List<int> ids, String label})> get roundPages => {
    for (final e in ((json['round_pages'] as Map?) ?? const {}).entries)
      if (e.value is Map)
        '${e.key}': (
          ids: ((e.value as Map)['ids'] as List? ?? const []).whereType<num>().map((n) => n.toInt()).toList(),
          label: _str((e.value as Map)['label']),
        ),
  };
  Map<String, dynamic> get settings => (json['settings'] as Map?)?.cast<String, dynamic>() ?? const {};
  int get minEntries => _int(settings['min_entries'], 2);
  int get maxEntries => _int(settings['max_entries'], 2);
  int get forfeitMinutes => _int(settings['forfeit_minutes'], 10);
  int get questionCount => _int(settings['question_count']);
  int get questionSeconds => _int(settings['question_seconds']);
  int get handSeconds => _int(settings['hand_seconds']);
  int get teamMinSize => _int(settings['team_min_size'], 1);
  int get teamMaxSize => _int(settings['team_max_size'], 5);
  int get rounds => _int(json['rounds']);
  List<TournamentEntry> get entries => [for (final m in _maps(json['entries'])) TournamentEntry(m)];
  List<Duel> get duels => [for (final m in _maps(json['duels'])) Duel(m)];
  int? get winnerEntryId => _intOrNull(json['winner_entry_id']);

  TournamentEntry? entry(int? id) => entries.where((e) => e.id == id).firstOrNull;
}

class TournamentEnvelope {
  TournamentEnvelope(this.tournament, this.myEntryId, this.channel);

  final TournamentState tournament;
  final int? myEntryId;
  final String channel;

  static TournamentEnvelope parse(Map<String, dynamic> r) => TournamentEnvelope(
    TournamentState((r['tournament'] as Map).cast()),
    _intOrNull(r['my_entry_id']),
    _str(r['channel']),
  );
}

// ------------------------------------------------------------------ listes

class OpenMatch {
  OpenMatch(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get code => _str(json['code']);
  String get mode => _str(json['mode']);
  String get lang => _str(json['lang']);
  String get pagesLabel => _str(json['pages_label']);
  String get creator => _str(json['creator']);
  bool get hostOnly => json['host_only'] == true;
  int get players => _int(json['players']);
  int get maxPlayers => _int(json['max_players']);
  int get questionCount => _int(json['question_count']);
}

class OpenTournament {
  OpenTournament(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get code => _str(json['code']);
  String get name => _str(json['name']);
  String get mode => _str(json['mode']);
  String get state => _str(json['state']);
  String get pagesLabel => _str(json['pages_label']);
  String get organizer => _str(json['organizer']);
  int get entries => _int(json['entries']);
  int get maxEntries => _int(json['max_entries']);
  String? get winner => json['winner'] as String?;
}

class Invitation {
  Invitation(this.json);

  final Map<String, dynamic> json;

  int get teamId => _int(json['team_id']);
  String get teamName => _str(json['team_name']);
  String get captain => _str(json['captain']);
  int? get matchId => _intOrNull(json['match_id']);
  String? get matchCode => json['match_code'] as String?;
  int? get tournamentId => _intOrNull(json['tournament_id']);
  String? get tournamentName => json['tournament_name'] as String?;
}

class PastMatch {
  PastMatch(this.json);

  final Map<String, dynamic> json;

  int get matchId => _int(json['match_id']);
  String get code => _str(json['code']);
  String get mode => _str(json['mode']);
  String? get finishedAt => json['finished_at'] as String?;
  String get pagesLabel => _str(json['pages_label']);
  int get rank => _int(json['rank']);
  int get score => _int(json['score']);
  int get players => _int(json['players']);
  bool get won => json['won'] == true;
  String? get tournament => json['tournament'] as String?;
}

class ServerConfig {
  ServerConfig(this.json);

  final Map<String, dynamic> json;

  int get serverNow => _int(json['server_now']);
  String get websocketVersion => _str(json['websocket_version']);
  Map<String, dynamic> get limits => (json['limits'] as Map?)?.cast<String, dynamic>() ?? const {};
  Map<String, dynamic> get defaults => (json['defaults'] as Map?)?.cast<String, dynamic>() ?? const {};
  int get maxPlayers => _int(limits['max_players'], 10);
  int get teamMaxSize => _int(limits['team_max_size'], 5);
  int get teamMinSize => _int(limits['team_min_size'], 1);
  int get tournamentMaxEntries => _int(limits['tournament_max_entries'], 32);
  int get maxPages => _int(limits['max_pages'], 200);
  (int, int) range(String key, (int, int) fallback) {
    final v = limits[key];
    return v is List && v.length == 2 ? (_int(v[0]), _int(v[1])) : fallback;
  }

  int defaultOf(String key, int fallback) => _int(defaults[key], fallback);
}

// ------------------------------------------------------------------ invitations, joueurs, groupes

/// Une invitation envoyée pour ce match (vue de la salle d'attente).
class SentInvitation {
  SentInvitation(this.json);

  final Map<String, dynamic> json;

  int get playerId => _int(json['player_id']);
  String get pseudo => _str(json['pseudo']);

  /// `pending`, `accepted`, `declined`, `expired`.
  String get state => _str(json['state']);
}

/// Une invitation reçue à un match.
class MatchInvitation {
  MatchInvitation(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  int get matchId => _int(json['match_id']);
  String get code => _str(json['code']);
  String get inviter => _str(json['inviter']);
  String get pagesLabel => _str(json['pages_label']);
  String get mode => _str(json['mode']);
  int get players => _int(json['players']);
}

/// Un joueur de « Mes joueurs ».
class Contact {
  Contact(this.json);

  final Map<String, dynamic> json;

  int get playerId => _int(json['player_id']);
  String get pseudo => _str(json['pseudo']);
  bool get favorite => json['favorite'] == true;
  int get matchesTogether => _int(json['matches_together']);
  bool get busy => json['busy'] == true;
}

class GroupMember {
  GroupMember(this.json);

  final Map<String, dynamic> json;

  int get playerId => _int(json['player_id']);
  String get pseudo => _str(json['pseudo']);
  bool get owner => json['owner'] == true;
  bool get busy => json['busy'] == true;
}

/// Un groupe (classe, club) : son code se partage, on invite tous ses membres d'un geste.
class PlayerGroup {
  PlayerGroup(this.json, [this.link = '']);

  final Map<String, dynamic> json;
  final String link;

  int get id => _int(json['id']);
  String get name => _str(json['name']);
  String get code => _str(json['code']);
  String get owner => _str(json['owner']);
  bool get mine => json['mine'] == true;
  int get memberCount => _int(json['member_count']);
  List<GroupMember> get members => [for (final m in _maps(json['members'])) GroupMember(m)];
}

/// Résultat d'un envoi d'invitations.
class InviteResult {
  InviteResult(this.json);

  final Map<String, dynamic> json;

  List<String> get invited => (json['invited'] as List? ?? const []).map((e) => '$e').toList();
  List<String> get busy => (json['busy'] as List? ?? const []).map((e) => '$e').toList();

  /// (pseudo, motif) : `self`, `blocked`, `policy`, `already`, `limit`, `group`.
  List<({String pseudo, String reason})> get skipped => [
    for (final m in _maps(json['skipped'])) (pseudo: _str(m['pseudo']), reason: _str(m['reason'])),
  ];
}
