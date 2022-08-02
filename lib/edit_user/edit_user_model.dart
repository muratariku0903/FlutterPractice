import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUserModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  String? name;
  String? desc;

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setDesc(String desc) {
    this.desc = desc;
    notifyListeners();
  }

  bool isUpdated() {
    return name != null || desc != null;
  }

  Future update() async {
    name = nameController.text;
    desc = descController.text;

    if (FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'desc': desc,
      });
    }
    notifyListeners();
  }
}
