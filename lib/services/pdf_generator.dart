import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/analysis_result.dart';
import '../utils/formatting.dart';

class PdfGenerator {
  Future<void> generateAndShare(
    AnalysisResult result,
    String tenderName,
    String tenderNumber,
    double p0,
  ) async {
    final pdf = pw.Document();

    // بارگذاری فونت فارسی
    final fontData = await rootBundle.load("assets/fonts/Vazir-Regular.ttf");
    final font = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('گزارش تحلیل مناقصه', style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('نام مناقصه: $tenderName', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Text('شماره مناقصه: $tenderNumber', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Text('مبلغ اولیه پیمان: ${formatNumber(p0)} ریال', style: pw.TextStyle(font: font, fontSize: 12)),
              pw.SizedBox(height: 20),
              pw.Text(result.modeTitle, style: pw.TextStyle(font: font, fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text(result.modeDescription, style: pw.TextStyle(font: font, fontSize: 10)),
              pw.SizedBox(height: 20),
              pw.Text('لیست پیشنهادات:', style: pw.TextStyle(font: font, fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('نام شرکت', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('مبلغ (ریال)', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('وضعیت', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold))),
                  ]),
                  ...result.sortedBids.map((bid) => pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(bid.company, style: pw.TextStyle(font: font))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(formatNumber(bid.price), style: pw.TextStyle(font: font))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(bid.isValidStage2 ? 'معتبر' : 'غیرمعتبر', style: pw.TextStyle(font: font))),
                  ])),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('آمار نهایی:', style: pw.TextStyle(font: font, fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text('میانگین: ${result.average != null ? formatNumber(result.average!) : 'N/A'} ریال', style: pw.TextStyle(font: font)),
              if (result.stdDev != null) pw.Text('انحراف معیار: ${formatNumber(result.stdDev!)} ریال', style: pw.TextStyle(font: font)),
            ],
          ),
        ),
      ),
    );

    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: 'گزارش_مناقصه_$tenderNumber.pdf');
  }
}