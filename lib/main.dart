import 'package:flutter/material.dart';
import 'package:infinity_project/pages/cart.dart';
import 'package:infinity_project/pages/home.dart';

import '../pages/loginPage.dart';
import '../pages/productDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final CartModel cart = CartModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NMIMS Shirpur',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => loginPage(),
        '/homePage': (context) => HomePageWidget(),
        '/productDetails': (context) => productDetails(cart: cart),
        '/cart': (context) => CartWidget(cart: cart),
      },
    );
  }
}
