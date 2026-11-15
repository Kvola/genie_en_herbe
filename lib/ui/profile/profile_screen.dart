import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/version.dart';
import '../../core/theme.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/online_common.dart';
import 'contacts_screen.dart';
import 'groups_screen.dart';

/// Onglet « Profil » : le joueur, ses crédits IA, les réglages de l'appareil, le compte.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final me = ref.watch(onlineMeProvider).value;
    final player = me?.player;
    final quota = ref.watch(aiQuotaProvider);
    final settings = ref.watch(settingsProvider).value ?? const AppSettings();
    final server = ref.watch(serverUrlProvider).replaceAll(RegExp(r'/+$'), '');
    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(aiQuotaProvider);
            await ref.read(onlineMeProvider.notifier).refresh();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (player != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text(player.pseudo.characters.first.toUpperCase())),
                  title: Text(player.pseudo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  subtitle: Text('${me!.phone}\n${l.onlineStats(player.played, player.won)} · '
                      '${l.profileTournamentsWon(player.tournamentsWon)}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: l.profileRename,
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      final name = await askName(context, l.profileRename, initial: player.pseudo, label: l.pseudoLabel);
                      if (name == null || name == player.pseudo || !context.mounted) return;
                      final updated = await runOnline(
                        context,
                        () => ref.read(onlineServiceProvider).updateProfile(pseudo: name),
                      );
                      if (updated != null) ref.read(onlineMeProvider.notifier).set(updated);
                    },
                  ),
                ),
              SectionTitle(l.socialTitle),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.people_outline),
                title: Text(l.contactsTitle),
                subtitle: Text(l.contactsHint),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ContactsScreen.open(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.groups_outlined),
                title: Text(l.groupsTitle),
                subtitle: Text(l.groupsHint),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => GroupsScreen.open(context),
              ),
              SectionTitle(l.aiTitle),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: switch (quota) {
                    AsyncData(value: final q) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: context.palette.accentIcon),
                            const SizedBox(width: 8),
                            Expanded(child: Text(q.enabled ? l.aiFreeToday(q.freeRemaining, q.daily) : l.aiOff)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(l.aiCredits(q.credits), style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(l.aiExplain, style: Theme.of(context).textTheme.bodySmall),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.redeem),
                            label: Text(l.aiRedeem),
                            onPressed: () async {
                              final code = await askName(context, l.aiRedeem, label: l.aiCodeLabel);
                              if (code == null || code.isEmpty || !context.mounted) return;
                              final r = await runOnline(context, () => ref.read(onlineServiceProvider).redeemAiCode(code));
                              if (r == null || !context.mounted) return;
                              ref.invalidate(aiQuotaProvider);
                              context.toast(l.aiRedeemed(r.added));
                            },
                          ),
                        ),
                      ],
                    ),
                    AsyncError(:final error) => Text(onlineError(context, error)),
                    _ => const LinearProgressIndicator(),
                  },
                ),
              ),
              SectionTitle(l.settingsTitle),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.translate),
                title: Text(l.settingsLanguage),
                trailing: DropdownButton<String>(
                  value: settings.localeCode ?? 'system',
                  onChanged: (v) => ref.read(settingsProvider.notifier).setLocale(v == 'system' ? null : v),
                  items: [
                    DropdownMenuItem(value: 'system', child: Text(l.settingsSystem)),
                    const DropdownMenuItem(value: 'fr', child: Text('Français')),
                    const DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.dark_mode_outlined),
                title: Text(l.settingsTheme),
                trailing: DropdownButton<String>(
                  value: settings.themeMode,
                  onChanged: (v) => ref.read(settingsProvider.notifier).setTheme(v ?? 'system'),
                  items: [
                    DropdownMenuItem(value: 'system', child: Text(l.settingsSystem)),
                    DropdownMenuItem(value: 'light', child: Text(l.settingsLight)),
                    DropdownMenuItem(value: 'dark', child: Text(l.settingsDark)),
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.help_outline),
                title: Text(l.settingsGuide),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => launchUrl(Uri.parse('$server/apps/genie-en-herbe/guide'), mode: LaunchMode.externalApplication),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline),
                title: Text(l.settingsVersion(appVersion)),
              ),
              SectionTitle(l.profileAccount),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout),
                title: Text(l.profileSignOut),
                onTap: () async {
                  if (!await confirmDialog(context, l.profileSignOut, action: l.profileSignOut)) return;
                  await ref.read(onlineMeProvider.notifier).signOut();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                title: Text(l.profileDelete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                onTap: () async {
                  final ok = await confirmDialog(context, l.profileDelete, body: l.profileDeleteConfirm, action: l.profileDelete);
                  if (!ok || !context.mounted) return;
                  final done = await runOnline(context, () async {
                    await ref.read(onlineServiceProvider).deleteAccount();
                    return true;
                  });
                  if (done == null || !context.mounted) return;
                  ref.read(onlineMeProvider.notifier).set(null);
                  context.toast(l.profileDeleted);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
