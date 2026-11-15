import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../online/online_providers.dart';
import '../common.dart';
import '../online/online_common.dart';

final contactsProvider = FutureProvider.autoDispose((ref) => ref.watch(onlineServiceProvider).contacts());

/// Mes joueurs : ceux avec qui j'ai joué (favoris d'abord), les joueurs bloqués,
/// et de qui j'accepte les invitations.
class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactsScreen()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(contactsProvider);
    final service = ref.read(onlineServiceProvider);
    Future<void> act(Future<void> Function() action) async {
      if (await runOnline(context, () => action().then((_) => true)) == true) ref.invalidate(contactsProvider);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.contactsTitle)),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: value,
          onRetry: () => ref.invalidate(contactsProvider),
          builder: (data) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SectionTitle(l.invitePolicyTitle),
              RadioGroup<String>(
                groupValue: data.invitePolicy,
                onChanged: (v) => v == null ? null : act(() => service.setInvitePolicy(v)),
                child: Column(
                  children: [
                    RadioListTile<String>(value: 'all', title: Text(l.invitePolicyAll), dense: true),
                    RadioListTile<String>(value: 'known', title: Text(l.invitePolicyKnown), dense: true),
                    RadioListTile<String>(value: 'none', title: Text(l.invitePolicyNone), dense: true),
                  ],
                ),
              ),
              SectionTitle(l.contactsTitle),
              if (data.contacts.isEmpty) Text(l.contactsEmpty, style: Theme.of(context).textTheme.bodySmall),
              for (final c in data.contacts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(c.pseudo),
                  subtitle: Text(l.contactMatches(c.matchesTogether)),
                  leading: IconButton(
                    tooltip: c.favorite ? l.contactUnfavorite : l.contactFavorite,
                    icon: Icon(c.favorite ? Icons.star : Icons.star_border),
                    onPressed: () => act(() => service.setFavorite(c.playerId, !c.favorite)),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (_) async {
                      if (await confirmDialog(context, l.blockPlayer(c.pseudo), body: l.blockHint, action: l.block) &&
                          context.mounted) {
                        await act(() => service.setBlocked(c.playerId, true));
                      }
                    },
                    itemBuilder: (_) => [PopupMenuItem(value: 'block', child: Text(l.block))],
                  ),
                ),
              if (data.blocked.isNotEmpty) ...[
                SectionTitle(l.blockedTitle),
                for (final b in data.blocked)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.block),
                    title: Text(b.pseudo),
                    trailing: TextButton(onPressed: () => act(() => service.setBlocked(b.id, false)), child: Text(l.unblock)),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
