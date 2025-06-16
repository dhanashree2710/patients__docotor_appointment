// import 'package:doctors_appoitment/modules/Login/presentation/views/login_mobile_view.dart';
// import 'package:flutter/material.dart';

// class ForgotPasswordDesktopView extends StatefulWidget {
//   @override
//   _ForgotPasswordDesktopViewState createState() =>
//       _ForgotPasswordDesktopViewState();
// }

// class _ForgotPasswordDesktopViewState extends State<ForgotPasswordDesktopView> {
//   final _formKey = GlobalKey<FormState>();

//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _emailController = TextEditingController();

//   bool _obscureNew = true;
//   bool _obscureConfirm = true;

  // final LinearGradient gradient = const LinearGradient(
  //   colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     bool isNarrow = screenWidth < 1000;

//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         width: double.infinity,
//         height: double.infinity,
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 1200),
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 20,
//                   color: Colors.grey.withOpacity(0.2),
//                 ),
//               ],
//               color: Colors.white,
//             ),
//             child: isNarrow
//                 ? Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildImage(context, screenHeight),
//                       const SizedBox(height: 32),
//                       _buildForm(context),
//                     ],
//                   )
//                 : Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         flex: 4,
//                         child: _buildImage(context, screenHeight),
//                       ),
//                       const SizedBox(width: 40),
//                       Expanded(
//                         flex: 5,
//                         child: _buildForm(context),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImage(BuildContext context, double height) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Image.asset(
//           'assets/forgot_img.png',
//           fit: BoxFit.contain,
//           height: height * 0.6,
//         ),
//       ),
//     );
//   }

//   Widget _buildForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ShaderMask(
//               shaderCallback: (bounds) => gradient.createShader(bounds),
//               child: const Text(
//                 'New Password',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Your new password must be different\nfrom previously used passwords.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const SizedBox(height: 32),
//             _buildGradientFormField(
//               controller: _emailController,
//               label: 'Email',
//               hintText: 'Enter your email',
//               prefixIcon: Icons.email_outlined,
//               obscureText: false,
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Email is required';
//                 } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                     .hasMatch(value)) {
//                   return 'Enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildGradientFormField(
//               controller: _newPasswordController,
//               label: 'New Password',
//               hintText: 'Enter New Password',
//               prefixIcon: Icons.lock_outline,
//               suffixIcon: _obscureNew ? Icons.visibility_off : Icons.visibility,
//               obscureText: _obscureNew,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'New password is required';
//                 } else if (value.length < 6) {
//                   return 'Password must be at least 6 characters';
//                 }
//                 return null;
//               },
//               onSuffixTap: () => setState(() => _obscureNew = !_obscureNew),
//             ),
//             const SizedBox(height: 16),
//             _buildGradientFormField(
//               controller: _confirmPasswordController,
//               label: 'Confirm Password',
//               hintText: 'Enter Confirm Password',
//               prefixIcon: Icons.lock_outline,
//               suffixIcon:
//                   _obscureConfirm ? Icons.visibility_off : Icons.visibility,
//               obscureText: _obscureConfirm,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please confirm your password';
//                 } else if (value != _newPasswordController.text) {
//                   return 'Passwords do not match';
//                 }
//                 return null;
//               },
//               onSuffixTap: () =>
//                   setState(() => _obscureConfirm = !_obscureConfirm),
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: 180,
//               height: 50,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: gradient,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text("Password updated successfully!")),
//                       );
//                       Future.delayed(
//                         const Duration(seconds: 1),
//                         () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginMobileView()),
//                           );
//                         },
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
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
