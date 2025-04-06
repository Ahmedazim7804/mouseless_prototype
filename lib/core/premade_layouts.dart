import 'package:mouseless/models/layout_node.dart';

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

  static WindowNode get layout1 {
    late final int activeWindowId;
    final layout = RootNode(
      axis: LayoutAxis.vertical,
      children: [
        WindowNode(window: '1', parent: null),
        ContainerNode(
          axis: LayoutAxis.vertical,
          children: [
            WindowNode(window: '2', parent: null),
            WindowNode(window: '3', parent: null),
            ContainerNode(
              axis: LayoutAxis.horizontal,
              id: 6,
              children: [
                WindowNode(
                  window: '4',
                  parent: null,
                  getId: (p0) => activeWindowId = p0,
                ),
                WindowNode(window: '5', parent: null),
                ContainerNode(
                  axis: LayoutAxis.horizontal,
                  id: 9,
                  children: [
                    WindowNode(window: '6', parent: null),
                    ContainerNode(
                      axis: LayoutAxis.vertical,

                      children: [
                        WindowNode(window: '7', parent: null),
                        WindowNode(window: '8', parent: null),
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

    final activateWindow = getWindowById(layout, activeWindowId);

    return activateWindow!;
  }

  static WindowNode get layout2 {
    late final int activeWindowId;
    final layout = RootNode(
      axis: LayoutAxis.horizontal,
      children: [
        ContainerNode(
          axis: LayoutAxis.vertical,
          children: [
            WindowNode(window: '4', parent: null),
            ContainerNode(
              axis: LayoutAxis.vertical,
              children: [
                WindowNode(window: '2', parent: null),
                WindowNode(window: '3', parent: null),
                ContainerNode(
                  axis: LayoutAxis.horizontal,
                  id: 6,
                  children: [
                    WindowNode(window: '5', parent: null),
                    ContainerNode(
                      axis: LayoutAxis.horizontal,
                      id: 9,
                      children: [
                        WindowNode(window: '6', parent: null),
                        ContainerNode(
                          axis: LayoutAxis.vertical,

                          children: [
                            WindowNode(window: '7', parent: null),
                            WindowNode(window: '8', parent: null),
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
          parent: null,
        ),
        WindowNode(
          window: '1',
          parent: null,
          getId: (p0) => activeWindowId = p0,
        ),
      ],
    );

    final activateWindow = getWindowById(layout, activeWindowId);
    print(activateWindow?.window);

    return activateWindow!;
  }
}
