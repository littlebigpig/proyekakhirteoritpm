import 'package:flutter/material.dart';
import 'package:tugas2teori/models/daftar_situs.dart';
import 'package:tugas2teori/router/router.dart';
import 'package:provider/provider.dart';

void main() {
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
          primary: Colors.lightBlue, // Warna utama light blue
          secondary: Colors.lightBlueAccent, // Warna sekunder
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white, // Warna teks appbar
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
