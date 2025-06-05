import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  const HomePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AdminHomeMobileView(
        userData: userData,
      ),
      desktop: AdminHomeDesktopView(userData: userData),
    );
  }
}
