import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/models/address.dart';
import 'package:tastybite/widgets/my_text_field.dart';
import 'package:tastybite/widgets/simple_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveAddressPage extends StatelessWidget {
  SaveAddressPage({super.key});

  final _nameControler = TextEditingController();
  final _phoneNmbrController = TextEditingController();
  final _flatNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateControler = TextEditingController();
  final _completeAddressController = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;

  // Get the location
  getUserLocationAddress() async {
    // Check if location permissions are granted
    var status = await Permission.location.status;
    if (status.isDenied) {
      // Request location permissions
      await Permission.location.request();
    }

    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placemarks![0];

    String fullAdress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAdress;

    _flatNumberController.text =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';

    _cityController.text =
        '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';

    _stateControler.text = '${pMark.country}';

    _completeAddressController.text = fullAdress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "TASTY BITE",
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Save address info
          if (formKey.currentState!.validate()) {
            final model = Address(
              name: _nameControler.text.trim(),
              state: _stateControler.text.trim(),
              fullAddress: _completeAddressController.text.trim(),
              phoneNumber: _phoneNmbrController.text.trim(),
              flatNumber: _flatNumberController.text.trim(),
              city: _cityController.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,
            ).toJson();

            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().microsecondsSinceEpoch.toString())
                .set(model)
                .then((value) {
              Fluttertoast.showToast(msg: "New address has been saved");
              formKey.currentState!.reset();
            });
          }
        },
        label: const Text("Save"),
        // icon: Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add new address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _locationController,
                  decoration:
                      const InputDecoration(hintText: "What's your address?"),
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                //=> Get current location
                print("Get my current location clicked...");
                getUserLocationAddress();
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              label: const Text(
                "Get my current location",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    //-> Name
                    MyTextField(
                      hint: "Name",
                      controller: _nameControler,
                    ),

                    //-> Phone Number
                    MyTextField(
                      hint: "Phone Number",
                      controller: _phoneNmbrController,
                    ),

                    //-> City
                    MyTextField(
                      hint: "City",
                      controller: _cityController,
                    ),

                    //-> State / Country
                    MyTextField(
                      hint: "State / Country",
                      controller: _stateControler,
                    ),

                    //-> Address Line
                    MyTextField(
                      hint: "Address Line",
                      controller: _flatNumberController,
                    ),

                    //-> Complete address
                    MyTextField(
                      hint: "Complete address",
                      controller: _completeAddressController,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
