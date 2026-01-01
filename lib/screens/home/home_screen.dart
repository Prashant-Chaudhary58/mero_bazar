import 'package:flutter/material.dart';
import 'package:mero_bazar/screens/widgets/home/category_widget.dart';
import 'package:mero_bazar/screens/widgets/home/home_banner_widget.dart';
import 'package:mero_bazar/screens/widgets/home/home_search_widget.dart';
import 'package:mero_bazar/screens/widgets/home/product_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSearchWidget(),
              const SizedBox(height: 20),
              const HomeBannerWidget(),
              const SizedBox(height: 24),
              const Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    CategoryWidget(title: "All", isSelected: true),
                    CategoryWidget(title: "Vegetables (तरकारी)"),
                    CategoryWidget(title: "Fruits (फलफूल)"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ProductCardWidget(
                    name: product['name'],
                    image: product['image'],
                    rating: product['rating'],
                    price: product['price'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _products = [
  {
    "name": "Maize",
    "price": 10,
    "rating": 3.8,
    "image": "assets/crops/cereals/maize.png",
  },
  {
    "name": "Cabbage",
    "price": 80,
    "rating": 4.0,
    "image": "assets/crops/vegetables/cabbage.png",
  },
  {
    "name": "Potato",
    "price": 50,
    "rating": 4.2,
    "image": "assets/crops/vegetables/Potato.jpg",
  },
  {
    "name": "Brinjal",
    "price": 60,
    "rating": 4.1,
    "image": "assets/crops/vegetables/Brinjal.png",
  },
  {
    "name": "Maize",
    "price": 20,
    "rating": 4.0,
    "image": "assets/crops/cereals/maize.png",
  },
  {
    "name": "Cabbage",
    "price": 60,
    "rating": 4.2,
    "image": "assets/crops/vegetables/cabbage.png",
  },
  {
    "name": "Potato",
    "price": 45,
    "rating": 4.0,
    "image": "assets/crops/vegetables/Potato.jpg",
  },
  {
    "name": "Brinjal",
    "price": 50,
    "rating": 3.9,
    "image": "assets/crops/vegetables/Brinjal.png",
  },
];
