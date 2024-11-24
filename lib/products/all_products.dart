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

class AllProducts {
  static List<Product> get allProducts => [
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
}
