import 'package:flutter/material.dart';

import 'common.dart';
import 'documents/library_screen.dart';
import 'online/online_home_screen.dart';
import 'online/online_links.dart';
import 'profile/profile_screen.dart';

/// Les trois onglets : Documents, Jouer, Profil.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return OnlineLinkHandler(
      child: Scaffold(
        // IndexedStack : chaque onglet garde sa position.
        body: IndexedStack(
          index: _index,
          children: const [LibraryScreen(), OnlineHomeScreen(), ProfileScreen()],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.description_outlined),
              selectedIcon: const Icon(Icons.description),
              label: l.navDocuments,
            ),
            NavigationDestination(
              icon: const Icon(Icons.sports_esports_outlined),
              selectedIcon: const Icon(Icons.sports_esports),
              label: l.navPlay,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
