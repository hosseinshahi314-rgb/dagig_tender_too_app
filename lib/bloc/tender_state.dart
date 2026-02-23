import '../../models/analysis_result.dart';

abstract class TenderState {}

class TenderInitial extends TenderState {}

class TenderLoading extends TenderState {}

class TenderSuccess extends TenderState {
  final AnalysisResult result;
  TenderSuccess(this.result);
}

class TenderError extends TenderState {
  final String message;
  TenderError(this.message);
}