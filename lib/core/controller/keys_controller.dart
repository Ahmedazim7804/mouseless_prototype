import 'dart:async';
import 'dart:collection';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/models/keybinding.dart';

class KeyStatusUpdate extends Equatable {
  final LogicalKeyboardKey logicalKey;
  final bool isPressed;

  const KeyStatusUpdate(this.logicalKey, this.isPressed);

  @override
  List<Object?> get props => [logicalKey.keyId, isPressed];

  @override
  String toString() {
    return 'KeyStatusUpdate{logicalKey: ${logicalKey.debugName}, isPressed: $isPressed}';
  }
}

class KeysController<T> extends ChangeNotifier {
  final List<Keybinding<T>> recognizableKeybindings;

  KeysController({required this.recognizableKeybindings});

  final StreamController<KeyStatusUpdate> _keyStatusStreamController =
      StreamController<KeyStatusUpdate>.broadcast();

  final StreamController<Keybinding<T>> _keybindingEventStreamController =
      StreamController<Keybinding<T>>.broadcast();

  final Set<LogicalKeyboardKey> _pressedKeys =
      LinkedHashSet<LogicalKeyboardKey>();

  Set<LogicalKeyboardKey> get pressedKeys => UnmodifiableSetView(_pressedKeys);

  Stream<KeyStatusUpdate> get keyStatusStream =>
      _keyStatusStreamController.stream;
  Stream<Keybinding<T>> get keybindingEvents =>
      _keybindingEventStreamController.stream;

  Keybinding<T>? _activeKeybinding;
  bool needsBindingCheck = false;

  @override
  void dispose() {
    _keyStatusStreamController.close();
    _keybindingEventStreamController.close();
    super.dispose();
  }

  void addKey(KeyEvent event) {
    final LogicalKeyboardKey key = event.logicalKey;

    if (event is KeyDownEvent) {
      // Add the key only if it's not already considered pressed.
      if (_pressedKeys.add(key)) {
        _keyStatusStreamController.sink.add(KeyStatusUpdate(key, true));
        needsBindingCheck = true;
        notifyListeners();
      }
    } else if (event is KeyUpEvent) {
      // Remove the key only if it was already pressed
      if (_pressedKeys.remove(key)) {
        _keyStatusStreamController.sink.add(KeyStatusUpdate(key, false));

        if (_activeKeybinding != null &&
            _pressedKeys.containsAll(_activeKeybinding!.keys)) {
          _activeKeybinding = null;

          needsBindingCheck = true;
        } else {
          needsBindingCheck = true;
        }

        notifyListeners();
      }
    }

    if (needsBindingCheck) {
      _checkForRecognizedKeybindings();
    }
  }

  void _checkForRecognizedKeybindings() {
    Keybinding<T>? longestRecognizedKeybinding;

    for (final keybinding in recognizableKeybindings) {
      if (_pressedKeys.containsAll(keybinding.keys)) {
        if (longestRecognizedKeybinding == null ||
            keybinding.keys.length > longestRecognizedKeybinding.keys.length) {
          longestRecognizedKeybinding = keybinding;

          // TODO: This might fire repeatedly if keys are held down.
        }
      }
    }

    if (longestRecognizedKeybinding != _activeKeybinding) {
      _activeKeybinding = longestRecognizedKeybinding;

      if (_activeKeybinding != null) {
        _keybindingEventStreamController.sink.add(_activeKeybinding!);
      }
    }
  }

  void clearPressedKeys() {
    if (_pressedKeys.isNotEmpty) {
      final keysToRelease = List<LogicalKeyboardKey>.from(_pressedKeys);
      _pressedKeys.clear();
      for (final key in keysToRelease) {
        _keyStatusStreamController.sink.add(KeyStatusUpdate(key, false));
      }
      notifyListeners();
    }
  }
}
