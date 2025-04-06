import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouseless/core/controller/i3_layout_controller.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/core/extensions.dart';
import 'package:mouseless/core/premade_layouts.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/models/layout_node.dart';
import 'package:mouseless/screens/components/keys_history_widget.dart';
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
  final layout2 = PremadeLayouts.layout2;
  bool achieved = false;

  bool areLayoutsSame(LayoutNode? node1, LayoutNode? node2) {
    // Base case 1: Both are null, considered the same.
    if (node1 == null && node2 == null) {
      return true;
    }

    // Base case 2: One is null, the other isn't, considered different.
    if (node1 == null || node2 == null) {
      return false;
    }

    // Base case 3: Nodes have different runtime types, considered different.
    if (node1.runtimeType != node2.runtimeType) {
      return false;
    }

    // --- Type-specific comparison ---

    // Case 1: Both are WindowNodes
    if (node1 is WindowNode && node2 is WindowNode) {
      // Compare only the 'window' property as per requirement 1.
      return node1.window == node2.window;
    }

    // Case 2: Both are ContainerNodes (includes RootNode)
    if (node1 is ContainerNode && node2 is ContainerNode) {
      // Check axis equality (requirement 2 & 3).
      if (node1.axis != node2.axis) {
        return false;
      }

      // Check if they have the same number of children (requirement 3).
      if (node1.children.length != node2.children.length) {
        return false;
      }

      // Recursively check each child pair (requirement 3).
      for (int i = 0; i < node1.children.length; i++) {
        if (!areLayoutsSame(node1.children[i], node2.children[i])) {
          // If any child pair doesn't match, the containers are not the same.
          return false;
        }
      }

      // If all checks pass (axis, child count, and all children recursively match),
      // the containers are considered the same.
      return true;
    }

    return true;
  }

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
    ).keybindingEvents.listen((keybinding) {
      final event = keybinding.type;

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

      if (areLayoutsSame(i3LayoutController.root, layout2.root)) {
        sub.cancel();
        achieved = true;

        if (!mounted || !context.mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff282828), // Dark background color
              title: Row(
                children: [
                  Icon(
                    Icons.celebration, // Example icon: party popper
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Congratulations!',
                    style: TextStyle(color: Colors.white), // White title text
                  ),
                ],
              ),
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline, // Example icon: checkmark
                    color: Colors.greenAccent,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'You won!',
                    style: TextStyle(color: Colors.white), // White content text
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    i3LayoutController.setNewLayout(PremadeLayouts.layout1);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.blueAccent, // Accent color for the button text
                  ),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
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
                  _Simulation(fixedLayout: (layout2.root!, layout2)),
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
                KeysHistoryWidget(),
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
