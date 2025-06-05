import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/appointment_desktop_view.dart';
import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/appointment_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class AppointmentBookingPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  const AppointmentBookingPage({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AppointmentBookingMobileView(
        userData: userData,
        doctorId: '',
      ),
      desktop: AppointmentBookingDesktopView(
        userData: userData,
        doctorId: '',
      ),
    );
  }
}
