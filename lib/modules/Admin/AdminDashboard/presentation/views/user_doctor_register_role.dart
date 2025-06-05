import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/utils/common/pop_up_screen.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateUserDesktopScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CreateUserDesktopScreen({super.key, required this.userData});

  @override
  State<CreateUserDesktopScreen> createState() =>
      _CreateUserDesktopScreenState();
}

class _CreateUserDesktopScreenState extends State<CreateUserDesktopScreen> {
  final supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole;
  final List<String> _roles = ['admin', 'doctor', 'patient'];

  final gradient = const LinearGradient(
    colors: [KDRTColors.darkBlue, KDRTColors.cyan],
  );

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
      margin: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildGradientDropdownField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: DropdownButtonFormField<String>(
          value: _selectedRole,
          validator: (value) => value == null ? 'Please select a role' : null,
          decoration: InputDecoration(
            hintText: 'Select Role',
            hintStyle: const TextStyle(color: KDRTColors.black),
            filled: true,
            fillColor: KDRTColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: const Icon(Icons.admin_panel_settings,
                  color: KDRTColors.white),
            ),
          ),
          items: _roles
              .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role.toUpperCase()),
                  ))
              .toList(),
          onChanged: (val) => setState(() => _selectedRole = val),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text.trim();
        final email = _emailController.text.trim();

        String? userIdToInsert;

        if (_selectedRole == 'doctor') {
          // Fetch doctor with same name and email
          final doctorResponse = await supabase
              .from('doctors')
              .select('doctors_id, doctors_name, doctors_email')
              .eq('doctors_name', name)
              .eq('doctors_email', email)
              .maybeSingle();

          if (doctorResponse != null) {
            // If doctor found, use the doctor's id for user
            userIdToInsert = doctorResponse['doctors_id'] as String?;
          } else {
            // No matching doctor found, handle as error or continue with null id
            // Here you can throw or show error if you want
            throw Exception(
                'Doctor with this name and email not found in doctors table.');
          }
        }

        // Prepare the insert data
        final insertData = {
          'user_name': name,
          'user_email': email,
          'user_password': _passwordController.text,
          'role': _selectedRole,
        };

        // If doctor, include id from doctors table
        if (userIdToInsert != null) {
          insertData['user_id'] = userIdToInsert;
        }

        final response =
            await supabase.from('users').insert(insertData).select().single();

        // Show success popup
        showCustomAlert(
          context,
          isSuccess: true,
          title: 'Success',
          description: 'User Registered Successfully!',
          nextScreen: CreateUserDesktopScreen(userData: widget.userData),
        );
      } catch (e) {
        // Show error popup
        showCustomAlert(
          context,
          isSuccess: false,
          title: 'Error',
          description: e.toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(userData: widget.userData),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) {
            return UserAppBar(
              userName: '${widget.userData['user_name']}, Add User',
              onMenuPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth < 700 ? double.infinity : 600.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildGradientFormField(
                        controller: _nameController,
                        hintText: 'Enter Name',
                        prefixIcon: Icons.person,
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter name' : null,
                      ),
                      _buildGradientFormField(
                        controller: _emailController,
                        hintText: 'Enter Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter valid email' : null,
                      ),
                      _buildGradientFormField(
                        controller: _passwordController,
                        hintText: 'Enter Password',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Min 6 characters required'
                            : null,
                      ),
                      _buildGradientDropdownField(),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
