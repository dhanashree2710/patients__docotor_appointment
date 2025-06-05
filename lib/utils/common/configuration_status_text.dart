import 'dart:ui';

import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';

Color? getStatusTextColor(String status) {
  if (status == 'Pending') {
    return KDRTColors.warning;
  } else if (status == 'Confirm') {
    return const Color.fromARGB(255, 52, 150, 3);
  } else if (status == 'Cancel') {
    return KDRTColors.danger;
  }
  return null;
}
