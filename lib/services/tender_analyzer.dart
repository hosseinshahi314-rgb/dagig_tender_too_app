import '../models/tender_input.dart';
import '../models/analysis_result.dart';
import '../models/bid_data.dart';
import 'dart:math' as math;

class TenderAnalyzer {
  AnalysisResult analyze(TenderInput input) {
    final mode = _determineMode(input);
    final result = _analyzeBids(mode, input);

    String modeTitle = '';
    String modeDescription = '';
    String rangeDescription = '';

    switch (mode) {
      case _AnalysisMode.mode1:
        modeTitle = 'حالت اول: تعداد پیشنهادات کم یا همه در محدوده ±10%';
        modeDescription = 'محدوده مجاز = برآورد بهنگام × 0.9 تا برآورد بهنگام × 1.1';
        rangeDescription = 'محدوده مجاز: ±10% برآورد بهنگام';
        break;
      case _AnalysisMode.mode2:
        modeTitle = 'حالت دوم: بیش از 2 پیشنهاد و میانگین خارج از محدوده نهایی';
        modeDescription = 'محدوده مجاز پیشنهادات: 0.8P₀ تا 1.2P₀';
        rangeDescription = 'دامنه نهایی: 0.8P₀ تا 1.35P₀';
        break;
      case _AnalysisMode.mode3:
        modeTitle = 'حالت سوم: بیش از 2 پیشنهاد و میانگین در محدوده نهایی';
        modeDescription = 'نرمال‌سازی = 1 - |پیشنهاد - میانگین| ÷ (3 × انحراف معیار)';
        rangeDescription = 'محدوده مجاز پیشنهادات: 0.8P₀ تا 1.2P₀';
        break;
    }

    return AnalysisResult(
      sortedBids: result['bids'] as List<BidData>,
      average: result['average'] as double?,
      stdDev: result['stdDev'] as double?,
      modeTitle: modeTitle,
      modeDescription: modeDescription,
      rangeDescription: rangeDescription,
      initialAmount: input.initialAmount, 
    );
  }

  _AnalysisMode _determineMode(TenderInput input) {
    final bids = input.bids.map((b) => b.price).toList();
    if (bids.length <= 2) return _AnalysisMode.mode1;

    final minRange10 = input.updatedEstimate * 0.9;
    final maxRange10 = input.updatedEstimate * 1.1;
    final allInRange = bids.every((bid) => bid >= minRange10 && bid <= maxRange10);

    if (allInRange) return _AnalysisMode.mode1;

    final avg = bids.reduce((a, b) => a + b) / bids.length;
    final minFinal = input.initialAmount * 0.8;
    final maxFinal = input.initialAmount * 1.35;

    if (avg < minFinal || avg > maxFinal) return _AnalysisMode.mode2;

    return _AnalysisMode.mode3;
  }

  Map<String, dynamic> _analyzeBids(_AnalysisMode mode, TenderInput input) {
    final bids = input.bids;
    final bidPrices = bids.map((b) => b.price).toList();
    List<BidData> bidDataList = [];
    double? avg, std;

    switch (mode) {
      case _AnalysisMode.mode1:
        final minRange = input.updatedEstimate * 0.9;
        final maxRange = input.updatedEstimate * 1.1;
        for (var bid in bids) {
          final isValid = bid.price >= minRange && bid.price <= maxRange;
          bidDataList.add(BidData(
            company: bid.company,
            price: bid.price,
            isValidStage2: isValid,
          ));
        }
        avg = bidPrices.reduce((a, b) => a + b) / bidPrices.length;
        break;

      case _AnalysisMode.mode2:
      case _AnalysisMode.mode3:
        final minStage2 = input.initialAmount * 0.8;
        final maxStage2 = input.initialAmount * 1.2;
        final validBids = bids.where((bid) => bid.price >= minStage2 && bid.price <= maxStage2).toList();

        avg = validBids.isNotEmpty
            ? validBids.map((b) => b.price).reduce((a, b) => a + b) / validBids.length
            : 0.0;

        if (mode == _AnalysisMode.mode3 && validBids.isNotEmpty) {
          final variance = validBids.map((bid) => math.pow(bid.price - avg!, 2)).reduce((a, b) => a + b) / validBids.length;
          std = math.sqrt(variance);
        }

        for (var bid in bids) {
          final isValidStage2 = bid.price >= minStage2 && bid.price <= maxStage2;
          bidDataList.add(BidData(
            company: bid.company,
            price: bid.price,
            isValidStage2: isValidStage2,
          ));
        }
        break;
    }

    bidDataList.sort((a, b) => a.price.compareTo(b.price));
    return {'bids': bidDataList, 'average': avg, 'stdDev': std};
  }
}

enum _AnalysisMode { mode1, mode2, mode3 }