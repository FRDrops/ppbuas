import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {
      "name": "Isi Bensin",
      "icon": FontAwesomeIcons.gasPump,
    },
    {
      "name": "Belanja",
      "icon": FontAwesomeIcons.cartShopping,
    },
    {
      "name": "Internet",
      "icon": FontAwesomeIcons.wifi,
    },
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
        (category) => category['name'] == categoryName,
        orElse: () => {"icon": FontAwesomeIcons.cartShopping});
    return category['icon'];
  }
}
