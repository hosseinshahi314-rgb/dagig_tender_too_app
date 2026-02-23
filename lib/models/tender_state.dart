import '../controllers/bid_controller.dart';
import 'package:flutter/material.dart';

class TenderState extends ChangeNotifier {
  final TextEditingController tenderNameController = TextEditingController();
  final TextEditingController tenderNumberController = TextEditingController();
  final TextEditingController initialAmountController = TextEditingController();
  final TextEditingController updatedEstimateController =
      TextEditingController();
  final List<BidController> bidControllers = [BidController()];

  String resultText = '';
  bool isLoading = false;

  void addBid() {
    if (bidControllers.length < 20) {
      bidControllers.add(BidController());
      notifyListeners();
    }
  }

  void removeBid(int index) {
    if (bidControllers.length > 1) {
      bidControllers.removeAt(index);
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setResult(String text) {
    resultText = text;
    notifyListeners();
  }

  void clearAll() {
    tenderNameController.clear();
    tenderNumberController.clear();
    initialAmountController.clear();
    updatedEstimateController.clear();
    bidControllers.clear();
    bidControllers.add(BidController());
    resultText = '';
    notifyListeners();
  }

  @override
  void dispose() {
    tenderNameController.dispose();
    tenderNumberController.dispose();
    initialAmountController.dispose();
    updatedEstimateController.dispose();
    for (var controller in bidControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
