import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/admin_appointment_status_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/admin_appointment_status_mobile_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/appointment_status_desktop_view.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:flutter/material.dart';

class AdminHomeMobileView extends StatelessWidget {
  final Map<String, dynamic> userData;
  const AdminHomeMobileView({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(userData: userData),
      backgroundColor: KDRTColors.white,
      body: Builder(
        builder: (context) => Column(
          children: [
            UserAppBar(
              userName: 'Welcome, ${userData['user_name']}',
              onMenuPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            Expanded(
              child: AdminAppointmentStatusMobileView(
                adminId: userData[
                    'user_id'], // Or pass doctorId if filtering is needed
                userData: userData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
