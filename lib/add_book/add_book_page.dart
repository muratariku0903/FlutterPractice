import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_list/add_book/add_book_model.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage(Key? key):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('TODO ADD'),
          ),
          body: Center(
            child: Consumer<AddBookModel>(builder: (context, model, child) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 100,
                          height: 160,
                          child: model.imageFile != null
                              ? Image.file(model.imageFile!)
                              : Container(
                                  color: Colors.grey,
                                ),
                        ),
                        onTap: () async {
                          await model.pickImage();
                        },
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: 'todo title'),
                        onChanged: (text) {
                          model.title = text;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: 'todo desc'),
                        onChanged: (text) {
                          model.author = text;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await model.addBook();
                            const snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('ADD TODO'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pop(true);
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: const Text('ADD'),
                      )
                    ],
                  ));
            }),
          )),
    );
  }
}
