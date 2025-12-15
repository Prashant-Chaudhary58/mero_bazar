import 'package:flutter/material.dart';
import 'package:mero_bazar/screens/widgets/bottom_navigation_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("This is home screen"),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(),
      
    );
  }
}
