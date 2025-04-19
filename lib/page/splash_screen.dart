import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null && username.isNotEmpty) {
      setState(() {
        _userName = username;
      });
    }

    await Future.delayed(Duration(seconds: 2));

    if (username != null && username.isNotEmpty) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Selamat Datang",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (_userName.isNotEmpty) ...[
              SizedBox(height: 10),
              Text("Halo, $_userName", style: TextStyle(fontSize: 18)),
            ],
          ],
        ),
      ),
    );
  }
}
