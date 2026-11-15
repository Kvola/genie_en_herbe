import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../online/api.dart';
import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/online_common.dart';
import 'document_screen.dart';
import 'import_screen.dart';
import 'page_reader_screen.dart';
import 'practice_screen.dart';

/// Icône d'un document d'après son format.
IconData documentIcon(DocumentSummary d) => switch (d.fileKind) {
  'pdf' => Icons.picture_as_pdf_outlined,
  'pptx' || 'odp' => Icons.slideshow_outlined,
  'xlsx' || 'csv' => Icons.table_chart_outlined,
  'photo' => Icons.photo_camera_outlined,
  _ => Icons.description_outlined,
};

/// « 12 pages · Public » : ce qu'on voit d'un document dans une liste.
String documentSubtitle(BuildContext context, DocumentSummary d, {bool owner = false}) {
  final l = context.l10n;
  return [
    l.docUnits(d.pageCount, d.unit),
    if (owner)
      switch (d.visibility) {
        'public' => l.docPublic,
        'shared' => l.docShared,
        _ => l.docPrivate,
      }
    else
      l.docBy(d.owner),
  ].join(' · ');
}

/// Ajoute à la bibliothèque un document partagé par son code (saisi, ou reçu par lien), puis l'ouvre.
Future<void> addSharedDocument(BuildContext context, WidgetRef ref, {String? code}) async {
  final l = context.l10n;
  code ??= await askName(context, l.docAddShared, label: l.docShareCode);
  if (code == null || code.trim().isEmpty || !context.mounted) return;
  final doc = await runOnline(context, () => ref.read(onlineServiceProvider).addSharedDocument(code!.trim()));
  if (doc == null || !context.mounted) return;
  ref.invalidate(libraryProvider);
  context.toast(l.docAdded(doc.name));
  await DocumentScreen.open(context, doc.id);
}

/// Onglet « Documents » : mes documents, ceux qu'on m'a partagés, les documents publics.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final library = ref.watch(libraryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.libraryTitle),
        actions: [
          IconButton(
            tooltip: l.docPublicLibrary,
            icon: const Icon(Icons.travel_explore),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PublicLibraryScreen())),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'code') addSharedDocument(context, ref);
            },
            itemBuilder: (_) => [PopupMenuItem(value: 'code', child: Text(l.docAddShared))],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.upload_file),
        label: Text(l.docImport),
        onPressed: () => ImportScreen.open(context),
      ),
      body: SafeArea(
        top: false,
        // Riverpod relance seul un chargement échoué : pendant ces essais l'état est « en cours »
        // mais garde l'erreur. Hors ligne, on montre tout de suite les pages gardées.
        child: !library.hasValue && library.error is ApiException && (library.error as ApiException).isNetwork
            ? _OfflineLibrary(onRetry: () => ref.invalidate(libraryProvider))
            : AsyncBody(
                value: library,
                onRetry: () => ref.invalidate(libraryProvider),
                builder: (data) => RefreshIndicator(
                  onRefresh: () async => ref.invalidate(libraryProvider),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    children: [
                      if (data.mine.isEmpty && data.shared.isEmpty) const _EmptyLibrary(),
                      if (data.mine.isNotEmpty) ...[
                        SectionTitle(l.libraryMine),
                        for (final d in data.mine) _DocTile(doc: d, owner: true),
                      ],
                      if (data.shared.isNotEmpty) ...[
                        SectionTitle(l.libraryShared),
                        for (final d in data.shared) _DocTile(doc: d),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({required this.doc, this.owner = false});

  final DocumentSummary doc;
  final bool owner;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      leading: Icon(documentIcon(doc), color: context.palette.brandIcon),
      title: Text(doc.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(documentSubtitle(context, doc, owner: owner)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => DocumentScreen.open(context, doc.id),
    ),
  );
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.local_library_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(l.libraryEmptyTitle, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l.libraryEmptyBody, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Les documents publics, avec une recherche par titre.
class PublicLibraryScreen extends ConsumerStatefulWidget {
  const PublicLibraryScreen({super.key});

  @override
  ConsumerState<PublicLibraryScreen> createState() => _PublicLibraryScreenState();
}

class _PublicLibraryScreenState extends ConsumerState<PublicLibraryScreen> {
  Timer? _debounce;
  String _q = '';
  AsyncValue<List<DocumentSummary>> _docs = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _load('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _load(String q) async {
    _q = q;
    try {
      final docs = await ref.read(onlineServiceProvider).publicDocuments(q);
      if (mounted && q == _q) setState(() => _docs = AsyncData(docs));
    } catch (e, st) {
      if (mounted && q == _q) setState(() => _docs = AsyncError(e, st));
    }
  }

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
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 400), () => _load(v.trim()));
                },
              ),
            ),
            Expanded(
              child: AsyncBody(
                value: _docs,
                onRetry: () => _load(_q),
                builder: (docs) => docs.isEmpty
                    ? Center(
                        child: Padding(padding: const EdgeInsets.all(24), child: Text(l.docNoPublic)),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        children: [for (final d in docs) _DocTile(doc: d)],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hors ligne : les pages déjà lues, gardées sur cet appareil, pour les relire et s'entraîner.
class _OfflineLibrary extends ConsumerWidget {
  const _OfflineLibrary({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return FutureBuilder<List<PageText>>(
      future: ref.read(pageCacheProvider).all(),
      builder: (context, snap) {
        final pages = snap.data ?? const <PageText>[];
        final byDoc = <int, List<PageText>>{};
        for (final p in pages) {
          byDoc.putIfAbsent(p.documentId, () => []).add(p);
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                leading: const Icon(Icons.wifi_off),
                title: Text(l.offlineTitle),
                subtitle: Text(l.offlineHint),
                trailing: TextButton(onPressed: onRetry, child: Text(l.retry)),
              ),
            ),
            if (snap.hasData && pages.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l.offlineNoPages, textAlign: TextAlign.center),
              ),
            for (final entry in byDoc.entries) ...[
              SectionTitle(entry.value.first.document),
              for (final p in (entry.value..sort((a, b) => a.number.compareTo(b.number))))
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    title: Text(p.label),
                    trailing: IconButton(
                      tooltip: l.practiceThisPage,
                      icon: const Icon(Icons.school_outlined),
                      onPressed: () => PracticeScreen.open(context, [
                        PageRef(p.id, p.label, p.documentId, p.document),
                      ], lang: p.lang),
                    ),
                    onTap: () => PageReaderScreen.open(
                      context,
                      pages: [for (final x in entry.value) PageRef(x.id, x.label, x.documentId, x.document)],
                      initial: entry.value.indexOf(p),
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
