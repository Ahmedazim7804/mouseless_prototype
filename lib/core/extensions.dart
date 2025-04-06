import 'package:flutter/widgets.dart';
import 'package:mouseless/models/layout_node.dart';

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

extension LayoutNodeExt on LayoutNode {
  RootNode? get root {
    LayoutNode node = this;
    while (node.parent != null) {
      node = node.parent!;
    }
    return node as RootNode;
  }
}
