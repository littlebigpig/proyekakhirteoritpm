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
        color: const Color.fromARGB(255, 93, 182, 255),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            backgroundColor: const Color.fromARGB(255, 93, 182, 255),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 128, 198, 255),
            gap: 8,
            onTabChange: (index) {
              navigationShell.goBranch(index);
            },
            padding: const EdgeInsets.all(10),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.public, text: 'Countries'),
              GButton(icon: Icons.person, text: 'Profile'),
              GButton(icon: Icons.edit_document, text: 'Kesan & Saran'),
            ],
          ),
        ),
      ),
    );
  }
}
