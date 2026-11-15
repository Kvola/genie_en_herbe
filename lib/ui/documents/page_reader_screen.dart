import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../engine/text_tools.dart';
import '../../online/doc_models.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/online_common.dart';
import 'practice_screen.dart';

/// Une citation de la page (passage qui justifie une réponse).
class QuoteBlock extends StatelessWidget {
  const QuoteBlock({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    decoration: BoxDecoration(
      color: context.palette.highlight,
      border: Border(left: BorderSide(color: context.palette.accentIcon, width: 3)),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text('« $text »', style: const TextStyle(fontStyle: FontStyle.italic)),
  );
}

/// Lecture des pages (révision avant un match, correction après) : on tourne les pages ;
/// [highlight] est surligné dans la page où il se trouve.
class PageReaderScreen extends ConsumerStatefulWidget {
  const PageReaderScreen({
    super.key,
    required this.pages,
    this.initial = 0,
    this.matchId,
    this.tournamentId,
    this.highlight,
  });

  final List<PageRef> pages;
  final int initial;
  final int? matchId;
  final int? tournamentId;
  final String? highlight;

  static Future<void> open(
    BuildContext context, {
    required List<PageRef> pages,
    int initial = 0,
    int? matchId,
    int? tournamentId,
  }) {
    if (pages.isEmpty) return Future.value();
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PageReaderScreen(pages: pages, initial: initial, matchId: matchId, tournamentId: tournamentId),
    ));
  }

  /// Une seule page (celle d'une question), avec le passage surligné.
  static Future<void> openOne(BuildContext context, int pageId, {int? matchId, String? highlight}) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PageReaderScreen(
          pages: [PageRef(pageId, '', 0, '')],
          matchId: matchId,
          highlight: highlight,
        ),
      ));

  @override
  ConsumerState<PageReaderScreen> createState() => _PageReaderScreenState();
}

class _PageReaderScreenState extends ConsumerState<PageReaderScreen> {
  late final _controller = PageController(initialPage: widget.initial);
  late int _index = widget.initial;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = widget.pages[_index];
    final scale = ref.watch(settingsProvider.select((s) => s.value?.textScale ?? 1.0));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          current.label.isEmpty ? l.pageRead : current.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: l.textSmaller,
            icon: const Icon(Icons.text_decrease),
            onPressed: scale <= 0.8 ? null : () => ref.read(settingsProvider.notifier).setTextScale(scale - 0.1),
          ),
          IconButton(
            tooltip: l.textLarger,
            icon: const Icon(Icons.text_increase),
            onPressed: scale >= 1.8 ? null : () => ref.read(settingsProvider.notifier).setTextScale(scale + 0.1),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _PageBody(
                  page: widget.pages[i],
                  matchId: widget.matchId,
                  tournamentId: widget.tournamentId,
                  highlight: widget.highlight,
                  scale: scale,
                ),
              ),
            ),
            if (widget.pages.length > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: l.pagePrevious,
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _index == 0
                          ? null
                          : () => _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                    ),
                    Expanded(child: Text('${_index + 1} / ${widget.pages.length}', textAlign: TextAlign.center)),
                    IconButton(
                      tooltip: l.pageNext,
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _index >= widget.pages.length - 1
                          ? null
                          : () => _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                    ),
                  ],
                ),
              ),
            if (widget.highlight == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.school_outlined),
                    label: Text(widget.pages.length > 1 ? l.practiceThesePages : l.practiceThisPage),
                    onPressed: () => PracticeScreen.open(
                      context,
                      widget.pages,
                      matchId: widget.matchId,
                      tournamentId: widget.tournamentId,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PageBody extends ConsumerStatefulWidget {
  const _PageBody({required this.page, required this.scale, this.matchId, this.tournamentId, this.highlight});

  final PageRef page;
  final int? matchId;
  final int? tournamentId;
  final String? highlight;
  final double scale;

  @override
  ConsumerState<_PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends ConsumerState<_PageBody> with AutomaticKeepAliveClientMixin {
  late Future<({PageText page, bool offline})> _load = _fetch();

  Future<({PageText page, bool offline})> _fetch() => ref.read(pageCacheProvider).load(
    ref.read(onlineServiceProvider),
    widget.page.id,
    matchId: widget.matchId,
    tournamentId: widget.tournamentId,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = context.l10n;
    return FutureBuilder(
      future: _load,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(onlineError(context, snap.error!), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: () => setState(() => _load = _fetch()), child: Text(l.retry)),
                ],
              ),
            ),
          );
        }
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final page = snap.data!.page;
        final style = readingStyle(context, widget.scale);
        final text = page.text.trim();
        final span = widget.highlight == null || widget.highlight!.isEmpty ? null : findQuote(text, widget.highlight!);
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              '${page.document} — ${page.label}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            if (snap.data!.offline)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(l.pageOfflineCopy, style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 12),
            if (text.isEmpty)
              Text(l.pageEmpty, style: Theme.of(context).textTheme.bodyMedium)
            else
              SelectableText.rich(
                TextSpan(
                  style: style,
                  children: span == null
                      ? [TextSpan(text: keepNumbersTogether(text))]
                      : [
                          TextSpan(text: keepNumbersTogether(text.substring(0, span.$1))),
                          TextSpan(
                            text: keepNumbersTogether(text.substring(span.$1, span.$2)),
                            style: TextStyle(backgroundColor: context.palette.highlight, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: keepNumbersTogether(text.substring(span.$2))),
                        ],
                ),
              ),
          ],
        );
      },
    );
  }
}
