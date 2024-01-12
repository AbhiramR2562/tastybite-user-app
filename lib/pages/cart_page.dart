import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tastybite/assistantMethod/assistant_method.dart';
import 'package:tastybite/assistantMethod/cart_item_counter.dart';
import 'package:tastybite/assistantMethod/total_amount.dart';
import 'package:tastybite/models/items.dart';
import 'package:tastybite/pages/address_page.dart';
import 'package:tastybite/pages/splash_page.dart';
import 'package:tastybite/widgets/cart_item_design.dart';
import 'package:tastybite/widgets/text_widget_header.dart';

class CartPage extends StatefulWidget {
  final String? sellerUID;
  const CartPage({super.key, this.sellerUID});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<int>? separateQuantityItemList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateQuantityItemList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.red,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              clearCartNow(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => SplashPage()));
              Fluttertoast.showToast(
                  msg: "Cart has been cleared successfully..");
            },
            icon: Icon(Icons.clear_all)),
        title: Text(
          "TASTY BITE",
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Stack(
            children: [
              IconButton(
                  // Send user to cart page
                  onPressed: () {
                    print("Already in Cart page");
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
              Positioned(
                  child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3,
                    right: 4,
                    child: Center(
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, c) {
                          return Text(
                            counter.count.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ))
            ],
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 3),
          //Clear Cart
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                clearCartNow(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SplashPage()));

                Fluttertoast.showToast(
                    msg: "Cart has been cleared successfully..");
              },
              label: const Text(
                "Clear Cart",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
            ),
          ),
          //payment
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                // Go to the address page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddressPage(
                              totalAmount: totalAmount.toDouble(),
                              sellerUID: widget.sellerUID,
                            )));
              },
              label: const Text(
                "Pay Now",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Overall total amount
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: "My Cart List",
            ),
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Total Amount= ${amountProvider.tAmount.toString()}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              );
            }),
          ),

          // Display cart item with quantity number
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("itemID", whereIn: separateItemIDs())
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : snapshot.data!.docs.length == 0
                        ? Container() // Building cart
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Items model = Items.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>,
                              );

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateQuantityItemList![index]);
                              } else {
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateQuantityItemList![index]);
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayTotalAmount(
                                          totalAmount.toDouble());
                                });
                              }

                              return CartItemDesign(
                                model: model,
                                context: context,
                                quantityNumber:
                                    separateQuantityItemList![index],
                              );
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0,
                          ));
              })
        ],
      ),
    );
  }
}
