import 'package:flutter/material.dart';

class AnggotaPage extends StatelessWidget {
  const AnggotaPage({super.key});

  final List<Map<String, String>> anggotaKelompok = const [
    {
      'nama': 'Nathaleon Ranggainaya Dian Kuncoro',
      'foto': 'assets/leon.jpg',
      'deskripsi': 'NIM : 123220015',
    },
    {
      'nama': 'Zalfa Aqvi Ramadhani',
      'foto': 'assets/zalfa.jpg',
      'deskripsi': 'NIM : 123220032',
    },
    {
      'nama': 'Muhammad Raihan Abdillah Ridho',
      'foto': 'assets/rehan.jpg',
      'deskripsi': 'NIM : 123220148',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Anggota Kelompok',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: anggotaKelompok.length,
        itemBuilder: (context, index) {
          final anggota = anggotaKelompok[index];
          return Card(
            margin: const EdgeInsets.all(15),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto profil with error handling
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image.asset(
                    anggota['foto']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama anggota
                      Text(
                        anggota['nama']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Deskripsi anggota
                      Text(
                        anggota['deskripsi']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}