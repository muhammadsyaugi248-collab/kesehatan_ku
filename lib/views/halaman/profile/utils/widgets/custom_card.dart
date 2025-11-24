import 'package:flutter/material.dart';

// Komponen Card dasar yang digunakan di semua widget lain.
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Padding(padding: padding, child: child),
    );
  }
}
