import 'package:flutter/material.dart';

const kIndianRed = Color(0xFFB22222);

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: kIndianRed,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "For help and support, contact us at:\n\nEmail: support@hunarhaat.com\nPhone: +91 9876543210",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
