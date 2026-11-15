import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/whatsapp.dart';
import '../../online/models.dart';
import '../../online/online_providers.dart';
import '../common.dart';
import '../online/online_common.dart';

final _groupsProvider = FutureProvider.autoDispose<List<PlayerGroup>>((ref) => ref.watch(onlineServiceProvider).groups());

final _groupProvider = FutureProvider.autoDispose.family<PlayerGroup, int>(
  (ref, id) => ref.watch(onlineServiceProvider).group(id),
);

/// Mes groupes : ceux que j'ai créés et ceux que j'ai rejoints.
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GroupsScreen()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final groups = ref.watch(_groupsProvider);
    final service = ref.read(onlineServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.groupsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.group_add_outlined),
        label: Text(l.groupCreate),
        onPressed: () async {
          final name = await askName(context, l.groupCreate, label: l.groupName);
          if (name == null || name.length < 2 || !context.mounted) return;
          final g = await runOnline(context, () => service.createGroup(name));
          ref.invalidate(_groupsProvider);
          if (g != null && context.mounted) await GroupScreen.open(context, g.id);
        },
      ),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: groups,
          onRetry: () => ref.invalidate(_groupsProvider),
          builder: (items) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Text(l.groupsIntro, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: Text(l.groupJoin),
                onPressed: () async {
                  final code = await askName(context, l.groupJoin, label: l.groupCode);
                  if (code == null || code.isEmpty || !context.mounted) return;
                  final r = await runOnline(context, () => service.join(code));
                  ref.invalidate(_groupsProvider);
                  if (r?.group != null && context.mounted) {
                    context.toast(l.groupJoined(r!.group!.name));
                    await GroupScreen.open(context, r.group!.id);
                  } else if (r != null && context.mounted) {
                    context.toast(l.groupNotAGroup);
                  }
                },
              ),
              const SizedBox(height: 8),
              for (final g in items)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(g.mine ? Icons.admin_panel_settings_outlined : Icons.groups_outlined),
                    title: Text(g.name),
                    subtitle: Text('${l.groupMembers(g.memberCount)} · ${g.mine ? l.groupMine : l.groupBy(g.owner)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await GroupScreen.open(context, g.id);
                      ref.invalidate(_groupsProvider);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Un groupe : son code (à partager), ses membres ; le créateur le gère.
class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key, required this.groupId});

  final int groupId;

  static Future<void> open(BuildContext context, int id) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupScreen(groupId: id)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(_groupProvider(groupId));
    final service = ref.read(onlineServiceProvider);
    final myId = ref.watch(onlineMeProvider).value?.player?.id;
    Future<void> update(Future<Object?> Function() action) async {
      if (await runOnline(context, action) != null) ref.invalidate(_groupProvider(groupId));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(value.value?.name ?? l.groupsTitle),
        actions: [
          if (value.value case final g?)
            PopupMenuButton<String>(
              onSelected: (a) async {
                switch (a) {
                  case 'rename':
                    final name = await askName(context, l.groupRename, initial: g.name, label: l.groupName);
                    if (name != null && name.length >= 2 && context.mounted) {
                      await update(() => service.updateGroup(g.id, name: name));
                    }
                  case 'renew':
                    if (await confirmDialog(context, l.groupRenewCode, body: l.groupRenewCodeHint) && context.mounted) {
                      await update(() => service.updateGroup(g.id, renewCode: true));
                    }
                  case 'delete':
                    if (await confirmDialog(context, l.groupDelete, body: l.groupDeleteHint, action: l.groupDelete) &&
                        context.mounted &&
                        await runOnline(context, () => service.deleteGroup(g.id).then((_) => true)) == true &&
                        context.mounted) {
                      Navigator.of(context).pop();
                    }
                  case 'leave':
                    if (await confirmDialog(context, l.groupLeave, action: l.groupLeave) &&
                        context.mounted &&
                        await runOnline(context, () => service.leaveGroup(g.id).then((_) => true)) == true &&
                        context.mounted) {
                      Navigator.of(context).pop();
                    }
                }
              },
              itemBuilder: (_) => g.mine
                  ? [
                      PopupMenuItem(value: 'rename', child: Text(l.groupRename)),
                      PopupMenuItem(value: 'renew', child: Text(l.groupRenewCode)),
                      PopupMenuItem(value: 'delete', child: Text(l.groupDelete)),
                    ]
                  : [PopupMenuItem(value: 'leave', child: Text(l.groupLeave))],
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: AsyncBody(
          value: value,
          onRetry: () => ref.invalidate(_groupProvider(groupId)),
          builder: (g) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _GroupCodeCard(group: g),
              SectionTitle('${l.groupMembersTitle} (${g.memberCount})'),
              for (final m in g.members)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(m.owner ? Icons.admin_panel_settings_outlined : Icons.person_outline),
                  title: Text(m.owner ? '${m.pseudo} (${l.groupOwner})' : m.pseudo,
                      style: TextStyle(fontWeight: m.playerId == myId ? FontWeight.w700 : null)),
                  subtitle: m.busy ? Text(l.teamInviteBusy) : null,
                  trailing: g.mine && !m.owner
                      ? PopupMenuButton<String>(
                          onSelected: (a) async {
                            if (a == 'remove' &&
                                await confirmDialog(context, l.groupRemoveMember(m.pseudo), action: l.teamRemove) &&
                                context.mounted) {
                              await update(() => service.updateGroup(g.id, removePlayerId: m.playerId));
                            } else if (a == 'transfer' &&
                                await confirmDialog(context, l.groupTransfer(m.pseudo), body: l.groupTransferHint) &&
                                context.mounted) {
                              await update(() => service.updateGroup(g.id, transferTo: m.playerId));
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 'remove', child: Text(l.teamRemove)),
                            PopupMenuItem(value: 'transfer', child: Text(l.groupTransferAction)),
                          ],
                        )
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Le code du groupe en grand, son QR code, et de quoi le partager.
class _GroupCodeCard extends StatelessWidget {
  const _GroupCodeCard({required this.group});

  final PlayerGroup group;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = l.groupShareText(group.name, group.code);
    final link = group.link;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(l.groupCode, style: Theme.of(context).textTheme.labelLarge),
            SelectableText(
              group.code,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (link.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: QrImageView(data: link, size: 140, backgroundColor: Colors.white),
              ),
            ],
            const SizedBox(height: 8),
            Text(l.groupShareHint, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
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
                    await Clipboard.setData(ClipboardData(text: group.code));
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
