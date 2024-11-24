import 'package:flutter/material.dart';
import 'package:greend/products/product_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final List<String> categories = ["Fruits", "Bakery", "Beverages"];

CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
