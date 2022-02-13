import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  final tween = Tween(
    begin: const Offset(1, 0),
    end: Offset.zero,
  );

  CustomRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == "/") {
      return child;
    }
    return SlideTransition(
      child: child,
      position: animation.drive(tween),
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  final tween = Tween(
    begin: const Offset(1, 0),
    end: Offset.zero,
  );

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == "/") {
      return child;
    }
    return SlideTransition(
      child: child,
      position: animation.drive(tween),
    );
  }
}
