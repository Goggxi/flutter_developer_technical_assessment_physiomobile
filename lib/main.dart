import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physiomobile_technical_assessment/app.dart';
import 'package:physiomobile_technical_assessment/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await di.init();
  runApp(const MainApp());
}
