import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/screens/components/keyboard_key.dart';
import 'package:provider/provider.dart';

class KeyVisualInfo {
  final DateTime pressTime;
  Timer? removalTimer;
  bool isRemovalScheduled;

  KeyVisualInfo({
    required this.pressTime,
    this.removalTimer,
    this.isRemovalScheduled = false,
  });

  void cancelRemoval() {
    removalTimer?.cancel();
    removalTimer = null;
    isRemovalScheduled = false;
  }
}

class PressedKeysListWidget extends StatefulWidget {
  const PressedKeysListWidget({super.key});

  @override
  State<PressedKeysListWidget> createState() => _PressedKeysListWidgetState();
}

class _PressedKeysListWidgetState extends State<PressedKeysListWidget> {
  late final KeysController keysController =
      Provider.of<KeysController<I3Event>>(context, listen: false);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final LinkedHashMap<LogicalKeyboardKey, KeyVisualInfo> _displayedKeysInfo =
      LinkedHashMap();
  StreamSubscription<KeyStatusUpdate>? _keyStatusSubscription;
  List<LogicalKeyboardKey> get _orderedKeys => _displayedKeysInfo.keys.toList();
  final Duration minDisplayDuration = Duration(milliseconds: 200);
  final Duration _animationDuration = const Duration(milliseconds: 200);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToStream();
  }

  void _subscribeToStream() {
    _keyStatusSubscription?.cancel();
    for (var keyInfo in _displayedKeysInfo.values) {
      keyInfo.cancelRemoval();
    }

    _keyStatusSubscription = keysController.keyStatusStream.listen((update) {
      if (update.isPressed) {
        _handleKeyPress(update.logicalKey);
      } else {
        _handleKeyRelease(update.logicalKey);
      }
    });
  }

  @override
  void dispose() {
    _keyStatusSubscription?.cancel();
    super.dispose();
  }

  void _handleKeyPress(LogicalKeyboardKey key) {
    if (_displayedKeysInfo.containsKey(key)) {
      final info = _displayedKeysInfo[key]!;
      if (info.isRemovalScheduled) {
        info.cancelRemoval();
      }
      return;
    } else {
      final insertIndex = _orderedKeys.length;
      final newInfo = KeyVisualInfo(pressTime: DateTime.now());
      _displayedKeysInfo[key] = newInfo;

      _listKey.currentState?.insertItem(
        insertIndex,
        duration: _animationDuration,
      );
    }
  }

  void _handleKeyRelease(LogicalKeyboardKey key) {
    if (_displayedKeysInfo.containsKey(key)) {
      final info = _displayedKeysInfo[key]!;

      if (!info.isRemovalScheduled) {
        final remainingTime =
            minDisplayDuration - DateTime.now().difference(info.pressTime);

        if (remainingTime <= Duration.zero) {
          _triggerAnimatedRemoval(key);
        } else {
          info.isRemovalScheduled = true;
          info.removalTimer = Timer(remainingTime, () {
            if (_displayedKeysInfo.containsKey(key) &&
                _displayedKeysInfo[key]!.isRemovalScheduled) {
              _triggerAnimatedRemoval(key);
            }
          });
        }
      }
    }
  }

  void _triggerAnimatedRemoval(LogicalKeyboardKey key) {
    final currentKeysOrder = _orderedKeys;
    final index = currentKeysOrder.indexOf(key);

    if (index != -1) {
      final info = _displayedKeysInfo.remove(key);
      info?.cancelRemoval();

      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildAnimatedItem(key, animation),
        duration: _animationDuration,
      );
    }
  }

  Widget _buildAnimatedItem(
    LogicalKeyboardKey key,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      key: ValueKey(key.hashCode),
      scale: animation,
      child: KeyboardKeyWidget(
        keyText: key.keyLabel,
        logicalKeyEquivalent: {key},
        isPressed: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      key: _listKey,
      scrollDirection: Axis.horizontal,
      initialItemCount: _orderedKeys.length,
      itemBuilder: (context, index, animation) {
        final currentKeys = _orderedKeys;

        if (index < 0 || index >= currentKeys.length) {
          return const SizedBox.shrink();
        }

        return _buildAnimatedItem(currentKeys[index], animation);
      },
    );
  }
}
