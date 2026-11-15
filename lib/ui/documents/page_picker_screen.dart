import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/online_common.dart';
import 'document_screen.dart';
import 'library_screen.dart';

/// Choisir les pages au programme d'un match ou d'un tournoi : un document, puis ses pages.
///
/// À la validation, les questions des pages choisies sont préparées (sans IA tout de
/// suite, par l'IA en arrière-plan) ; rend la sélection avec l'état de leurs questions.
class PagePickerScreen extends ConsumerWidget {
  const PagePickerScreen({super.key, this.initial = PageSelection.empty, this.title});

  final PageSelection initial;
  final String? title;

  static Future<PageSelection?> open(BuildContext context, {PageSelection initial = PageSelection.empty, String? title}) =>
      Navigator.of(context).push<PageSelection>(
        MaterialPageRoute(builder: (_) => PagePickerScreen(initial: initial, title: title)),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final library = ref.watch(libraryProvider);
    Future<void> pick(DocumentSummary d) async {
      final initial = initial0(d.id);
      final picked = await Navigator.of(context).push<PageSelection>(
        MaterialPageRoute(builder: (_) => _PagesOfDocument(documentId: d.id, initialIds: initial)),
      );
      if (picked != null && context.mounted) Navigator.of(context).pop(picked);
    }

    return Scaffold(
      appBar: AppBar(title: Text(title ?? l.pickerTitle)),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: library,
          onRetry: () => ref.invalidate(libraryProvider),
          builder: (data) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text(l.pickerHint, style: Theme.of(context).textTheme.bodySmall),
              if (data.mine.isNotEmpty) ...[
                SectionTitle(l.libraryMine),
                for (final d in data.mine) _tile(context, d, pick, owner: true),
              ],
              if (data.shared.isNotEmpty) ...[
                SectionTitle(l.libraryShared),
                for (final d in data.shared) _tile(context, d, pick),
              ],
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.travel_explore),
                label: Text(l.docPublicLibrary),
                onPressed: () async {
                  final d = await Navigator.of(context).push<DocumentSummary>(
                    MaterialPageRoute(builder: (_) => const _PublicPicker()),
                  );
                  if (d != null) await pick(d);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<int> initial0(int documentId) =>
      {for (final d in initial.docs) if (d.documentId == documentId) for (final p in d.pages) p.id};

  Widget _tile(BuildContext context, DocumentSummary d, Future<void> Function(DocumentSummary) pick, {bool owner = false}) =>
      Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Icon(documentIcon(d)),
          title: Text(d.name, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(documentSubtitle(context, d, owner: owner)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => pick(d),
        ),
      );
}

/// Les documents publics, pour en choisir un.
class _PublicPicker extends ConsumerStatefulWidget {
  const _PublicPicker();

  @override
  ConsumerState<_PublicPicker> createState() => _PublicPickerState();
}

class _PublicPickerState extends ConsumerState<_PublicPicker> {
  late Future<List<DocumentSummary>> _docs = ref.read(onlineServiceProvider).publicDocuments('');

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.docPublicLibrary)),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Icons.search), labelText: l.docSearch),
                onSubmitted: (q) => setState(() => _docs = ref.read(onlineServiceProvider).publicDocuments(q.trim())),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _docs,
                builder: (context, snap) {
                  if (snap.hasError) return Center(child: Text(onlineError(context, snap.error!)));
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snap.data!;
                  if (docs.isEmpty) return Center(child: Text(l.docNoPublic));
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final d in docs)
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(documentIcon(d)),
                            title: Text(d.name),
                            subtitle: Text(documentSubtitle(context, d)),
                            onTap: () => Navigator.of(context).pop(d),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Les pages d'un document, à cocher ; « Valider » prépare leurs questions.
class _PagesOfDocument extends ConsumerStatefulWidget {
  const _PagesOfDocument({required this.documentId, required this.initialIds});

  final int documentId;
  final Set<int> initialIds;

  @override
  ConsumerState<_PagesOfDocument> createState() => _PagesOfDocumentState();
}

class _PagesOfDocumentState extends ConsumerState<_PagesOfDocument> {
  late final Set<int> _selected = {...widget.initialIds};
  bool _busy = false;

  Future<void> _confirm(DocumentDetail doc) async {
    setState(() => _busy = true);
    final r = await runOnline(context, () => ref.read(onlineServiceProvider).prepareQuestions(_selected.toList()));
    if (!mounted) return;
    setState(() => _busy = false);
    if (r == null) return;
    final message = aiReasonMessage(context, r.aiQueued, r.aiReason);
    if (message != null) context.toast(message);
    final fresh = {for (final p in r.pages) p.id: p};
    Navigator.of(context).pop(PageSelection([
      DocPages(doc.id, doc.name, doc.unit, [for (final p in doc.pages) if (_selected.contains(p.id)) fresh[p.id] ?? p]),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final docValue = ref.watch(documentProvider(widget.documentId));
    final doc = docValue.value;
    return Scaffold(
      appBar: AppBar(title: Text(doc?.name ?? l.pickerTitle, maxLines: 1, overflow: TextOverflow.ellipsis)),
      bottomNavigationBar: doc == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_busy) const Padding(padding: EdgeInsets.only(bottom: 8), child: LinearProgressIndicator()),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.check),
                        label: Text(l.pickerConfirm(_selected.length)),
                        onPressed: _selected.isEmpty || _busy ? null : () => _confirm(doc),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: docValue,
          onRetry: () => ref.invalidate(documentProvider(widget.documentId)),
          builder: (doc) => ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            children: [
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selected.addAll(doc.pages.where((p) => !p.nearlyEmpty).map((p) => p.id))),
                    child: Text(l.docSelectAll),
                  ),
                  if (_selected.isNotEmpty)
                    TextButton(onPressed: () => setState(_selected.clear), child: Text(l.docSelectNone)),
                ],
              ),
              for (final p in doc.pages)
                CheckboxListTile(
                  value: _selected.contains(p.id),
                  onChanged: (v) => setState(() => v == true ? _selected.add(p.id) : _selected.remove(p.id)),
                  title: Text(p.label, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(pageStatus(context, p)),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
