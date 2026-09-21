import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/api/api_client.dart' show NetworkException;
import 'package:happy_pay_flutter/api/auth_api.dart';
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class HappyDocumentsScreen extends StatefulWidget {
  const HappyDocumentsScreen({super.key});

  @override
  State<HappyDocumentsScreen> createState() => _HappyDocumentsScreenState();
}

class _HappyDocumentsScreenState extends State<HappyDocumentsScreen> {
  bool _acceptsTerms = false;
  bool _acceptsPrivacy = false;
  bool _acknowledges = false;
  bool _submitting = false;
  // Ticking the acknowledgement also ticks the two documents.
  bool get _isComplete => _acknowledges && !_submitting;

  Future<void> _continue() async {
    if (_submitting) return;
    final draft = AppSession.signUpDraft;
    final phone = AppSession.phone;
    final firstName = draft.firstName;
    final lastName = draft.lastName;
    final gender = draft.gender;
    final dateOfBirth = draft.dateOfBirth;
    final street = draft.street;
    final city = draft.city;
    final postCode = draft.postCode;
    if (phone == null ||
        firstName == null ||
        lastName == null ||
        gender == null ||
        dateOfBirth == null ||
        street == null ||
        city == null ||
        postCode == null) {
      _showError('Some details are missing. Please go back and check them.');
      return;
    }

    final member = AppSession.loyaltyMember;
    final qcCode = AppSession.memberPrefill?.qcCode ?? '';

    setState(() => _submitting = true);
    try {
      final created = await createClient(
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        gender: gender.toLowerCase(),
        dateOfBirth: dateOfBirth,
        street: street,
        city: city,
        postCode: postCode,
        email: draft.email,
        qcCode: qcCode,
      );
      if (!mounted) return;
      if (!created) {
        _showError('We could not create your account. Please try again.');
        return;
      }

      // Step 6 again: the member record may exist now that the client does.
      final lookup = await findMember(phone);
      if (!mounted) return;
      final signedInMember = lookup.member ?? member;
      if (signedInMember != null) {
        // TODO(#50): finishSignIn(phone) before going home.
      }

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/home_screen', (_) => false);
    } on NetworkException {
      if (mounted) _showError('No connection. Please try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onTermsChanged(bool value) {
    _acceptsTerms = value;
    _acknowledges = _acceptsTerms && _acceptsPrivacy;
    setState(() {});
  }

  void _onPrivacyChanged(bool value) {
    _acceptsPrivacy = value;
    _acknowledges = _acceptsTerms && _acceptsPrivacy;
    setState(() {});
  }

  void _onAcknowledgesChanged(bool value) {
    _acknowledges = value;
    _acceptsTerms = value;
    _acceptsPrivacy = value;
    setState(() {});
  }

  static final _checkboxStyle = WidgetStateProperty.resolveWith<Color>(
    (states) =>
        states.contains(WidgetState.selected) ? Colors.black : Colors.white,
  );

  static const _checkboxSide = BorderSide(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const AppBackButton(), elevation: 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Review haPPy Documents.',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed('/kyc/terms_and_conditions');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      const Text(
                        'haPPy Terms and Conditions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: _acceptsTerms,
                        onChanged: (v) => _onTermsChanged(v ?? false),
                        fillColor: _checkboxStyle,
                        side: _checkboxSide,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/kyc/privacy_policy');
                  },

                  child: Row(
                    children: [
                      const Text(
                        'haPPy Privacy Policy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: _acceptsPrivacy,
                        onChanged: (v) => _onPrivacyChanged(v ?? false),
                        fillColor: _checkboxStyle,
                        side: _checkboxSide,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acknowledges,
                    onChanged: (v) => _onAcknowledgesChanged(v ?? false),
                    fillColor: _checkboxStyle,
                    side: _checkboxSide,
                  ),
                  const Expanded(
                    child: Text(
                      'I acknowledge that I have received, read, and accepted the haPPy Terms and conditions and privacy policy.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isComplete ? _continue : null,
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll(
                    Size.fromHeight(60),
                  ),
                  shape: const WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.disabled)
                        ? Colors.grey
                        : Colors.black,
                  ),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                child: Text(
                  _submitting ? 'Creating account...' : 'I Accept',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
