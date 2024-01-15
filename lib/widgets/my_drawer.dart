import 'package:flutter/material.dart';
import 'package:tastybite/authentication/auth_page.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/pages/address_page.dart';
import 'package:tastybite/pages/history_page.dart';
import 'package:tastybite/pages/home_page.dart';
import 'package:tastybite/pages/my_order_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            // Header
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    //fontFamily: "Train",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Drawer Body
          Container(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //Home
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),

                // My order
                ListTile(
                  leading: const Icon(
                    Icons.note_alt_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "My order",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    print("My order clicked...");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyOrderPage()));
                  },
                ),

                // History
                ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    print("History clicked...");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HistoryPage()));
                  },
                ),

                // Search
                ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Search",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    print("Search clicked...");
                  },
                ),

                // Add new address
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Location",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    print("Location clicked...");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddressPage()));
                  },
                ),

                // Sign out
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Sign out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    print("Home drawer clicked...");
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AuthPage()));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
