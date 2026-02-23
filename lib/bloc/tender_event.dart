import '../../models/tender_input.dart';

abstract class TenderEvent {}

class CalculateTenderEvent extends TenderEvent {
  final TenderInput input;
  CalculateTenderEvent(this.input);
}

class GeneratePdfReportEvent extends TenderEvent {
  final TenderInput input;
  GeneratePdfReportEvent(this.input);
}