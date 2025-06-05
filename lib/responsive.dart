import 'package:flutter/material.dart';

enum ResponsiveSize {
  mobile,
  desktop,
}

class Responsive extends StatelessWidget {
  static double mobileWidth = 475.0;
  static double desktopWidth = 768.0;

  final Widget mobile;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  static bool isMobileSize() => _currentSize == ResponsiveSize.mobile;
  static bool isDesktopSize() => _currentSize == ResponsiveSize.desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < desktopWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopWidth;

  static ResponsiveSize responsiveSize(BuildContext context) {
    if (isMobile(context)) {
      return ResponsiveSize.mobile;
    } else {
      return ResponsiveSize.desktop;
    }
  }

  static ResponsiveSize _currentSize = ResponsiveSize.desktop;

  static void update(BuildContext context) {
    if (isMobile(context)) {
      _currentSize = ResponsiveSize.mobile;
    } else {
      _currentSize = ResponsiveSize.desktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopWidth) {
          return desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}
