import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class PatientHomePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  const PatientHomePage({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: PatientHomeMobileView(
        userData: userData,
      ),
      desktop: PatientHomeDesktopView(
        userData: userData,
      ),
    );
  }
}
