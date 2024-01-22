import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/models/address.dart';
import 'package:tastybite/widgets/shipment_address_design.dart';
import 'package:tastybite/widgets/status_banner.dart';

class OrderDetailsPage extends StatefulWidget {
  final String? orderID;
  const OrderDetailsPage({super.key, this.orderID});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String orderStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (context, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data() as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(height: 10),

                        //-> Tottal Amount
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tottal: " +
                                  "\$" +
                                  dataMap["totalAmount"].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        //-> Order Id
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order Id: " + widget.orderID!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),

                        //-> Order at (time)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order at: " +
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["orderTime"]))),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Divider(thickness: 4),
                        orderStatus == "ended"
                            ? Image.asset(
                                "assets/images/delivery-man-with-boxes.jpg")
                            : Image.asset(
                                "assets/images/way-concept-illustration.jpg"),
                        const Divider(thickness: 4),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(sharedPreferences!.getString("uid"))
                              .collection("userAddress")
                              .doc(dataMap["addressID"])
                              .get(),
                          builder: ((context, snapshot) {
                            return snapshot.hasData
                                ? ShipmentAddressDesign(
                                    model: Address.fromJson(snapshot.data!
                                        .data()! as Map<String, dynamic>),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          }),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
