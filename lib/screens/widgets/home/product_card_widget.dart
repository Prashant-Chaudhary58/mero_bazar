import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final String name;
  final String image;
  final double rating;
  final int price;
  final VoidCallback? onFavoriteTap;

  const ProductCardWidget({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.price,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: onFavoriteTap,
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(rating.toString()),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Rs. $price",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
