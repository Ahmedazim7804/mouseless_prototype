import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';
import 'package:mouseless/models/window.dart';

class I3LayoutController extends ChangeNotifier {
  WindowNode active;

  RootNode get root {
    LayoutNode node = active;
    while (node.parent != null) {
      node = node.parent!;
    }
    return node as RootNode;
  }

  I3LayoutController({required this.active});

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

  (ContainerNode, int)? _findGrandParentWithAxis(
    LayoutAxis axis, {
    required WindowNode node,
  }) {
    ContainerNode parent = node.parent;

    while (parent.parent != null && parent.parent!.axis != axis) {
      parent = parent.parent!;
    }

    if (parent.parent != null) {
      final index = parent.parent!.children.indexWhere(
        (element) => element.id == parent.id,
      );

      return (parent.parent!, index);
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

  (LayoutNode, int) findNodeClosestToIndex(
    WindowNode node,
    ContainerNode container,
    LayoutDirection direction, {
    bool wrap = true,
  }) {
    final index = node.parent.children.indexOf(node);

    final children = container.children;
    final len = children.length;

    late int newIndex;

    switch (direction) {
      case LayoutDirection.left:
        newIndex = (index - 1);
      case LayoutDirection.right:
        newIndex = (index + 1);
      case LayoutDirection.up:
        newIndex = (index - 1);
      case LayoutDirection.down:
        newIndex = (index + 1);
    }

    if (wrap) {
      newIndex = newIndex % len;
    }

    return (children[newIndex], newIndex);
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
      final grandParent = _findGrandParentWithAxis(axis, node: active)?.$1;

      if (grandParent != null) {
        final firstChild = findFirstWindowChild(grandParent);

        if (firstChild != null) {
          active = firstChild;
        }
      }
    } else if (active.parent.axis == axis) {
      final closest =
          findNodeClosestToIndex(active, active.parent, direction).$1;

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

  void _removeNodeFromParent(WindowNode node) {
    final index = node.parent.children.indexWhere(
      (element) => element.id == node.id,
    );

    if (index == -1) {
      return;
    }

    node.parent.children.removeAt(index);
  }

  void _cleanLayout(LayoutNode? node) {
    if (node == null) {
      return;
    }

    bool modifiedInLastIteration = true;

    while (modifiedInLastIteration) {
      modifiedInLastIteration = false;

      List<LayoutNode> stack = [node];
      Set<LayoutNode> visited = {};

      while (stack.isNotEmpty) {
        LayoutNode current = stack.removeLast();

        if (visited.contains(current)) {
          continue;
        }

        bool modified = false;

        if (current is ContainerNode && current is! RootNode) {
          if (current.children.isEmpty) {
            current.parent?.children.remove(current);
            modified = true;
          } else if (current.children.length == 1) {
            current.parent?.children.remove(current);
            current.parent?.children.add(
              current.children.first..parent = current.parent,
            );
            modified = true;
          }
        }

        if (modified) {
          modifiedInLastIteration = true;
          break;
        } else {
          for (int i = current.children.length - 1; i >= 0; i--) {
            if (current.children[i] is ContainerNode) {
              stack.add(current.children[i]);
            }
          }
        }
      }
    }
  }

  void _moveWindow({
    required LayoutAxis axis,
    required LayoutDirection direction,
  }) {
    final len = active.parent.children.length;
    final index = active.parent.children.indexWhere(
      (element) => element.id == active.id,
    );

    // not last child in its parent and parent is horizontal
    if (active.parent.axis == axis &&
        index !=
            switch (direction) {
              LayoutDirection.left => 0,
              LayoutDirection.up => 0,
              LayoutDirection.down => len - 1,
              LayoutDirection.right => len - 1,
            }) {
      final res = findNodeClosestToIndex(active, active.parent, direction);

      if (res.$2 < 0 || res.$2 >= len) {
        return;
      }

      if (res.$1 is ContainerNode) {
        _removeNodeFromParent(active);
        res.$1.children.add(active..parent = res.$1 as ContainerNode);
        active = res.$1.children.last as WindowNode;
      } else {
        active.parent.children[index] = res.$1;
        active.parent.children[res.$2] = active;
      }
    } else {
      final result = _findGrandParentWithAxis(axis, node: active);

      final grandParent = result?.$1;
      final indexOfAncestorContainerActiveWindowParentInGrandParent =
          result?.$2;

      // no parent with same axis found till root, grandparent is the root and has different axis
      if (grandParent == null) {
        globalId++;
        final newContainerNode = ContainerNode(
          axis: axis,
          id: globalId,
          parent: root,
          children: root.children,
        );

        root.children.clear();
        root.children.add(newContainerNode);
        root.children.add(active..parent = newContainerNode);

        active = root.children.last as WindowNode;
      } else {
        final ancestor =
            grandParent
                .children[indexOfAncestorContainerActiveWindowParentInGrandParent!];

        if (ancestor.id == active.parent.id ||
            indexOfAncestorContainerActiveWindowParentInGrandParent ==
                grandParent.children.length - 1) {
          _removeNodeFromParent(active);
          grandParent.children.add(active..parent = grandParent);
          active = grandParent.children.last as WindowNode;
        } else {
          final sibling =
              grandParent
                  .children[indexOfAncestorContainerActiveWindowParentInGrandParent +
                  1];
          final newContainer = ContainerNode(
            axis: axis,
            id: grandParent.children.length,
            parent: grandParent,
            children: [active, sibling],
          );

          grandParent
                  .children[indexOfAncestorContainerActiveWindowParentInGrandParent +
                  1] =
              newContainer;

          active = newContainer.children[0] as WindowNode;
        }
      }
    }

    // last child in its parent or parent is vertical

    _cleanLayout(root);
  }

  void moveRight() {
    _moveWindow(axis: LayoutAxis.horizontal, direction: LayoutDirection.right);
    notifyListeners();
  }

  void moveLeft() {
    _moveWindow(axis: LayoutAxis.horizontal, direction: LayoutDirection.left);
    notifyListeners();
  }

  void moveDown() {
    _moveWindow(axis: LayoutAxis.vertical, direction: LayoutDirection.down);
    notifyListeners();
  }

  void moveUp() {
    _moveWindow(axis: LayoutAxis.vertical, direction: LayoutDirection.up);
    notifyListeners();
  }

  void setNewLayout(LayoutNode activeNode) {
    assert(activeNode is WindowNode);
    active = activeNode as WindowNode;
    notifyListeners();
  }
}
