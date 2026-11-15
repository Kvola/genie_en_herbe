import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/app_update.dart';
import 'core/web_env.dart';
import 'online/online_providers.dart';
import 'online/push.dart';
import 'providers.dart';
import 'ui/online/online_links.dart';

/// Serveur ; `--dart-define=GENIE_SERVER=http://10.0.2.2:8096` en développement.
const genieServer = String.fromEnvironment('GENIE_SERVER', defaultValue: 'https://iyf.ebng.world');

const _appSlug = 'genie-en-herbe';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Version web : la page est servie par le serveur lui-même (même origine).
  final server = kIsWeb ? webBaseUri().origin : genieServer;
  final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  final push = NoPushService();
  unawaited(push.init());
  runApp(
    ProviderScope(
      overrides: [
        serverUrlProvider.overrideWithValue(server),
        pushProvider.overrideWithValue(push),
        // Liens (genieenherbe://join/CODE) ouverts depuis la page d'invitation du serveur.
        if (android) gameLinksProvider.overrideWithValue(AppLinks().uriLinkStream),
        if (appUpdateSupported)
          appUpdateCheckerProvider.overrideWithValue(
            AppUpdateChecker(server: server, slug: _appSlug, store: PrefsAppUpdateStore()),
          ),
        // Navigateur d'un téléphone Android : proposer l'application installable.
        if (kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          webInstallUrlProvider.overrideWithValue(Uri.parse('$server/apps/$_appSlug')),
      ],
      child: const GenieApp(),
    ),
  );
}
