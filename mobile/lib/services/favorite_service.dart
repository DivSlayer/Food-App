import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/services/db.dart';

class FavoriteService extends ChangeNotifier {
  final List<FoodModel> _favoriteList = [];
  final DatabaseService _databaseService = DatabaseService();
  static final FavoriteService _instance = FavoriteService._internal();

  factory FavoriteService() {
    return _instance;
  }

  FavoriteService._internal();

  Future<bool> toggle(FoodModel food) async {
    bool exists = await checkExist(food.uuid);
    print("The object already exists: $exists");

    if (exists) {
      removeFromFavorites(food);
      return false;
    } else {
      await addToFavorite(food);
      return true;
    }
  }

  Future<void> addToFavorite(FoodModel food) async {
    try {
      FoodModel? insertedFood = await _databaseService.insertFavorite(food);
      if (insertedFood != null) {
        _favoriteList.add(food);
        notifyListeners();
      }
    } catch (e) {
      print("Error adding to favorites: $e");
      rethrow;
    }
  }

  Future<void> removeFromFavorites(FoodModel food) async {
    print("Removing from Favorite food");

    // Remove from local list
    _favoriteList.removeWhere((item) => item.uuid == food.uuid);

    notifyListeners();
    // Remove from database
    bool dbRes = await _databaseService.deleteFavorite(food.uuid);
    print("Removing From Database result: $dbRes");
  }

  Future<bool> checkExist(String uuid) async {
    return await _databaseService.checkExist(
      keys: ['food_uuid'],
      table: Tables.favorites,
      values: [uuid],
    );
  }

  Future<void> getFoods() async {
    try {
      List<FoodModel> dbFoods = await _databaseService.getAllFavorites();

      // Clear and add all from database
      _favoriteList.clear();
      _favoriteList.addAll(dbFoods);

      notifyListeners();
    } catch (e) {
      print("Error fetching favorite foods: $e");
      rethrow;
    }
  }

  List<FoodModel> get favoriteList => _favoriteList;
}
