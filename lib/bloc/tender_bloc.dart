import 'package:bloc/bloc.dart';
import '../../services/tender_analyzer.dart';
import '../../services/pdf_generator.dart';
import 'tender_event.dart';
import 'tender_state.dart';

class TenderBloc extends Bloc<TenderEvent, TenderState> {
  final TenderAnalyzer analyzer = TenderAnalyzer();
  final PdfGenerator pdfGenerator = PdfGenerator();

  TenderBloc() : super(TenderInitial()) {
    on<CalculateTenderEvent>((event, emit) async {
      emit(TenderLoading());

      try {
        final result = analyzer.analyze(event.input);
        emit(TenderSuccess(result));
      } catch (e) {
        emit(TenderError(e.toString()));
      }
    });

    on<GeneratePdfReportEvent>((event, emit) async {
      try {
        final result = analyzer.analyze(event.input);
        await pdfGenerator.generateAndShare(
          result,
          event.input.name,
          event.input.number,
          event.input.initialAmount,
        );
      } catch (e) {
        emit(TenderError("خطا در تولید PDF: $e"));
      }
    });
  }
}