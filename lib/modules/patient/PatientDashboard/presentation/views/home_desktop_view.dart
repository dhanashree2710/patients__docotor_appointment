import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/appointment_desktop_view.dart';

import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientHomeDesktopView extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PatientHomeDesktopView({super.key, required this.userData});

  @override
  State<PatientHomeDesktopView> createState() => _PatientHomeDesktopViewState();
}

class _PatientHomeDesktopViewState extends State<PatientHomeDesktopView> {
  List<Map<String, dynamic>> doctorList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('doctors').select();

      print(response);
      setState(() {
        doctorList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        doctorList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: UserDrawer(userData: widget.userData),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) => UserAppBar(
            userName: 'Welcome, ${widget.userData['user_name']}',
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth >= 1200;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: doctorList.length == 1
                ? _buildSingleDoctorView(
                    doctorList.first, constraints, isDesktop)
                : _buildMultipleDoctorsView(doctorList, isDesktop),
          );
        },
      ),
    );
  }

  /// SINGLE DOCTOR VIEW (Same as your current design)
  Widget _buildSingleDoctorView(
      Map<String, dynamic> doctor, BoxConstraints constraints, bool isDesktop) {
    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animation
              Expanded(
                flex: 3,
                child: Center(
                  child: Lottie.asset(
                    'assets/appointment.json',
                    height: constraints.maxHeight * 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Doctor Details
              Expanded(
                flex: 2,
                child: _buildDoctorDetailCard(doctor),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/appointment.json',
                  height: 300,
                ),
              ),
              const SizedBox(height: 24),
              _buildDoctorDetailCard(doctor),
            ],
          );
  }

  Widget _buildDoctorDetailCard(Map<String, dynamic> doctor) {
    return Card(
      elevation: 6,
      shadowColor: KDRTColors.cyan,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildDoctorAvatar(doctor['doctors_img'])),
            UIHelpers.verticalSpaceMedium,
            LinearGradientText(
              text: "Dr. ${doctor['doctors_name']}",
              textStyle:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            UIHelpers.verticalSpaceMedium,
            buildInfoRow("Name", "Dr. ${doctor['doctors_name']}"),
            buildInfoRow("Experience", "${doctor['doctors_experience']} years"),
            buildInfoRow(
                "Speciality", "${doctor['doctors_speciality']} Specialist"),
            buildInfoRow("About", "${doctor['doctors_info']}"),
            buildInfoRow("Phone", "${doctor['doctors_phone']}"),
            buildInfoRow("Email", "${doctor['doctors_email']}"),
            buildInfoRow("Address", "${doctor['doctors_address']}"),
            UIHelpers.verticalSpaceLarge,
            Center(
              child: GradientButton(
                text: 'Book Appointment',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentBookingDesktopView(
                        doctorId: doctor['doctors_id'],
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /// MULTIPLE DOCTORS VIEW
  Widget _buildMultipleDoctorsView(
      List<Map<String, dynamic>> doctors, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Centered Animation at the Top
        Center(
          child: Lottie.asset(
            'assets/appointment.json',
            height: 300,
          ),
        ),
        const SizedBox(height: 24),

        // Horizontal Row of Doctor Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: doctors.map((doctor) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: isDesktop ? 550 : 480, // adjust width based on screen
                  child: _buildDoctorDetailCard(doctor),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearGradientText(
            text: "$title : ",
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.left,
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDoctorAvatar(String? imageUrl) {
  return CircleAvatar(
    radius: 60,
    backgroundColor: Colors.grey[200],
    backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
        ? NetworkImage(imageUrl)
        : const AssetImage('assets/dummy.jpg') as ImageProvider,
    onBackgroundImageError: (_, __) {
      debugPrint('❌ Failed to load image: $imageUrl');
    },
  );
}
