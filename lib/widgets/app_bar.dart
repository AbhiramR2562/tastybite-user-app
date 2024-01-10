import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tastybite/assistantMethod/cart_item_counter.dart';
import 'package:tastybite/pages/cart_page.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? sellerUID;
  final PreferredSizeWidget? bottom;
  const MyAppBar({super.key, this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back)),
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
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CartPage(sellerUID: widget.sellerUID))),
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
    );
  }
}
