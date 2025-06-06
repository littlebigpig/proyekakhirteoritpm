import 'package:flutter/material.dart';

class Destination {
  Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

final List<Destination> destinations = [
  Destination(label: 'Home', icon: Icons.home),
  Destination(label: 'Countries', icon: Icons.public),
  Destination(label: 'Informasi', icon: Icons.info),
  Destination(label: 'Kesan & Saran', icon: Icons.edit_document),
];
