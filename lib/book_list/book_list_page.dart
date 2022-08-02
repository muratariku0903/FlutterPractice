import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_list/domain/book.dart';
import 'package:book_list/book_list/book_list_model.dart';
import 'package:book_list/add_book/add_book_page.dart';
import 'package:book_list/edit_book/edit_book_page.dart';
import 'package:book_list/login/login_page.dart';
import 'package:book_list/user/user_page.dart';

class BookListPage extends StatelessWidget {
  const BookListPage(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TODO'),
          actions: [
            IconButton(
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserPage(null),
                      fullscreenDialog: true,
                    ),
                  );
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
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return const CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                  (book) => Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (value) async {
                            final String? title = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(book, null),
                              ),
                            );

                            if (title != null) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('$titleを編集しました'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }

                            model.fetchBookList();
                          },
                          backgroundColor: const Color(0xFF7BC043),
                          foregroundColor: Colors.black45,
                          icon: Icons.edit,
                          label: '編集',
                        ),
                        SlidableAction(
                          onPressed: (value) async {
                            await showConfirmDialog(context, book, model);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.black45,
                          icon: Icons.delete,
                          label: '削除',
                        )
                      ],
                    ),
                    child: ListTile(
                      leading:
                          book.img != null ? Image.network(book.img!) : null,
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
                  ),
                )
                .toList();

            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBookPage(null),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                const snackBar = SnackBar(
                  content: Text('added!'),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Future showConfirmDialog(
      BuildContext context, Book book, BookListModel model) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete this book?'),
          content: Text('title is : ${book.title}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await model.delete(book);
                Navigator.pop(context);

                const snackBar = SnackBar(
                  content: Text('Success delete book'),
                  backgroundColor: Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                model.fetchBookList();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
