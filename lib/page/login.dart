import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';
import '../models/user.dart';
import '../services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String password = passwordController.text;

      final dbHelper = DatabaseHelper();
      final user = await dbHelper.verifyUser(name, password);

      if (user != null) {
        try {
          final notificationService = NotificationService();
          await notificationService.showNotification(
            title: 'Login Berhasil',
            body: 'Selamat datang kembali, $name!',
          );
        } catch (e) {
          print('Error showing notification: $e');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("is_logged_in", true);
        await prefs.setString('username', name);
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username atau password salah")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/natnow_dark.png',
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan masuk ke akun Anda",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person_outline, color: Color(0xFF7BC6FF)),
                      helperText: '2-10 karakter',
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name tidak boleh kosong";
                      }
                      if (value.length < 2) {
                        return "Name minimal 2 karakter";
                      }
                      if (value.length > 10) {
                        return "Name maksimal 10 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF7BC6FF)),
                      helperText: '2-10 karakter',
                    ),
                    obscureText: true,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 2) {
                        return "Password minimal 2 karakter";
                      }
                      if (value.length > 10) {
                        return "Password maksimal 10 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        key: const Key('login_register_button'),
                        onPressed: () => context.go('/register'),
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7BC6FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
