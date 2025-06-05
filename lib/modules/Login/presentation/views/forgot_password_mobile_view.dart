// import 'package:doctors_appoitment/modules/Login/presentation/views/login_mobile_view.dart';
// import 'package:flutter/material.dart';

// class ForgotPasswordMobileView extends StatefulWidget {
//   @override
//   _ForgotPasswordMobileViewState createState() =>
//       _ForgotPasswordMobileViewState();
// }

// class _ForgotPasswordMobileViewState extends State<ForgotPasswordMobileView> {
//   final _formKey = GlobalKey<FormState>();

//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _emailController = TextEditingController();

//   bool _obscureNew = true;
//   bool _obscureConfirm = true;

//   final LinearGradient gradient = const LinearGradient(
//     colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 ShaderMask(
//                   shaderCallback: (bounds) => gradient.createShader(
//                     Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                   ),
//                   child: const Text(
//                     'New Password',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Your new password must be different\nfrom previously used passwords.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 32),
//                 _buildGradientFormField(
//                   controller: _emailController,
//                   label: 'Email',
//                   hintText: 'Enter your email',
//                   prefixIcon: Icons.email_outlined,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Email is required';
//                     } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                         .hasMatch(value)) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 _buildGradientFormField(
//                   controller: _newPasswordController,
//                   label: 'New Password',
//                   hintText: 'Enter New Password',
//                   prefixIcon: Icons.lock_outline,
//                   suffixIcon:
//                       _obscureNew ? Icons.visibility_off : Icons.visibility,
//                   obscureText: _obscureNew,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'New password is required';
//                     } else if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                   onSuffixTap: () => setState(() => _obscureNew = !_obscureNew),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildGradientFormField(
//                   controller: _confirmPasswordController,
//                   label: 'Confirm Password',
//                   hintText: 'Enter Confirm Password',
//                   prefixIcon: Icons.lock_outline,
//                   suffixIcon:
//                       _obscureConfirm ? Icons.visibility_off : Icons.visibility,
//                   obscureText: _obscureConfirm,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     } else if (value != _newPasswordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                   onSuffixTap: () =>
//                       setState(() => _obscureConfirm = !_obscureConfirm),
//                 ),
//                 const SizedBox(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 150,
//                       height: 50,
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(
//                           gradient: gradient,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               // Simulate password reset success
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content:
//                                         Text("Password updated successfully!")),
//                               );

//                               Future.delayed(const Duration(seconds: 1), () {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => LoginMobileView()),
//                                 );
//                               });
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           child: const Text(
//                             "Submit",
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGradientFormField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     required IconData prefixIcon,
//     IconData? suffixIcon,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     VoidCallback? onSuffixTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(1.5),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           keyboardType: keyboardType,
//           validator: validator,
//           style: const TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             hintText: hintText,
//             prefixIcon: ShaderMask(
//               shaderCallback: (bounds) => gradient.createShader(bounds),
//               child: Icon(prefixIcon, color: Colors.white),
//             ),
//             suffixIcon: suffixIcon != null
//                 ? GestureDetector(
//                     onTap: onSuffixTap,
//                     child: ShaderMask(
//                       shaderCallback: (bounds) => gradient.createShader(bounds),
//                       child: Icon(suffixIcon, color: Colors.white),
//                     ),
//                   )
//                 : null,
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
