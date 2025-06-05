import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/appointment_status_mobile_view.dart';
import 'package:flutter/material.dart';

class DoctorHomeMobileView extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DoctorHomeMobileView({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(userData: userData),
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
              child: AppointmentListMobileView(
                doctorId: userData[
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
