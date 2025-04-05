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
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.keyB},
        type: I3Event.focusLeft,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.keyN},
        type: I3Event.focusDown,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.keyM},
        type: I3Event.focusUp,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.comma},
        type: I3Event.focusRight,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.minus},
        type: I3Event.moveLeft,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.equal},
        type: I3Event.moveRight,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.bracketLeft},
        type: I3Event.moveUp,
      ),
      Keybinding<I3Event>(
        keys: {LogicalKeyboardKey.superKey, LogicalKeyboardKey.bracketRight},
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
      // bottomNavigationBar: Theme(
      //   data: Theme.of(context).copyWith(
      //     splashColor: Colors.transparent,
      //     splashFactory: NoSplash.splashFactory,
      //   ),
      //   child: BottomNavigationBar(
      //     backgroundColor: Colors.transparent,
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     elevation: 0,
      //     currentIndex: widget.navigationShell.currentIndex,
      //     onTap: (index) {
      //       widget.navigationShell.goBranch(index);
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           'assets/icons/chat_screen.svg',
      //           colorFilter: ColorFilter.mode(
      //             widget.navigationShell.currentIndex == 0
      //                 ? selectedIconColor
      //                 : unselectedIconColor,
      //             BlendMode.srcIn,
      //           ),
      //         ),
      //         label: 'Chat',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           FlowbeeIcons.discover,
      //           colorFilter: ColorFilter.mode(
      //             widget.navigationShell.currentIndex == 1
      //                 ? selectedIconColor
      //                 : unselectedIconColor,
      //             BlendMode.srcIn,
      //           ),
      //         ),
      //         label: 'Discover',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           'assets/icons/sessions_list.svg',
      //           colorFilter: ColorFilter.mode(
      //             widget.navigationShell.currentIndex == 2
      //                 ? selectedIconColor
      //                 : unselectedIconColor,
      //             BlendMode.srcIn,
      //           ),
      //         ),
      //         label: 'Sessions',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
