import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Center(child: const  Text('This is home page', style: TextStyle(fontSize: 50),)),
      ),
    );
  }
}
