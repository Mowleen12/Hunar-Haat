import 'package:flutter/material.dart';

const kIndianRed = Color(0xFFB22222);

class MyAddressScreen extends StatelessWidget {
  const MyAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Address"),
        backgroundColor: kIndianRed,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "You have not saved any address.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
