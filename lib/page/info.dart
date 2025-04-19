import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas2teori/models/daftar_situs.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:go_router/go_router.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";
    setState(() {
      _username = username;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Reset daftar situs favorit
    final daftarSitus = Provider.of<DaftarSitus>(context, listen: false);
    daftarSitus.removeAllFavorites();

    // Arahkan ke halaman login
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 20),

            // Nama user dari SharedPreferences
            Text(
              _username.isNotEmpty ? _username : "User",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Email berdasarkan _username (misalnya user@gmail.com)
            Text(
              _username.isNotEmpty ? '$_username@gmail.com' : "email@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),

            // Help & Logout Buttons
            FilledButton.icon(
              onPressed: () => context.push(Routes.NestedBantuanPage),
              icon: Icon(Icons.help, size: 20),
              label: Text('Bantuan'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout, color: Colors.red, size: 20),
              label: Text('Log out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
