import 'package:book_list/book_list/book_list_model.dart';
import 'package:flutter/material.dart';
import 'package:book_list/add_book/add_book_page.dart';
import 'package:provider/provider.dart';
import 'package:book_list/domain/book.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:book_list/edit_book/edit_book_page.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODO'),
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map((book) => Slidable(
                      endActionPane: ActionPane(
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (value) async {
                              final String? title = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookPage(book),
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
                            backgroundColor: Color(0xFF7BC043),
                            foregroundColor: Colors.black45,
                            icon: Icons.edit,
                            label: '編集',
                          ),
                          SlidableAction(
                            onPressed: (value) => {},
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.black45,
                            icon: Icons.delete,
                            label: '削除',
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                      ),
                    ))
                .toList();

            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBookPage(),
                fullscreenDialog: true,
              ),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
