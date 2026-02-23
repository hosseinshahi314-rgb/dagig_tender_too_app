import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'models/tender_state.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const DagigTenderToolApp());
}

class DagigTenderToolApp extends StatelessWidget {
  const DagigTenderToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TenderState(),
      child: MaterialApp(
        title: 'DagigTenderTool',
        locale: const Locale('fa', 'IR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fa', 'IR'),
          Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1E3A8A),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
          useMaterial3: true,
          // فونت فارسی
          fontFamily: 'Vazir', // فونت�� که بعداً در pubspec تعریف می‌کنیم
        ),
        home: const CalculatorScreen(),
      ),
    );
  }
}