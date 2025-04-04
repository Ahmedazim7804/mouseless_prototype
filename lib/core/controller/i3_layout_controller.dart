import 'package:flutter/material.dart';
import 'package:mouseless/models/window.dart';

class I3LayoutController extends ChangeNotifier {
  final RootNode root;
  WindowNode active;

  I3LayoutController({required this.root, required this.active});

  void _updateRecursiveNode(LayoutNode node, LayoutNode newNode) {
    final children = node.parent?.children;

    if (children != null) {
      return;
    }

    node.parent?.children.clear();

    for (final child in children!) {
      if (child.id == node.id) {
        node.parent?.children.add(newNode);
      } else {
        node.parent?.children.add(child);
      }
    }

    notifyListeners();
  }

  ContainerNode? _findParentWithAxisRecursively(
    LayoutAxis axis, {
    required LayoutNode node,
  }) {
    if (node is ContainerNode && node.axis == axis) {
      return node;
    }
    if (node.parent == null) {
      return null;
    }

    return _findParentWithAxisRecursively(axis, node: node.parent!);
  }

  ContainerNode? _findGrandParentWithAxis(
    LayoutAxis axis, {
    required WindowNode node,
  }) {
    ContainerNode parent = node.parent;

    while (parent.parent != null && parent.parent!.axis != axis) {
      parent = parent.parent!;
    }

    if (parent.parent != null) {
      return parent.parent;
    }

    return null;
  }

  WindowNode? findFirstWindowChild(ContainerNode start) {
    for (final child in start.children) {
      if (child is WindowNode) {
        return child;
      } else if (child is ContainerNode) {
        final found = findFirstWindowChild(child);
        if (found != null) {
          return found;
        }
      }
    }

    return null;
  }

  LayoutNode findNodeClosestToIndex(
    WindowNode node,
    ContainerNode container,
    LayoutDirection direction,
  ) {
    final index = node.parent.children.indexOf(node);

    final children = container.children;
    final len = children.length;

    switch (direction) {
      case LayoutDirection.left:
        return children[(index - 1) % len];
      case LayoutDirection.right:
        return children[(index + 1) % len];
      case LayoutDirection.up:
        return children[(index - 1) % len];
      case LayoutDirection.down:
        return children[(index + 1) % len];
    }
  }

  void _focusWindow({
    required LayoutAxis axis,
    required LayoutDirection direction,
  }) {
    final len = active.parent.children.length;

    final index = active.parent.children.indexWhere(
      (element) => element.id == active.id,
    );
    if (active.parent.parent?.axis == axis &&
        index ==
            switch (direction) {
              LayoutDirection.left => 0,
              LayoutDirection.up => 0,
              LayoutDirection.down => len,
              LayoutDirection.right => len,
            }) {
      final grandParent = _findGrandParentWithAxis(axis, node: active);

      if (grandParent != null) {
        final firstChild = findFirstWindowChild(grandParent);

        if (firstChild != null) {
          active = firstChild;
        }
      }
    } else if (active.parent.axis == axis) {
      final closest = findNodeClosestToIndex(active, active.parent, direction);

      if (closest is WindowNode) {
        active = closest;
      } else {
        final windowInClosest = findFirstWindowChild(closest as ContainerNode);
        if (windowInClosest != null) {
          active = windowInClosest;
        }
      }
    } else {
      final parent = _findParentWithAxisRecursively(axis, node: active);

      if (parent != null) {
        final firstChild = findFirstWindowChild(parent);

        if (firstChild != null) {
          active = firstChild;
        }
      }
    }
  }

  void focusDown() {
    _focusWindow(axis: LayoutAxis.vertical, direction: LayoutDirection.down);
    notifyListeners();
  }

  void focusUp() {
    _focusWindow(axis: LayoutAxis.vertical, direction: LayoutDirection.up);
    notifyListeners();
  }

  void focusLeft() {
    _focusWindow(axis: LayoutAxis.horizontal, direction: LayoutDirection.left);
    notifyListeners();
  }

  void focusRight() {
    _focusWindow(axis: LayoutAxis.horizontal, direction: LayoutDirection.right);
    notifyListeners();
  }
}
