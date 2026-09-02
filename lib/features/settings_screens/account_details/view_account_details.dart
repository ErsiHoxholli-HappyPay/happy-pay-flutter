import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/features/settings_screens/account_details/edit_phone_number_screen.dart';
import 'package:happy_pay_flutter/features/settings_screens/widgets/confirm_modal.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/personal_info_data.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/input_field.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class ViewAccountDetails extends StatefulWidget {
  const ViewAccountDetails({
    super.key,
    required this.primaryLabel,
    required this.onSubmit,
    this.keepPrimaryWhileEditing = false,
  });
  final String primaryLabel;
  final void Function(PersonalInfoData data) onSubmit;
  final bool keepPrimaryWhileEditing;

  @override
  State<ViewAccountDetails> createState() => _ViewAccountDetailsState();
}

class _ViewAccountDetailsState extends State<ViewAccountDetails> {
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

  Widget _buildPrimaryButton() {
    return SizedBox(
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
          widget.onSubmit(data);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(widget.primaryLabel),
      ),
    );
  }

  Widget _buildViewButtons() {
    return Column(
      children: [
        _buildPrimaryButton(),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ConfirmModal.showEditDetails(
              context,
              onConfirm: () => setState(() => _isEditing = true),
            ),

            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButtons() {
    return Column(
      children: [
        if (widget.keepPrimaryWhileEditing) ...[
          _buildPrimaryButton(),
          const SizedBox(height: 8),
        ],
        Row(
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
                onPressed: () {
                  setState(() => _isEditing = false);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditPhoneNumberScreen()),
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
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
          'Account Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

                  AppSubmitButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPhoneNumberScreen(),
                        ),
                      );
                    },
                    label: 'Change Phone Number',
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
