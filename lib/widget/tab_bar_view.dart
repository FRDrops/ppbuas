import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbb/widget/transaction_list.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
class TypeTabBar extends StatelessWidget {
  final String? category;  // Allow nullable type
  final String? monthYear; // Allow nullable type

  TypeTabBar({Key? key, this.category, this.monthYear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  text: "Kredit",
                ),
                Tab(
                  text: "Debit",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text("Kredit for $category in $monthYear"),  // Example of using the passed values
                  ),
                  Center(
                    child: Text("Debit for $category in $monthYear"),  // Example of using the passed values
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
