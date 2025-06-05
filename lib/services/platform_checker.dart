// platform_checker.dart
import 'dart:io' show Platform;

class PlatformChecker {
  static bool get isMobile {
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool get isDesktop {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }
}
