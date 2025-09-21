import 'package:flutter/material.dart';

const kIndianRed = Color(0xFFB22222);

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: kIndianRed,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "No orders yet.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
