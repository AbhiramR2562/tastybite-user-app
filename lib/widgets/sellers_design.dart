import 'package:flutter/material.dart';
import 'package:tastybite/models/sellers.dart';
import 'package:tastybite/pages/menus_page.dart';

class SellersDesignWidget extends StatefulWidget {
  Sellers? model;
  BuildContext? context;
  SellersDesignWidget({super.key, this.model, this.context});

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenusPage(
                    model: widget.model,
                  ))),
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
                widget.model!.sellerProfileUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5),
              Text(
                widget.model!.sellerName!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  // fontFamily: "Train",
                ),
              ),
              Text(
                widget.model!.sellerEmail!,
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
