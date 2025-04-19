import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KonversiWaktuPage extends StatefulWidget {
  const KonversiWaktuPage({Key? key}) : super(key: key);

  @override
  State<KonversiWaktuPage> createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  String formatNumber(double value) {
    if (value.abs() > 1e15) {
      return value.toStringAsExponential(5);
    } else {
      return NumberFormat.decimalPattern().format(value.round());
    }
  }

  void _convertTime() {
    try {
      if (_controller.text.isEmpty) {
        setState(() {
          _result = 'Masukkan jumlah tahun terlebih dahulu';
        });
        return;
      }

      final double years = double.parse(_controller.text);

      if (years < 0) {
        setState(() {
          _result = 'Input tidak valid. Tahun tidak boleh bernilai negatif.';
        });
        return;
      }

      final double totalDays = years * 365.25;
      final double totalHours = totalDays * 24;
      final double totalMinutes = totalHours * 60;
      final double totalSeconds = totalMinutes * 60;

      setState(() {
        _result =
            '${_controller.text} tahun setara dengan:\n'
            '⏱️ ${formatNumber(totalDays)} hari\n'
            '⏰ ${formatNumber(totalHours)} jam\n'
            '⌚ ${formatNumber(totalMinutes)} menit\n'
            '⏳ ${formatNumber(totalSeconds)} detik';
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
      appBar: AppBar(title: const Text('Konversi Waktu')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Jumlah Tahun',
                    border: OutlineInputBorder(),
                    hintText: 'Contoh: 1, 2.5, 0.75',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                onPressed: _convertTime,
                child: const Text('Konversi', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hasil Konversi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: 360,
                height: 200,
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
            ],
          ),
        ),
      ),
    );
  }
}
