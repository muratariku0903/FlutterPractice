import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String? title;
  String? author;
  File? imageFile;
  final picker = ImagePicker();

  Future addBook() async {
    if (title == null || title == '') {
      throw '本のタイトルが入力されていません';
    }

    if (author == null || author == '') {
      throw '本の著者が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('books').doc();

    String? imgURL;
    if (imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('books/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    await doc.set({
      'title': title,
      'author': author,
      'img': imgURL,
    });
    notifyListeners();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
