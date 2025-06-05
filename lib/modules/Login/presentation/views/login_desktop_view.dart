import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/views/home_desktop_view.dart';
import 'package:doctors_appointment_application/modules/Register/presentation/pages/register_page.dart';
import 'package:doctors_appointment_application/modules/Register/presentation/views/register_desktop_view.dart';

import 'package:doctors_appointment_application/modules/patient/PatientDashboard/presentation/pages/home_page.dart';
import 'package:doctors_appointment_application/services/supabase_service.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:doctors_appointment_application/utils/components/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginDesktopView extends StatefulWidget {
  const LoginDesktopView({super.key});

  @override
  State<LoginDesktopView> createState() => _LoginDesktopViewState();
}

class _LoginDesktopViewState extends State<LoginDesktopView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  static const LinearGradient gradientColor = LinearGradient(
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isNarrow = screenWidth < 900;

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
              const BoxShadow(blurRadius: 20, color: KDRTColors.cyan)
            ],
          ),
          child: isNarrow
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildImage(context, screenHeight),
                      UIHelpers.verticalSpaceLargePlus,
                      _buildForm(context),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            'assets/login.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 70),
                    Expanded(child: _buildForm(context)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearGradientText(
              text: "Sign In",
              textStyle: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
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
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
              label: 'Email',
            ),
            UIHelpers.verticalSpaceSmallRegular,
            _buildGradientFormField(
              controller: _passwordController,
              hintText: "Password",
              prefixIcon: Icons.lock,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
              onSuffixTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              label: 'Password',
            ),
            UIHelpers.verticalSpaceSmall,
            Align(
              alignment: Alignment.centerRight,
              child: ShaderMask(
                shaderCallback: (bounds) => gradientColor.createShader(bounds),
                child: TextButton(
                  onPressed: () {
                    //resetPassword(_emailController.text);
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: KDRTColors.white, fontSize: 16),
                  ),
                ),
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
                                      PatientHomePage(userData: user),
                                ),
                              );
                            } else if (role == 'doctor') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DoctorHomeDesktopView(userData: user),
                                ),
                              );
                            } else if (role == 'admin') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AdminHomeDesktopView(userData: user),
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
                            description:
                                e.message ?? "Invalid email or password",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: KDRTColors.black, fontSize: 18),
                ),
                UIHelpers.horizontalSpaceSmallRegular,
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterDesktopView(),
                      ),
                    );
                  },
                  child: LinearGradientText(
                    text: "Sign Up",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
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
          'assets/login.jpg',
          fit: BoxFit.contain,
          height: height * 0.5,
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
