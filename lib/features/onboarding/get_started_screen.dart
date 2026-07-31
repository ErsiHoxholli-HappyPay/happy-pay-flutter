import 'package:flutter/material.dart';
import 'package:happ_pay_flutter/widgets/get_started_modal/get_started_modal.dart';
import 'package:happ_pay_flutter/features/onboarding/phone_number_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showOnboarding());
  }

  void _goToPhone() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PhoneNumberScreen()),
    );
  }

  void _showOnboarding() {
    showOnboardingSheet(
      context,
      onSkip: _goToPhone,
      onComplete: _goToPhone,
      steps: const [
        OnboardingStepData(
          eyebrow: 'LOYALTY',
          title:
              'Lots of points, lots of personalized benefits. One reward program.',
        ),
        OnboardingStepData(
          eyebrow: 'Wallet',
          title:
              'Securely store, send, and receive money.\nSimplified and smarter.',
        ),
        OnboardingStepData(
          eyebrow: 'Loans',
          title: 'Flexible repayment options. Borrow now, pay later with ease.',
          primaryLabel: 'Get Started',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
