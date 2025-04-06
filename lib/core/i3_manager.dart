import 'package:mouseless/core/extensions.dart';
import 'package:mouseless/models/layout_node.dart';

class I3Manager {
  // static List<Window> focusLeftWindow(List<Window> windows) {
  //   final activeWindow = windows.activeWindowOrNull;
  //   if (activeWindow == null) {
  //     return windows;
  //   }

  //   final nextWindow = windows.closestLeftWindow;

  //   if (nextWindow == null) {
  //     return windows;
  //   }

  //   windows[activeWindow.id] = activeWindow.copyWith(isActive: false);
  //   windows[nextWindow.id] = nextWindow.copyWith(isActive: true);

  //   return windows;
  // }

  // static List<Window> focusRightWindow(List<Window> windows) {
  //   final activeWindow = windows.activeWindowOrNull;
  //   if (activeWindow == null) {
  //     return windows;
  //   }

  //   final nextWindow = windows.closestRightWindow;

  //   if (nextWindow == null) {
  //     return windows;
  //   }

  //   windows[activeWindow.id] = activeWindow.copyWith(isActive: false);
  //   windows[nextWindow.id] = nextWindow.copyWith(isActive: true);

  //   return windows;
  // }

  // static List<Window> focusDownWindow(List<Window> windows) {
  //   final activeWindow = windows.activeWindowOrNull;
  //   if (activeWindow == null) {
  //     return windows;
  //   }

  //   final nextWindow = windows.closestBelowWindow;

  //   if (nextWindow == null) {
  //     return windows;
  //   }

  //   windows[activeWindow.id] = activeWindow.copyWith(isActive: false);
  //   windows[nextWindow.id] = nextWindow.copyWith(isActive: true);

  //   return windows;
  // }

  // static List<Window> focusUpperWindow(List<Window> windows) {
  //   final activeWindow = windows.activeWindowOrNull;
  //   if (activeWindow == null) {
  //     return windows;
  //   }

  //   final nextWindow = windows.closestAboveWindow;

  //   if (nextWindow == null) {
  //     return windows;
  //   }

  //   windows[activeWindow.id] = activeWindow.copyWith(isActive: false);
  //   windows[nextWindow.id] = nextWindow.copyWith(isActive: true);

  //   return windows;
  // }

  // static List<Window> moveWindowLeft(List<Window> windows) {
  //   final activeWindow = windows.activeWindowOrNull;

  //   if (activeWindow == null) {
  //     return windows;
  //   }

  //   final windowsInActiveWindowColumn =
  //       windows.where((e) => e.col == activeWindow.col).toList();

  //   // if leftmost column and more than 1 window in the column

  //   final leftColumnWindows =
  //       windows.where((e) => e.col == activeWindow.col - 1).toList();

  //   if (windowsInActiveWindowColumn.length == 1 && activeWindow.col != 0) {
  //     print('Moving window left');
  //     if (windowsInActiveWindowColumn.length == 1) {
  //       windows[activeWindow.id] = activeWindow.copyWith(
  //         col: activeWindow.col - 1,
  //       );

  //       windows[windowsInActiveWindowColumn.first.id] =
  //           windowsInActiveWindowColumn.first.copyWith(col: activeWindow.col);
  //     } else {
  //       windows[activeWindow.id] = activeWindow.copyWith(
  //         col: activeWindow.col - 1,
  //         row: windowsInActiveWindowColumn.maxRows + 1,
  //       );
  //     }
  //   } else if (windowsInActiveWindowColumn.length > 1) {
  //     if (activeWindow.col == 0) {
  //       windows =
  //           windows.map((e) {
  //             if (e.col != activeWindow.col) {
  //               return e.copyWith(col: e.col + 1);
  //             } else {
  //               return e;
  //             }
  //           }).toList();
  //     } else {
  //       if (leftColumnWindows.length == 1) {
  //         windows[activeWindow.id] = activeWindow.copyWith(row: 0);

  //         windows =
  //             windows.map((e) {
  //               if (e.id == activeWindow.id) {
  //                 return e;
  //               } else if (e.col >= activeWindow.col) {
  //                 return e.copyWith(col: e.col + 1);
  //               }

  //               return e;
  //             }).toList();
  //       } else if (leftColumnWindows.length > 1) {
  //         windows[activeWindow.id] = activeWindow.copyWith(
  //           col: activeWindow.col - 1,
  //           row: leftColumnWindows.maxRows + 1,
  //         );
  //       }
  //     }
  //   }

  //   return windows;
  // }
}
