import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/models/Data.dart';
import 'package:flutter_recipe/models/Ingredient.dart';
import 'package:flutter_recipe/models/Recipe.dart';
import 'package:flutter_recipe/models/Util.dart';
import 'package:flutter_recipe/widgets/DismissBgTrash.dart';
import 'package:flutter_recipe/widgets/ListSectionHeader.dart';
import 'dart:developer';

import '../models/Ingredient.dart';

class RecipePage extends StatefulWidget {

  RecipePage({Key? key, required this.recipe}) : super(key: key);   // send recipe when loading page

  // Properties (Widget) ; use final
  final Recipe recipe;

  @override
  RecipePageState createState() { return RecipePageState(); }
}

class RecipePageState extends State<RecipePage> with WidgetsBindingObserver {

  // Properties (State)

  Data data = Data();
  Util util = Util();


  // Init + app state observer
  @override void initState() { super.initState(); WidgetsBinding.instance!.addObserver(this); }
  @override void dispose() { WidgetsBinding.instance!.removeObserver(this); super.dispose(); }
  @override void didChangeAppLifecycleState(AppLifecycleState state) { if (state == AppLifecycleState.inactive) data.appToBackground(); }

  // Event Handlers / Functions

  void recipeNameOnChanged(String text) {
    // Save recipe name as user changes text box
    widget.recipe.name = text;
  }

  void addOnTap() {
    widget.recipe.ingredients.add (new Ingredient("", 0, ""));
    redrawUI();
  }

  void ingredientOnDismissed(Ingredient ingredient) {
    widget.recipe.ingredients.remove(ingredient);
    redrawUI();
  }
  void nameOnChanged(String text, Ingredient ingredient) {
    ingredient.name = text;
  }
  void amountOnChanged(String text, Ingredient ingredient) {
    double d = double.tryParse(text) ?? 0;
    ingredient.amount = d;
  }
  void unitOnChanged(String text, Ingredient ingredient) {
    ingredient.unit = text;

    for (Ingredient ingredient in widget.recipe.ingredients) {
      // ingredient.name
    }
  }

  void redrawUI() {
    setState(() {});  // redraw
  }


  // Build UI

  @override
  Widget build(BuildContext context) {

    final title = 'List';

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),

        body: ListView.builder(

          itemCount: widget.recipe.ingredients.length + 4,  // add header, recipe name, header, footer (add ingredient)
          itemBuilder: (context, index) {

            if (index == 0) {
              return ListSectionHeader("Recipe Name");
            }
            else if (index  == 1) {
              // Recipe name input field
              return ListTile(
                title: TextFormField(
                  initialValue: widget.recipe.name,
                  decoration: InputDecoration(border: UnderlineInputBorder(), hintText: 'Recipe Name'),
                  onChanged: (text) { recipeNameOnChanged(text); }
                ),
              );
            }
            else if (index == 2) {
              return ListSectionHeader("Ingredients");
            }

            else if (index == widget.recipe.ingredients.length + 3) {
              // Footer
              return ListTile(
                title: Center(child: Text("Add Ingredient")),
                onTap: () { addOnTap(); },
              );
            }
            else {
              // Ingredient row
              final Ingredient ingredient = widget.recipe.ingredients[index - 3];

              return Dismissible(
                key: UniqueKey(), // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets
                direction: DismissDirection.endToStart,  // swipe left to dismiss
                background: DismissBgTrash(),
                onDismissed: (direction) { ingredientOnDismissed(ingredient); },  // called by framework after user swipes away
                child: ListTile(
                    title: Row (
                      children: <Widget> [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: ingredient.name,
                            decoration: InputDecoration(border: UnderlineInputBorder(), hintText: 'Ingredient'),
                            onChanged: (text) { nameOnChanged(text, ingredient); },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            initialValue: util.doubleToString(ingredient.amount),
                            decoration: InputDecoration(border: UnderlineInputBorder(), hintText: 'Amt'),
                            onChanged: (text) { amountOnChanged(text, ingredient); },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: ingredient.unit,
                            decoration: InputDecoration(border: UnderlineInputBorder(), hintText: 'Unit'),
                            onChanged: (text) { unitOnChanged(text, ingredient); },
                          ),
                        ),
                      ]
                    )
                ),
              );
            }
          },
        ),
    );
  }
}