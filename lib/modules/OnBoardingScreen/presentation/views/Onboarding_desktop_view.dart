import 'package:doctors_appointment_application/modules/Login/presentation/views/login_desktop_view.dart';
import 'package:doctors_appointment_application/utils/common/custom_button.dart';
import 'package:doctors_appointment_application/utils/components/kdrt_typography.dart';
import 'package:flutter/material.dart';

class OnboardingDesktopView extends StatefulWidget {
  const OnboardingDesktopView({super.key});

  @override
  State<OnboardingDesktopView> createState() => _OnboardingDesktopViewState();
}

class _OnboardingDesktopViewState extends State<OnboardingDesktopView> {
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
        MaterialPageRoute(builder: (context) => const LoginDesktopView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 2000 ? 900.0 : width * 0.9;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Container(
          width: cardWidth,
          height: 500,
          padding: const EdgeInsets.all(30),
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
    return Row(
      children: [
        // Left: Text and Button
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearGradientText(
                text: title,
                textStyle: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 400,
                  child: GradientButton(
                    text: currentPage == 1 ? 'Get Started' : 'Next',
                    onPressed: nextPage,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 30),

        // Right: Image
        Expanded(
          child: Center(
            child: Image.network(
              imageUrl,
              width: 550,
              height: 550,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
