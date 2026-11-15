import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../common.dart';
import 'match_screen.dart';
import 'online_common.dart';
import 'schedule.dart';

/// Nouveau match : formule, pages au programme, nombre de questions et temps, organisateur sans jouer.
class CreateMatchScreen extends ConsumerStatefulWidget {
  const CreateMatchScreen({super.key, this.initialPages = PageSelection.empty});

  /// Pages déjà choisies (depuis la fiche d'un document).
  final PageSelection initialPages;

  static Future<void> open(BuildContext context, {PageSelection pages = PageSelection.empty}) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateMatchScreen(initialPages: pages)));

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  String _mode = 'solo';
  late PageSelection _pages = widget.initialPages;
  bool _hostOnly = false;

  /// Match programmé : l'heure prévue (null = tout de suite).
  DateTime? _scheduledAt;
  int? _count;
  int? _seconds;
  int? _hand;
  int? _maxPlayers;
  bool _public = true;
  bool _busy = false;

  Future<void> _submit() async {
    setState(() => _busy = true);
    final env = await runOnline(context, () => ref.read(onlineServiceProvider).createMatch({
      'mode': _mode,
      'pages': _pages.pageIds,
      'host_only': _hostOnly,
      'scheduled_at': _scheduledAt?.millisecondsSinceEpoch,
      'question_count': _count,
      'question_seconds': _seconds,
      'hand_seconds': _hand,
      'max_players': _mode == 'solo' ? _maxPlayers : null,
      'is_public': _public,
    }));
    if (!mounted) return;
    setState(() => _busy = false);
    if (env == null) return;
    unawaited(ref.read(onlineMeProvider.notifier).refresh());
    final navigator = Navigator.of(context);
    navigator.pop();
    await MatchScreen.open(navigator.context, env.match.id, seed: env);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final config = ref.watch(serverConfigProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.createMatchTitle)),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: config,
          onRetry: () => ref.invalidate(serverConfigProvider),
          builder: (c) {
            final (qMin, qMax) = c.range('question_count', (5, 30));
            final (sMin, sMax) = c.range('question_seconds', (10, 120));
            final (hMin, hMax) = c.range('hand_seconds', (3, 15));
            final count = (_count ?? c.defaultOf('question_count', 10)).clamp(qMin, qMax);
            final seconds = (_seconds ?? c.defaultOf('question_seconds', 30)).clamp(sMin, sMax);
            final hand = (_hand ?? c.defaultOf('hand_seconds', 5)).clamp(hMin, hMax);
            final maxPlayers = (_maxPlayers ?? c.maxPlayers).clamp(2, c.maxPlayers);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'solo', icon: const Icon(Icons.person), label: Text(l.onlineModeSolo)),
                    ButtonSegment(value: 'team', icon: const Icon(Icons.groups), label: Text(l.onlineModeTeam)),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (s) => setState(() => _mode = s.first),
                ),
                if (_mode == 'team')
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(l.teamSizeHint(c.teamMinSize, c.teamMaxSize), style: Theme.of(context).textTheme.bodySmall),
                  ),
                SectionTitle(l.createPages),
                PagesField(
                  selection: _pages,
                  requiredCount: count,
                  onChanged: (v) => setState(() => _pages = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.scheduleSwitch),
                  subtitle: Text(_scheduledAt == null ? l.scheduleSwitchHint : formatSchedule(context, _scheduledAt!)),
                  value: _scheduledAt != null,
                  onChanged: (v) async {
                    if (!v) {
                      setState(() => _scheduledAt = null);
                      return;
                    }
                    final at = await pickSchedule(context);
                    if (at != null && mounted) setState(() => _scheduledAt = at);
                  },
                ),
                if (_scheduledAt != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: Text(l.scheduleChange),
                      onPressed: () async {
                        final at = await pickSchedule(context, initial: _scheduledAt);
                        if (at != null && mounted) setState(() => _scheduledAt = at);
                      },
                    ),
                  ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.createHostOnly),
                  subtitle: Text(l.createHostOnlyHint),
                  value: _hostOnly,
                  onChanged: (v) => setState(() => _hostOnly = v),
                ),
                const SizedBox(height: 12),
                Text(l.createQuestions(count)),
                Slider(
                  value: count.toDouble(),
                  min: qMin.toDouble(),
                  max: qMax.toDouble(),
                  divisions: qMax - qMin,
                  label: '$count',
                  onChanged: (v) => setState(() => _count = v.round()),
                ),
                Text(l.createQuestionTime(seconds)),
                Slider(
                  value: seconds.toDouble(),
                  min: sMin.toDouble(),
                  max: sMax.toDouble(),
                  divisions: (sMax - sMin) ~/ 5,
                  label: '$seconds s',
                  onChanged: (v) => setState(() => _seconds = (v / 5).round() * 5),
                ),
                Text(l.createHandTime(hand)),
                Slider(
                  value: hand.toDouble(),
                  min: hMin.toDouble(),
                  max: hMax.toDouble(),
                  divisions: hMax - hMin,
                  label: '$hand s',
                  onChanged: (v) => setState(() => _hand = v.round()),
                ),
                if (_mode == 'solo') ...[
                  Text(l.createMaxPlayers(maxPlayers)),
                  Slider(
                    value: maxPlayers.toDouble(),
                    min: 2,
                    max: c.maxPlayers.toDouble(),
                    divisions: c.maxPlayers - 2 > 0 ? c.maxPlayers - 2 : 1,
                    label: '$maxPlayers',
                    onChanged: (v) => setState(() => _maxPlayers = v.round()),
                  ),
                ],
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.createPublic),
                  subtitle: Text(l.createPublicHint),
                  value: _public,
                  onChanged: (v) => setState(() => _public = v),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: Text(l.createSubmit),
                  onPressed: _busy || _pages.isEmpty
                      ? null
                      : () {
                          _count = count;
                          _seconds = seconds;
                          _hand = hand;
                          _maxPlayers = maxPlayers;
                          _submit();
                        },
                ),
                if (_busy) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
