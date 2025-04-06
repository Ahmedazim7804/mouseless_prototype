import 'package:flutter/material.dart';
import 'package:mouseless/models/layout_node.dart';

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

  WindowNode? findFirstWindowChild(
    ContainerNode start, {
    bool forward = true,
    int? startWith,
  }) {
    final startIndex = startWith ?? (forward ? 0 : start.children.length - 1);

    if (forward) {
      for (int i = 0; i < start.children.length; i++) {
        final index = (startIndex + i) % start.children.length;
        final child = start.children[index];
        if (child is WindowNode) {
          return child;
        } else if (child is ContainerNode) {
          final found = findFirstWindowChild(child, forward: forward);
          if (found != null) {
            return found;
          }
        }
      }
    } else {
      for (int i = 0; i < start.children.length; i++) {
        final index =
            (startIndex - i + start.children.length) % start.children.length;
        final child = start.children[index];
        if (child is WindowNode) {
          return child;
        } else if (child is ContainerNode) {
          final found = findFirstWindowChild(child, forward: forward);
          if (found != null) {
            return found;
          }
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

    int index = active.parent.children.indexWhere(
      (element) => element.id == active.id,
    );
    final bool forward = switch (direction) {
      LayoutDirection.left => false,
      LayoutDirection.right => true,
      LayoutDirection.up => false,
      LayoutDirection.down => true,
    };

    /*
    CASES
      1. Active's parent's axis is same as the axis in which we are shifting focus
        1.1 Active is not at extreme end of its parent
          SOLUTION => i get the closest node in the direction and set it as active
        1.2 Active is at extreme end of its parent
          SOLUTION => a. if active's parent is root node, return (because we are at the end of the layout)
                      b. find the grand parent with same axis
                      c. if found, move active to the grand parent
                      d. if not found, create a new root with the axis in which we are trying to move, and make the old root a child of the new root
      2. Active's parent's axis is different from the axis in which we are shifting focus
    */

    // CASE 1
    if (active.parent.axis == axis) {
      // CASE 1.1
      if (index !=
          switch (direction) {
            LayoutDirection.left => 0,
            LayoutDirection.up => 0,
            LayoutDirection.down => len - 1,
            LayoutDirection.right => len - 1,
          }) {
        final res = findNodeClosestToIndex(
          active,
          active.parent,
          direction,
          wrap: false,
        );

        if (res.$2 < 0 || res.$2 >= len) {
          return;
        }

        if (res.$1 is WindowNode) {
          active = res.$1 as WindowNode;
        } else {
          final windowInClosest = findFirstWindowChild(res.$1 as ContainerNode);
          if (windowInClosest != null) {
            active = windowInClosest;
          }
        }
      } else {
        // CASE 1.2
        if (active.parent is RootNode) {
          var (closest, closestIndex) = findNodeClosestToIndex(
            active,
            active.parent,
            direction,
            wrap: true,
          );

          while (closest is! WindowNode) {
            final res = findFirstWindowChild(closest as ContainerNode);
            if (res != null) {
              closest = res;
            } else {
              return;
            }
          }

          active = closest;
        } else {
          final grandParent = _findGrandParentWithAxis(axis, node: active);

          if (grandParent != null) {
            final firstChild = findFirstWindowChild(
              grandParent.$1,
              forward: forward,
              startWith: grandParent.$2 + (forward ? 1 : -1),
            );

            if (firstChild != null) {
              active = firstChild;
            }
          }
        }
      }
    } else {
      // CASE 2
      final parentRes = _findGrandParentWithAxis(axis, node: active);

      if (parentRes != null) {
        final firstChild = findFirstWindowChild(
          parentRes.$1,
          forward: forward,
          startWith: parentRes.$2 + (forward ? 1 : -1),
        );

        if (firstChild != null) {
          active = firstChild;
        }
      } else {
        // no parent with same axis found till root
        return;
      }
    }

    // // CASE 1.2
    // if (active.parent.parent?.axis == axis &&
    //     index ==
    //         switch (direction) {
    //           LayoutDirection.left => 0,
    //           LayoutDirection.up => 0,
    //           LayoutDirection.down => len - 1,
    //           LayoutDirection.right => len - 1,
    //         }) {
    //   if (active.parent is RootNode) {
    //     LayoutNode? closest =
    //         findNodeClosestToIndex(
    //           active,
    //           active.parent,
    //           direction,
    //           wrap: true,
    //         ).$1;

    //     while (closest is! WindowNode) {
    //       closest = findFirstWindowChild(closest as ContainerNode);
    //       if (closest == null) {
    //         return;
    //       }
    //     }

    //     active = closest;
    //   } else {
    //     final grandParent = _findGrandParentWithAxis(axis, node: active)?.$1;

    //     if (grandParent != null) {
    //       final firstChild = findFirstWindowChild(grandParent);

    //       if (firstChild != null) {
    //         active = firstChild;
    //       }
    //     }
    //   }
    // } else if (active.parent.axis == axis) {
    //   final closest =
    //       findNodeClosestToIndex(active, active.parent, direction).$1;

    //   if (closest is WindowNode) {
    //     active = closest;
    //   } else {
    //     final windowInClosest = findFirstWindowChild(closest as ContainerNode);
    //     if (windowInClosest != null) {
    //       active = windowInClosest;
    //     }
    //   }
    // } else {
    //   final parent = _findParentWithAxisRecursively(axis, node: active);

    //   if (parent != null) {
    //     final firstChild = findFirstWindowChild(parent);

    //     if (firstChild != null) {
    //       active = firstChild;
    //     }
    //   }
    // }
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
        } else if (current is RootNode) {
          if (current.children.length == 1) {
            final child = current.children.first;

            if (child is ContainerNode) {
              current.children.clear();
              for (var grandChild in child.children) {
                current.children.add(grandChild..parent = current);
              }
            }
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

    final indexChange = switch (direction) {
      LayoutDirection.left => 0,
      LayoutDirection.right => 1,
      LayoutDirection.up => 0,
      LayoutDirection.down => 1,
    };

    /*
     CASES
     1 active's parent has same axis as the axis it is trying to move
       1.1 active is not at extreme end of its parent
         SOLUTION => i get the closest node in the direction and swap with it
       1.2 active is at extreme end of its parent
         SOLUTION => a. if active's parent is root node, return (because we are at the end of the layout)
                     b. find the grand parent with same axis
                     c. if found, move active to the grand parent
                     d. if not found, create a new root with the axis in which we are trying to move, and make the old root a child of the new root
     2. active's parent has different axis than the axis it is trying to move
       SOLUTION => it does not matter if it is at extreme end or not/
                   a. find the grand parent with same axis
                   b. if found, move active to the grand parent
                   c. if not found, create a new root with the axis in which we are trying to move, and make the old root a child of the new root

    */

    // CASE 1.1
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
        res.$1.children.insert(0, active..parent = res.$1 as ContainerNode);
        active = res.$1.children.first as WindowNode;
      } else {
        active.parent.children[index] = res.$1;
        active.parent.children[res.$2] = active;
      }
    } else if (active.parent.axis != axis) {
      // CASE 2
      final parentRes = _findGrandParentWithAxis(axis, node: active);

      if (parentRes != null) {
        _removeNodeFromParent(active);
        parentRes.$1.children.insert(
          parentRes.$2 + indexChange,
          active..parent = parentRes.$1,
        );
        active =
            parentRes.$1.children[parentRes.$2 + indexChange] as WindowNode;
      } else {
        // no parent with same axis found till root
        _removeNodeFromParent(active);
        final root = this.root;
        globalId++;

        final newRoot = RootNode(id: root.id, axis: axis, children: []);

        final newContainerNode = ContainerNode(
          axis: root.axis,
          id: globalId,
          parent: newRoot,
          children: root.children,
        );

        newRoot.children.add(newContainerNode..parent = newRoot);
        newRoot.children.add(active..parent = newRoot);

        active = newRoot.children.last as WindowNode;
      }
    } else {
      // CASE 1.2

      final parent = _findGrandParentWithAxis(axis, node: active);

      if (active.parent is RootNode) {
        return;
      }

      if (parent == null) {
        _removeNodeFromParent(active);
        final root = this.root;
        globalId++;

        final newRoot = RootNode(id: root.id, axis: axis, children: []);

        final newContainerNode = ContainerNode(
          axis: root.axis,
          id: globalId,
          parent: newRoot,
          children: root.children,
        );

        newRoot.children.add(newContainerNode..parent = newRoot);
        newRoot.children.add(active..parent = newRoot);

        active = newRoot.children.last as WindowNode;
        // no parent with same axis found till root
      } else {
        _removeNodeFromParent(active);

        parent.$1.children.insert(
          parent.$2 + indexChange,
          active..parent = parent.$1,
        );

        active = parent.$1.children[parent.$2 + indexChange] as WindowNode;
      }
    }

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
