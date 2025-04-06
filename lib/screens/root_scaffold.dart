import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/screens/components/sidebar/sidebar.dart';
import 'package:provider/provider.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  final _focusNode = FocusNode();
  late final keysController = KeysController<I3Event>(
    recognizableKeybindings: [
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.keyJ},
        type: I3Event.focusLeft,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.keyK},
        type: I3Event.focusDown,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.keyL},
        type: I3Event.focusUp,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.semicolon},
        type: I3Event.focusRight,
      ),
      Keybinding<I3Event>(
        keys: {
          LogicalKeyboardKey.superKey,
          LogicalKeyboardKey.shiftLeft,
          LogicalKeyboardKey.keyJ,
        },
        type: I3Event.moveLeft,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.colon},
        type: I3Event.moveRight,
      ),
      Keybinding<I3Event>(
        keys: {
          LogicalKeyboardKey.superKey,
          LogicalKeyboardKey.shiftLeft,
          LogicalKeyboardKey.keyL,
        },
        type: I3Event.moveUp,
      ),
      Keybinding<I3Event>(
        keys: {
          LogicalKeyboardKey.superKey,
          LogicalKeyboardKey.shiftLeft,
          LogicalKeyboardKey.keyK,
        },
        type: I3Event.moveDown,
      ),
    ],
  );

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xff141414),
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: keysController.addKey,
        child: ChangeNotifierProvider.value(
          value: keysController,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SidebarWidget(),
              Expanded(child: widget.navigationShell),
            ],
          ),
        ),
      ),
    );
  }
}
