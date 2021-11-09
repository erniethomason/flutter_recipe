
import 'package:flutter/material.dart';
import 'package:flutter_recipe/models/Data.dart';
import 'package:flutter_recipe/models/Recipe.dart';
import 'package:flutter_recipe/models/Util.dart';
import 'package:flutter_recipe/widgets/DismissBgTrash.dart';

import 'RecipePage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  // Properties (Widget) ; use final
  final String title = "Recipes";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  // Properties (State)

  Data data = Data();
  Util util = Util();


  // Init + app state observer
  @override void initState() { super.initState(); WidgetsBinding.instance!.addObserver(this); } // ! used in null safety to force this as non-null
  @override void dispose() { WidgetsBinding.instance!.removeObserver(this); super.dispose(); }
  @override void didChangeAppLifecycleState(AppLifecycleState state) { if (state == AppLifecycleState.inactive) data.appToBackground(); }


  // Event Handlers / Functions

  void _titleBarMenuOnSelect(String text) {
    if (text == "Settings") util.showSnackBarMsg("Settings pressed", context);
  }

  void _addOnTap () async {
    Recipe recipe = new Recipe("");
    data.r.recipes.add(recipe); // save to our array now (even though blank) so it will saved to storage when user leaves app
    await Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)));
    // wait until we return to this page ; if new recipe was not edited, remove from our array
    if (recipe.name.length == 0 && recipe.ingredients.length == 0) data.r.recipes.remove(recipe);
    redrawUI();
  }
  void _recipeOnTap(Recipe recipe) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe))); // wait until return, then redraw UI in case user changed name
    redrawUI();
  }

  void recipeOnDismissed(Recipe recipe) {
    data.r.recipes.remove(recipe);
    redrawUI();
  }
  void redrawUI() {
    setState(() {});  // redraw
  }


  List<Recipe> filteredRecipes = [];  // this this  in _HomePageState

  void loadFilteredRecipes(String filterText) {
    // fills filteredRecipies, which will then be used as source in ListView
    filteredRecipes.clear();
    if (filterText == null || filterText.length == 0) filteredRecipes.addAll(data.r.recipes);
    else {
      for (Recipe recipe in data.r.recipes) {
        if (recipe.name.contains(filterText)) filteredRecipes.add(recipe);
      }
    }
    redrawUI();
  }

  // Build UI

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[            // add buttons along top-right in title bar
          PopupMenuButton<String>(    // 3-dot button
            onSelected: _titleBarMenuOnSelect,
            itemBuilder: (BuildContext context) {
              Set<String> items = new Set();
              items.add("Settings");
              return items.map((String choice) {    // standard flutter code that just works
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

      body: ListView.builder(

        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {

          // Recipe row
          final Recipe recipe = filteredRecipes[index];

          return Dismissible(   // allows row to be swiped left/right
            key: UniqueKey(),   // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets
            direction: DismissDirection.endToStart,  // only swipe left supported
            background: DismissBgTrash(),
            onDismissed: (direction) { recipeOnDismissed(recipe); }, // called by framework after user swipes away
            confirmDismiss: (DismissDirection direction) async => await util.showDialogConfirmDismiss(context, "", "Delete recipe '${recipe.name}'?"),
            child: ListTile(
              title: Text(recipe.name.length == 0 ? "(no name)" : recipe.name),
              onTap: () { _recipeOnTap(recipe); },
            ),
          );

        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addOnTap,
        child: Icon(Icons.add),
      ),
    );
  }
}
