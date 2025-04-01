import 'dart:async';
import 'dart:collection';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/models/keybinding.dart';

class KeysController<T> extends ChangeNotifier {
  final List<Keybinding<T>> recognizableKeybindings;

  KeysController({required this.recognizableKeybindings});

  final StreamController<(KeyEvent, int)> _keyEventStreamController =
      StreamController<(KeyEvent, int)>.broadcast();

  final StreamController<T> _streamEventsController =
      StreamController<T>.broadcast();

  final Set<LogicalKeyboardKey> _pressedKeys = {};

  Set<LogicalKeyboardKey> get pressedKeys => _pressedKeys;
  StreamQueue<(KeyEvent, int)> get stream =>
      StreamQueue(_keyEventStreamController.stream.asBroadcastStream());
  Stream<T> get streamEvents =>
      _streamEventsController.stream.asBroadcastStream();

  bool callNotifyListener = false;

  @override
  void dispose() {
    _keyEventStreamController.close();
    super.dispose();
  }

  void addKey(KeyEvent key) {
    if (key is KeyDownEvent) {
      for (final keybinding in recognizableKeybindings) {
        _pressedKeys.add(key.logicalKey);
        if (keybinding.keys.difference(_pressedKeys).isEmpty) {
          _streamEventsController.sink.add(keybinding.type);
        }
      }

      _keyEventStreamController.sink.add((
        key,
        _pressedKeys.indexed.where((e) => e.$2 == key.logicalKey).first.$1,
      ));
    } else if (key is KeyUpEvent) {
      _keyEventStreamController.sink.add((
        key,
        _pressedKeys.indexed.where((e) => e.$2 == key.logicalKey).first.$1,
      ));
      _pressedKeys.remove(key.logicalKey);
    }

    callNotifyListener = true;
    // notifyListeners();
  }
}
