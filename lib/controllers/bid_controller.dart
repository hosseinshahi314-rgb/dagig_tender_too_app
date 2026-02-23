import 'package:flutter/material.dart';

class BidController {
  final TextEditingController companyController;
  final TextEditingController priceController;
  int parentIndex = 0;
  int parentLength = 1;

  BidController({String company = '', String price = ''})
      : companyController = TextEditingController(text: company),
        priceController = TextEditingController(text: price);

  void dispose() {
    companyController.dispose();
    priceController.dispose();
  }
}