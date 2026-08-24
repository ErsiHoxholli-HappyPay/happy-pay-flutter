import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/verification_info.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/personal_info_data.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/input_field.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:happy_pay_flutter/widgets/get_started_modal/step_progress_bar.dart';

class ReviewPersonalInfoScreen extends StatefulWidget {
  const ReviewPersonalInfoScreen({
    super.key,
    required this.fatherName,
    required this.employmentStatus,
    required this.personalInfo,
  });

  final String fatherName;
  final String employmentStatus;
  final PersonalInfoData personalInfo;

  @override
  State<ReviewPersonalInfoScreen> createState() =>
      _ReviewPersonalInfoScreenState();
}

class _ReviewPersonalInfoScreenState extends State<ReviewPersonalInfoScreen> {
  bool _isSubmitting = false;

  late final TextEditingController _fatherNameController;
  late final TextEditingController _employmentController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _genderController;
  late final TextEditingController _birthDayController;
  late final TextEditingController _birthMonthController;
  late final TextEditingController _birthYearController;
  late final TextEditingController _phoneCodeController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;
  late final TextEditingController _roadController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _postalController;

  @override
  void initState() {
    super.initState();
    final info = widget.personalInfo;
    _fatherNameController = TextEditingController(text: widget.fatherName);
    _employmentController = TextEditingController(
      text: widget.employmentStatus,
    );
    _firstNameController = TextEditingController(text: info.firstName);
    _lastNameController = TextEditingController(text: info.lastName);
    _genderController = TextEditingController(text: info.gender);
    _birthDayController = TextEditingController(text: info.birthDay);
    _birthMonthController = TextEditingController(text: info.birthMonth);
    _birthYearController = TextEditingController(text: info.birthYear);
    _phoneCodeController = TextEditingController(text: info.phoneCode);
    _phoneNumberController = TextEditingController(text: info.phoneNumber);
    _emailController = TextEditingController(text: info.email);
    _cityController = TextEditingController(text: info.city);
    _roadController = TextEditingController(text: info.road);
    _apartmentController = TextEditingController(text: info.apartment);
    _postalController = TextEditingController(text: info.postal);
  }

  @override
  void dispose() {
    _fatherNameController.dispose();
    _employmentController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _birthDayController.dispose();
    _birthMonthController.dispose();
    _birthYearController.dispose();
    _phoneCodeController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _roadController.dispose();
    _apartmentController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VerificationInfo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: FractionallySizedBox(
          widthFactor: 0.5,
          child: StepProgressBar(
            stepFills: const [0.5],
            color: const Color.fromARGB(255, 216, 10, 10),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review your personal information',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To continue, please confirm your personal information. Make sure it matches your government-issued ID, which you\'ll need to provide in the next steps.',
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _fatherNameController,
                    label: '',
                    hintText: "Father's First Name",
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _employmentController,
                    label: '',
                    hintText: 'Employment Status',
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Required for compliance with financial regulations.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _firstNameController,
                          label: 'First name',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _lastNameController,
                          label: 'Last name',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _genderController,
                    label: 'Gender',
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Date of birth',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _birthDayController,
                          label: '',
                          hintText: 'DD',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: _birthMonthController,
                          label: '',
                          hintText: 'Month',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: _birthYearController,
                          label: '',
                          hintText: 'Year',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Phone number',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: AppTextField(
                          controller: _phoneCodeController,
                          label: '',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: _phoneNumberController,
                          label: '',
                          hintText: 'Phone number',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _emailController,
                    label: 'Email address (Optional)',
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _cityController,
                    label: 'City',
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _roadController,
                    label: 'Road',
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _apartmentController,
                          label: 'Apartment number',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _postalController,
                          label: 'Postal code',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSubmitButton(
              label: 'Continue',
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
