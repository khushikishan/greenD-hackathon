import 'package:flutter/material.dart';
import 'package:greend/products/dairy_and_eggs_products.dart';
import 'package:greend/products/snacks_products.dart';
import 'package:greend/products/men_shirts_products.dart';
import 'package:greend/products/women_shirts_products.dart';
import 'package:greend/products/hoodie_sweater_products.dart';
import 'package:greend/products/pant_shorts_products.dart';
import 'package:greend/products/socks_shoes_products.dart';
import 'package:greend/products/household_items_products.dart';
import 'package:greend/products/beverages_products.dart';
import 'package:greend/products/frozen_food_products.dart';
import 'package:greend/products/product_model.dart';
import 'package:greend/products/product_card.dart';

class ProductListScreen extends StatelessWidget {
  final String category;
  final List<Product> allProducts = [
    // Combine all product lists into a single list
    ...dairyAndEggsProducts,
    ...snacksProducts,
    ...menShirtsProducts,
    ...womenShirtsProducts,
    ...hoodieSweaterProducts,
    ...pantShortsProducts,
    ...socksShoesProducts,
    ...householdItemsProducts,
    ...beveragesProducts,
    ...frozenFoodProducts,
  ];

  ProductListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    
    final List<Product> filteredProducts = allProducts
        .where((product) => product.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text(
                "No products available in this category.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2 / 3,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product, addToCart: (product) {});
              },
            ),
    );
  }
}
