import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mouseless/screens/components/sidebar/sidebar.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xff141414),
      body: Row(
        children: [
          SidebarWidget(),
          // widget.navigationShell,
        ],
      ),
      // bottomNavigationBar: Theme(
      //   data: Theme.of(context).copyWith(
      //     splashColor: Colors.transparent,
      //     splashFactory: NoSplash.splashFactory,
      //   ),
      //   child: BottomNavigationBar(
      //     backgroundColor: Colors.transparent,
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     elevation: 0,
      //     currentIndex: widget.navigationShell.currentIndex,
      //     onTap: (index) {
      //       widget.navigationShell.goBranch(index);
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           'assets/icons/chat_screen.svg',
      //           colorFilter: ColorFilter.mode(
      //             widget.navigationShell.currentIndex == 0
      //                 ? selectedIconColor
      //                 : unselectedIconColor,
      //             BlendMode.srcIn,
      //           ),
      //         ),
      //         label: 'Chat',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           FlowbeeIcons.discover,
      //           colorFilter: ColorFilter.mode(
      //             widget.navigationShell.currentIndex == 1
      //                 ? selectedIconColor
      //                 : unselectedIconColor,
      //             BlendMode.srcIn,
      //           ),
      //         ),
      //         label: 'Discover',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           'assets/icons/sessions_list.svg',
      //           colorFilter: ColorFilter.mode(
      //             widget.navigationShell.currentIndex == 2
      //                 ? selectedIconColor
      //                 : unselectedIconColor,
      //             BlendMode.srcIn,
      //           ),
      //         ),
      //         label: 'Sessions',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
