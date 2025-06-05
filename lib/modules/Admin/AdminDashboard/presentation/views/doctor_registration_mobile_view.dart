import 'dart:io';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';

class DoctorRegisterMobile extends StatefulWidget {
  final Map<String, dynamic> userData;
  const DoctorRegisterMobile({super.key, required this.userData});

  @override
  _DoctorRegisterMobileState createState() => _DoctorRegisterMobileState();
}

class _DoctorRegisterMobileState extends State<DoctorRegisterMobile> {
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _doctorEmailController = TextEditingController();
  final TextEditingController _doctorPasswordController =
      TextEditingController();
  final TextEditingController _doctorAddressController =
      TextEditingController();
  final TextEditingController _doctorPhoneController = TextEditingController();
  final TextEditingController _doctorExperienceController =
      TextEditingController();
  final TextEditingController _doctorSpecialityController =
      TextEditingController();
  final TextEditingController _doctorinfoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LinearGradient gradient = const LinearGradient(
    colors: [KDRTColors.darkBlue, KDRTColors.cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  File? _doctorImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(userData: widget.userData),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) => UserAppBar(
            userName: 'Register Doctor',
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorNameController,
                hintText: 'Doctor Name',
                prefixIcon: Icons.person,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorEmailController,
                hintText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$")
                      .hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorPasswordController,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorAddressController,
                hintText: 'Address',
                prefixIcon: Icons.location_on,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorPhoneController,
                hintText: 'Phone',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorExperienceController,
                hintText: 'Experience',
                prefixIcon: Icons.work,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorSpecialityController,
                hintText: 'Speciality',
                prefixIcon: Icons.local_hospital,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _doctorinfoController,
                hintText: 'Information',
                prefixIcon: Icons.medical_information,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpaceLarge,
              GradientButton(
                text: 'Register Doctor',
                onPressed: _registerDoctor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
        child: _doctorImage != null
            ? CircleAvatar(backgroundImage: FileImage(_doctorImage!))
            : const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.camera_alt, color: Colors.black, size: 30),
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _doctorImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerDoctor() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;
      if (_doctorImage != null) {
        imageUrl = await _uploadImageToStorage(_doctorImage!);
      }

      try {
        final authResponse = await Supabase.instance.client.auth.signUp(
          email: _doctorEmailController.text.trim(),
          password: _doctorPasswordController.text.trim(),
        );

        final user = authResponse.user;
        if (user == null) {
          showCustomAlert(context,
              isSuccess: false,
              title: 'Registration Failed',
              description: 'User creation failed.');
          return;
        }

        final doctorData = {
          'doctors_id': user.id,
          'doctors_name': _doctorNameController.text.trim(),
          'doctors_email': _doctorEmailController.text.trim(),
          'doctors_password': _doctorPasswordController.text.trim(),
          'doctors_address': _doctorAddressController.text.trim(),
          'doctors_phone': _doctorPhoneController.text.trim(),
          'doctors_experience': _doctorExperienceController.text.trim(),
          'doctors_speciality': _doctorSpecialityController.text.trim(),
          'doctors_info': _doctorinfoController.text.trim(),
          'doctors_img': imageUrl,
        };

        await Supabase.instance.client.from('doctors').insert(doctorData);

        showCustomAlert(
          context,
          isSuccess: true,
          title: 'Success',
          description: 'Doctor Registered Successfully!',
          nextScreen: AdminHomeMobileView(userData: widget.userData),
        );
      } catch (e) {
        showCustomAlert(context,
            isSuccess: false, title: 'Error', description: e.toString());
      }
    }
  }

  Future<String?> _uploadImageToStorage(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final fileName =
          'doctor_img/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await Supabase.instance.client.storage
          .from('doctors-images')
          .uploadBinary(fileName, bytes);

      if (response.isEmpty) throw Exception('Image upload failed.');

      return Supabase.instance.client.storage
          .from('doctors-images')
          .getPublicUrl(fileName);
    } catch (e) {
      print("Upload error: $e");
      return null;
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
        borderRadius: BorderRadius.circular(10),
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
          decoration: InputDecoration(
            hintText: hintText,
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
}
