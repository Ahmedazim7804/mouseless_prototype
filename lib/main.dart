import 'package:flutter/material.dart';
import 'package:mouseless/core/router/router.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // const platform = MethodChannel('com.mouseless.app/pointer');
  // // final int? gtkWindowAddress = await platform.invokeMethod(
  // //   'getGdkWindowAddress',
  // // );
  // await platform.invokeMethod('hideWindow');
  // await platform.invokeMethod('setRedirectOverride');
  // await platform.invokeMethod('showWindow');

  final goRouter = getRouter();
  runApp(
    ShowCaseWidget(
      builder:
          (context) => MaterialApp.router(
            theme: ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
            ),
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            routeInformationProvider: goRouter.routeInformationProvider,
          ),
    ),
  );
}
