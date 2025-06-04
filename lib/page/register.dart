import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/database_helper.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password tidak sama")),
        );
        return;
      }

      final dbHelper = DatabaseHelper();
      
      // Check if username is taken
      if (await dbHelper.isUsernameTaken(name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username sudah digunakan")),
        );
        return;
      }

      // Check if email is taken
      if (await dbHelper.isEmailTaken(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email sudah digunakan")),
        );
        return;
      }

      // Create new user
      final user = User(
        name: name,
        email: email,
        password: password,
        profilePicturePath: '',
      );

      // Insert user into database
      final success = await dbHelper.insertUser(user);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registrasi berhasil! Silakan login")),
        );
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal melakukan registrasi")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    "Daftar Akun Baru",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan lengkapi data diri Anda",
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
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        value!.isEmpty ? "Name tidak boleh kosong" : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF7BC6FF)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      if (!value.contains('@')) {
                        return "Email tidak valid";
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
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF7BC6FF)),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? "Konfirmasi password tidak boleh kosong" : null,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _register,
                      child: Text(
                        "Register",
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
                        "Sudah punya akun? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          "Login",
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