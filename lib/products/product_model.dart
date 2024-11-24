import 'package:hive/hive.dart';

part 'product_model.g.dart'; 

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String company;

  @HiveField(5)
  final List<String> ingredients; 

  @HiveField(6)
  final double price;

  @HiveField(7)
  final String imageUrl;

  @HiveField(8)
  double? ecoRating; 

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.company,
    required this.ingredients,
    required this.price,
    required this.imageUrl,
    this.ecoRating,
  });

 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'company': company,
      'ingredients': ingredients,
      'price': price,
      'imageUrl': imageUrl,
      'ecoRating': ecoRating,
    };
  }

  
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      company: map['company'],
      ingredients: List<String>.from(map['ingredients']),
      price: map['price'],
      imageUrl: map['imageUrl'],
      ecoRating: map['ecoRating'],
    );
  }
}
