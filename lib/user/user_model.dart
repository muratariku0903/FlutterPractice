import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends ChangeNotifier {
  String? name;
  String? desc;
  String? email;

  Future fetchUser(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = snapshot.data();
    email = user?['email'];
    name = user?['name'];
    desc = user?['desc'];

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
