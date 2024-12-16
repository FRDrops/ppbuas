import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbb/utils/appvalidator.dart';
import 'package:pbb/widget/category_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";  // Set default value to "credit"
  var category = "Isi Bensin";  // Set valid category (changed from "Lainnya")

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = Appvalidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  // Method to handle form submission
  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoader = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    int timestamp = DateTime.now().microsecondsSinceEpoch;
    var amount = int.parse(amountEditController.text);
    DateTime date = DateTime.now();
    var id = uid.v4();
    String monthyear = DateFormat('MM y').format(date);

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // Check if the document exists
      if (!userDoc.exists) {
        // Document does not exist, handle this case
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          "remainingAmount": 0,  // Initialize with default values
          "totalCredit": 0,
          "totalDebit": 0,
          "updatedAt": timestamp,
        });
      }

      // Now that we know the document exists or was created, safely access the fields
      int remainingAmount = userDoc['remainingAmount'] ?? 0;
      int totalCredit = userDoc['totalCredit'] ?? 0;
      int totalDebit = userDoc['totalDebit'] ?? 0;

      if (type == 'credit') {
        remainingAmount += amount;
        totalCredit += amount;
      } else {
        remainingAmount -= amount;
        totalDebit -= amount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "remainingAmount": remainingAmount,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updatedAt": timestamp,
      });

      var data = {
        "id": id,
        "title": titleEditController.text,
        "amount": amount,
        "type": type,
        "timestamp": timestamp,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
        "monthyear": monthyear,
        "category": category,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection("transaction")
          .doc(id)
          .set(data);

      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      // You can show a dialog or message to the user in case of error
    } finally {
      setState(() {
        isLoader = false;
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Title TextFormField
          TextFormField(
            controller: titleEditController,
            decoration: InputDecoration(labelText: "Judul"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Judul is required';
              }
              return null;
            },
          ),
          // Amount TextFormField
          TextFormField(
            controller: amountEditController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Jumlah"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jumlah is required';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          // Category Dropdown
          CategoryDropdown(
            cattype: category,  // Set the initial category value
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  category = value;  // Update category when selection changes
                });
              }
            },
          ),
          // Transaction Type Dropdown (Credit / Debit)
          DropdownButtonFormField<String>(
            value: type,
            items: [
              DropdownMenuItem(
                value: "credit",
                child: Text("Kredit"),
              ),
              DropdownMenuItem(
                value: "debit",
                child: Text("Debit"),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  type = value;  // Update type when selection changes
                });
              }
            },
          ),
          // Submit Button
          ElevatedButton(
            onPressed: _submitForm,
            child: isLoader ? CircularProgressIndicator() : Text('Submit'),
          ),
        ],
      ),
    );
  }
}