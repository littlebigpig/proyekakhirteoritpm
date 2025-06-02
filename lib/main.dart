import 'package:flutter/material.dart';
import 'package:tugas2teori/models/daftar_situs.dart';
import 'package:tugas2teori/router/router.dart';
import 'package:provider/provider.dart';
import 'package:tugas2teori/services/database_helper.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DaftarSitus())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color.fromARGB(255, 93, 182, 255), // Warna utama light blue
          secondary: Colors.lightBlueAccent, // Warna sekunder
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 93, 182, 255),
          foregroundColor: Colors.white, // Warna teks appbar
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 93, 182, 255),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
