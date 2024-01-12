import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tastybite/assistantMethod/address_changer.dart';
import 'package:tastybite/assistantMethod/cart_item_counter.dart';
import 'package:tastybite/assistantMethod/total_amount.dart';
import 'package:tastybite/firebase_options.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tasty Bite',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: SplashPage(),
      ),
    );
  }
}
