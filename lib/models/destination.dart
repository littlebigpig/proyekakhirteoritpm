import 'package:flutter/material.dart';

class Destination {
  Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

final List<Destination> destinations = [
  Destination(label: 'Home', icon: Icons.home),
  Destination(label: 'Countries', icon: Icons.public),
  //Destination(label: 'Anggota', icon: Icons.person),
  Destination(label: 'Informasi', icon: Icons.info),
];
