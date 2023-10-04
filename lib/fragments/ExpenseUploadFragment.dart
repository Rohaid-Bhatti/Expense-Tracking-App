import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/activities/FAQScreen.dart';
import 'package:demo/activities/LoginScreen.dart';
import 'package:demo/activities/ProfileScreen.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/fragments/ExpenseListFragment.dart';
import 'package:demo/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ExpenseUploadFragment extends StatefulWidget {
  const ExpenseUploadFragment({Key? key}) : super(key: key);

  @override
  State<ExpenseUploadFragment> createState() => _ExpenseUploadFragmentState();
}

class _ExpenseUploadFragmentState extends State<ExpenseUploadFragment> {
  // Define controllers for text fields
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  // Define variables to store expense details
  double? amount;
  String? description;
  String? category;
  DateTime selectedDate = DateTime.now();
  String? attachmentPath;
  String? _selectedImagePath;

  // Pre-defined list of expense categories with icons
  List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': Icons.fastfood},
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Fee', 'icon': Icons.account_balance},
    {'name': 'Loan', 'icon': Icons.monetization_on},
    {'name': 'Entertainment', 'icon': Icons.movie},
    {'name': 'Others', 'icon': Icons.category},
  ];

  // Function to open date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Function to handle expense submission
  Future<void> _submitExpense() async {
    final amount = amountController.text.trim();
    final description = descriptionController.text.trim();

    if (amount.isEmpty || description.isEmpty || category == null) {
      // Display an error message if any of the required fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all the required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final firebaseService = FirebaseService();

      try {
        await firebaseService.uploadExpense(
          amount: double.parse(amount),
          description: description,
          category: category!,
          date: selectedDate,
          imagePath: _selectedImagePath, // Pass the image path
        );

        // Show a success message or navigate to a new screen
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Expense uploaded successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Optionally, navigate to another screen or reset the form.
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Optionally, reset the form or navigate to another screen.
        amountController.clear();
        descriptionController.clear();
        setState(() {
          category = null;
          selectedDate = DateTime.now();
          _selectedImagePath = null;
        });
      } catch (e) {
        // Handle any errors that occur during the upload
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
              Text('An error occurred while uploading the expense: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Expense'),
        centerTitle: true,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Expense amount input
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(fontSize: 24.0, color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value);
                  });
                },
              ),
            ),

            const SizedBox(height: 16.0),

            // Expense description input
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: descriptionController,
                maxLines: 3,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value);
                  });
                },
              ),
            ),

            const SizedBox(height: 16.0),

            const Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Grid of category selection
            Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: categories.map((categoryItem) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      category = categoryItem['name'];
                    });
                  },
                  child: Card(
                    elevation: 2.0,
                    color: category == categoryItem['name']
                        ? Colors.black
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            categoryItem['icon'],
                            size: 40.0,
                            color: category == categoryItem['name']
                                ? Colors.white
                                : Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            categoryItem['name'],
                            style: TextStyle(
                              color: category == categoryItem['name']
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16.0),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date: ',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      '${selectedDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Attachment upload (optional)
            ElevatedButton(
              onPressed: () {
                // Implement attachment upload functionality here
                _selectImage();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black45,
                onPrimary: Colors.white,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 30.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Upload Receipt',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 8.0,
            ),

            // Display the selected image path
            if (_selectedImagePath != null)
              Text(
                'Selected Image Path: $_selectedImagePath',
                style: TextStyle(fontSize: 16.0),
              ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      fixedSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 0.06),
                      shape: StadiumBorder(),
                      side: const BorderSide(color: Colors.black, width: 1)),
                  child: const Text("Submit"),
                  onPressed: () {
                    _submitExpense();
                  },
                ),
              ),
            ),

            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}
