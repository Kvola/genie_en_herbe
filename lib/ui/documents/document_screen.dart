import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/whatsapp.dart';
import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/create_match_screen.dart';
import '../online/create_tournament_screen.dart';
import '../online/online_common.dart';
import 'import_screen.dart';
import 'page_reader_screen.dart';
import 'practice_screen.dart';
import 'questions_screen.dart';

/// Message après une préparation de questions : ce que fait l'IA, ou pourquoi elle ne le fait pas.
String? aiReasonMessage(BuildContext context, int queued, String reason) {
  final l = context.l10n;
  if (queued > 0 && reason.isEmpty) return l.aiQueued;
  return switch (reason) {
    '' => null,
    'quota' => queued > 0 ? l.aiQueuedPartly : l.aiQuota,
    'failures' => l.aiFailures,
    'language' => l.aiLanguage,
    _ => l.aiUnavailable,
  };
}

/// État des questions d'une page, en quelques mots.
String pageStatus(BuildContext context, PageInfo p) {
  final l = context.l10n;
  if (p.nearlyEmpty) return l.pageEmpty;
  final parts = [l.questionsCount(p.questions.total)];
  switch (p.aiState) {
    case 'queued' || 'running':
      parts.add(l.pageAiRunning);
    case 'done':
      parts.add(l.pageAiDone);
    case 'failed':
      parts.add(l.pageAiFailed);
  }
  if (p.questions.validated > 0) parts.add(l.pageValidated(p.questions.validated));
  return parts.join(' · ');
}

/// Fiche d'un document : ses pages, l'état de leurs questions, et ce qu'on peut en faire.
class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({super.key, required this.documentId, this.justImported = false});

  final int documentId;
  final bool justImported;

  static Future<void> open(BuildContext context, int id, {bool justImported = false}) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => DocumentScreen(documentId: id, justImported: justImported)));

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final _selected = <int>{};
  bool _busy = false;
  Timer? _poll;

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  /// Tant que l'IA travaille sur des pages, la fiche se met à jour toute seule.
  void _watchPending(DocumentDetail doc) {
    final pending = doc.pages.any((p) => p.aiPending);
    if (pending && _poll == null) {
      _poll = Timer.periodic(const Duration(seconds: 8), (_) => ref.invalidate(documentProvider(widget.documentId)));
    } else if (!pending && _poll != null) {
      _poll?.cancel();
      _poll = null;
    }
  }

  PageSelection _selection(DocumentDetail doc) => PageSelection([
    DocPages(doc.id, doc.name, doc.unit, [for (final p in doc.pages) if (_selected.contains(p.id)) p]),
  ]);

  Future<void> _prepare(DocumentDetail doc, {bool ai = true}) async {
    setState(() => _busy = true);
    final r = await runOnline(context, () => ref.read(onlineServiceProvider).prepareQuestions(_selected.toList(), ai: ai));
    if (!mounted) return;
    setState(() => _busy = false);
    if (r == null) return;
    ref.invalidate(documentProvider(widget.documentId));
    ref.invalidate(aiQuotaProvider);
    final message = aiReasonMessage(context, r.aiQueued, ai ? r.aiReason : '');
    context.toast(message ?? context.l10n.questionsPrepared);
  }

  Future<void> _selectRange(DocumentDetail doc) async {
    final l = context.l10n;
    final from = TextEditingController(text: '1'), to = TextEditingController(text: '${doc.pages.length}');
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.docSelectRange),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: from,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.docFrom),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: to,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.docTo),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.confirm)),
        ],
      ),
    );
    final a = int.tryParse(from.text.trim()), b = int.tryParse(to.text.trim());
    from.dispose();
    to.dispose();
    if (ok != true || a == null || b == null) return;
    final lo = a < b ? a : b, hi = a < b ? b : a;
    setState(() {
      for (final p in doc.pages) {
        if (p.number >= lo && p.number <= hi) _selected.add(p.id);
      }
    });
  }

  Future<void> _ownerAction(String action, DocumentDetail doc) async {
    final l = context.l10n;
    final service = ref.read(onlineServiceProvider);
    switch (action) {
      case 'rename':
        final name = await askName(context, l.docRename, initial: doc.name, label: l.importDocTitle);
        if (name == null || name.length < 2 || !mounted) return;
        await runOnline(context, () => service.updateDocument(doc.id, name: name));
      case 'visibility':
        final v = await _VisibilityDialog.show(context, doc.visibility);
        if (v == null || v == doc.visibility || !mounted) return;
        await runOnline(context, () => service.updateDocument(doc.id, visibility: v));
      case 'share':
        final r = await runOnline(context, () => service.shareDocument(doc.id));
        if (r == null || !mounted) return;
        ref.invalidate(documentProvider(doc.id));
        await _ShareSheet.show(context, doc.name, r.code, r.link);
      case 'lang':
        final lang = await showDialog<String>(
          context: context,
          builder: (c) => SimpleDialog(
            title: Text(l.importLang),
            children: [
              for (final code in const ['fr', 'en', 'es', 'pt', 'de', 'it'])
                SimpleDialogOption(onPressed: () => Navigator.pop(c, code), child: Text(languageName(code))),
            ],
          ),
        );
        if (lang == null || !mounted) return;
        await runOnline(context, () => service.updateDocument(doc.id, lang: lang));
      case 'delete':
        if (!await confirmDialog(context, l.docDelete, body: l.docDeleteConfirm, action: l.docDelete) || !mounted) {
          return;
        }
        final ok = await runOnline(context, () async {
          await service.deleteDocument(doc.id);
          return true;
        });
        if (ok == true && mounted) {
          ref.invalidate(libraryProvider);
          Navigator.of(context).pop();
        }
        return;
      case 'forget':
        await runOnline(context, () async {
          await service.forgetDocument(doc.id);
          return true;
        });
        if (mounted) {
          ref.invalidate(libraryProvider);
          Navigator.of(context).pop();
        }
        return;
    }
    ref.invalidate(documentProvider(doc.id));
    ref.invalidate(libraryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final docValue = ref.watch(documentProvider(widget.documentId));
    // L'IA a fini un lot de ce document : la fiche se met à jour.
    ref.listen(playerEventsProvider, (_, next) {
      final e = next.value;
      if (e != null && e.payload['event'] == 'questions_ready' && e.payload['document_id'] == widget.documentId) {
        ref.invalidate(documentProvider(widget.documentId));
      }
    });
    final doc = docValue.value;
    if (doc != null) _watchPending(doc);
    final selection = doc == null ? PageSelection.empty : _selection(doc);
    return Scaffold(
      appBar: AppBar(
        title: Text(doc?.name ?? l.libraryTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (doc != null && doc.mine)
            PopupMenuButton<String>(
              onSelected: (a) => _ownerAction(a, doc),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'share', child: Text(l.docShare)),
                PopupMenuItem(value: 'visibility', child: Text(l.docVisibility)),
                PopupMenuItem(value: 'rename', child: Text(l.docRename)),
                PopupMenuItem(value: 'lang', child: Text(l.importLang)),
                PopupMenuItem(value: 'delete', child: Text(l.docDelete)),
              ],
            )
          else if (doc != null && doc.visibility == 'shared')
            PopupMenuButton<String>(
              onSelected: (a) => _ownerAction(a, doc),
              itemBuilder: (_) => [PopupMenuItem(value: 'forget', child: Text(l.docForget))],
            ),
        ],
      ),
      bottomNavigationBar: doc == null || _selected.isEmpty ? null : _actions(context, doc, selection),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: docValue,
          onRetry: () => ref.invalidate(documentProvider(widget.documentId)),
          builder: (doc) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(documentProvider(widget.documentId)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              children: [
                if (widget.justImported)
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(padding: const EdgeInsets.all(14), child: Text(l.docJustImported)),
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text([
                    l.docUnits(doc.pageCount, doc.unit),
                    languageName(doc.lang),
                    if (doc.mine)
                      switch (doc.visibility) {
                        'public' => l.docPublic,
                        'shared' => l.docShared,
                        _ => l.docPrivate,
                      }
                    else
                      l.docBy(doc.owner),
                  ].join(' · ')),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _selected.addAll(doc.pages.where((p) => !p.nearlyEmpty).map((p) => p.id))),
                      child: Text(l.docSelectAll),
                    ),
                    TextButton(onPressed: () => _selectRange(doc), child: Text(l.docSelectRange)),
                    if (_selected.isNotEmpty)
                      TextButton(onPressed: () => setState(_selected.clear), child: Text(l.docSelectNone)),
                  ],
                ),
                if (_selected.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                    child: Text(l.docSelectHint, style: Theme.of(context).textTheme.bodySmall),
                  ),
                for (final (i, p) in doc.pages.indexed)
                  _PageTile(
                    page: p,
                    selected: _selected.contains(p.id),
                    owner: doc.mine,
                    onChanged: (v) => setState(() => v ? _selected.add(p.id) : _selected.remove(p.id)),
                    onOpen: () => PageReaderScreen.open(
                      context,
                      pages: [for (final x in doc.pages) PageRef(x.id, x.label, doc.id, doc.name)],
                      initial: i,
                    ),
                    onReview: () => QuestionsScreen.open(context, doc, p),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actions(BuildContext context, DocumentDetail doc, PageSelection selection) {
    final l = context.l10n;
    return SafeArea(
      child: Material(
        elevation: 6,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${l.docSelected(_selected.length)} · ${l.pagesReady(selection.readyQuestions)}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              if (_busy) const Padding(padding: EdgeInsets.only(top: 6), child: LinearProgressIndicator()),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(l.docPrepare),
                    onPressed: _busy ? null : () => _prepare(doc),
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.sports_esports_outlined),
                    label: Text(l.docMatch),
                    onPressed: () => CreateMatchScreen.open(context, pages: selection),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.emoji_events_outlined),
                    label: Text(l.docTournament),
                    onPressed: () => CreateTournamentScreen.open(context, pages: selection),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.school_outlined),
                    label: Text(l.docPractice),
                    onPressed: () => PracticeScreen.open(context, [
                      for (final p in doc.pages)
                        if (_selected.contains(p.id)) PageRef(p.id, p.label, doc.id, doc.name),
                    ], lang: doc.lang),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageTile extends StatelessWidget {
  const _PageTile({
    required this.page,
    required this.selected,
    required this.owner,
    required this.onChanged,
    required this.onOpen,
    required this.onReview,
  });

  final PageInfo page;
  final bool selected;
  final bool owner;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final muted = page.nearlyEmpty;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 4, right: 4),
        leading: Checkbox(value: selected, onChanged: (v) => onChanged(v ?? false)),
        title: Text(
          page.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: muted ? Theme.of(context).colorScheme.onSurfaceVariant : null),
        ),
        subtitle: Text(pageStatus(context, page)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (page.aiPending)
              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            if (owner && page.questions.total > 0)
              IconButton(
                tooltip: context.l10n.reviewTitle,
                icon: const Icon(Icons.fact_check_outlined),
                onPressed: onReview,
              ),
            IconButton(
              tooltip: context.l10n.pageRead,
              icon: const Icon(Icons.chrome_reader_mode_outlined),
              onPressed: onOpen,
            ),
          ],
        ),
        onTap: () => onChanged(!selected),
      ),
    );
  }
}

class _VisibilityDialog extends StatelessWidget {
  const _VisibilityDialog({required this.current});

  final String current;

  static Future<String?> show(BuildContext context, String current) =>
      showDialog<String>(context: context, builder: (_) => _VisibilityDialog(current: current));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget option(String value, IconData icon, String title, String hint) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(hint),
      selected: value == current,
      onTap: () => Navigator.pop(context, value),
    );
    return AlertDialog(
      title: Text(l.docVisibility),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          option('private', Icons.lock_outline, l.docPrivate, l.docPrivateHint),
          option('shared', Icons.key_outlined, l.docShared, l.docSharedHint),
          option('public', Icons.public, l.docPublic, l.docPublicHint),
        ],
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel))],
    );
  }
}

/// Partager un document : son code, son lien (WhatsApp, autre application, copier).
class _ShareSheet extends StatelessWidget {
  const _ShareSheet({required this.name, required this.code, required this.link});

  final String name;
  final String code;
  final String link;

  static Future<void> show(BuildContext context, String name, String code, String link) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => _ShareSheet(name: name, code: code, link: link),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = l.docShareText(name, code);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.docShareCode, style: Theme.of(context).textTheme.labelLarge),
            SelectableText(
              code,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(l.docShareHint, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.chat),
                  label: Text(l.lobbyShareWhatsApp),
                  onPressed: () async {
                    if (!await openWhatsApp('$text\n$link')) {
                      await SharePlus.instance.share(ShareParams(text: '$text\n$link'));
                    }
                  },
                ),
                IconButton(
                  tooltip: l.share,
                  icon: const Icon(Icons.share),
                  onPressed: () => SharePlus.instance.share(ShareParams(text: '$text\n$link')),
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
