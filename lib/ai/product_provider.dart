import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greend/products/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> products = []; 

  ProductProvider() {
    _loadProducts(); 
  }

  
  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = products.map((product) => product.toMap()).toList();
    await prefs.setString('products', jsonEncode(productsJson));
  }

 
  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString('products');
    if (productsJson != null) {
      final List<dynamic> decodedProducts = jsonDecode(productsJson);
      products = decodedProducts.map((json) => Product.fromMap(json)).toList();
      notifyListeners(); 
    }
  }


  void addProduct(Product product) {
    products.add(product);
    _saveProducts();
    notifyListeners();
  }
}
