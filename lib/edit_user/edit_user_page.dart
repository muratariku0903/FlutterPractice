import 'package:book_list/edit_user/edit_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditUserModel>(
      create: (_) => EditUserModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EDIT USER'),
        ),
        body: Center(
          child: Consumer<EditUserModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.nameController,
                    decoration: const InputDecoration(
                      hintText: 'name',
                    ),
                    onChanged: (text) {
                      model.setName(text);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.descController,
                    decoration: const InputDecoration(
                      hintText: 'desc',
                    ),
                    onChanged: (text) {
                      model.setDesc(text);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await model.update();
                        Navigator.of(context).pop();
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('UPDATE'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
