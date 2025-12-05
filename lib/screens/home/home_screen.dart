import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home screen",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body:Center(child: const  Text('Welcome to home Screen', style: TextStyle(fontSize: 50),)),
      ),
    );
  }
}
