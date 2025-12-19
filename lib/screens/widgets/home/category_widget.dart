import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryWidget({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (_) => onTap?.call(),
        selectedColor: Colors.green.shade300,
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
