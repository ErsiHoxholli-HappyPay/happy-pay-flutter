import 'package:flutter/material.dart';
import 'features/splash_screen.dart';
import 'features/coupons/coupons_screen.dart';
import 'data/coupons.dart';
import 'features/onboarding/get_started_screen.dart';
import 'features/onboarding/phone_number_screen.dart';
import 'features/onboarding/otp_code.dart';
import 'features/onboarding/home.dart';
import 'features/kyc/complete_profile.dart';
import 'features/kyc/contact_information.dart';
import 'features/kyc/address_details.dart';
import 'features/kyc/happy_documents.dart';
import 'features/kyc/terms_and_conditions.dart';
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
      home: CouponsScreen(coupons: coupons),
      routes: {
        '/get_started': (context) => const GetStartedScreen(),
        '/phone_number': (context) => const PhoneNumberScreen(),
        '/otp_code': (context) => const OtpCodeScreen(),
        '/home': (context) => const HomeScreen(),
        '/kyc/complete_profile': (context) => const CompleteProfileScreen(),
        '/kyc/contact_information': (context) =>
            const ContactInformationScreen(),
        '/kyc/address_details': (context) => const AddressDetailsScreen(),
        '/kyc/happy_documents': (context) => const HappyDocumentsScreen(),
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
