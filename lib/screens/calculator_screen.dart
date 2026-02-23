import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tender_bloc.dart';
import '../bloc/tender_event.dart';
import '../bloc/tender_state.dart';
import '../models/tender_input.dart';
import '../models/bid_data.dart';
import '../models/analysis_result.dart';
import '../widgets/bid_input_card.dart';
import '../controllers/bid_controller.dart';
import '../utils/formatting.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController tenderNameController = TextEditingController();
  final TextEditingController tenderNumberController = TextEditingController();
  final TextEditingController initialAmountController = TextEditingController();
  final TextEditingController updatedEstimateController =
      TextEditingController();
  final List<BidController> bidControllers = [BidController()];

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TenderBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DagigTenderTool',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: const Color(0xFF1E3A8A),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<TenderBloc, TenderState>(
            listener: (context, state) {
              if (state is TenderError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final isLoading = state is TenderLoading;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سیستم تحلیل مناقصات نفت',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A)),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'محاسبه دامنه‌های مجاز بر اساس دستورالعمل‌های وزارت نفت',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: tenderNameController,
                      decoration: InputDecoration(
                        labelText: 'نام مناقصه',
                        hintText: 'مثال: تأمین لوله گاز',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.description,
                            color: Color(0xFF1E3A8A)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: tenderNumberController,
                      decoration: InputDecoration(
                        labelText: 'شماره مناقصه',
                        hintText: 'مثال: 1404/001',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon:
                            const Icon(Icons.numbers, color: Color(0xFF1E3A8A)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: initialAmountController,
                      decoration: InputDecoration(
                        labelText: 'مبلغ اولیه پیمان (P₀) بر حسب ریال',
                        hintText: 'مثال: 40000000000',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.monetization_on,
                            color: Color(0xFF1E3A8A)),
                        filled: true,
                        fillColor: Colors.yellow.shade50,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: updatedEstimateController,
                      decoration: InputDecoration(
                        labelText: 'برآورد بهنگام (ریال)',
                        hintText: 'مثال: 50000000000',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.auto_fix_high,
                            color: Color(0xFF1E3A8A)),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'پیشنهادات شرکت‌ها:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A)),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bidControllers.length,
                      itemBuilder: (context, index) {
                        final controller = bidControllers[index];
                        controller.parentIndex = index;
                        controller.parentLength = bidControllers.length;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: BidInputCard(
                            controller: controller,
                            index: index,
                            canRemove: bidControllers.length > 1,
                            onRemove: () => removeBid(index),
                            onAdd: addBid,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : () => _onGeneratePdf(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text('دانلود گزارش PDF',
                                style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : () => _onCalculate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isLoading ? Colors.grey : const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('محاسبه و تحلیل نهایی',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is TenderSuccess)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.blue.shade200, width: 2),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Text(
                            _buildReport(state.result),
                            style: const TextStyle(fontSize: 14, height: 1.6),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF1E3A8A),
          padding: const EdgeInsets.all(12),
          child: const Text(
            'DagigTenderTool © 1404',
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void addBid() {
    if (bidControllers.length < 20) {
      setState(() {
        bidControllers.add(BidController());
      });
    }
  }

  void removeBid(int index) {
    if (bidControllers.length > 1) {
      setState(() {
        bidControllers.removeAt(index);
      });
    }
  }

  String _buildReport(AnalysisResult result) {
    return '''
📊 گزارش تحلیل مناقصه

🎯 ${result.modeTitle}
${result.rangeDescription}

📈 لیست پیشنهادات (از کمترین به بیشترین):

${result.sortedBids.map((bid) => '${bid.isValidStage2 ? "🟢" : "🔴"} ${bid.company}: ${formatNumber(bid.price)} ریال ${bid.isValidStage2 ? "(معتبر مرحله ۲)" : "(غیرمعتبر)"}').join('\n')}

آمار نهایی:
   • میانگین پیشنهادات معتبر: ${result.average != null ? formatNumber(result.average!) : 'N/A'} ریال
   • دامنه نهایی مجاز: ${formatNumber(result.initialAmount * 0.8)} تا ${formatNumber(result.initialAmount * 1.35)} ریال
   ${result.stdDev != null ? '   • انحراف معیار: ${formatNumber(result.stdDev!)} ریال' : ''}
      ''';
  }

  void _onCalculate(BuildContext context) {
    final p0 = _parseNumber(initialAmountController.text);
    final updatedEstimate = _parseNumber(updatedEstimateController.text);

    if (tenderNameController.text.trim().isEmpty ||
        tenderNumberController.text.trim().isEmpty ||
        p0 == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('لطفاً تمام اطلاعات مناقصه را وارد کنید')));
      return;
    }

    final bids = bidControllers
        .where((c) => c.priceController.text.isNotEmpty)
        .map((c) => BidData(
              company: c.companyController.text.trim().isNotEmpty
                  ? c.companyController.text.trim()
                  : 'شرکت ${bidControllers.indexOf(c) + 1}',
              price: _parseNumber(c.priceController.text),
              isValidStage2: false,
            ))
        .toList();

    if (bids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لطفاً حداقل یک پیشنهاد وارد کنید')));
      return;
    }

    final input = TenderInput(
      name: tenderNameController.text,
      number: tenderNumberController.text,
      initialAmount: p0,
      updatedEstimate: updatedEstimate,
      bids: bids,
    );

    context.read<TenderBloc>().add(CalculateTenderEvent(input));
  }

  void _onGeneratePdf(BuildContext context) {
    final p0 = _parseNumber(initialAmountController.text);
    final bids = bidControllers
        .where((c) => c.priceController.text.isNotEmpty)
        .map((c) => BidData(
              company: c.companyController.text.trim().isNotEmpty
                  ? c.companyController.text.trim()
                  : 'شرکت ${bidControllers.indexOf(c) + 1}',
              price: _parseNumber(c.priceController.text),
              isValidStage2: false,
            ))
        .toList();

    final input = TenderInput(
      name: tenderNameController.text,
      number: tenderNumberController.text,
      initialAmount: p0,
      updatedEstimate: _parseNumber(updatedEstimateController.text),
      bids: bids,
    );

    context.read<TenderBloc>().add(GeneratePdfReportEvent(input));
  }

  double _parseNumber(String text) {
    final cleanText = text.replaceAll(RegExp(r'[^\d.]'), '');
    return cleanText.isEmpty ? 0.0 : double.parse(cleanText);
  }
}
