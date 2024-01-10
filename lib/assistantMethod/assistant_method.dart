import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tastybite/assistantMethod/cart_item_counter.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/pages/splash_page.dart';

separateItemIDs() {
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\n This is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }
  print("\n This is itemID now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemId! + ":$itemCounter");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({
    "userCart": tempList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item add to Cart Successfully..");

    sharedPreferences!.setStringList("userCart", tempList);

    // Update the badge
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemNumber();
  });
}

// Quantities
separateItemQuantities() {
  List<int> separateItemQuantitiesList = [];
  List<String> defaultItemList = [];
  int i = 1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    //56557657:7
    String item = defaultItemList[i].toString();

    //7 - quantity number
    List<String> listItemCharacters = item.split(":").toList();

    // Converting to int
    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\n This is quantity number = " + quanNumber.toString());

    separateItemQuantitiesList.add(quanNumber);
  }
  print("\n This is quantity list now = ");
  print(separateItemQuantitiesList);

  return separateItemQuantitiesList;
}

// Clearing Cart
clearCartNow(context) {
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance.collection("users")
    ..doc(firebaseAuth.currentUser!.uid)
        .update({"userCart": emptyList}).then((value) {
      sharedPreferences!.setStringList("userCart", emptyList!);
      Provider.of<CartItemCounter>(context, listen: false)
          .displayCartListItemNumber();
    });
}
