import 'package:doctors_appointment_application/modules/Login/presentation/views/login_mobile_view.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:flutter/material.dart';

class OnboardingMobileView extends StatefulWidget {
  const OnboardingMobileView({super.key});

  @override
  State<OnboardingMobileView> createState() => _OnboardingMobileViewState();
}

class _OnboardingMobileViewState extends State<OnboardingMobileView> {
  final PageController _controller = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginMobileView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Container(
          width: width * 0.9, // Responsive width
          height: height * 0.85, // Responsive height, 70% of screen height
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
          ),
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            children: [
              buildOnboardingPage(
                title: 'Find Trusted Doctors',
                description:
                    'Discover qualified and experienced healthcare professionals at your fingertips. Book appointments with ease and confidence.',
                imageUrl:
                    'https://ejahiztsxmwwqdmbquzt.supabase.co/storage/v1/object/sign/doctors-images/o1.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InN0b3JhZ2UtdXJsLXNpZ25pbmcta2V5XzhiY2ZlYjQzLThlMzUtNGYxMC1hOGQyLTA2Mzg4NGI0YTQyZiJ9.eyJ1cmwiOiJkb2N0b3JzLWltYWdlcy9vMS5wbmciLCJpYXQiOjE3NDg0MjU1OTAsImV4cCI6MTkwNjEwNTU5MH0.hhYmqyeJv45ekEmdV8HVGzWHBp39G1B0yOOuwjauaqo',
              ),
              buildOnboardingPage(
                title: 'Your Health, Our Priority',
                description:
                    'Get personalized care from the best doctors. Consult online or in person, anytime, anywhere. Your well-being matters to us.',
                imageUrl:
                    'https://ejahiztsxmwwqdmbquzt.supabase.co/storage/v1/object/sign/doctors-images/o2.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InN0b3JhZ2UtdXJsLXNpZ25pbmcta2V5XzhiY2ZlYjQzLThlMzUtNGYxMC1hOGQyLTA2Mzg4NGI0YTQyZiJ9.eyJ1cmwiOiJkb2N0b3JzLWltYWdlcy9vMi5wbmciLCJpYXQiOjE3NDg0MjU2NjgsImV4cCI6MTkwNjEwNTY2OH0.gafdG50TmEyM0-05nR08E47xOr6vDUktOFSF-Db9MXM',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOnboardingPage({
    required String title,
    required String description,
    required String imageUrl,
  }) {
    final width = MediaQuery.of(context).size.width;
    final textStyle = TextStyle(
      fontSize: width > 600 ? 24 : 20, // Adjust font size based on screen width
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top: Image
        Image.network(
          imageUrl,
          width: width * 0.8, // Adjust image size based on screen width
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),

        // Middle: Text
        LinearGradientText(
          text: title,
          textStyle: textStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Text(
          description,
          style: TextStyle(
            fontSize: width > 600 ? 16 : 14, // Smaller text for smaller screens
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Bottom: Button
        GradientButton(
          text: currentPage == 1 ? 'Get Started' : 'Next',
          onPressed: nextPage,
        ),
      ],
    );
  }
}
