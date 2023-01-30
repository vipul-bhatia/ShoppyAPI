

import 'package:flutter/material.dart';

class productList {
  final List<productListData> items;

  const productList({
    required this.items,
  });
}

class productListData {
  final int id;
  final String title;
  final dynamic price;
  final String description;
  final String category;
  final String image;
  final List<Rating> rating;

  const productListData ({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
}

class Rating {
  final dynamic rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });
}