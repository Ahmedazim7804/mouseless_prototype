import 'package:flutter/material.dart';
import 'package:mouseless/core/router/router.dart';

void main() {
  final goRouter = getRouter();
  runApp(
    MaterialApp.router(
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
  );
}
