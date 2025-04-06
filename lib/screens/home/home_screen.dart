import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouseless/core/controller/i3_layout_controller.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/core/extensions.dart';
import 'package:mouseless/core/premade_layouts.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/models/layout_node.dart';
import 'package:mouseless/screens/components/pressed_keys_list.dart';
import 'package:mouseless/screens/components/sidebar/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription sub;
  late final I3LayoutController i3LayoutController = I3LayoutController(
    active: PremadeLayouts.layout1,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(
        context,
      ).startShowCase([grabShowcaseKey, unGrabShowcaseKey]);
    });

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
      } else if (event == I3Event.moveLeft) {
        i3LayoutController.moveLeft();
      } else if (event == I3Event.moveRight) {
        i3LayoutController.moveRight();
      } else if (event == I3Event.moveUp) {
        i3LayoutController.moveUp();
      } else if (event == I3Event.moveDown) {
        i3LayoutController.moveDown();
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Simulation", style: GoogleFonts.suezOne(fontSize: 24)),
              Container(
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xff828282)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {
                    i3LayoutController.setNewLayout(PremadeLayouts.layout1);
                  },
                  child: Text("Reset", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 5,
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
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [Text("History", style: TextStyle(fontSize: 20))],
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, con) {
                      return Center(child: PressedKeysListWidget());
                    },
                  ),
                ),
              ],
            ),
          ),
        ].spacedBy(height: 16),
      ),
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
      child: Padding(
        padding: EdgeInsets.all(widget.root is RootNode ? 8 : 0),
        child: Builder(
          builder: (_) {
            if (widget.root is WindowNode) {
              final window = widget.root as WindowNode;
              return _WindowWidget(
                id: window.window,
                isActive: window.id == widget.active.id,
              );
            } else if (widget.root is ContainerNode) {
              if ((widget.root as ContainerNode).axis ==
                  LayoutAxis.horizontal) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: widget.root.children
                      .map(
                        (e) => SimulationWindowsGridWidget(
                          root: e,
                          active: widget.active,
                        ),
                      )
                      .toList()
                      .spacedBy(width: 4),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: widget.root.children
                      .map(
                        (e) => SimulationWindowsGridWidget(
                          root: e,
                          active: widget.active,
                        ),
                      )
                      .toList()
                      .spacedBy(height: 4),
                );
              }
            }

            return SizedBox.shrink();
          },
        ),
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
          Text(
            fixedLayout == null ? "Current" : "Achieve",
            style: TextStyle(fontSize: 20),
          ),
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
