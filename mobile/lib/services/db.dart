import 'dart:async';
import 'package:food_app/models/account.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/utils/funcs.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/extra.dart';
import '../models/food.dart';
import '../models/instruction.dart';
import '../models/order.dart';
import '../models/restaurant.dart';
import '../models/token_model.dart';

enum Tables {
  orders,
  favorites,
  foods,
  token,
  transaction,
  sizes,
  selected_size,
  restaurants,
  account,
}

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  /// Returns an instance of the [Database]. Creates it if it doesn't exist.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and creates the tables.
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'food.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Creates the necessary tables.
  Future<void> _createDB(Database db, int version) async {
    // Food-related table
    await db.execute('''
      CREATE TABLE foods (
        uuid TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        details TEXT NOT NULL,
        preparation_time INTEGER NOT NULL,
        rating TEXT NOT NULL,
        restaurant_uuid TEXT NOT NULL,
        comments_count INTEGER NOT NULL,
        rating_count INTEGER NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (restaurant_uuid) REFERENCES restaurants (uuid) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE sizes (
        name TEXT NOT NULL,
        details TEXT NOT NULL,
        price INTEGER NOT NULL,
        food_uuid TEXT NOT NULL,
        order_uuid TEXT NOT NULL,
        FOREIGN KEY (food_uuid) REFERENCES foods (uuid)
        FOREIGN KEY (order_uuid) REFERENCES orders (uuid)
      )
    ''');

    // Order-related table
    await db.execute('''
      CREATE TABLE orders (
        uuid TEXT PRIMARY KEY,
        food_uuid TEXT NOT NULL,
        status TEXT NOT NULL,
        created_time TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (food_uuid) REFERENCES foods (uuid)
      )
    ''');

    // Extras and instructions tables
    await db.execute('''
      CREATE TABLE extras (
        uuid TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        price INTEGER NOT NULL,
        stack INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE instructions (
        uuid TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        price INTEGER NOT NULL,
        stack INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    // Junction tables for order relationships
    await db.execute('''
      CREATE TABLE order_extras (
        order_uuid TEXT NOT NULL,
        extra_uuid TEXT NOT NULL,
        PRIMARY KEY (order_uuid, extra_uuid),
        FOREIGN KEY (order_uuid) REFERENCES orders (uuid),
        FOREIGN KEY (extra_uuid) REFERENCES extras (uuid)
      )
    ''');

    await db.execute('''
      CREATE TABLE order_instructions (
        order_uuid TEXT NOT NULL,
        instruction_uuid TEXT NOT NULL,
        PRIMARY KEY (order_uuid, instruction_uuid),
        FOREIGN KEY (order_uuid) REFERENCES orders (uuid),
        FOREIGN KEY (instruction_uuid) REFERENCES instructions (uuid)
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE favorites (
        food_uuid TEXT PRIMARY KEY,
        created_at TEXT NOT NULL,
        FOREIGN KEY (food_uuid) REFERENCES foods (uuid) ON DELETE CASCADE
      )
    ''');

    // Token table
    await db.execute('''
      CREATE TABLE token(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        refresh TEXT NOT NULL,
        access TEXT NOT NULL
      )
    ''');

    await db.execute('''  
      CREATE TABLE restaurants (  
        uuid TEXT PRIMARY KEY,  
        name TEXT NOT NULL,  
        image TEXT,  
        logo TEXT NOT NULL  
      )  
    ''');

    await db.execute('''  
      CREATE TABLE account (  
        uuid TEXT PRIMARY KEY,  
        active_address TEXT NOT NULL  
      )  
    ''');
  }

  // ================== Food Operations ==================

  /// Inserts a [FoodModel] into the database along with its sizes.
  Future<void> insertFood({
    required FoodModel food,
    SizeModel? selectedSize,
    String orderUuid = "01",
  }) async {
    final db = await database;
    // Insert food data.
    final foodExist = await checkExist(keys: ['uuid'], table: Tables.foods, values: [food.uuid]);
    if (!foodExist) {
      bool isIn = await checkExist(
        table: Tables.restaurants,
        keys: ['uuid'],
        values: [food.restaurantInfo.uuid],
      );
      if (!isIn) {
        await db.insert('restaurants', food.restaurantInfo.toJson());
      }
      await db.insert('foods', food.toJson());
    } else {
      updateFood(food: food);
    }
    if (selectedSize != null) {
      insertSelectedSize(selectedSize: selectedSize, foodUUid: food.uuid, orderUUid: orderUuid);
    }
  }

  Future<void> insertSelectedSize({
    required SizeModel selectedSize,
    required String foodUUid,
    required String orderUUid,
  }) async {
    final db = await database;
    bool sizeExist = await checkExist(
      keys: ['food_uuid', 'order_uuid'],
      table: Tables.sizes,
      values: [foodUUid, orderUUid],
    );
    if (sizeExist) {
      await db.update(
        'sizes',
        {
          'food_uuid': foodUUid,
          'order_uuid': orderUUid,
          'name': selectedSize.name,
          'details': selectedSize.details,
          'price': selectedSize.price,
        },
        where: 'food_uuid = ? AND order_uuid = ?',
        whereArgs: [foodUUid, orderUUid],
      );
    } else {
      await db.insert('sizes', {
        'food_uuid': foodUUid,
        'order_uuid': orderUUid,
        'name': selectedSize.name,
        'details': selectedSize.details,
        'price': selectedSize.price,
      });
    }
  }

  /// Retrieves a [FoodModel] from the database using its [uuid].
  Future<FoodModel> getFood({required String uuid, String orderUuid = "01"}) async {
    final db = await database;
    final foodMap = await db.query('foods', where: 'uuid = ?', whereArgs: [uuid]);
    if (foodMap.isEmpty) throw Exception('Food not found');

    // Retrieve associated sizes.
    final sizes = await db.query(
      'sizes',
      where: 'order_uuid = ? AND food_uuid = ?',
      whereArgs: [orderUuid, uuid],
    );
    final resInfo = await db.query(
      'restaurants',
      where: 'uuid = ?',
      whereArgs: [foodMap.first['restaurant_uuid']],
    );
    return FoodModel(
      uuid: foodMap.first['uuid'] as String,
      name: foodMap.first['name'] as String,
      image: foodMap.first['image'] as String,
      details: foodMap.first['details'] as String,
      preparationTime: foodMap.first['preparation_time'] as int,
      rating: foodMap.first['rating'] as String,
      sizes: [],
      restaurantInfo: RestaurantShortInfo.fromJson(resInfo.first),
      restaurant: null,
      selectedSize:
          sizes.isNotEmpty
              ? SizeModel(
                name: sizes[0]['name'] as String,
                details: sizes[0]['details'] as String,
                price: sizes[0]['price'] as int,
              )
              : null,
      commentsCount: foodMap.first['comments_count'] as int,
      ratingCount: foodMap.first['rating_count'] as int,
      category: foodMap.first['category'] as String,
    );
  }

  Future<bool> updateFood({
    required FoodModel food,
    SizeModel? selectedSize,
    String orderUUid = "01",
  }) async {
    final db = await database;
    int result = await db.update('foods', food.toJson(), where: 'uuid = ?', whereArgs: [food.uuid]);
    if (selectedSize != null) {
      insertSelectedSize(selectedSize: selectedSize, foodUUid: food.uuid, orderUUid: orderUUid);
    }
    return result != 0;
  }

  /// Deletes a food record by its [uuid].
  Future<bool> deleteFood({required String uuid}) async {
    final db = await database;
    final res = await db.delete('foods', where: 'uuid = ?', whereArgs: [uuid]);
    return res != 0;
  }

  // ================== Order Operations ==================

  /// Inserts an [OrderModel] into the database along with its extras and instructions.
  Future<void> insertOrder(OrderModel order, SizeModel selectedSize) async {
    final db = await database;
    await insertFood(food: order.food, selectedSize: selectedSize, orderUuid: order.uuid);
    // Insert order record.
    await db.insert('orders', {
      'uuid': order.uuid,
      'food_uuid': order.food.uuid,
      'status': order.status.value,
      'created_time': order.createdTime.toIso8601String(),
      'quantity': order.quantity,
    });

    // Insert order extras.
    for (final extra in order.extras) {
      await db.insert('extras', extra.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert('order_extras', {'order_uuid': order.uuid, 'extra_uuid': extra.uuid});
    }

    // Insert order instructions.
    for (final instruction in order.instructions) {
      await db.insert(
        'instructions',
        instruction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      await db.insert('order_instructions', {
        'order_uuid': order.uuid,
        'instruction_uuid': instruction.uuid,
      });
    }
  }

  /// Retrieves an [OrderModel] from the database by its [uuid].
  Future<OrderModel> getOrder(String uuid) async {
    final db = await database;
    final orderQuery = await db.query('orders', where: 'uuid = ?', whereArgs: [uuid]);

    if (orderQuery.isEmpty) throw Exception('Order not found');
    print(orderQuery);
    // Retrieve the associated food.
    final food = await getFood(uuid: orderQuery.first['food_uuid'] as String, orderUuid: uuid);
    // Retrieve extras for the order.
    final extras = await db.rawQuery(
      '''
      SELECT e.* FROM extras e
      INNER JOIN order_extras oe ON e.uuid = oe.extra_uuid
      WHERE oe.order_uuid = ?
    ''',
      [uuid],
    );

    // Retrieve instructions for the order.
    final instructions = await db.rawQuery(
      '''
      SELECT i.* FROM instructions i
      INNER JOIN order_instructions oi ON i.uuid = oi.instruction_uuid
      WHERE oi.order_uuid = ?
    ''',
      [uuid],
    );

    return OrderModel(
      uuid: orderQuery.first['uuid'] as String,
      food: food,
      status: const OrderStatusConverter().fromJson(orderQuery.first['status'] as String),
      createdTime: DateTime.parse(orderQuery.first['created_time'] as String),
      quantity: orderQuery.first['quantity'] as int,
      extras: extras.map((e) => ExtraModel.fromJson(e)).toList(),
      instructions: instructions.map((i) => InstructionModel.fromJson(i)).toList(),
    );
  }

  /// Updates an existing [OrderModel] in the database.
  Future<void> updateOrder(OrderModel order) async {
    final db = await database;
    await db.update(
      'orders',
      {
        'food_uuid': order.food.uuid,
        'status': order.status,
        'created_time': order.createdTime.toIso8601String(),
        'quantity': order.quantity,
      },
      where: 'uuid = ?',
      whereArgs: [order.uuid],
    );

    // Update extras.
    await db.delete('order_extras', where: 'order_uuid = ?', whereArgs: [order.uuid]);
    for (final extra in order.extras) {
      await db.insert('extras', extra.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert('order_extras', {'order_uuid': order.uuid, 'extra_uuid': extra.uuid});
    }

    // Update instructions.
    await db.delete('order_instructions', where: 'order_uuid = ?', whereArgs: [order.uuid]);
    for (final instruction in order.instructions) {
      await db.insert(
        'instructions',
        instruction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      await db.insert('order_instructions', {
        'order_uuid': order.uuid,
        'instruction_uuid': instruction.uuid,
      });
    }
  }

  /// Retrieves all orders stored in the database.
  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;
    final orders = await db.query('orders');
    return Future.wait(orders.map((order) => getOrder(order['uuid'] as String)));
  }

  /// Clears all order-related data from the database.
  Future<void> clearAllOrders() async {
    final db = await database;

    await db.delete('orders');
    await db.delete('order_extras');
    await db.delete('order_instructions');
  }

  /// Deletes an order by its [uuid].
  Future<int> deleteOrder(String uuid, String foodUUID) async {
    final db = await database;
    final existsInFav = await checkExist(
      table: Tables.favorites,
      keys: ['food_uuid'],
      values: [foodUUID],
    );
    final existsInOthers = await checkExist(
      table: Tables.orders,
      keys: ['food_uuid'],
      values: [foodUUID],
      excludeKey: 'uuid',
      excludeValue: uuid,
    );
    if (existsInFav == false && existsInOthers == false) {
      await deleteFood(uuid: foodUUID);
    }
    return await db.delete('orders', where: 'uuid = ?', whereArgs: [uuid]);
  }

  // ================== Favorite Operations ==================

  /// Inserts a [FoodModel] as a favorite.
  /// Ensures the food exists and then stores its reference.
  Future<FoodModel?> insertFavorite(FoodModel food) async {
    final db = await database;
    SizeModel? selectedSize =
        food.sizes.isNotEmpty ? food.sizes[(food.sizes.length - 1) ~/ 2] : null;
    bool foodExist = await checkExist(keys: ['uuid'], table: Tables.foods, values: [food.uuid]);
    if (!foodExist) {
      await insertFood(food: food, selectedSize: selectedSize);
    } else {
      updateFood(food: food, selectedSize: selectedSize, orderUUid: "01");
    }
    final insertedId = await db.insert('favorites', {
      'food_uuid': food.uuid,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    if (insertedId != 0) {
      final favorites = await getFavorite(food.uuid);
      return favorites.isNotEmpty ? favorites.first : null;
    }
    return null;
  }

  /// Deletes a favorite [FoodModel] by its [foodUuid].
  Future<bool> deleteFavorite(String foodUuid) async {
    final db = await database;
    // Delete food if it is not associated with any order.
    final existsInOrder = await checkExist(
      table: Tables.orders,
      keys: ['food_uuid'],
      values: [foodUuid],
    );
    if (!existsInOrder) {
      await deleteFood(uuid: foodUuid);
    }
    final res = await db.delete('favorites', where: 'food_uuid = ?', whereArgs: [foodUuid]);
    return res != 0;
  }

  /// Retrieves a list of favorite [FoodModel] entries for the given [uuid].
  Future<List<FoodModel>> getFavorite(String uuid) async {
    final db = await database;
    final favorites = await db.query('favorites', where: 'food_uuid = ?', whereArgs: [uuid]);
    return Future.wait(favorites.map((f) async => await getFood(uuid: f['food_uuid'] as String)));
  }

  /// Retrieves all favorite [FoodModel] entries.
  Future<List<FoodModel>> getAllFavorites() async {
    final db = await database;
    final favorites = await db.query('favorites');
    return Future.wait(favorites.map((f) async => await getFood(uuid: f['food_uuid'] as String)));
  }

  /// Checks whether a record exists for [foodUuid] in the specified [table].
  Future<bool> checkExist({
    required List<String> keys,
    required Tables table,
    required List<String> values,
    String? excludeKey,
    String? excludeValue,
  }) async {
    final db = await database;
    String keyQuery = keys.map((item) => "$item = ?").toList().join(" AND ");
    if (excludeKey != null) {
      keyQuery += " AND $excludeKey != $excludeValue";
    }
    final result = await db.query(table.name, where: keyQuery, whereArgs: values);
    return result.isNotEmpty;
  }

  // ================== Token Operations ==================

  /// Sets a new token by clearing the existing one and inserting the new values.
  Future<bool> setToken(Map<String, dynamic> json) async {
    final db = await database;
    await clearTable(Tables.token);
    final id = await db.insert(Tables.token.name, {
      'refresh': json['refresh'] as String,
      'access': json['access'] as String,
    });
    return id != 0;
  }

  // ================== Account Operations ==================
  Future<void> setAccount(AccountModel account, String activeAddressID) async {
    final db = await database;
    List<Map<String, dynamic>> accounts = await db.rawQuery("SELECT * FROM account");
    if (accounts.isNotEmpty) {
      Map<String, dynamic> account = accounts.first;
      db.update(
        Tables.account.name,
        {'active_address': activeAddressID},
        where: 'uuid = ?',
        whereArgs: [account['uuid']],
      );
    } else {
      db.insert('account', {'uuid': account.uuid, 'active_address': activeAddressID});
    }
  }

  Future<Map<String, dynamic>?> getAccount() async {
    final db = await database;
    List<Map<String, dynamic>> accounts = await db.rawQuery("SELECT * FROM account");
    if (accounts.isNotEmpty) {
      return accounts.first;
    }
    return null;
  }

  /// Retrieves the stored token.
  Future<TokenModel?> getToken() async {
    final db = await database;
    final queryResult = await db.query('token');
    if (queryResult.isNotEmpty) {
      return TokenModel.fromJson(queryResult.first);
    }
    return null;
  }

  /// Clears all data from the specified [table].
  Future<void> clearTable(Tables table) async {
    final db = await database;
    await db.delete(table.name);
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Helper Functions
  Future<int> getLastID({required Tables table}) async {
    final db = await database;
    int lastID = await db
        .query(table.name)
        .then((value) => value.isNotEmpty ? value.last['id'] as int : 0);
    return lastID;
  }

  Future<bool> deleteItem({required Tables table, int? id = 1}) async {
    final db = await database;
    int result = await db.delete(table.name, where: "id = ?", whereArgs: [id]);
    return result != 0;
  }
}
