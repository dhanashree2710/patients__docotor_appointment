import 'package:doctors_appointment_application/modules/OnBoardingScreen/presentation/views/Onboarding_desktop_view.dart';
import 'package:doctors_appointment_application/modules/OnBoardingScreen/presentation/views/Onboarding_mobile_view.dart';
import 'package:doctors_appointment_application/responsive.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: OnboardingMobileView(),
      desktop: OnboardingDesktopView(),
    );
  }
}
