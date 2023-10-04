import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/activities/FAQScreen.dart';
import 'package:demo/activities/LoginScreen.dart';
import 'package:demo/activities/ProfileScreen.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/fragments/ExpenseListFragment.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Map<String, dynamic>> expenseData = [];
  List<Map<String, dynamic>> recentExpenses = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final expenseCollection = FirebaseFirestore.instance.collection('expense');

      // Fetch and update expenseData (e.g., for the pie chart)
      final expenseDataSnapshot = await expenseCollection.get();
      expenseData = expenseDataSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'category': data['category'],
          'amount': data['amount'],
        };
      }).toList();

      // Fetch and update recentExpenses (e.g., for the list)
      final recentSnapshot = await expenseCollection
          /*.orderBy('timestamp', descending: true)*/
          .limit(3)
          .get();
      recentExpenses = recentSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'category': data['category'],
          'amount': data['amount'],
          'date': (data['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
        };
      }).toList();

      // Update the UI by calling setState
      setState(() {});
    } catch (e) {
      // Handle errors, e.g., display an error message
      print('Error fetching data: $e');
    }
  }

  Future<void> showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to Logout?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await Get.put(AuthController()).signoutMethod();
                Get.offAll(() => LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total expenses for the past month
    final DateTime now = DateTime.now();
    final DateTime lastMonth = now.subtract(Duration(days: 30)); // Assuming 30 days in a month
    final double totalExpensesLastMonth = recentExpenses
        .where((expense) => expense['date'].isAfter(lastMonth))
        .fold(0.0, (sum, expense) => sum + expense['amount']);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dashboard'),
      ),

      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Container(
                height: 200,
                padding:
                const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 24),
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Drawer Head',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              ListTile(
                horizontalTitleGap: 0,
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.person, size: 20),
                title: Text("My Profile", style: TextStyle()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.manage_history, size: 20),
                title: const Text("Expense History", style: TextStyle()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpenseListFragment()));
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.question_mark_rounded, size: 20),
                title: Text("FAQs", style: TextStyle()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FAQScreen()));
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.logout, size: 20),
                title: Text("Logout", style: TextStyle()),
                onTap: () {
                  showLogOutDialog();
                },
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display a pie chart of expense categories
            Container(
              height: 350,
              child: PieChart(
                PieChartData(
                  sections: expenseData.map((expense) {
                    return PieChartSectionData(
                      title: expense['category'],
                      value: double.parse(expense['amount'].toString()),
                    );
                  }).toList(),
                  // Other customization options for your chart
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Display the total expenses for the past month
            Center(
              child: Text(
                'Total Expenses for the Past Month: \$${totalExpensesLastMonth.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16.0,),
              ),
            ),

            const SizedBox(height: 10),

            // Display the recent expenses
            Text(
              'Recent Expenses',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: recentExpenses.length,
              itemBuilder: (context, index) {
                final expense = recentExpenses[index];
                final formattedDate = DateFormat.yMMMMd().format(expense['date']); // Format the date
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 3,),
                        Column(
                          children: [
                            const SizedBox(height: 5,),
                            Text(expense['category']),
                            const SizedBox(height: 5,),
                            Text('\$${expense['amount'].toStringAsFixed(2)}'),
                            const SizedBox(height: 5,),
                          ],
                        ),
                        Text(formattedDate),
                        const SizedBox(width: 3,),// Display the formatted date
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}