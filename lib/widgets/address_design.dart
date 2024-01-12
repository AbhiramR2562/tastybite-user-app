import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tastybite/assistantMethod/address_changer.dart';
import 'package:tastybite/assistantMethod/total_amount.dart';
import 'package:tastybite/maps/maps.dart';
import 'package:tastybite/models/address.dart';
import 'package:tastybite/pages/order_place_page.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;
  const AddressDesign({
    super.key,
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Select this address
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            //-> Address info
            Row(
              children: [
                Radio(
                  value: widget.value!,
                  groupValue: widget.currentIndex!,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    //Provider
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                    print(val);
                  },
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          //Name
                          TableRow(
                            children: [
                              Text(
                                "Name: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.model!.name.toString()),
                            ],
                          ),

                          //Phone Number
                          TableRow(
                            children: [
                              Text(
                                "PhoneNumber: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.model!.phoneNumber.toString()),
                            ],
                          ),

                          // Flat Number
                          TableRow(
                            children: [
                              Text(
                                "FlatNumber: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.model!.flatNumber.toString()),
                            ],
                          ),

                          // City
                          TableRow(
                            children: [
                              Text(
                                "City: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.model!.city.toString()),
                            ],
                          ),

                          // State
                          TableRow(
                            children: [
                              Text(
                                "State: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.model!.state.toString()),
                            ],
                          ),

                          // Full Address
                          TableRow(
                            children: [
                              Text(
                                "FullAaddress: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.model!.fullAddress.toString()),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                MapsUtils.openMapWithPosition(
                    widget.model!.lat!, widget.model!.lng!);
                //  MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
              },
              child: Text("Check on Maps"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),

            widget.value == Provider.of<AddressChanger>(context).count
                ? ElevatedButton(
                    onPressed: () {
                      // Navigate to the order place page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderPlacePage(
                                    addressID: widget.addressID,
                                    totalAmount: widget.totalAmount,
                                    sellerUID: widget.sellerUID,
                                  )));
                    },
                    child: Text(
                      "Proceed",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
