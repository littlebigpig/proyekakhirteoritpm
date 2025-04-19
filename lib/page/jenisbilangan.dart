import 'package:flutter/material.dart';

class JenisBilanganPage extends StatefulWidget {
  const JenisBilanganPage({Key? key}) : super(key: key);

  @override
  State<JenisBilanganPage> createState() => _JenisBilanganPageState();
}

class _JenisBilanganPageState extends State<JenisBilanganPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _checkNumber() {
    try {
      if (_controller.text.isEmpty) {
        setState(() {
          _result = 'Masukkan bilangan terlebih dahulu';
        });
        return;
      }

      final num number = num.parse(_controller.text);
      List<String> types = [];

      // Cek bilangan bulat atau desimal
      if (number % 1 == 0) {
        types.add('Bilangan Bulat');

        // Cek bilangan positif, negatif, atau nol
        if (number > 0) {
          types.add('Bilangan Positif');
        } else if (number < 0) {
          types.add('Bilangan Negatif');
        } else {
          types.add('Bilangan Nol');
        }

        // Cek bilangan cacah (0 dan bilangan asli)
        if (number >= 0) {
          types.add('Bilangan Cacah');
        }

        // Cek bilangan prima (hanya bilangan bulat > 1 yang bisa prima)
        if (number > 1 && number % 1 == 0) {
          bool isPrime = true;
          for (int i = 2; i <= number / 2; i++) {
            if (number % i == 0) {
              isPrime = false;
              break;
            }
          }
          if (isPrime) {
            types.add('Bilangan Prima');
          }
        }
      } else {
        types.add('Bilangan Desimal');

        // Cek bilangan positif atau negatif untuk desimal
        if (number > 0) {
          types.add('Bilangan Positif');
        } else if (number < 0) {
          types.add('Bilangan Negatif');
        }
      }

      setState(() {
        _result = 'Bilangan ${_controller.text} adalah:\n${types.join('\n')}';
      });
    } catch (e) {
      setState(() {
        _result = 'Input tidak valid. Masukkan angka yang benar.';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jenis Bilangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Input field
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Bilangan',
                      border: OutlineInputBorder(),
                      hintText: 'Contoh: 5, -3, 2.5',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol periksa
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _checkNumber,
                  child: const Text('Periksa', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),

                // Judul hasil
                const Text(
                  'Hasil:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Box hasil yang diperkecil
                Container(
                  width: 300,
                  height: 160,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _result,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Deskripsi jenis-jenis bilangan
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade50,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis-jenis Bilangan:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Bilangan Bulat: Bilangan tanpa komponen pecahan atau desimal (contoh: -3, -2, -1, 0, 1, 2, 3).',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '2. Bilangan Positif: Bilangan yang lebih besar dari nol (contoh: 1, 2, 3, 4.5).',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '3. Bilangan Negatif: Bilangan yang lebih kecil dari nol (contoh: -1, -2, -3, -4.5).',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '4. Bilangan Cacah: Bilangan bulat yang tidak negatif (contoh: 0, 1, 2, 3).',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '5. Bilangan Prima: Bilangan bulat positif yang hanya dapat dibagi habis oleh 1 dan dirinya sendiri (contoh: 2, 3, 5, 7, 11).',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '6. Bilangan Desimal: Bilangan yang memiliki komponen pecahan atau desimal (contoh: 1.5, 2.75, -3.25).',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
