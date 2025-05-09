import 'package:equatable/equatable.dart';

enum LayoutAxis { horizontal, vertical }

enum LayoutDirection { left, right, up, down }

int globalId = 1;

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

class WindowNode extends LayoutNode {
  final String window;

  WindowNode({
    super.id,
    required this.window,
    required super.parent,
    void Function(int)? getId,
  }) : super(children: const []) {
    getId?.call(id);
  }

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
