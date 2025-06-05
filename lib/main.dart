import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/pages/doctor_register_page.dart';
import 'package:doctors_appointment_application/modules/Doctor/DoctorDashboard/presentation/pages/home_page.dart';
import 'package:doctors_appointment_application/modules/OnBoardingScreen/presentation/pages/Onboarding_page.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ejahiztsxmwwqdmbquzt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqYWhpenRzeG13d3FkbWJxdXp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4MDM0OTYsImV4cCI6MjA2MDM3OTQ5Nn0.CSuUO0Y16wHxWr3uVgXaACbZp5iwhf78hvosdQIG2qs',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctors Appointment Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: OnboardingPage(),
      //home: DoctorRegisterPage(),
    );
  }
}
