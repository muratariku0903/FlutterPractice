import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_list/login/login_page.dart';
import 'package:book_list/edit_user/edit_user_page.dart';
import 'package:book_list/user/user_model.dart';

class UserPage extends StatelessWidget {
  const UserPage(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      create: (_) =>
          UserModel()..fetchUser(FirebaseAuth.instance.currentUser!.uid),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User'),
          actions: [
            Consumer<UserModel>(builder: (context, model, child) {
              return IconButton(
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditUserPage(null),
                        fullscreenDialog: true,
                      ),
                    );
                    model.fetchUser(FirebaseAuth.instance.currentUser!.uid);
                  } else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(null),
                        fullscreenDialog: true,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.edit),
              );
            }),
          ],
        ),
        body: Center(
          child: Consumer<UserModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        model.email ?? 'nothing email',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        model.name ?? 'nothing name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          model.logout();
                          Navigator.of(context).pop();
                        },
                        child: const Text('logout'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
