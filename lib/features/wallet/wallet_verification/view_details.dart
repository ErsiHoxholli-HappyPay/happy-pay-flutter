import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/father_name_job_info.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/personal_info_data.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/input_field.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final _user = AppSession.currentUser;
  bool _isEditing = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _genderController;
  late final TextEditingController _birthDayController;
  late final TextEditingController _birthMonthController;
  late final TextEditingController _birthYearController;
  late final TextEditingController _phoneCodeController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  final _cityController = TextEditingController();
  final _roadController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _postalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final nameParts = (_user?.name ?? '').split(' ');
    _firstNameController = TextEditingController(text: nameParts.first);
    _lastNameController = TextEditingController(
      text: nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : (_user?.lastName ?? ''),
    );
    _genderController = TextEditingController(text: _user?.gender ?? '');

    final dateParts = (_user?.birthDate ?? '--').split('-');
    _birthDayController = TextEditingController(
      text: dateParts.length == 3 ? dateParts[2] : '',
    );
    _birthMonthController = TextEditingController(
      text: dateParts.length == 3 ? dateParts[1] : '',
    );
    _birthYearController = TextEditingController(
      text: dateParts.length == 3 ? dateParts[0] : '',
    );

    final phoneParts = (_user?.phoneNumber ?? '').split(' ');
    _phoneCodeController = TextEditingController(text: phoneParts.first);
    _phoneNumberController = TextEditingController(
      text: phoneParts.length > 1 ? phoneParts.sublist(1).join(' ') : '',
    );

    _emailController = TextEditingController(text: _user?.email ?? '');
  }

  @override
  void dispose() {
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

  Widget _buildViewButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final data = PersonalInfoData(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                gender: _genderController.text,
                birthDay: _birthDayController.text,
                birthMonth: _birthMonthController.text,
                birthYear: _birthYearController.text,
                phoneCode: _phoneCodeController.text,
                phoneNumber: _phoneNumberController.text,
                email: _emailController.text,
                city: _cityController.text,
                road: _roadController.text,
                apartment: _apartmentController.text,
                postal: _postalController.text,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobInformationScreen(personalInfo: data),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Everything's correct"),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() => _isEditing = true),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Edit info'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => setState(() => _isEditing = false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _isEditing = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review your details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please review your details and make sure they match your information',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          readOnly: !_isEditing,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          readOnly: !_isEditing,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _genderController,
                    label: 'Gender',
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Date of Birth',
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
                          readOnly: !_isEditing,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: _birthMonthController,
                          label: '',
                          hintText: 'MM',
                          readOnly: !_isEditing,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: _birthYearController,
                          label: '',
                          hintText: 'YYYY',
                          readOnly: !_isEditing,
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
                          readOnly: !_isEditing,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: _phoneNumberController,
                          label: '',
                          readOnly: !_isEditing,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _emailController,
                    label: 'Email address',
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _cityController,
                    label: 'City',
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _roadController,
                    label: 'Road',
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _apartmentController,
                          label: 'Apartment number',
                          readOnly: !_isEditing,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _postalController,
                          label: 'Postal number',
                          readOnly: !_isEditing,
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
            child: _isEditing ? _buildEditButtons() : _buildViewButtons(),
          ),
        ],
      ),
    );
  }
}
