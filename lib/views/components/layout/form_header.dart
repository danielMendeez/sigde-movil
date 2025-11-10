import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double imageSize;

  const FormHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.imageSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.green[300]!, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.green[100]!,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRect(child: Image.asset(imagePath, fit: BoxFit.contain)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
