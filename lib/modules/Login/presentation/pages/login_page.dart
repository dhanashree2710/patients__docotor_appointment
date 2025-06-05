import 'package:doctors_appointment_application/modules/Login/presentation/views/login_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Login/presentation/views/login_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: LoginMobileView(),
      desktop: LoginDesktopView(),
    );
  }
}
