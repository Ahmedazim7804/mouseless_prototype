import 'package:equatable/equatable.dart';

int globalId = 1;

enum NodeType { window, horizontalContainer, verticalContainer, root }

abstract class LayoutNode extends Equatable {
  ContainerNode? parent;
  final List<LayoutNode> children;
  final int id;

  LayoutNode({this.parent, this.children = const [], int? id})
    : id = id ?? globalId++;

  @override
  List<Object?> get props => [
    parent?.id,
    children.map((e) => e.id).toList(),
    id,
  ];
}

enum LayoutAxis { horizontal, vertical }

enum LayoutDirection { left, right, up, down }

class WindowNode extends LayoutNode {
  final String window;

  WindowNode({super.id, required this.window, required super.parent})
    : super(children: const []);

  @override
  ContainerNode get parent => super.parent as ContainerNode;

  WindowNode copyWith({String? window, ContainerNode? parent}) {
    return WindowNode(
      window: window ?? this.window,
      parent: parent ?? this.parent,
      id: id,
    );
  }

  @override
  List<Object?> get props => [
    parent.id,
    children.map((e) => e.id).toList(),
    id,
    window,
  ];
}

class ContainerNode extends LayoutNode {
  LayoutAxis axis;
  @override
  ContainerNode({
    super.id,
    required this.axis,
    required super.children,
    required super.parent,
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }
}

class RootNode extends ContainerNode {
  RootNode({super.id, required super.axis, required super.children})
    : super(parent: null);
}

class Window {
  final bool isActive;
  final int row;
  final int col;
  final int strechRows;
  final int strechCols;
  final int id;

  List<int> get occupyingRows =>
      List.generate(strechRows + 1, (index) => row + index);
  List<int> get occupyingCols =>
      List.generate(strechCols + 1, (index) => col + index);

  Window({
    required this.isActive,
    required this.id,
    required this.row,
    required this.col,
    required this.strechRows,
    required this.strechCols,
  });

  Window copyWith({
    bool? isActive,
    int? row,
    int? col,
    int? strechRows,
    int? strechCols,
  }) {
    return Window(
      isActive: isActive ?? this.isActive,
      id: id,
      row: row ?? this.row,
      col: col ?? this.col,
      strechRows: strechRows ?? this.strechRows,
      strechCols: strechCols ?? this.strechCols,
    );
  }
}
