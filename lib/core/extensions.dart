import 'package:flutter/widgets.dart';

extension ListWidgetExt on List<Widget> {
  List<Widget> spacedBy({double? height, double? width}) {
    // Only one of height or width can and must be non-null
    assert(
      (height != null && width == null) || (height == null && width != null),
    );

    return List.generate(length * 2 - 1, (index) {
      if (index.isEven) {
        return this[index ~/ 2];
      } else {
        return SizedBox(height: height, width: width);
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
