import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/core/extensions.dart';
import 'package:mouseless/core/i3_manager.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:mouseless/models/simulation.dart';
import 'package:mouseless/models/window.dart';
import 'package:collection/collection.dart';
import 'package:mouseless/screens/components/pressed_keys_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = Provider.of<KeysController<I3Event>>(
      context,
      listen: false,
    ).streamEvents.listen((event) {
      final newWindows = switch (event) {
        I3Event.focusUp => I3Manager.focusUpperWindow(sim.windows),
        I3Event.focusDown => I3Manager.focusDownWindow(sim.windows),
        I3Event.focusLeft => I3Manager.focusLeftWindow(sim.windows),
        I3Event.focusRight => I3Manager.focusRightWindow(sim.windows),
        I3Event.moveLeft => I3Manager.moveWindowLeft(sim.windows),
      };

      setState(() {
        sim = sim.copyWith(windows: newWindows);
      });
    });
  }

  SimulationModel sim = SimulationModel(
    title: "Current",
    windows: [
      Window(
        id: 0,
        isActive: false,
        row: 0,
        col: 0,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 1,
        isActive: false,
        row: 0,
        col: 1,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 2,
        isActive: false,
        row: 0,
        col: 2,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 3,
        isActive: false,
        row: 0,
        col: 3,
        strechRows: 1,
        strechCols: 0,
      ),
      Window(
        id: 4,
        isActive: true,
        row: 1,
        col: 0,
        strechRows: 0,
        strechCols: 1,
      ),
    ],
  );

  final simAchieve = SimulationModel(
    title: "Achieve",
    windows: [
      Window(
        id: 0,
        isActive: false,
        row: 0,
        col: 0,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 1,
        isActive: false,
        row: 0,
        col: 1,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 2,
        isActive: false,
        row: 0,
        col: 2,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 3,
        isActive: false,
        row: 0,
        col: 3,
        strechRows: 0,
        strechCols: 0,
      ),
      Window(
        id: 4,
        isActive: true,
        row: 1,
        col: 0,
        strechRows: 0,
        strechCols: 3,
      ),
    ],
  );

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 400,
    //   width: 400,
    //   child: SimulationWindowsGridWidget(simulation: sim),
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Simulation"),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _Simulation(simulation: sim),
              _Simulation(simulation: simAchieve),
            ].spacedBy(width: 16),
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
  const SimulationWindowsGridWidget({super.key, required this.simulation});

  final SimulationModel simulation;

  @override
  State<SimulationWindowsGridWidget> createState() =>
      _SimulationWindowsGridWidgetState();
}

class _SimulationWindowsGridWidgetState
    extends State<SimulationWindowsGridWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        late List<Window> sortedWindows = widget.simulation.windows.sorted((
          a,
          b,
        ) {
          if (a.row == b.row) {
            return a.col - b.col;
          } else {
            return a.row - b.row;
          }
        });
        final maxRows = sortedWindows
            .map((e) => e.row + e.strechRows + 1)
            .reduce((a, b) => a > b ? a : b);

        final maxCols = sortedWindows
            .map((e) => e.col + e.strechCols + 1)
            .reduce((a, b) => a > b ? a : b);

        // build the grid
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, con) {
                return StaggeredGrid.count(
                  axisDirection: AxisDirection.down,
                  crossAxisCount: maxCols,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children:
                      sortedWindows
                          .map(
                            (window) => StaggeredGridTile.extent(
                              crossAxisCellCount: window.strechCols + 1,
                              mainAxisExtent:
                                  ((con.maxHeight / maxRows) - 2) *
                                  (window.strechRows + 1),
                              child: _WindowWidget(window: window),
                            ),
                          )
                          .toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Simulation extends StatelessWidget {
  const _Simulation({
    super.key,
    required this.simulation,
    // required this.maxWidth,
    // required this.minWidth,
  });
  // final double minWidth;
  // final double maxWidth;
  final SimulationModel simulation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(simulation.title, style: TextStyle(fontSize: 20)),
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
                      SimulationWindowsGridWidget(simulation: simulation),
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
  const _WindowWidget({super.key, required this.window});

  final Window window;

  @override
  Widget build(BuildContext context) {
    final text = "Window ${window.id}${window.isActive ? " *" : ""}";
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border:
            window.isActive
                ? Border.all(color: Color(0xff3B98E4), width: 2)
                : null,
        color: Color(0xff181818).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
