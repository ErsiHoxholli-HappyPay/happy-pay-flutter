import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/personal_info_data.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/review_personal_info.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/input_field.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/profession_field.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:happy_pay_flutter/widgets/get_started_modal/step_progress_bar.dart';

class JobInformationScreen extends StatefulWidget {
  const JobInformationScreen({super.key, required this.personalInfo});

  final PersonalInfoData personalInfo;

  @override
  State<JobInformationScreen> createState() {
    return _JobInformationScreenState();
  }
}

class _JobInformationScreenState extends State<JobInformationScreen> {
  final _fathernameController = TextEditingController();
  String? _selected;
  String? _profession;
  bool _isSubmitting = false;

  static const _otherLabel = 'Other (please specify)';
  static const List<String> _professions = [
    'Employed',
    'Self-employed',
    'Unemployed',
    'Student',
    'Retired',
    'Homemaker',
    'Freelancer / Consultant',
    'Public Sector Employee',
    'Private Sector Employee',
    'Business Owner',
    'Temporary / Contract Worker',
    'Not Applicable',
    _otherLabel,
  ];

  Future<void> _handleSubmit() async {
    if (_profession == null || _profession!.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPersonalInfoScreen(
          fatherName: _fathernameController.text,
          employmentStatus: _profession!,
          personalInfo: widget.personalInfo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: FractionallySizedBox(
          widthFactor: 0.5,
          child: StepProgressBar(
            stepFills: [0.5],
            color: Color.fromARGB(255, 216, 10, 10),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fill in your details'),
            const SizedBox(height: 20),
            Text(
              'To help us verify your identity and meet legal requirements, please provide a few additional details. \nYour information is kept secure and used only for verification purposes.',
            ),
            const SizedBox(height: 30),
            AppTextField(
              controller: _fathernameController,
              hintText: 'Father\'s First Name',
              label: '',
            ),
            SizedBox(height: 20),
            AppDropdownField<String>(
              label: '',
              hint: 'Employment Status',
              value: _selected,
              items: _professions,
              itemLabel: (p) => p,
              onChanged: (value) {
                setState(() {
                  _selected = value;
                  _profession = value;
                });
              },
            ),
            Spacer(),
            AppSubmitButton(
              label: 'Continue',
              isLoading: _isSubmitting,
              onPressed: _profession == null ? null : _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
