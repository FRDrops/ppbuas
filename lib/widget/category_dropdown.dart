// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pbb/utils/icon_list.dart';
//ignore_for_file: prefer_const_constructors

class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({super.key, this.cattype, required this.onChanged});
  final String? cattype;
  final ValueChanged<String?> onChanged;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    // Ensure that cattype is a valid category or use a fallback category
    return DropdownButton<String>(
      value: cattype,
      isExpanded: true,
      hint: Text("Pilih Kategory"),
      items: appIcons.homeExpensesCategories
          .map((e) => DropdownMenuItem<String>(
                value: e["name"],
                child: Row(
                  children: [
                    Icon(
                      e["icon"],
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      e["name"],
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value); // Pass the selected value to the parent widget
        }
      },
    );
  }
}