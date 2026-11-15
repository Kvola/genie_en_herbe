import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/online_common.dart';
import 'document_screen.dart';
import 'page_reader_screen.dart';

final _pageQuestionsProvider = FutureProvider.autoDispose.family<({PageInfo page, List<BankQuestion> questions}), int>(
  (ref, pageId) => ref.watch(onlineServiceProvider).pageQuestions(pageId),
);

/// Relecture des questions d'une page (propriétaire du document) : valider, corriger,
/// supprimer, ajouter, régénérer. Les questions validées passent en premier dans les matchs.
class QuestionsScreen extends ConsumerWidget {
  const QuestionsScreen({super.key, required this.document, required this.page});

  final DocumentSummary document;
  final PageInfo page;

  static Future<void> open(BuildContext context, DocumentSummary document, PageInfo page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuestionsScreen(document: document, page: page)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(_pageQuestionsProvider(page.id));
    final service = ref.read(onlineServiceProvider);
    void reload() {
      ref.invalidate(_pageQuestionsProvider(page.id));
      ref.invalidate(documentProvider(document.id));
    }

    Future<void> regenerate(bool ai) async {
      final ok = await confirmDialog(context, l.reviewRegenerate, body: l.reviewRegenerateHint, action: l.reviewRegenerate);
      if (!ok || !context.mounted) return;
      final r = await runOnline(context, () => service.regenerate(page.id, ai: ai));
      if (r == null || !context.mounted) return;
      reload();
      final message = aiReasonMessage(context, r.aiQueued, ai ? r.aiReason : '');
      context.toast(message ?? l.questionsPrepared);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.reviewTitle),
        actions: [
          IconButton(
            tooltip: l.pageRead,
            icon: const Icon(Icons.chrome_reader_mode_outlined),
            onPressed: () => PageReaderScreen.open(
              context,
              pages: [PageRef(page.id, page.label, document.id, document.name)],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              switch (v) {
                case 'validate_all':
                  if (await runOnline(context, () => service.validatePage(page.id).then((_) => true)) == true) reload();
                case 'regen_ai':
                  await regenerate(true);
                case 'regen_offline':
                  await regenerate(false);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'validate_all', child: Text(l.reviewValidateAll)),
              PopupMenuItem(value: 'regen_ai', child: Text(l.reviewRegenerateAi)),
              PopupMenuItem(value: 'regen_offline', child: Text(l.reviewRegenerateOffline)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l.reviewAdd),
        onPressed: () async {
          final values = await QuestionEditor.show(context);
          if (values == null || !context.mounted) return;
          final saved = await runOnline(context, () => service.saveQuestion({'page_id': page.id, ...values}));
          if (saved != null) reload();
        },
      ),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: value,
          onRetry: reload,
          builder: (data) => RefreshIndicator(
            onRefresh: () async => reload(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text('${document.name} — ${data.page.label}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${pageStatus(context, data.page)}\n${l.reviewHint}'),
                  isThreeLine: true,
                ),
                if (data.questions.isEmpty)
                  Padding(padding: const EdgeInsets.all(24), child: Text(l.reviewNone, textAlign: TextAlign.center)),
                for (final (i, q) in data.questions.indexed)
                  _QuestionCard(
                    index: i + 1,
                    question: q,
                    onValidate: (v) async {
                      if (await runOnline(context, () => service.validateQuestion(q.id, v).then((_) => true)) == true) {
                        reload();
                      }
                    },
                    onEdit: () async {
                      final values = await QuestionEditor.show(context, initial: q);
                      if (values == null || !context.mounted) return;
                      final saved = await runOnline(context, () => service.saveQuestion({'question_id': q.id, ...values}));
                      if (saved != null) reload();
                    },
                    onDelete: () async {
                      if (!await confirmDialog(context, l.reviewDelete, action: l.reviewDelete) || !context.mounted) return;
                      if (await runOnline(context, () => service.deleteQuestion(q.id).then((_) => true)) == true) reload();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.onValidate,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final BankQuestion question;
  final ValueChanged<bool> onValidate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final q = question;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: q.validated
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: context.palette.success, width: 1.5),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('$index.', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(switch (q.source) {
                    'ai' => l.sourceAi,
                    'manual' => l.sourceManual,
                    _ => l.sourceOffline,
                  }),
                ),
                const Spacer(),
                if (q.timesPlayed > 0) Text(l.reviewPlayed(q.timesPlayed), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Text(q.prompt, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 6),
            for (final (i, o) in q.options.indexed)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 2),
                child: Text(
                  '${i == q.answer ? '✓' : '·'} $o',
                  style: TextStyle(
                    color: i == q.answer ? context.palette.success : null,
                    fontWeight: i == q.answer ? FontWeight.w600 : null,
                  ),
                ),
              ),
            if (q.explain.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: Text(q.explain, style: Theme.of(context).textTheme.bodySmall),
              ),
            if (q.quote.isNotEmpty)
              Padding(padding: const EdgeInsets.only(right: 8, top: 6), child: QuoteBlock(text: q.quote)),
            Row(
              children: [
                Switch(value: q.validated, onChanged: onValidate),
                Text(q.validated ? l.reviewValidated : l.reviewProposed),
                const Spacer(),
                IconButton(tooltip: l.reviewEdit, icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
                IconButton(tooltip: l.reviewDelete, icon: const Icon(Icons.delete_outline), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Saisie ou correction d'une question : énoncé, 2 à 6 propositions, la bonne, l'explication.
class QuestionEditor extends StatefulWidget {
  const QuestionEditor({super.key, this.initial});

  final BankQuestion? initial;

  static Future<Map<String, dynamic>?> show(BuildContext context, {BankQuestion? initial}) =>
      Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(fullscreenDialog: true, builder: (_) => QuestionEditor(initial: initial)),
      );

  @override
  State<QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  late final _prompt = TextEditingController(text: widget.initial?.prompt ?? '');
  late final _explain = TextEditingController(text: widget.initial?.explain ?? '');
  late final List<TextEditingController> _options = [
    for (final o in widget.initial?.options ?? const ['', '', '', '']) TextEditingController(text: o),
  ];
  late int _answer = widget.initial?.answer ?? 0;

  @override
  void dispose() {
    _prompt.dispose();
    _explain.dispose();
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final l = context.l10n;
    final options = [for (final c in _options) c.text.trim()];
    if (_prompt.text.trim().length < 5) {
      context.toast(l.editorPromptTooShort);
      return;
    }
    final filled = [for (final (i, o) in options.indexed) if (o.isNotEmpty) (i, o)];
    if (filled.length < 2) {
      context.toast(l.editorNeedOptions);
      return;
    }
    if (options[_answer].isEmpty) {
      context.toast(l.editorNeedAnswer);
      return;
    }
    Navigator.of(context).pop({
      'prompt': _prompt.text.trim(),
      'options': [for (final (_, o) in filled) o],
      'answer': filled.indexWhere((e) => e.$1 == _answer),
      'explain': _explain.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? l.reviewAdd : l.reviewEdit),
        actions: [TextButton(onPressed: _save, child: Text(l.save))],
      ),
      body: SafeArea(
        top: false,
        child: RadioGroup<int>(
          groupValue: _answer,
          onChanged: (v) => setState(() => _answer = v ?? _answer),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _prompt,
                minLines: 2,
                maxLines: 4,
                maxLength: 600,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l.editorPrompt),
              ),
              Text(l.editorOptionsHint, style: Theme.of(context).textTheme.bodySmall),
              for (final (i, c) in _options.indexed)
                Row(
                  children: [
                    Radio<int>(value: i),
                    Expanded(
                      child: TextField(
                        controller: c,
                        maxLength: 200,
                        decoration: InputDecoration(labelText: l.editorOption(i + 1), counterText: ''),
                      ),
                    ),
                    if (_options.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => setState(() {
                          _options.removeAt(i).dispose();
                          if (_answer >= _options.length) _answer = 0;
                        }),
                      ),
                  ],
                ),
              if (_options.length < 6)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l.editorAddOption),
                    onPressed: () => setState(() => _options.add(TextEditingController())),
                  ),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _explain,
                minLines: 2,
                maxLines: 5,
                maxLength: 1000,
                decoration: InputDecoration(labelText: l.editorExplain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
