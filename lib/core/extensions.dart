import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:mouseless/models/window.dart';

extension ListWidgetExt on List<Widget> {
  // make the method take a optional parameter for spacing widget
  List<Widget> spacedBy({double? height, double? width, Widget? widget}) {
    if (length < 2) {
      return this;
    }
    if (widget != null) {
      assert(height == null && width == null);
    } else {
      // Only one of height or width can and must be non-null
      assert(
        (height != null && width == null) || (height == null && width != null),
      );
    }

    widget = widget ?? SizedBox(height: height, width: width);
    return List.generate(length * 2 - 1, (index) {
      if (index.isEven) {
        return this[index ~/ 2];
      } else {
        return widget!;
      }
    });
  }

  List<Widget> spaceBySpecificSize({
    required List<int> spacing,
    required Axis axis,
  }) {
    assert(spacing.length == length - 1);

    return List.generate(length * 2 - 1, (index) {
      if (index.isEven) {
        return this[index ~/ 2];
      } else {
        return SizedBox(
          height: axis == Axis.vertical ? spacing[index ~/ 2].toDouble() : null,
          width:
              axis == Axis.horizontal ? spacing[index ~/ 2].toDouble() : null,
        );
      }
    });
  }
}

extension ListWindowsExt on List<Window> {
  int get maxRows {
    return map((e) => e.row).reduce((a, b) => a > b ? a : b);
  }

  int get maxCols {
    return map((e) => e.col).reduce((a, b) => a > b ? a : b);
  }

  Window get activeWindow {
    return firstWhereOrNull((window) => window.isActive)!;
  }

  Window? get activeWindowOrNull {
    return firstWhereOrNull((window) => window.isActive);
  }

  Window? get closestAboveWindow {
    final activeWindow = this.activeWindow;
    final maxRows = this.maxRows + 1;

    final aboveWindows =
        where(
          (e) => (e.row - 1) % maxRows == activeWindow.row && !e.isActive,
        ).toList();

    if (aboveWindows.isEmpty) {
      return null;
    }

    return aboveWindows.reduce((a, b) {
      if (a.col == activeWindow.col) {
        return a;
      } else if (b.col == activeWindow.col) {
        return b;
      } else {
        return a.col < b.col ? a : b;
      }
    });
  }

  Window? get closestLeftWindow {
    final activeWindow = this.activeWindow;

    final sameRowWindows =
        where((e) => e.occupyingRows.contains(activeWindow.row)).toList();

    if (sameRowWindows.isEmpty) {
      return null;
    }

    final index = sameRowWindows.indexWhere((e) => e.id == activeWindow.id);

    return sameRowWindows[(index - 1) % sameRowWindows.length];
  }

  Window? get closestRightWindow {
    final activeWindow = this.activeWindow;

    final sameRowWindows =
        where((e) => e.occupyingRows.contains(activeWindow.row)).toList();

    if (sameRowWindows.isEmpty) {
      return null;
    }

    final index = sameRowWindows.indexWhere((e) => e.id == activeWindow.id);

    return sameRowWindows[(index + 1) % sameRowWindows.length];
  }

  Window? get closestBelowWindow {
    final maxRows = this.maxRows + 1;
    final activeWindow = this.activeWindow;

    final belowWindows = where(
      (e) => (e.row + 1) % maxRows == activeWindow.row && !e.isActive,
    );

    if (belowWindows.isEmpty) {
      return null;
    }

    return belowWindows.reduce((a, b) {
      if (a.col == activeWindow.col) {
        return a;
      } else if (b.col == activeWindow.col) {
        return b;
      } else {
        return a.col < b.col ? a : b;
      }
    });
  }
}
