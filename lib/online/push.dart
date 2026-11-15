/// Notifications push : point d'entrée unique, sans effet dans cette version.
///
/// Les événements (invitation, duel à jouer, questions prêtes…) arrivent par le
/// canal temps réel quand l'application est ouverte. Les notifications
/// application fermée (Firebase Cloud Messaging, comme Quiz Biblique) seront
/// branchées ici dès que l'application Android `ci.ivorycocoa.genie_en_herbe`
/// sera déclarée dans le projet Firebase (fichier google-services) : le reste de
/// l'application n'aura pas à changer.
library;

import 'dart:async';

/// Données d'une notification : le même contenu que l'événement temps réel.
typedef PushData = Map<String, dynamic>;

class PushService {
  final _opened = StreamController<PushData>.broadcast();
  final _received = StreamController<PushData>.broadcast();
  final _tokens = StreamController<String>.broadcast();

  /// Terminé quand l'initialisation est finie.
  Future<void> get ready async {}

  /// Notification touchée (application en arrière-plan ou fermée).
  Stream<PushData> get opened => _opened.stream;

  /// Notification reçue pendant que l'application est à l'écran.
  Stream<PushData> get received => _received.stream;

  /// Nouveau jeton d'appareil.
  Stream<String> get tokenRefreshed => _tokens.stream;

  /// Notification qui a ouvert l'application (lue une seule fois).
  PushData? takeInitial() => null;

  Future<void> init() async {}

  /// Jeton de l'appareil, ou null (pas de notifications).
  Future<String?> token() async => null;

  /// Jeton actuel sans rien demander (pour la déconnexion).
  Future<String?> currentToken() async => null;
}

/// Pour les tests et le web : ne fait rien.
class NoPushService extends PushService {}
