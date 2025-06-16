import 'package:doctors_appointment_application/modules/Login/presentation/pages/login_page.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final LinearGradient gradient = const LinearGradient(
    colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _resetPassword() async {
    setState(() => isLoading = true);

    final email = _emailController.text.trim();
    final newPassword = _passwordController.text.trim();

    try {
      final response = await Supabase.instance.client
          .from('users')
          .update({'user_password': newPassword})
          .eq('user_email', email)
          .select();

      if (response.isEmpty) {
        showCustomAlert(
          context,
          isSuccess: false,
          title: 'Error',
          description: 'Email not found. Please check and try again.',
        );
      } else {
        _emailController.clear();
        _passwordController.clear();
        showCustomAlert(
          context,
          isSuccess: true,
          title: 'Success',
          description: 'Password updated successfully!',
          nextScreen: const LoginPage(), // Replace with your login screen
        );
      }
    } catch (e) {
      showCustomAlert(
        context,
        isSuccess: false,
        title: 'Error',
        description: 'Something went wrong: $e',
      );
    } finally {
      setState(() => isLoading = false);
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Icon(prefixIcon, color: Colors.white),
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: ShaderMask(
                      shaderCallback: (bounds) => gradient.createShader(bounds),
                      child: Icon(suffixIcon, color: Colors.white),
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Forgot Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: isDesktop ? 500 : double.infinity,
          padding: const EdgeInsets.all(24),
          margin: isDesktop
              ? const EdgeInsets.symmetric(horizontal: 0)
              : const EdgeInsets.all(12),
          decoration: isDesktop
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                )
              : null,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGradientFormField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || !val.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                _buildGradientFormField(
                  controller: _passwordController,
                  hintText: 'Enter new password',
                  prefixIcon: Icons.lock,
                  suffixIcon:
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                  obscureText: obscurePassword,
                  validator: (val) => val == null || val.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                  onSuffixTap: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
                const SizedBox(height: 24),
                GradientButton(
                  text: "Reset Password",
                  onPressed: _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
