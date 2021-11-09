import 'Recipe.dart';

class Recipes {

  List<Recipe> recipes = [];    // init as empty array

  // Constructor (default constructor explicitly required since we have named constructor fromJson below)
  Recipes();



  // JSON

  //Recipes.fromJson(Map<String, dynamic> json) :   // JSON -> Object ; called from dart's jsonEncode
        //recipes = json['recipes'];

  Recipes.fromJson(Map<String, dynamic> json) {
    List recipesJson = json['recipes'];
    for (dynamic recipeJson in recipesJson) recipes.add(Recipe.fromJson(recipeJson));
  }

  Map<String, dynamic> toJson() =>                // Object -> JSON ; called from dart's jsonDecode
  { 'recipes': recipes };

}