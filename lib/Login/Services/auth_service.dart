import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _errorMessage = "";
  Future<Map<String, dynamic>?> getUser(String uID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('User').doc(uID).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? roleam = documentSnapshot.data();
        return roleam;
      } else {
        print('Document does not exist.');
        return Map();
      }
    } catch (e) {
      print('Error fetching data: $e');
      return Map();
    }
  }

  Future<void> setRole(String uID, String role) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(uID)
          .update({"Current_Role": role});
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<void> navigateUser(
      {required String uID,
      required int roleAmount,
      required List role,
      required BuildContext context}) async {
    try {
      if (roleAmount > 1) {
        context.go("/Role");
      } else {
        await setRole(uID, role[0]);
        await Future.delayed(const Duration(seconds: 1));
        context.go("/");
      }
    } catch (e) {
      print('error navigation');
    }
  }

  Future<int> getRoleAmount(String uID) async {
    var list = await getUser(uID);

    var amount = list?["Role"].length;
    return amount;
  }

  Future<List> getRoles(String uID) async {
    var list = await getUser(uID);

    var roles = list?["Role"];
    return roles;
  }

  Future<String> currentRole() async {
    var uID = _firebaseAuth.currentUser!.uid;
    var list = await getUser(uID);

    var role = list?["Current_Role"];
    return role;
  }

  Future<Map<String, dynamic>?> getCurrUser() async {
    final userID = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('User').doc(userID).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? User = documentSnapshot.data();
      return User;
    } else {
      print('Document does not exist.');
      return Map();
    }
  }

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-not-found':
        return 'User not found.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An error occurred during sign-in.';
    }
  }

  Future<String> getUID() {
    return _firebaseAuth.currentUser!.uid as Future<String>;
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await Future.delayed(const Duration(seconds: 1));
      final uid = _firebaseAuth.currentUser!.uid;
      var roleAmount = await getRoleAmount(uid);
      var roles = await getRoles(uid);
      print(roleAmount);
      print(roles);
      navigateUser(
          uID: uid, roleAmount: roleAmount, role: roles, context: context);
    } catch (e) {
      // print('error: $e');
      // _errorMessage = getErrorMessage(e as String);
      // print(_errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      await setRole(_firebaseAuth.currentUser!.uid, "");
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Handle sign-out errors
      print('Error signing out: $e');
      // You might want to re-throw the error or display an error message to the user
      rethrow;
    }
  }

  Future<String> getUserName(String uid) async {
    try {
      // Assuming you have a 'Users' collection with user documents
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(uid).get();

      // Adjust the field name based on how you store the user's name in Firestore
      // Common field names might be 'name', 'fullName', or 'displayName'
      return userSnapshot.get('Nama') ?? 'Unknown User';
    } catch (e) {
      print('Error getting username: $e');
      return 'Unknown User';
    }
  }
}
