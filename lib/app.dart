import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physiomobile_technical_assessment/core/utils/extensions/context_extension.dart';
import 'package:physiomobile_technical_assessment/presentation/pages/home/home_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: MaterialApp(
        home: HomePage(),
        theme: context.themeExt.copyWith(
          textTheme: GoogleFonts.orbitronTextTheme(),
        ),
      ),
    );
  }
}
