import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../theme.dart';
import '../widgets/nest_nav_bar.dart';
import 'add_spot_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'welcome_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    if (!store.signedIn) return const WelcomeScreen();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: store.tab,
        children: const [
          HomeScreen(),
          MapScreen(),
          AddSpotScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NestNavBar(
        index: store.tab,
        onTap: store.openTab,
      ),
    );
  }
}
