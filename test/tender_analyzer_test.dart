import 'package:flutter_test/flutter_test.dart';
import 'package:dagigtendertool/services/tender_analyzer.dart';
import 'package:dagigtendertool/models/tender_input.dart';
import 'package:dagigtendertool/models/bid_data.dart';

void main() {
  group('TenderAnalyzer Tests', () {
    late TenderAnalyzer analyzer;

    setUp(() {
      analyzer = TenderAnalyzer();
    });

    test('Should return mode1 when all bids are within 10% of updated estimate', () {
      final input = TenderInput(
        name: 'Test',
        number: '123',
        initialAmount: 1000000000,
        updatedEstimate: 1000000000,
        bids: [
          BidData(company: 'A', price: 950000000, isValidStage2: false),
          BidData(company: 'B', price: 1050000000, isValidStage2: false),
        ],
      );

      final result = analyzer.analyze(input);
      expect(result.modeTitle, contains('حالت اول'));
    });

    test('Should return mode2 when average is outside final range', () {
      final input = TenderInput(
        name: 'Test',
        number: '123',
        initialAmount: 1000000000,
        updatedEstimate: 1000000000,
        bids: [
          BidData(company: 'A', price: 1500000000, isValidStage2: false),
          BidData(company: 'B', price: 1600000000, isValidStage2: false),
          BidData(company: 'C', price: 1700000000, isValidStage2: false),
        ],
      );

      final result = analyzer.analyze(input);
      expect(result.modeTitle, contains('حالت دوم'));
    });

    test('Should sort bids by price in ascending order', () {
      final input = TenderInput(
        name: 'Test',
        number: '123',
        initialAmount: 1000000000,
        updatedEstimate: 1000000000,
        bids: [
          BidData(company: 'A', price: 1200000000, isValidStage2: false),
          BidData(company: 'B', price: 1000000000, isValidStage2: false),
          BidData(company: 'C', price: 1100000000, isValidStage2: false),
        ],
      );

      final result = analyzer.analyze(input);
      expect(result.sortedBids.first.company, 'B');
      expect(result.sortedBids.last.company, 'A');
    });
  });
}