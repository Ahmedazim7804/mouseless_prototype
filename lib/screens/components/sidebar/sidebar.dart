import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/screens/components/app_logo.dart';
import 'package:mouseless/screens/components/sidebar/sidebar_items.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300, minWidth: 300),
      decoration: BoxDecoration(color: Color(0xff1d1d1d)),
      padding: EdgeInsets.symmetric(vertical: 32),
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          AppLogoWidget(),
          SizedBox(height: 64),
          SidebarItemsListWidget(),
          ElevatedButton(
            onPressed: () async {
              const platform = MethodChannel('com.mouseless.app/pointer');
              await platform.invokeMethod('grabKeyboard');
            },
            child: Text("Grab"),
          ),
          ElevatedButton(
            onPressed: () async {
              const platform = MethodChannel('com.mouseless.app/pointer');
              await platform.invokeMethod('unGrabKeyboard');
            },
            child: Text("Ungrab"),
          ),
        ],
      ),
    );
  }
}
