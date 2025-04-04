import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mouseless/core/controller/i3_layout_controller.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/core/extensions.dart';
import 'package:mouseless/core/premade_layouts.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/models/window.dart';
import 'package:mouseless/screens/components/pressed_keys_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription sub;
  late final I3LayoutController i3LayoutController = I3LayoutController(
    root: PremadeLayouts.layout1.$1,
    active: PremadeLayouts.layout1.$2,
  );

  @override
  void initState() {
    super.initState();
    sub = Provider.of<KeysController<I3Event>>(
      context,
      listen: false,
    ).streamEvents.listen((event) {
      if (event == I3Event.focusLeft) {
        i3LayoutController.focusLeft();
      } else if (event == I3Event.focusRight) {
        i3LayoutController.focusRight();
      } else if (event == I3Event.focusUp) {
        i3LayoutController.focusUp();
      } else if (event == I3Event.focusDown) {
        i3LayoutController.focusDown();
      }
    });
  }

  @override
  void dispose() {
    i3LayoutController.dispose();
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Simulation"),
        Expanded(
          child: ChangeNotifierProvider.value(
            value: i3LayoutController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                _Simulation(),
                _Simulation(
                  fixedLayout: (
                    i3LayoutController.root,
                    i3LayoutController.active,
                  ),
                ),
              ].spacedBy(width: 16),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 64, child: PressedKeysListWidget()),
              // Expanded(
              //   child: LayoutBuilder(
              //     builder: (context, con) {
              //       return Container(
              //         alignment: Alignment.center,
              //         width: con.maxWidth,
              //         height: 64,
              //         child: PressedKeysListWidget(),
              //       );
              //     },
              //   ),
              // ),
              // Container(
              //   color: Colors.blue,
              //   height: 200,
              //   // width: 400,
              // ),
            ],
          ),
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Column(children: [Text("History", style: TextStyle(fontSize: 20))]),
        //     SizedBox(height: 200, width: 400, child: PressedKeysListWidget()),
        //     // Expanded(
        //     //   child: Wrap(
        //     //     alignment: WrapAlignment.center,
        //     //     runAlignment: WrapAlignment.center,
        //     //     crossAxisAlignment: WrapCrossAlignment.center,
        //     //     children: keysController.pressedKeys
        //     //         .map(
        //     //           (e) => AnimatedOpacity(
        //     //             opacity: 1,
        //     //             duration: Duration(milliseconds: 200),
        //     //             child: KeyboardKeyWidget(
        //     //               isPressed: true,
        //     //               keyText: e.keyLabel,
        //     //               logicalKeyEquivalent: {e},
        //     //             ),
        //     //           ),
        //     //         )
        //     //         .toList()
        //     //         .spacedBy(widget: const KeyboardKeyPlus())
        //     //         .spacedBy(width: 16),
        //     //   ),
        //     // ),
        //   ],
        // ),
      ],
    );
  }
}

class SimulationWindowsGridWidget extends StatefulWidget {
  const SimulationWindowsGridWidget({
    super.key,
    required this.root,
    required this.active,
  });

  final LayoutNode root;
  final WindowNode active;

  @override
  State<SimulationWindowsGridWidget> createState() =>
      _SimulationWindowsGridWidgetState();
}

class _SimulationWindowsGridWidgetState
    extends State<SimulationWindowsGridWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(
        builder: (_) {
          if (widget.root is WindowNode) {
            final window = widget.root as WindowNode;
            return _WindowWidget(
              id: window.window,
              isActive: window.id == widget.active.id,
            );
          } else if (widget.root is ContainerNode) {
            if ((widget.root as ContainerNode).axis == LayoutAxis.horizontal) {
              return Container(
                padding: EdgeInsets.all(8),
                color: Color.fromARGB(
                  255,
                  ((widget.root.id + 1) * 100) % 255,
                  ((widget.root.id + 1) * 200) % 255,
                  ((widget.root.id + 1) * 300) % 255,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children:
                      widget.root.children
                          .map(
                            (e) => SimulationWindowsGridWidget(
                              root: e,
                              active: widget.active,
                            ),
                          )
                          .toList(),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(8),
                color: Color.fromARGB(
                  255,
                  ((widget.root.id + 1) * 100) % 255,
                  ((widget.root.id + 1) * 200) % 255,
                  ((widget.root.id + 1) * 300) % 255,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children:
                      widget.root.children
                          .map(
                            (e) => SimulationWindowsGridWidget(
                              root: e,
                              active: widget.active,
                            ),
                          )
                          .toList(),
                ),
              );
            }
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _Simulation extends StatelessWidget {
  const _Simulation({super.key, this.fixedLayout});

  final (LayoutNode root, WindowNode active)? fixedLayout;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current", style: TextStyle(fontSize: 20)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff282828),
              ),
              child: LayoutBuilder(
                builder: (context, con) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Status Bar",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Builder(
                        builder: (_) {
                          if (fixedLayout != null) {
                            return SimulationWindowsGridWidget(
                              root: fixedLayout!.$1,
                              active: fixedLayout!.$2,
                            );
                          }
                          return Consumer<I3LayoutController>(
                            builder: (_, controller, ___) {
                              return SimulationWindowsGridWidget(
                                active: controller.active,
                                root: controller.root,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowWidget extends StatelessWidget {
  const _WindowWidget({super.key, required this.id, required this.isActive});

  final String id;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      print("Active window: $id");
    }
    final text = "$id${isActive ? " *" : ""}";
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border:
            isActive ? Border.all(color: Color(0xff3B98E4), width: 2) : null,
        color: Color(0xff181818).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
