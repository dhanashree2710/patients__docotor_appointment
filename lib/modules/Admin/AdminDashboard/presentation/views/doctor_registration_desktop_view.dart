import 'dart:io';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';

class DoctorRegisterDesktop extends StatefulWidget {
  final Map<String, dynamic> userData;
  DoctorRegisterDesktop({super.key, required this.userData});

  @override
  _DoctorRegisterDesktopState createState() => _DoctorRegisterDesktopState();
}

class _DoctorRegisterDesktopState extends State<DoctorRegisterDesktop> {
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

  XFile? _doctorImage;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _doctorImage = pickedFile;
      });
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      }
    }
  }

  Future<String?> _uploadImageToStorage(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final fileName =
          'doctor_img/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageResponse = await Supabase.instance.client.storage
          .from('doctors-images')
          .uploadBinary(fileName, bytes);

      if (storageResponse.isEmpty) throw Exception('Failed to upload image.');

      final publicUrl = Supabase.instance.client.storage
          .from('doctors-images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  Future<void> _registerDoctor() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;

      if (_doctorImage != null) {
        imageUrl = await _uploadImageToStorage(_doctorImage!);
      }

      final email = _doctorEmailController.text.trim();
      final password = _doctorPasswordController.text.trim();

      try {
        final authResponse = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );

        final user = authResponse.user;
        if (user == null) {
          showCustomAlert(context,
              isSuccess: false,
              title: 'Registration Failed',
              description: 'Could not create user.');
          return;
        }

        final doctorData = {
          'doctors_id': user.id,
          'doctors_name': _doctorNameController.text.trim(),
          'doctors_email': email,
          'doctors_password': password,
          'doctors_address': _doctorAddressController.text.trim(),
          'doctors_phone': _doctorPhoneController.text.trim(),
          'doctors_experience': _doctorExperienceController.text.trim(),
          'doctors_speciality': _doctorSpecialityController.text.trim(),
          'doctors_info': _doctorinfoController.text.trim(),
          'doctors_img': imageUrl,
        };

        final response = await Supabase.instance.client
            .from('doctors')
            .insert(doctorData)
            .select();

        if (response == null) {
          showCustomAlert(context,
              isSuccess: false,
              title: 'Registration Failed',
              description: 'Failed to insert doctor data.');
        } else {
          showCustomAlert(
            context,
            isSuccess: true,
            title: 'Success',
            description: 'Doctor Registered Successfully!',
            nextScreen: AdminHomeDesktopView(userData: widget.userData),
          );
        }
      } catch (e) {
        showCustomAlert(context,
            isSuccess: false, title: 'Error', description: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(
          userData: widget.userData), // Optional: if you have a drawer
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelpers.verticalSpaceMedium,
                    _buildImagePicker(),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorNameController,
                      hintText: 'Enter Doctor Name',
                      prefixIcon: Icons.person,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Doctor name is required'
                          : null,
                    ),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorEmailController,
                      hintText: 'Enter Doctor Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email is required';
                        if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorPasswordController,
                      hintText: 'Enter Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password is required'
                          : null,
                    ),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorAddressController,
                      hintText: 'Enter Doctor Address',
                      prefixIcon: Icons.location_on,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Address is required'
                          : null,
                    ),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorPhoneController,
                      hintText: 'Enter Doctor Phone',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Phone is required'
                          : null,
                    ),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorExperienceController,
                      hintText: 'Enter Doctor Experience',
                      prefixIcon: Icons.work,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Experience is required'
                          : null,
                    ),
                    UIHelpers.verticalSpaceMedium,
                    _buildGradientFormField(
                      controller: _doctorSpecialityController,
                      hintText: 'Enter Doctor Speciality',
                      prefixIcon: Icons.local_hospital,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Speciality is required'
                          : null,
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
                    UIHelpers.verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 5, color: Colors.transparent),
            gradient: gradient,
          ),
          child: _doctorImage != null
              ? (kIsWeb
                  ? CircleAvatar(
                      backgroundImage: _webImageBytes != null
                          ? MemoryImage(_webImageBytes!)
                          : null,
                    )
                  : CircleAvatar(
                      backgroundImage:
                          Image.file(File(_doctorImage!.path)).image,
                    ))
              : const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
        ),
      ),
    );
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
}
