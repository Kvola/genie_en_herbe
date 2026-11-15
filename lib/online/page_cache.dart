import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'doc_models.dart';
import 'service.dart';

/// Les pages déjà lues, gardées sur le téléphone : on les relit, et on s'entraîne
/// dessus, sans réseau. Les plus anciennes s'effacent au-delà de [maxPages].
class PageCache {
  PageCache([Future<SharedPreferences>? prefs]) : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  static const maxPages = 200;
  static const _index = 'page_cache_index';
  static String _key(int id) => 'page_cache_$id';

  Future<PageText?> get(int id) async {
    try {
      final raw = (await _prefs).getString(_key(id));
      return raw == null ? null : PageText((jsonDecode(raw) as Map).cast<String, dynamic>());
    } catch (_) {
      return null;
    }
  }

  Future<void> put(PageText page) async {
    try {
      final p = await _prefs;
      final ids = (p.getStringList(_index) ?? const <String>[]).where((i) => i != '${page.id}').toList()
        ..add('${page.id}');
      while (ids.length > maxPages) {
        await p.remove(_key(int.parse(ids.removeAt(0))));
      }
      await p.setString(_key(page.id), jsonEncode(page.json));
      await p.setStringList(_index, ids);
    } catch (_) {
      // Stockage plein ou indisponible : la lecture en ligne marche quand même.
    }
  }

  /// Le texte d'une page : du serveur (et gardé), sinon de la copie du téléphone.
  /// Rend aussi si la page vient de la copie (pas de réseau).
  Future<({PageText page, bool offline})> load(
    OnlineService service,
    int id, {
    int? matchId,
    int? tournamentId,
  }) async {
    try {
      final page = await service.page(id, matchId: matchId, tournamentId: tournamentId);
      await put(page);
      return (page: page, offline: false);
    } catch (e) {
      final cached = await get(id);
      if (cached != null) return (page: cached, offline: true);
      rethrow;
    }
  }
}
