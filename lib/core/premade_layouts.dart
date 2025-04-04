import 'package:mouseless/models/window.dart';

class PremadeLayouts {
  static WindowNode? getWindowById(LayoutNode? node, int id) {
    if (node == null) {
      return null;
    }

    if (node is WindowNode && node.id == id) {
      return node;
    }

    for (final child in node.children) {
      final foundNode = getWindowById(child, id);
      if (foundNode != null) {
        return foundNode;
      }
    }

    return null;
  }

  static (RootNode, WindowNode) get layout1 {
    final layout = RootNode(
      id: 1,
      axis: LayoutAxis.vertical,
      children: [
        WindowNode(window: '1', id: 2, parent: null),
        ContainerNode(
          axis: LayoutAxis.vertical,
          id: 3,
          children: [
            WindowNode(window: '2', id: 4, parent: null),
            WindowNode(window: '3', id: 5, parent: null),
            ContainerNode(
              axis: LayoutAxis.horizontal,
              id: 6,
              children: [
                WindowNode(window: '4', id: 7, parent: null),
                WindowNode(window: '5', id: 8, parent: null),
                ContainerNode(
                  axis: LayoutAxis.horizontal,
                  id: 9,
                  children: [
                    WindowNode(window: '6', id: 10, parent: null),
                    ContainerNode(
                      axis: LayoutAxis.vertical,
                      id: 11,
                      children: [
                        WindowNode(window: '7', id: 12, parent: null),
                        WindowNode(window: '8', id: 13, parent: null),
                      ],
                      parent: null,
                    ),
                  ],
                  parent: null,
                ),
              ],
              parent: null,
            ),
          ],
          parent: null,
        ),
      ],
    );

    final activateWindow = getWindowById(layout, 7);

    return (layout, activateWindow!);
  }
}
