import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/pages/doctor_register_page.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/pages/home_page.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/user_doctor_register_role.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/pages/home_page.dart';

import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/appointment_status_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/OnBoardingScreen/presentation/pages/Onboarding_page.dart';

import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/pages/home_page.dart';
import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/appointment_history_desktop_view.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_platform/universal_platform.dart'; // For platform checking
import 'dart:io' show exit;

class UserDrawer extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserDrawer({super.key, required this.userData});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  static const LinearGradient gradientColor = LinearGradient(
    colors: [KDRTColors.darkBlue, KDRTColors.cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final role = widget.userData['role'] ?? 'patient'; // default role

    return Drawer(
      backgroundColor: KDRTColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(size),
          UIHelpers.verticalSpaceMedium,

          //Admin
          if (role == 'admin') ...[
            _buildGradientTile(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          userData: widget.userData,
                        )),
              ),
            ),
            _buildGradientTile(
              icon: Icons.people,
              title: 'Register Doctor',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        DoctorRegisterPage(userData: widget.userData)),
              ),
            ),
            // _buildGradientTile(
            //     icon: Icons.medical_services,
            //     title: 'Patient Records',
            //     onTap: () {}),
            _buildGradientTile(
              icon: Icons.person_add,
              title: 'Register Users/Doctors as role',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CreateUserDesktopScreen(userData: widget.userData)),
              ),
            ),
            _buildGradientTile(
              icon: Icons.event_available,
              title: 'Patients Appointment',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PatientHomePage(userData: widget.userData)),
              ),
            ),
          ]

          //Doctor
          else if (role == 'doctor') ...[
            _buildGradientTile(
              icon: Icons.event,
              title: 'Appointments',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DoctorHomePage(
                          userData: widget.userData,
                        )),
              ),
            ),
            _buildGradientTile(
              icon: Icons.event_available,
              title: 'Book Appointment',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PatientHomePage(userData: widget.userData)),
              ),
            ),
            // _buildGradientTile(
            //     icon: Icons.medical_services,
            //     title: 'Patient Records',
            //     onTap: () {}),
          ]

          //Patient
          else if (role == 'patient') ...[
            _buildGradientTile(
              icon: Icons.calendar_today,
              title: 'Book Appointment',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PatientHomePage(userData: widget.userData)),
              ),
            ),
            _buildGradientTile(
              icon: Icons.history,
              title: 'Appointment History',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PatientAppointmentHistoryDesktopView(
                        patientId: widget.userData['user_id'],
                        userData: widget.userData)),
              ),
            ),
          ],
          _buildGradientTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => _showLogoutConfirmation(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: size.height * 0.15,
              width: size.width * 0.4,
              child:
                  Lottie.asset('assets/admin_drawer.json', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: LinearGradientText(
              text: widget.userData['user_name'] ?? '',
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildGradientTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: ShaderMask(
        shaderCallback: (bounds) => gradientColor.createShader(bounds),
        child: Icon(icon, size: 28, color: Colors.white),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 16, color: Colors.black87)),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: KDRTColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/confirmation.json',
                  height: 120, width: 120, fit: BoxFit.contain),
              const SizedBox(height: 16),
              const Text('Are you sure you want to logout?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await Supabase.instance.client.auth.signOut();
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => OnboardingPage()),
                          (route) => false,
                        );

                        if (UniversalPlatform.isDesktop) {
                          exit(0);
                        } else if (UniversalPlatform.isMobile) {
                          SystemNavigator.pop();
                        }
                      } catch (e) {
                        print('Logout error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: KDRTColors.darkBlue,
                    ),
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: KDRTColors.cyan,
                    ),
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
