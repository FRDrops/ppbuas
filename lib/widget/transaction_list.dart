import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbb/widget/transactions_card.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
class TransactionList extends StatelessWidget {
  TransactionList({super.key, required this.category, required this.type, required this.monthYear});
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final String category;
  final String type;
  final String monthYear;

  
  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('transaction')
                .orderBy('timestamp', descending: true)
                .where('monthYear', isEqualTo: "")
                .where('type', isEqualTo: "");

                if (category != "All") {
                  query = query.where("category", isEqualTo: category);
                };
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: query.limit(150).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No transactions available'));
              }

              // Accessing the list of transaction documents
              var transactionDocs = snapshot.data!.docs;

              // Returning the ListView builder to display each transaction
              return ListView.builder(
                shrinkWrap: true,
                itemCount: transactionDocs.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var transaction = transactionDocs[index].data() as Map<String, dynamic>;
                  String description = transaction['title'] ?? 'No Description';
                  String amount = transaction['amount']?.toString() ?? '0';
                  String category = transaction['category'] ?? 'Others';
                  var timestamp = transaction['timestamp'];

                  return TransactionCard(
                    description: description,
                    amount: amount,
                    category: category,
                    timestamp: timestamp,
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
