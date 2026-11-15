import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../online/online_providers.dart';
import 'common.dart';
import 'online/online_common.dart';
import 'online/online_links.dart';
import 'online/projection_screen.dart';
import 'online/sign_in_screen.dart';

/// Premier écran (pas encore connecté) : ce qu'est Génie en herbe, et comment entrer.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final text = Theme.of(context).textTheme;
    Widget step(IconData icon, String title, String body) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(body),
    );
    return OnlineLinkHandler(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset('assets/branding/icon-full.png', width: 96, height: 96),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.appTitle, textAlign: TextAlign.center, style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(l.welcomeTagline, textAlign: TextAlign.center, style: text.titleMedium),
              const SizedBox(height: 24),
              step(Icons.upload_file, l.welcomeStep1, l.welcomeStep1Body),
              step(Icons.checklist, l.welcomeStep2, l.welcomeStep2Body),
              step(Icons.sports_esports_outlined, l.welcomeStep3, l.welcomeStep3Body),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.login),
                label: Text(l.welcomeSignIn),
                onPressed: () => SignInScreen.open(context),
              ),
              const SizedBox(height: 8),
              Text(l.onlineAccountHint, textAlign: TextAlign.center, style: text.bodySmall),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.cast),
                label: Text(l.onlineProjection),
                onPressed: () => ProjectionScreen.open(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pas de réseau au démarrage (compte connu, serveur injoignable).
class OfflineStartScreen extends ConsumerWidget {
  const OfflineStartScreen({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 48, color: context.palette.brandIcon),
                const SizedBox(height: 12),
                Text(onlineError(context, error), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(onPressed: () => ref.invalidate(onlineMeProvider), child: Text(l.retry)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
