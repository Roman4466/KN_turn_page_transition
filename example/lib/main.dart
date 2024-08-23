import 'package:flutter/material.dart';
import 'package:example/routes.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TurnPageTransition Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const TurnPageTransitionsTheme(
          overleafColor: Colors.grey,
          animationTransitionPoint: 0.5,
        ),
        primarySwatch: Colors.blue,
      ),
      routerConfig: Routes.routerConfig(),
    );
  }
}