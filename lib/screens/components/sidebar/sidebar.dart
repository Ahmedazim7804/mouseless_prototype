import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouseless/screens/components/app_logo.dart';
import 'package:mouseless/screens/components/sidebar/sidebar_items.dart';
import 'package:showcaseview/showcaseview.dart';

GlobalKey grabShowcaseKey = GlobalKey();
GlobalKey unGrabShowcaseKey = GlobalKey();

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
          Showcase.withWidget(
            key: grabShowcaseKey,
            height: double.infinity,
            width: 256,
            tooltipPosition: TooltipPosition.top,
            container: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff121212),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Press this key to grab the keyboard for the app, so that keyboard shortcuts do not interfere with i3wm.\n\n Note that the other apps will not be able to use the keyboard until you ungrab it.",
              ),
            ),
            child: Container(
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
          ),
          SizedBox(height: 16),
          Showcase.withWidget(
            key: unGrabShowcaseKey,
            height: double.infinity,
            width: 256,
            tooltipPosition: TooltipPosition.top,
            container: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff121212),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Press this button to ungrab keyboard, so that other apps can use the keyboard again.",
              ),
            ),
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
