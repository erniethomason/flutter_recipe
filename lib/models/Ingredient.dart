class Ingredient {

  String name;
  double amount;
  String unit;

  // Constructor
  Ingredient (this.name, this.amount, this.unit); // special Dart format

  // Same as above in a more "standard" format
  /*
  Ingredient (String name, String amount, String unit) {
    this.name = name;
    this.amount = amount;
    this.unit = unit;
  } */



  // JSON

  // dart:  : defines an "initializer list".  No body needed in this case
  Ingredient.fromJson(Map<String, dynamic> json) :  // JSON -> Object ; called from dart's jsonEncode
        name = json['name'],
        amount = json['amount'],
        unit = json['unit'];

  /*
  // Same as above in a more "standard" format
  Ingredient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    unit = json['unit'];
  } */

// dart:  => means return ... without having to use standard { }
  Map<String, dynamic> toJson() =>    // Object -> JSON ; called from dart's jsonDecode
  { 'name': name,
    'amount': amount,
    'unit': unit };

  /*
  // Same as above in a more "standard" format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit };
  }
  */


}