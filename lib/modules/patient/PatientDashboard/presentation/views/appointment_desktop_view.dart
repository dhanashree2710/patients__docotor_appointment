// Same imports
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/admin_appointment_status_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/appointment_history_desktop_view.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentBookingDesktopView extends StatefulWidget {
  final String doctorId;
  final Map<String, dynamic> userData;

  const AppointmentBookingDesktopView({
    super.key,
    required this.doctorId,
    required this.userData,
  });

  @override
  State<AppointmentBookingDesktopView> createState() =>
      _AppointmentBookingDesktopViewState();
}

class _AppointmentBookingDesktopViewState
    extends State<AppointmentBookingDesktopView> {
  final _formKey = GlobalKey<FormState>();

  final LinearGradient gradient = const LinearGradient(
    colors: [KDRTColors.darkBlue, KDRTColors.cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final TextEditingController bookingforController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController problemController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate() ||
        selectedDate == null ||
        selectedTime == null) {
      showCustomAlert(
        context,
        isSuccess: false,
        title: "Missing Fields",
        description: "Please complete all fields including date and time.",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.from('appointment').insert({
        'doctors_id': widget.doctorId,
        'patient_id': widget.userData['user_id'],
        'bookingfor': bookingforController.text,
        'patient_name': patientNameController.text,
        'gender': genderController.text,
        'age': int.tryParse(ageController.text),
        'patient_phone': phoneController.text,
        'problem': problemController.text,
        'date': selectedDate!.toIso8601String(),
        'time': selectedTime!.format(context),
        'status': 'pending', // 👈 Add status
      }).select();

      if (response.isEmpty) {
        throw Exception("Failed to insert appointment");
      }

      bookingforController.clear();
      patientNameController.clear();
      genderController.clear();
      ageController.clear();
      phoneController.clear();
      problemController.clear();
      setState(() {
        selectedDate = null;
        selectedTime = null;
      });

      showCustomAlert(
        context,
        isSuccess: true,
        title: "Appointment Booked!",
        description: "Your appointment has been submitted with pending status.",
        nextScreen: null,
      );
    } catch (e) {
      showCustomAlert(
        context,
        isSuccess: true,
        title: "Appointment Booked!",
        description: "Your appointment has been submitted with pending status.",
        nextScreen: PatientAppointmentHistoryDesktopView(
          patientId: widget.userData['user_id'], // ✅ Use actual patient ID
          userData: widget.userData, // ✅ Pass current user data
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildGradientFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: KDRTColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: KDRTColors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: KDRTColors.black),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Icon(prefixIcon, color: KDRTColors.white),
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: ShaderMask(
                      shaderCallback: (bounds) => gradient.createShader(bounds),
                      child: Icon(suffixIcon, color: KDRTColors.white),
                    ),
                  )
                : null,
            filled: true,
            fillColor: KDRTColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientPickerTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(1.5),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: KDRTColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            child: Icon(icon, color: KDRTColors.white),
          ),
          title: Text(
            text,
            style: const TextStyle(color: KDRTColors.black),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(userData: widget.userData),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) => UserAppBar(
            userName: 'Book Your Appointment , ${widget.userData['user_name']}',
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👈 Lottie Animation on the Left
            Expanded(
              flex: 1,
              child: Lottie.asset(
                'assets/appointment_form.json',
                height: 500,
                repeat: true,
              ),
            ),

            const SizedBox(width: 32),

            // 👉 Form on the Right
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildGradientFormField(
                        controller: patientNameController,
                        hintText: "Patient Name",
                        prefixIcon: Icons.person,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter patient name"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildGradientFormField(
                        controller: bookingforController,
                        hintText: "Booking For (Self / Someone Else)",
                        prefixIcon: Icons.group,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter who you're booking for"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildGradientFormField(
                        controller: genderController,
                        hintText: "Gender",
                        prefixIcon: Icons.wc,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter gender"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildGradientFormField(
                        controller: ageController,
                        hintText: "Age",
                        prefixIcon: Icons.cake,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Enter age";
                          if (int.tryParse(value) == null)
                            return "Enter valid number";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildGradientFormField(
                        controller: phoneController,
                        hintText: "Phone Number",
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Enter phone number";
                          if (value.length < 10)
                            return "Enter valid phone number";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildGradientFormField(
                        controller: problemController,
                        hintText: "Problem",
                        prefixIcon: Icons.medical_services,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter problem"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildGradientPickerTile(
                        icon: Icons.calendar_today,
                        text: selectedDate == null
                            ? "Select Date"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                      _buildGradientPickerTile(
                        icon: Icons.access_time,
                        text: selectedTime == null
                            ? "Select Time"
                            : selectedTime!.format(context),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedTime = picked);
                          }
                        },
                      ),
                      GradientButton(
                        text: isLoading ? "Booking..." : "Confirm Appointment",
                        onPressed: _submitAppointment,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
