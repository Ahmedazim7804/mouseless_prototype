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
          Spacer(),
          Container(
            height: 32,
            constraints: BoxConstraints(maxWidth: 128),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xff828282)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () async {
                const platform = MethodChannel('com.mouseless.app/pointer');
                await platform.invokeMethod('grabKeyboard');
              },
              child: Text("Grab", style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 32,
            constraints: BoxConstraints(maxWidth: 128),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xff828282)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () async {
                const platform = MethodChannel('com.mouseless.app/pointer');
                await platform.invokeMethod('unGrabKeyboard');
              },
              child: Text("Ungrab", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
