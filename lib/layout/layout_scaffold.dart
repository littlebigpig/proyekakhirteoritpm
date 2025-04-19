import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.lightBlue,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.lightBlueAccent,
            gap: 8,
            onTabChange: (index) {
              navigationShell.goBranch(index);
            },
            padding: const EdgeInsets.all(10),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.person, text: 'Anggota'),
              GButton(icon: Icons.info, text: 'Informasi'),
            ],
          ),
        ),
      ),
    );
  }
}
