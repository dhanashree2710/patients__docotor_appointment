import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/doctor_registration_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/doctor_registration_mobile_view.dart';

import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class DoctorRegisterPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DoctorRegisterPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: DoctorRegisterMobile(userData: userData),
      desktop: DoctorRegisterDesktop(userData: userData),
    );
  }
}
