import 'package:flutter/material.dart';
import 'package:tastybite/models/items.dart';

class ItemDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;
  ItemDesignWidget({super.key, this.model, this.context});

  @override
  State<ItemDesignWidget> createState() => _ItemDesignWidgetState();
}

class _ItemDesignWidgetState extends State<ItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 295,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 5),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5),
              Text(
                widget.model!.title!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  // fontFamily: "Train",
                ),
              ),
              Text(
                widget.model!.shortInfo!,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 5),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
