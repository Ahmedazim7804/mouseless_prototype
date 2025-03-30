import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),

        Text('MOUSELESS', style: GoogleFonts.suezOne(fontSize: 20)),
      ],
    );
  }
}
