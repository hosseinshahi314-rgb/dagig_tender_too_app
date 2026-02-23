import 'bid_data.dart';

class TenderInput {
  final String name;
  final String number;
  final double initialAmount;
  final double updatedEstimate;
  final List<BidData> bids;

  TenderInput({
    required this.name,
    required this.number,
    required this.initialAmount,
    required this.updatedEstimate,
    required this.bids,
  });
}