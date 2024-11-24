import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:greend/cart/cart_page.dart';
import 'package:greend/pages/menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> allProducts = [
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

  List<Product> filteredProducts = [];
  String searchQuery = '';
  String? selectedCategory;
  final List<String> categories = [
    'All',
    'Dairy and Eggs',
    'Snacks',
    'Shirts - Men',
    'Shirts - Women',
    'Hoodie/Sweater',
    'Pant/Shorts',
    'Socks/Shoes',
    'Household Items',
    'Beverages',
    'Frozen Food',
  ];

  final List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    allProducts.shuffle(Random());
    _loadState(); 
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();

    
    await prefs.setString('searchQuery', searchQuery);
    await prefs.setString('selectedCategory', selectedCategory ?? 'All');

    
    final productIds = filteredProducts.map((product) => product.id).toList();
    await prefs.setString('filteredProducts', jsonEncode(productIds));
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

  
    searchQuery = prefs.getString('searchQuery') ?? '';
    selectedCategory = prefs.getString('selectedCategory');

    
    final productIdsJson = prefs.getString('filteredProducts');
    if (productIdsJson != null) {
      final List<int> productIds = List<int>.from(jsonDecode(productIdsJson));
      filteredProducts = allProducts
          .where((product) => productIds.contains(product.id))
          .toList();
    } else {
      filteredProducts = allProducts;
    }

    setState(() {});
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) => product.category == category)
            .toList();
      }
      _saveState(); 
    });
  }

  void searchProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = allProducts
          .where((product) =>
              (selectedCategory == null ||
                  selectedCategory == 'All' ||
                  product.category == selectedCategory) &&
              (product.name.toLowerCase().contains(query.toLowerCase()) ||
                  product.company.toLowerCase().contains(query.toLowerCase())))
          .toList();
      _saveState(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuScreen(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 8.0, right: 8.0),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF183C24)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF183C24),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: TextField(
                      onChanged: searchProducts,
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        border: InputBorder.none,
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF183C24)),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Color(0xFF183C24)),
                  onPressed: _showCategoryFilterDialog,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chat, color: Color(0xFF183C24)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/aiChat');
                  },
                ),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart,
                          color: Color(0xFF183C24)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(cart: cart),
                          ),
                        );
                      },
                    ),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cart.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
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
                return ProductCard(product: product, addToCart: addToCart);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: categories.map((category) {
            return ListTile(
              title: Text(category),
              selected: category == selectedCategory,
              onTap: () {
                Navigator.pop(context);
                filterByCategory(category);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
