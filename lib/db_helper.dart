import 'dart:io';

import 'package:apate/data/models/cart_item.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper!;
  }

  Future<Database> initDb() async {
    String dbName = "apate.db";
    String path;
    if (Platform.isAndroid && !kReleaseMode) {
      Directory? extDir = await getExternalStorageDirectory();
      path = join(extDir!.path, "databases", dbName);
    } else {
      String dbDir = await getDatabasesPath();
      path = join(dbDir, dbName);
    }
    var database = openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return database;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        merchant_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_price NUMERIC NOT NULL,
        product_qty NUMERIC NOT NULL
      )
    ''');
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<CartItem>> getCart() async {
    Database? db = await this.database;
    var cartMapList = await db!.query('cart');
    int count = cartMapList.length;
    List<CartItem> cart = List.empty(growable: true);
    for (int i = 0; i < count; i++) {
      cart.add(CartItem.fromMap(cartMapList[i]));
    }
    return cart;
  }

  Future<CartItem?> getCartItem(String productId) async {
    Database? db = await this.database;
    var cartMapList = await db!.query(
      'cart',
      where: 'product_id=?',
      whereArgs: [productId],
      limit: 1,
    );
    if (cartMapList.length == 1) {
      return CartItem.fromMap(cartMapList[0]);
    }
    return null;
  }

  Future<int> insert(CartItem item) async {
    Database? db = await this.database;
    return await db!.insert('cart', item.toMap());
  }

  Future<int> update(CartItem item) async {
    Database? db = await this.database;
    return await db!.update(
      'cart',
      item.toMap(),
      where: 'id=?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(CartItem item) async {
    Database? db = await this.database;
    return await db!.delete(
      'cart',
      where: 'id=?',
      whereArgs: [item.id],
    );
  }

  Future<int> clear() async {
    Database? db = await this.database;
    return await db!.delete('cart');
  }
}
