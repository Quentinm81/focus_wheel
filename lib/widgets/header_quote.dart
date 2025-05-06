import 'package:flutter/material.dart';

class HeaderQuote extends StatelessWidget {
  const HeaderQuote({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for daily motivational quote
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Text(
        '“Focus on being productive instead of busy.”',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Colors.blueGrey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
