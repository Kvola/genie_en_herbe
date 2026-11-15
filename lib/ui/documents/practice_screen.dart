import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/background.dart';
import '../../core/theme.dart';
import '../../engine/offline_quiz.dart';
import '../../engine/quiz_model.dart';
import '../../engine/text_tools.dart';
import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import 'page_reader_screen.dart';

/// S'entraîner seul sur des pages, sans réseau une fois les pages lues : les questions
/// sont fabriquées sur le téléphone (tirées du texte, français et anglais), sans chrono.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key, required this.pages, this.lang, this.matchId, this.tournamentId});

  final List<PageRef> pages;
  final String? lang;
  final int? matchId;
  final int? tournamentId;

  static Future<void> open(BuildContext context, List<PageRef> pages, {String? lang, int? matchId, int? tournamentId}) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PracticeScreen(pages: pages, lang: lang, matchId: matchId, tournamentId: tournamentId),
      ));

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  Quiz? _quiz;
  String? _error;
  int _index = 0;
  int? _chosen;
  int _score = 0;
  int _seed = 0;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _quiz = null;
      _error = null;
      _index = 0;
      _chosen = null;
      _score = 0;
    });
    try {
      if (_text.isEmpty) {
        final cache = ref.read(pageCacheProvider);
        final service = ref.read(onlineServiceProvider);
        final texts = <String>[];
        for (final p in widget.pages) {
          final r = await cache.load(service, p.id, matchId: widget.matchId, tournamentId: widget.tournamentId);
          texts.add(r.page.text);
        }
        _text = texts.where((t) => t.trim().isNotEmpty).join('\n\n');
      }
      final text = _text, seed = _seed, lang = widget.lang;
      final quiz = await runInBackground(
        () => OfflineQuizGenerator(text, lang: lang == null || !offlineLanguages.contains(lang) ? null : lang, seed: seed == 0 ? null : seed)
            .generate(count: 10),
      );
      if (mounted) setState(() => _quiz = quiz);
    } on OfflineQuizException catch (e) {
      if (mounted) setState(() => _error = e.reason == 'language' ? context.l10n.practiceLanguage : context.l10n.practiceTooShort);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.practiceNoPages);
    }
  }

  void _choose(int i) {
    if (_chosen != null) return;
    final q = _quiz!.questions[_index];
    setState(() {
      _chosen = i;
      if (i == q.answer) _score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final quiz = _quiz;
    return Scaffold(
      appBar: AppBar(title: Text(l.practiceTitle)),
      body: SafeArea(
        top: false,
        child: _error != null
            ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!, textAlign: TextAlign.center)))
            : quiz == null
            ? const Center(child: CircularProgressIndicator())
            : _index >= quiz.questions.length
            ? _done(context, quiz)
            : _question(context, quiz),
      ),
    );
  }

  Widget _question(BuildContext context, Quiz quiz) {
    final l = context.l10n;
    final q = quiz.questions[_index];
    final choices = q.isTrueFalse ? [l.practiceFalse, l.practiceTrue] : q.choices;
    final revealed = _chosen != null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LinearProgressIndicator(value: (_index + (revealed ? 1 : 0)) / quiz.questions.length),
        const SizedBox(height: 12),
        Text(l.playQuestion(_index + 1, quiz.questions.length), style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(q.question, style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.35)),
        const SizedBox(height: 12),
        for (var i = 0; i < choices.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                backgroundColor: !revealed
                    ? null
                    : i == q.answer
                    ? context.palette.successContainer
                    : i == _chosen
                    ? context.palette.errorContainer
                    : null,
              ),
              onPressed: revealed ? null : () => _choose(i),
              child: Text(choices[i], style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            ),
          ),
        if (revealed) ...[
          const SizedBox(height: 8),
          Text(
            _chosen == q.answer ? l.practiceRight : l.practiceWrong,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: _chosen == q.answer ? context.palette.success : context.palette.error,
            ),
          ),
          if (q.explanation.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(q.explanation)),
          if (q.quote.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: QuoteBlock(text: q.quote)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() {
              _index++;
              _chosen = null;
            }),
            child: Text(_index + 1 < quiz.questions.length ? l.practiceNext : l.practiceFinish),
          ),
        ],
      ],
    );
  }

  Widget _done(BuildContext context, Quiz quiz) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 72, color: context.palette.accentIcon),
            const SizedBox(height: 12),
            Text(l.practiceScore(_score, quiz.questions.length), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l.practiceAgain),
              onPressed: () {
                _seed = Random().nextInt(1 << 30) + 1;
                _start();
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.close)),
          ],
        ),
      ),
    );
  }
}
