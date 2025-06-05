import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/modules/Register/presentation/views/register_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Register/presentation/views/register_mobile_view.dart';

import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/views/home_mobile_view.dart';
import 'package:doctors_appointment_application/services/supabase_service.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginMobileView extends StatefulWidget {
  const LoginMobileView({super.key});

  @override
  State<LoginMobileView> createState() => _LoginMobileViewState();
}

class _LoginMobileViewState extends State<LoginMobileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final LinearGradient gradient = const LinearGradient(
    colors: [KDRTColors.darkBlue, KDRTColors.cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KDRTColors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KDRTColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: KDRTColors.cyan,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImage(context),
                UIHelpers.verticalSpaceLargePlus,
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/login.jpg',
          fit: BoxFit.contain,
          width: screenWidth * 0.7, // Image takes 70% of the screen width
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LinearGradientText(
              text: "Sign In",
              textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center),
          UIHelpers.verticalSpaceSmall,
          const Text(
            "Hi! Welcome back",
            style: TextStyle(fontSize: 20, color: KDRTColors.black),
          ),
          UIHelpers.verticalSpaceMedium,
          _buildGradientFormField(
            controller: _emailController,
            hintText: "Email",
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          UIHelpers.verticalSpaceSmallRegular,
          _buildGradientFormField(
            controller: _passwordController,
            hintText: "Password",
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword,
            suffixIcon:
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
            onSuffixTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          UIHelpers.verticalSpaceTiny,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                // );
              },
              child: LinearGradientText(
                  text: "Forget Password",
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // Skip the color here
                  ),
                  textAlign: TextAlign.center),
            ),
          ),
          UIHelpers.verticalSpaceSmallRegular,
          _isLoading
              ? const CircularProgressIndicator()
              : GradientButton(
                  text: "Sign In",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      try {
                        final service = SupabaseService();
                        final user = await service.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (user != null) {
                          final role = user['role'];
                          if (role == 'patient') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PatientHomeMobileView(userData: user),
                              ),
                            );
                          } else if (role == 'doctor') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DoctorHomeMobileView(userData: user),
                              ),
                            );
                          } else if (role == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminHomeMobileView(userData: user),
                              ),
                            );
                          } else {
                            showCustomAlert(
                              context,
                              isSuccess: false,
                              title: "Error",
                              description: "Invalid user role.",
                            );
                          }
                        } else {
                          showCustomAlert(
                            context,
                            isSuccess: false,
                            title: "Login Failed",
                            description: "User not found.",
                          );
                        }
                      } on AuthException catch (e) {
                        showCustomAlert(
                          context,
                          isSuccess: false,
                          title: "Login Failed",
                          description: e.message ?? "Invalid email or password",
                        );
                      } catch (e) {
                        showCustomAlert(
                          context,
                          isSuccess: false,
                          title: "Error",
                          description: "An unexpected error occurred.",
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                ),
          UIHelpers.verticalSpaceSmallRegular,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Don’t have an account?",
                style: TextStyle(color: KDRTColors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterMobileView(),
                    ),
                  );
                },
                child: LinearGradientText(
                    text: "Sign Up",
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // Skip the color here
                    ),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
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
