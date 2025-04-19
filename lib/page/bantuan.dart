import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bantuan Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Panduan Penggunaan Aplikasi',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Login Section
            _SectionTitle(title: '1. Login Aplikasi'),
            _StepCard(
              number: 1,
              title: 'Masuk ke Aplikasi',
              description:
                  'Buka aplikasi dan masukkan username dan password Anda pada halaman login',
            ),

            // Fitur Utama
            _SectionTitle(title: '2. Fitur Utama Aplikasi'),
            _FeatureCard(
              icon: Icons.timer,
              title: 'Stopwatch',
              description: 'Fitur untuk mengukur waktu dengan akurat',
              steps: [
                'Tekan tombol "Start" untuk memulai stopwatch',
                'Tekan "Lap" untuk mencatat waktu tanpa menghentikan stopwatch',
                'Tekan "Stop" untuk menghentikan pengukuran waktu',
                'Tekan "Reset" untuk mengembalikan stopwatch ke 00:00:00',
              ],
            ),
            _FeatureCard(
              icon: Icons.numbers,
              title: 'Jenis Bilangan',
              description: 'Fitur untuk mengecek jenis bilangan',
              steps: [
                'Masukkan bilangan yang ingin diperiksa',
                'Aplikasi akan menampilkan hasil:',
                '- Bilangan prima atau bukan',
                '- Bilangan desimal atau bulat',
                '- Bilangan positif atau negatif',
                '- Termasuk bilangan cacah atau tidak',
              ],
            ),
            _FeatureCard(
              icon: Icons.location_on,
              title: 'Tracking Lokasi',
              description: 'Fitur untuk melihat lokasi perangkat Anda',
              steps: [
                'Buka menu Tracking Lokasi',
                'Tekan tombol "Ambil Lokasi"',
                'Tunggu hingga aplikasi mendapatkan koordinat GPS',
                'Lokasi akan ditampilkan pada peta interaktif',
                'Koordinat (latitude dan longitude) akan ditampilkan',
              ],
            ),
            _FeatureCard(
              icon: Icons.access_time,
              title: 'Konversi Waktu',
              description:
                  'Fitur untuk mengkonversi tahun ke satuan waktu lebih kecil',
              steps: [
                'Masukkan jumlah tahun yang ingin dikonversi',
                'Tekan tombol "Konversi"',
                'Hasil akan menampilkan konversi ke:\n- Jumlah Hari\n- Jumlah Jam\n- Jumlah Menit\n- Jumlah Detik',
              ],
            ),
            _FeatureCard(
              icon: Icons.public,
              title: 'Daftar Situs',
              description:
                  'Fitur untuk melihat dan mengelola situs rekomendasi',
              steps: [
                'Buka menu Daftar Situs',
                'Scroll untuk melihat semua situs rekomendasi',
                'Tekan ikon hati untuk menambahkan ke favorit',
                'Tekan ikon sampah untuk menghapus situs',
                'Tekan pada item situs untuk membuka di browser',
              ],
            ),

            // FAQ Section
            SizedBox(height: 30),
            Text(
              'Pertanyaan Umum',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _FAQItem(
              question: 'Bagaimana cara menyimpan hasil stopwatch?',
              answer:
                  'Hasil stopwatch tidak disimpan otomatis. Anda perlu mencatatnya manual atau mengambil screenshot.',
            ),
            _FAQItem(
              question: 'Apakah aplikasi bisa bekerja offline?',
              answer:
                  'Sebagian fitur seperti stopwatch dan jenis bilangan bisa bekerja offline, tetapi tracking lokasi dan daftar situs membutuhkan koneksi internet.',
            ),
            _FAQItem(
              question: 'Bagaimana cara menambahkan situs sendiri?',
              answer:
                  'Fitur ini belum tersedia. Anda hanya bisa mengelola situs yang sudah direkomendasikan aplikasi.',
            ),

            // Contact Section
            SizedBox(height: 30),
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Butuh Bantuan Lebih Lanjut?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('m4h4atmints@aplikasi.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('+62 896-7271-1881'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> steps;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Theme.of(context).primaryColor),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(description),
            SizedBox(height: 15),
            Text(
              'Cara Penggunaan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Column(
              children:
                  steps
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${entry.key + 1}. '),
                              Expanded(child: Text(entry.value)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  _FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
