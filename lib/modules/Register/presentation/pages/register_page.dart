import 'package:doctors_appointment_application/modules/Register/presentation/views/register_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Register/presentation/views/register_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';

import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: RegisterMobileView(),
      desktop: RegisterDesktopView(),
    );
  }
}
