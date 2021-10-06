import 'package:flutter/material.dart';
import 'package:sqflite_demo_app/database_helper.dart';
import 'package:sqflite_demo_app/product.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: TextField(
            controller: textController,
          )),
          body: Center(
            child: FutureBuilder<List<Product>>(
                future: DatabaseHelper.instance.getProducts(),
                builder: (BuildContext contex,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: const Text("Loading..."),
                    );
                  }
                  return snapshot.data!.isEmpty
                      ? Center(
                          child: Text('No Products in list'),
                        )
                      : ListView(
                          children: snapshot.data!.map((product) {
                            return Center(
                              child: Card(
                                color: selectedId == product.id
                                    ? Colors.white70
                                    : Colors.white,
                                child: ListTile(
                                  title: Text(product.name),
                                  onTap: () {
                                    setState(() {
                                      if (selectedId == null) {
                                        textController.text = product.name;
                                        selectedId = product.id;
                                      } else {
                                        textController.text = '';
                                        selectedId = null;
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      DatabaseHelper.instance
                                          .remove(product.id!);
                                      selectedId = null;
                                      textController.text = '';
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                }),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () async {
              selectedId != null
                  ? await DatabaseHelper.instance.update(
                      Product(id: selectedId, name: textController.text),
                    )
                  : await DatabaseHelper.instance.add(
                      Product(name: textController.text),
                    );
              setState(() {
                selectedId = null;
                textController.text = '';
                textController.clear();
              });
            },
          )),
    );
  }
}
