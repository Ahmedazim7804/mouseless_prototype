import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mouseless/core/extensions.dart';
import 'package:mouseless/core/router/routes.dart';

class SidebarItemsListWidget extends StatefulWidget {
  const SidebarItemsListWidget({super.key});

  @override
  State<SidebarItemsListWidget> createState() => _SidebarItemsListWidgetState();
}

class _SidebarItemsListWidgetState extends State<SidebarItemsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SidebarItemWidget(
          path: AppRoutes.home.path,
          name: 'Home',
          icon: Icons.keyboard,
        ),
        _SidebarItemWidget(
          path: AppRoutes.userApps.path,
          name: 'User Apps',
          icon: Icons.apps,
        ),
        _SidebarItemWidget(
          path: AppRoutes.stats.path,
          name: 'Stats',
          icon: Icons.bar_chart,
        ),
        _SidebarItemWidget(
          path: AppRoutes.settings.path,
          name: 'Settings',
          icon: Icons.settings,
        ),
      ],
    );
  }
}

class _SidebarItemWidget extends StatelessWidget {
  const _SidebarItemWidget({
    super.key,
    required this.path,
    required this.name,
    required this.icon,
  });

  final IconData icon;
  final String path;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        final selected =
            path ==
            GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

        return InkWell(
          child: Container(
            constraints: BoxConstraints(maxHeight: 64, minHeight: 40),
            padding: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: selected ? const Color(0xff0A0909) : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(icon),
                SizedBox(width: 8),
                Text(name),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: 4,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : null,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
