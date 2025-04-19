import 'package:flutter/material.dart'; // Changed from widgets.dart
import 'package:tugas2teori/models/situs.dart';

class DaftarSitus extends ChangeNotifier {
  final List<Situs> _daftarSitus = [
    Situs(
      nama: "ChatGPT",
      deskripsi:
          "Platform chatbot AI berbasis NLP yang membantu dalam pemrograman, debugging, penulisan laporan teknis, dan brainstorming ide proyek. Dapat menjelaskan konsep informatika secara detail.",
      image: "assets/chatgpt.jpeg",
      isFavorite: false, // Added for all items
      url: " https://chat.openai.com",
    ),
    Situs(
      nama: "DeepSeek",
      deskripsi:
          "Chatbot AI gratis dengan kemampuan pemrograman dan penalaran teknis. Alternatif hemat untuk ChatGPT dengan fitur serupa.",
      image: "assets/deepseek.png",
      isFavorite: false,
      url: " https://www.deepseek.com",
    ),
    Situs(
      nama: "Claude AI",
      deskripsi:
          "AI asisten dari Anthropic yang fokus pada keamanan dan pemahaman konteks panjang. Berguna untuk analisis dokumen, riset, dan pemecahan masalah logika.",
      image: "assets/claude.jpeg",
      isFavorite: false,
      url: "https://claude.ai",
    ),
    Situs(
      nama: "Grok (by xAI)",
      deskripsi:
          "AI chatbot dari Elon Musk yang terintegrasi dengan platform X (Twitter), memberikan jawaban real-time dan sarkastik. Cocok untuk diskusi teknologi terkini.",
      image: "assets/grok.jpeg",
      isFavorite: false,
      url: "https://grok.x.ai",
    ),
    Situs(
      nama: "Grammarly",
      deskripsi:
          "Alat penulisan AI untuk memperbaiki tata bahasa, ejaan, dan gaya penulisan laporan teknis atau dokumentasi kode.",
      image: "assets/grammarly.jpeg",
      isFavorite: false,
      url: " https://www.grammarly.com",
    ),
    Situs(
      nama: "Google Gemini",
      deskripsi:
          "AI canggih dari Google yang terintegrasi dengan layanan Google (Docs, Gmail, dll.), cocok untuk riset, coding, dan analisis data.",
      image: "assets/gemini.jpeg",
      isFavorite: false,
      url: "https://gemini.google.com",
    ),
    Situs(
      nama: "Meta AI",
      deskripsi:
          "Asisten AI terintegrasi di WhatsApp, Instagram, Facebook, dan Messenger. Mendukung pemrosesan teks, gambar, terjemahan konten, dan generasi iklan berbasis AI. Ditenagai oleh model Llama 4 (multimodal) dan digunakan oleh 700 juta pengguna bulanan",
      image: "assets/meta.jpeg",
      isFavorite: false,
      url: "https://ai.meta.com/meta-ai",
    ),
  ];

  List<Situs> get daftarsitus => _daftarSitus;

  List<Situs> get favorites => _daftarSitus.where((s) => s.isFavorite).toList();

  void toggleFavorite(int index) {
    _daftarSitus[index].isFavorite = !_daftarSitus[index].isFavorite;
    notifyListeners();
  }

  void removeAllFavorites() {
    for (var situs in _daftarSitus) {
      situs.isFavorite = false;
    }
    notifyListeners();
  }
}
