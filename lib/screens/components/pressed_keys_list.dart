import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/screens/components/keyboard_key.dart';
import 'package:provider/provider.dart';

class PressedKeysListWidget extends StatefulWidget {
  const PressedKeysListWidget({super.key});

  @override
  State<PressedKeysListWidget> createState() => _PressedKeysListWidgetState();
}

class _PressedKeysListWidgetState extends State<PressedKeysListWidget> {
  late final KeysController keysController =
      Provider.of<KeysController<I3Event>>(context, listen: false);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<LogicalKeyboardKey> _pressedKeys = [];
  final List<int> removeThese = [];

  Future<void> addRemove(
    KeyEvent event,
    int index, {
    bool forceRemove = false,
  }) async {
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
      _listKey.currentState?.insertItem(
        index,
        duration: const Duration(milliseconds: 100),
      );
    } else if (event is KeyUpEvent) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        _pressedKeys.removeAt(index);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => ScaleTransition(
            scale: animation,
            child: KeyboardKeyWidget(
              keyText: event.logicalKey.keyLabel,
              logicalKeyEquivalent: {event.logicalKey},
              isPressed: true,
            ),
          ),
          duration: const Duration(milliseconds: 100),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    () async {
      while (true) {
        final event = await keysController.stream.next;

        addRemove(event.$1, event.$2);
      }
    }.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      initialItemCount: 0,
      itemBuilder: (context, index, animation) {
        return Row(
          children: [
            ScaleTransition(
              key: ValueKey(_pressedKeys.elementAt(index).keyId),
              scale: animation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: KeyboardKeyWidget(
                  keyText: _pressedKeys.elementAt(index).keyLabel,
                  logicalKeyEquivalent: {_pressedKeys.elementAt(index)},
                  isPressed: true,
                ),
              ),
            ),
            if (index != _pressedKeys.length - 1)
              ScaleTransition(scale: animation, child: KeyboardKeyPlus()),
          ],
        );
      },
    );
  }
}
