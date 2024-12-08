import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Pages/LoginPage.dart';

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
      }
    } catch (e) {
      print('Error fetching data: $e');
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
        context.go("Role");
      } else {
        setRole(uID, role[0]);
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

  String _getErrorMessage(String errorCode) {
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

      navigateUser(
          uID: uid, roleAmount: roleAmount, role: roles, context: context);
    } catch (e) {
      print('error: $e');
      _errorMessage = _getErrorMessage(e as String);
      print(_errorMessage);
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
}
