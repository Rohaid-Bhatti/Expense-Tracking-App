import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditExpenseScreen extends StatefulWidget {
  final Map<String, dynamic> expense;
  final String documentId;

  const EditExpenseScreen({Key? key, required this.expense, required this.documentId, }) : super(key: key);

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String category = '';

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers and category from the provided expense data.
    amountController.text = widget.expense['amount'].toString();
    descriptionController.text = widget.expense['description'];
    category = widget.expense['category'];
  }

  Future<void> _updateExpense() async {
    try {
      final expensesCollection = FirebaseFirestore.instance.collection('expense');
      await expensesCollection.doc(widget.documentId).update({
        'amount': double.parse(amountController.text.trim()),
        'description': descriptionController.text.trim(),
        'category': category,
      });

      // Navigate back to the expense list screen
      Navigator.pop(context);
    } catch (e) {
      print('Error updating expense: $e');
      // Handle the error as needed
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Expense amount input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),

            const SizedBox(height: 16.0),

            // Expense description input
            TextField(
              controller: descriptionController,
              maxLines: 3,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 16.0),

            // Category selection
            DropdownButtonFormField<String>(
              value: category,
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
              items: ['Food', 'Transport', 'Fee', 'Loan', 'Entertainment', 'Others']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
                  .toList(),
              decoration: InputDecoration(labelText: 'Category'),
            ),

            const SizedBox(height: 16.0),

            // Update button
            ElevatedButton(
              onPressed: _updateExpense,
              child: Text('Update Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
