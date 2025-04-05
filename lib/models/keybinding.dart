import 'package:flutter/services.dart';

enum I3Event {
  focusLeft,
  focusRight,
  focusUp,
  focusDown,
  moveLeft,
  moveRight,
  moveDown,
  moveUp,
}

class Keybinding<T> {
  final T type;
  final Set<LogicalKeyboardKey> keys;
  Keybinding({required this.keys, required this.type});
}
