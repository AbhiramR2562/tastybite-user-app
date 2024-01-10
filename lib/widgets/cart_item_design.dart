import 'package:flutter/material.dart';
import 'package:tastybite/models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quantityNumber;
  CartItemDesign({
    super.key,
    this.model,
    this.context,
    this.quantityNumber,
  });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                width: 140,
                height: 120,
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //=> Title
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),

                  Row(
                    //=> quantity
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.quantityNumber.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  //=> Price
                  Row(
                    children: [
                      const Text(
                        "Price: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      const Text(
                        "\$",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
