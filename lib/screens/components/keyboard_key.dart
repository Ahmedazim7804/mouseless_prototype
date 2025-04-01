import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:provider/provider.dart';

class KeyboardKeyWidget extends StatelessWidget {
  const KeyboardKeyWidget({
    super.key,
    required this.keyText,
    required this.logicalKeyEquivalent,
    required this.isPressed,
  });

  final String keyText;
  final Set<LogicalKeyboardKey> logicalKeyEquivalent;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    final width = switch (keyText.length) {
      1 => 64.0,
      2 => 72.0,
      3 => 96.0,
      4 => 112.0,
      5 => 128.0,
      _ => 128.0,
    };

    return isPressed
        ? Container(
          height: 64,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xff212B36), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(0, 8),
                blurStyle: BlurStyle.solid,
              ),
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(-2, 8),
                blurStyle: BlurStyle.solid,
              ),
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(2, 8),
                blurStyle: BlurStyle.solid,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            keyText.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff212B36),
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        : Container(
          height: 64,
          width: width,
          decoration: BoxDecoration(
            color: Color(0xff262626),
            borderRadius: BorderRadius.circular(8),
          ),
        );
  }
}

class KeyboardKeyPlus extends StatelessWidget {
  const KeyboardKeyPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.add);
  }
}
