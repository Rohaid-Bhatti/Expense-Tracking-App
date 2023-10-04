import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/activities/EditExpenseScreen.dart';
import 'package:flutter/material.dart';

class ExpenseListFragment extends StatefulWidget {
  const ExpenseListFragment({Key? key}) : super(key: key);

  @override
  State<ExpenseListFragment> createState() => _ExpenseListFragmentState();
}

class _ExpenseListFragmentState extends State<ExpenseListFragment> {
  Future<List<QueryDocumentSnapshot>> _loadExpenses() async {
    final expensesCollection = FirebaseFirestore.instance.collection('expense');
    final querySnapshot = await expensesCollection.get();

    return querySnapshot.docs;
  }

  Future<void> _deleteExpense(String documentId) async {
    try {
      final expensesCollection = FirebaseFirestore.instance.collection('expense');
      await expensesCollection.doc(documentId).delete();
      // Refresh the expense list after deletion
      setState(() {});
    } catch (e) {
      print('Error deleting expense: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _loadExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Display a loading indicator while fetching data
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final expenses = snapshot.data ?? [];

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index].data() as Map<String, dynamic>;
              final documentId = expenses[index].id;

              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.money, color: Colors.white,),
                  ),
                  title: Text(
                    '\$${expense['amount']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Category: ${expense['category']}'),
                      /*Text('Date: ${expense['date']}'),*/
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Implement edit functionality
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditExpenseScreen(
                                expense: expense,
                                documentId: documentId,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteExpense(documentId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // ... (rest of your code)
    );
  }
}
