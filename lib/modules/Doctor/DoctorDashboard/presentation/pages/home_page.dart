import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class DoctorHomePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DoctorHomePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: DoctorHomeMobileView(userData: userData),
      desktop: DoctorHomeDesktopView(userData: userData),
    );
  }
}
