import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Center(child: const  Text('Welcome to home Screen', style: TextStyle(fontSize: 50),)),
      ),
    );
  }
}
