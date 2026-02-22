# dagig_tender_too_app
DagigTenderTool تعیین کمترین قیمت متناسب در مناقصات وزارت نقت ، مطابق با بخشنامه وزارت نفت ، تعیین دامنه مناسب قیمت پیشنهادی
# DagigTenderTool

DagigTenderTool یک اپلیکیشن Flutter حرفه‌ای برای تحلیل مناقصات نفت است که طبق دستورالعمل‌های وزارت نفت کار می‌کند.

## ویژگی‌ها

- تحلیل خودکار پیشنهادات مناقصه
- تشخیص یکی از ۳ حالت تحلیلی
- گزارش‌گیری PDF با فونت فارسی
- استفاده از الگوهای طراحی مانند BLoC
- کاملاً RTL و فارسی‌سازی شده

## نصب

1. `git clone https://github.com/your-repo/dagigtendertool.git`
2. `cd dagigtendertool`
3. `flutter pub get`
4. `flutter run`

## ساختار پروژه
lib/
├── models/
│   ├── tender_input.dart
│   ├── bid_data.dart
│   └── analysis_result.dart
├── services/
│   ├── tender_analyzer.dart
│   ├── pdf_generator.dart
│   └── validators.dart
├── bloc/
│   ├── tender_bloc.dart
│   ├── tender_event.dart
│   └── tender_state.dart
├── widgets/
├── screens/
└── utils/

## نویسنده

hosseinshahi

## مجوز

MIT License
