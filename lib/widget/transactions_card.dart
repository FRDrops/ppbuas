
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Assuming this is your main widget where you display the transactions
class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Pengeluaran Saat Ini",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
          // StreamBuilder to fetch the transactions from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('transaction')
                .orderBy('timestamp', descending: true)
                .limit(20)
                .snapshots(),
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

class TransactionCard extends StatelessWidget {
  final String description;
  final String amount;
  final String category;
  final dynamic timestamp; // Timestamp can now be either int or Timestamp

  TransactionCard({
    required this.description,
    required this.amount,
    required this.category,
    required this.timestamp, // Allow timestamp to be either int or Timestamp
  });

  // Map categories to icons
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Isi Bensin':
        return FontAwesomeIcons.gasPump;
      case 'Belanja':
        return FontAwesomeIcons.cartShopping;
      case 'Internet':
        return FontAwesomeIcons.wifi;
      default:
        return FontAwesomeIcons.questionCircle; // Default icon if category doesn't match
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date;

    // Check if the timestamp is an int (Unix timestamp) or a Firestore Timestamp
    if (timestamp is int) {
      date = DateTime.fromMillisecondsSinceEpoch(timestamp); // Convert Unix timestamp to DateTime
    } else if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else {
      date = DateTime.now();
    }

    String formattedDate = DateFormat('dd MMM yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  color: Colors.blue.withOpacity(0.09),
                  blurRadius: 10.0,
                  spreadRadius: 4.0)
            ]),
        child: ListTile(
          minVerticalPadding: 10,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          leading: Container(
            width: 70,
            height: 100,
            child: Icon(
              getCategoryIcon(category),
              size: 30,
              color: Colors.green.withOpacity(0.7),
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Text(description)),
              Text(
                " Rp$amount",
                style: TextStyle(color: Colors.green),
              )
            ],
          ),
          subtitle: Text(
            formattedDate, // Display the formatted date
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
