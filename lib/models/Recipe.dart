import 'package:flutter_recipe/models/Ingredient.dart';

class Recipe {

  String name;
  List<Ingredient> ingredients = [];    // init as empty array

  // Constructor
  Recipe(this.name);


/*
  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
  }

  void removeIngredient(Ingredient ingredient) {
    ingredients.remove(ingredient);
  }
*/


  // JSON

  Recipe.fromJson(Map<String, dynamic> json) : name="" {    // name initializer required since we don't allow nulls
    // JSON -> Object ; called from dart's jsonEncode
    name = json['name'];
    List ingredientsJson = json['ingredients'];
    for (dynamic ingredientJson in ingredientsJson) ingredients.add(Ingredient.fromJson(ingredientJson));
  }

  Map<String, dynamic> toJson() =>                // Object -> JSON ; called from dart's jsonDecode
  { 'name' : name,
    'ingredients': ingredients };

}