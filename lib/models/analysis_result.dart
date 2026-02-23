// lib/models/analysis_result.dart
import 'bid_data.dart';

class AnalysisResult {
  final List<BidData> sortedBids;
  final double? average;
  final double? stdDev;
  final String modeTitle;
  final String modeDescription;
  final String rangeDescription;
  final double initialAmount;

  AnalysisResult({
    required this.sortedBids,
    this.average,
    this.stdDev,
    required this.modeTitle,
    required this.modeDescription,
    required this.rangeDescription,
    required this.initialAmount,
  });
}