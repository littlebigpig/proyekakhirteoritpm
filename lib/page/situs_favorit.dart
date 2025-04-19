import 'package:flutter/material.dart';
import 'package:tugas2teori/models/daftar_situs.dart';
import 'package:tugas2teori/page/situs_rekomendasi.dart';
import 'package:provider/provider.dart';

class SitusFavorit extends StatelessWidget {
  const SitusFavorit({super.key});

  @override
  Widget build(BuildContext context) {
    final daftarSitus = context.watch<DaftarSitus>();
    final favorites =
        daftarSitus.favorites; // Changed from situsFavorit to favorites

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Situs Favorit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              iconSize: 30,
              tooltip: 'Hapus Semua',
              onPressed: () => _showDeleteConfirmation(context, daftarSitus),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            favorites.isEmpty
                ? const Center(
                  child: Text(
                    'Tidak ada situs favorit',
                    style: TextStyle(fontSize: 18),
                  ),
                )
                : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: CardSitus(situs: favorites[index]),
                    );
                  },
                ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, DaftarSitus daftarSitus) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus semua favorit?'),
            content: const Text('Ini akan menghapus semua situs favorit anda.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  daftarSitus.removeAllFavorites();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua situs favorit terhapus'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
