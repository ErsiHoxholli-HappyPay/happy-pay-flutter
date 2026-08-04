import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/kyc/terms_and_conditions.dart';
import 'features/splash_screen.dart';
import 'features/onboarding/otp_code.dart';
import 'features/onboarding/home.dart';
import 'features/kyc/complete_profile.dart';
import 'features/kyc/address_details.dart';
import 'features/kyc/happy_documents.dart';
import 'features/kyc/contact_information.dart';
import 'features/kyc/privacy_policy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Pay',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
      routes: {
        '/otp_code': (context) => const OtpCodeScreen(),
        '/home': (context) => const HomeScreen(),

        '/splash_screen': (context) => const SplashScreen(),

        '/kyc': (context) => const CompleteProfileScreen(),
        '/kyc/happy_documents': (context) => const HappyDocumentsScreen(),
        '/kyc/contact_information': (context) =>
            const ContactInformationScreen(),
        '/kyc/address_details': (context) => const AddressDetailsScreen(),
        '/kyc/complete_profile': (context) => const CompleteProfileScreen(),

        '/kyc/terms_and_conditions': (context) =>
            const TermsAndConditionsScreen(),
        '/kyc/privacy_policy': (context) => const PrivacyPolicyScreen(),
      },

      // home: const OffersScreen(),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
    );
  }
}
