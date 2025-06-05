import 'package:doctors_appointment_application/modules/Login/presentation/views/login_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Register/data/models/user_model.dart';
import 'package:doctors_appointment_application/services/supabase_service.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RegisterDesktopView extends StatefulWidget {
  @override
  _RegisterDesktopViewState createState() => _RegisterDesktopViewState();
}

class _RegisterDesktopViewState extends State<RegisterDesktopView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<String> _roles = ['admin', 'doctor', 'patient'];
  String _selectedRole = 'patient';

  bool _obscurePassword = true;

  static const LinearGradient gradientColor = LinearGradient(
    colors: [KDRTColors.darkBlue, KDRTColors.cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Future<void> _addUser(Map<String, dynamic> userData) async {
    final service = SupabaseService();
    await service.addUser(userData); // make sure this method exists
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isNarrow = screenWidth < 900;

    return Scaffold(
      backgroundColor: KDRTColors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(18),
          width: screenWidth * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: KDRTColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                blurRadius: 20,
                color: KDRTColors.cyan,
              )
            ],
          ),
          child: isNarrow
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildImage(context, screenHeight),
                      UIHelpers.verticalSpaceMedium,
                      _buildFormContent(maxWidth: 600),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/register.jpg',
                          fit: BoxFit.cover,
                          height: screenHeight * 0.8,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: _buildFormContent(maxWidth: 500),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, double height) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/register.jpg',
          fit: BoxFit.contain,
          height: height * 0.5,
        ),
      ),
    );
  }

  Widget _buildFormContent({double? maxWidth}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 500),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => gradientColor.createShader(bounds),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: KDRTColors.white,
                  ),
                ),
              ),
              UIHelpers.verticalSpaceMedium,
              _buildGradientFormField(
                controller: _nameController,
                label: 'Name',
                hintText: 'Enter your Name',
                prefixIcon: Icons.person,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              UIHelpers.verticalSpaceSmallRegular,
              _buildGradientFormField(
                controller: _emailController,
                label: 'Email',
                hintText: 'example@gmail.com',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              UIHelpers.verticalSpaceSmallRegular,
              _buildGradientFormField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Enter your Password',
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon:
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                onSuffixTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              UIHelpers.verticalSpaceSmallRegular,

              // Role Dropdown
              Container(
                decoration: BoxDecoration(
                  gradient: gradientColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(1.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: KDRTColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'patient',
                        child: Text('Patient'),
                      ),
                      DropdownMenuItem(
                        value: 'doctor',
                        child: Text('Doctor'),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text('Admin'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Select Role',
                      hintStyle: const TextStyle(color: KDRTColors.grey),
                      prefixIcon: ShaderMask(
                        shaderCallback: (bounds) =>
                            gradientColor.createShader(bounds),
                        child: const Icon(
                          Icons.account_circle,
                          color: KDRTColors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: KDRTColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              UIHelpers.verticalSpaceMedium,
              GradientButton(
                  text: "Sign Up",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final response = await SupabaseService().signUpUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                          _selectedRole,
                        );

                        if (response != null) {
                          showCustomAlert(
                            context,
                            isSuccess: true,
                            title: 'Success',
                            description: 'Account created successfully!',
                            nextScreen: LoginDesktopView(),
                          );
                        } else {
                          showCustomAlert(context,
                              isSuccess: false,
                              title: 'Signup Failed',
                              description:
                                  'Email may already be in use or not confirmed.');
                        }
                      } catch (e) {
                        showCustomAlert(context,
                            isSuccess: false,
                            title: 'Error',
                            description: e.toString());
                      }
                    }
                  }),

              UIHelpers.verticalSpaceSmallRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginDesktopView()),
                      );
                    },
                    child: LinearGradientText(
                        text: "Sign In",
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // Skip the color here
                        ),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
              UIHelpers.verticalSpaceSmallRegular,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    FormFieldValidator<String>? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradientColor,
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
            hintStyle: const TextStyle(color: KDRTColors.grey),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => gradientColor.createShader(bounds),
              child: Icon(
                prefixIcon,
                color: KDRTColors.white,
              ),
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          gradientColor.createShader(bounds),
                      child: Icon(
                        suffixIcon,
                        color: KDRTColors.white,
                      ),
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
