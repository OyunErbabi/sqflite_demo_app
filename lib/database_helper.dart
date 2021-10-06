import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_demo_app/product.dart';

class DatabaseHelper {
  DatabaseHelper._privateConsturactor();
  static final DatabaseHelper instance = DatabaseHelper._privateConsturactor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'etrade.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products(
      id INTEGER PRIMARY KEY,
      name TEXT)
    ''');
  }

  Future<List<Product>> getProducts() async {
    Database db = await instance.database;
    var products = await db.query('products', orderBy: 'name');
    List<Product> productList = products.isNotEmpty
        ? products.map((c) => Product.fromMap(c)).toList()
        : [];
    return productList;
  }

  Future<int> add(Product product) async {
    Database db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Product product) async {
    Database db = await instance.database;
    return await db.update('products', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }
}
