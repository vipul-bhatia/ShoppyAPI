import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinity_project/models/product_list.dart';
import 'package:http/http.dart' as http;
import 'package:infinity_project/pages/productDetails.dart';

enum ProductFilter { electronics, jewelery }

Future<List<productListData>> productDatas() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    List<productListData> productDatas = [];
    for (var element in jsonResponse) {
      List<Rating> ratings = [];
      for (var rating in element['rating'].values) {
        ratings.add(Rating(
          rate: element['rating']['rate'] ?? 0.0,
          count: element['rating']['count'] ?? 0,
        ));
      }

      productDatas.add(productListData(
          id: element['id'],
          title: element['title'],
          price: element['price'],
          description: element['description'],
          category: element['category'],
          image: element['image'],
          rating: ratings));
    }
    return productDatas;
  } else {
    throw Exception("Failed to load products");
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  String _selectedCategory = "All";
  late Future<List<productListData>> _itemsFuture;
  late Future<List<productListData>> _allItems;
  Future<List<productListData>> _filterItems(String category) async {
    List<productListData> items = await _allItems;
    return items
        .where((item) => item.category == category || category == "All")
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _itemsFuture = productDatas();
    _allItems = _itemsFuture;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  void selectProduct(BuildContext ctx, productListData pd) {
    Navigator.of(ctx).pushNamed(
      productDetails.routeName,
      arguments: pd,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FilterChip(
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            label: Text("All"),
            selected: _selectedCategory == "All",
            onSelected: (bool selected) {
              setState(() {
                _selectedCategory = "All";
                _itemsFuture = _filterItems(_selectedCategory);
              });
            },
          ),
          FilterChip(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            label: Text("Electronics"),
            selected: _selectedCategory == "electronics",
            onSelected: (bool selected) {
              setState(() {
                _selectedCategory = "electronics";
                _itemsFuture = _filterItems(_selectedCategory);
              });
            },
          ),
          FilterChip(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            label: Text("Jewelery"),
            selected: _selectedCategory == "jewelery",
            onSelected: (bool selected) {
              setState(() {
                _selectedCategory = "jewelery";
                _itemsFuture = _filterItems(_selectedCategory);
              });
            },
          ),
           FilterChip(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            label: Text("Men clothing"),
            selected: _selectedCategory == "men's clothing",
            onSelected: (bool selected) {
              setState(() {
                _selectedCategory = "men's clothing";
                _itemsFuture = _filterItems(_selectedCategory);
              });
            },
          ),
          
           IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.orange,
              size: 24,
            ),
            iconSize: 24,
          ),
        ],
      ),
      key: scaffoldKey,
      backgroundColor: Color(0xFF4B39EF),
      body: FutureBuilder<List<productListData>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<productListData>? data = snapshot.data;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
                productListData item = data[index];

                return GestureDetector(
                  onTap: () => selectProduct(context, data[index]),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Color(0xFF4B39EF),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.network(
                          data[index].image,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          fit: BoxFit.fitWidth,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  data[index].category,
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  '₹${data[index].price}',
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          ;
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
