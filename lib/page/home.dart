import 'package:flutter/material.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
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
            FilledButton.icon(
              onPressed: () => context.push(Routes.NestedRekomendasi),
              icon: Icon(Icons.list, size: 20),
              label: Text('Daftar Situs'),
              style: FilledButton.styleFrom(
                minimumSize: Size(200, 56),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.push(Routes.NestedStopwatch),
              icon: Icon(Icons.timelapse, size: 20),
              label: Text('Stopwatch'),
              style: FilledButton.styleFrom(
                minimumSize: Size(200, 56),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.push(Routes.NestedMapSample),
              icon: Icon(Icons.map, size: 20),
              label: Text('Tracking Lokasi'),
              style: FilledButton.styleFrom(
                minimumSize: Size(200, 56),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.push(Routes.NestedKonversiWaktu),
              icon: Icon(Icons.date_range, size: 20),
              label: Text('Konversi Waktu'),
              style: FilledButton.styleFrom(
                minimumSize: Size(200, 56),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.push(Routes.NestedJenisBilangan),
              icon: Icon(Icons.numbers, size: 20),
              label: Text('Jenis Bilangan'),
              style: FilledButton.styleFrom(
                minimumSize: Size(200, 56),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
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
