import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbb/widget/category_list.dart';
import 'package:pbb/widget/tab_bar_view.dart';
import 'package:pbb/widget/timeline_month.dart';

//ignore_for_file: prefer_const_constructors
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Declare category and monthYear as nullable types
  String? category;
  String? monthYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expansive"),
      ),
      body: Column(
        children: [
          // TimeLineMonth widget
          SizedBox(
            child: TimeLineMonth(
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    monthYear = value;  // Update monthYear state
                  });
                }
              },
            ),
          ),
          // CategoryList widget
          SizedBox(
            child: CategoryList(
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;  // Update category state
                  });
                }
              },
            ),
          ),
          // TypeTabBar widget, passing category and monthYear
          TypeTabBar(
            category: category,  // Passing nullable category
            monthYear: monthYear,  // Passing nullable monthYear
          ),
        ],
      ),
    );
  }
}
