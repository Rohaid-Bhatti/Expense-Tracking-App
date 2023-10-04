import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadExpense({
    required double amount,
    required String description,
    required String category,
    required DateTime date,
    String? imagePath,
  }) async {
    try {

      final user = _auth.currentUser;
      if (user == null) {
        // Handle the case where the user is not authenticated
        throw Exception('User is not authenticated');
      }

      // Upload image to Firebase Storage
      String? imageUrl;
      if (imagePath != null) {
        final Reference storageRef =
        _storage.ref().child('expense_images/${DateTime.now()}.jpg');
        final UploadTask uploadTask = storageRef.putFile(File(imagePath));
        await uploadTask.whenComplete(() async {
          imageUrl = await storageRef.getDownloadURL();
        });
      }

      // Create a map containing the expense data including the 'id' field
      final Map<String, dynamic> expenseData = {
        'amount': amount,
        'description': description,
        'category': category,
        'date': date,
        'imageUrl': imageUrl,
        'userEmail': user.email, // Store user's email
        'userId': user.uid, // Store user's UID
        'id': '', // Initialize 'id' field (will be updated below)
      };

      // Store the expense data in Firestore and retrieve the auto-generated ID
      final docRef = await _firestore.collection('expense').add(expenseData);

      // Update the 'id' field with the auto-generated document ID
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception('Error uploading expense: $e');
    }
  }
}


//get users data
class FirestoreServices {
  static getUser(uid) {
    return FirebaseFirestore.instance.collection("users").where('uid', isEqualTo: uid).snapshots();
  }
}