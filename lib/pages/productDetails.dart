import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinity_project/pages/cart.dart';
import '../pages/productDetails.dart';
import '../models/product_list.dart';

class CartModel extends ChangeNotifier {
  final List<productListData> _products = [];
  final StreamController<List<productListData>> _streamController = StreamController<List<productListData>>();

  List<productListData> get products => _products;
  Stream<List<productListData>> get stream => _streamController.stream;

  void addProduct(productListData product) {
    _products.add(product);
    _streamController.add(_products);
    notifyListeners();
  }

  void dispose() {
    _streamController.close();
    super.dispose();
  }
}


class productDetails extends StatelessWidget {
  static const routeName = '/productDetails';
  late final CartModel cart;

  productDetails({required this.cart});


  @override
  Widget build(BuildContext context) {
    final pd = ModalRoute.of(context)!.settings.arguments as productListData;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF0F1113),
            size: 32,
          ),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF0F1113),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                   Navigator.pushNamed(context, '/cart');
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.orange,
                size: 28,
              )),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.network(
                  pd.image,
                  width: MediaQuery.of(context).size.width,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      pd.title,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      pd.price.toString(),
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      pd.category,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      pd.description,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 24),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(100, 40),
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                ),
                onPressed: () {
                  cart.addProduct(productListData(
                    id: pd.id,
                    title: pd.title,
                    price: pd.price,
                    description: pd.description,
                    category: pd.category,
                    image: pd.image, rating: pd.rating,
                  ));
                  //on sucess
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to cart'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
                label: Text('Add to Cart'),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
