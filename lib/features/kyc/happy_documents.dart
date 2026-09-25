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
  // Once the client exists, Retry only repeats the member lookup.
  bool _clientCreated = false;
  // Once the member is found, Retry only repeats finishSignIn.
  Map<String, dynamic>? _member;
  // Retry sends the same qcCode
  String? _qcCode;
  // Ticking the acknowledgement ticks the two documents.
  bool get _isComplete => _acknowledges && !_submitting;

  Future<void> _continue() async {
    if (_submitting) return;
    final phone = AppSession.phone;
    if (phone == null) {
      _showError('Phone number is missing. Please go back and check them.');
      return;
    }
    if (_member != null) {
      await _finishSignIn(phone, _member!);
      return;
    }
    if (_clientCreated) {
      await _lookupMember(phone);
      return;
    }

    final draft = AppSession.signUpDraft;
    final firstName = draft.firstName;
    final lastName = draft.lastName;
    final gender = draft.gender;
    final dateOfBirth = draft.dateOfBirth;
    final street = draft.street;
    final cityId = draft.cityId;
    final postCode = draft.postCode;
    if (firstName == null ||
        lastName == null ||
        gender == null ||
        dateOfBirth == null ||
        street == null ||
        cityId == null ||
        postCode == null) {
      _showError('Some details are missing. Please go back and check them.');
      return;
    }
    _qcCode ??= AppSession.memberPrefill?.qcCode ?? '';

    setState(() => _submitting = true);
    try {
      final created = await createClient(
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        gender: gender.toLowerCase(),
        dateOfBirth: dateOfBirth,
        street: street,
        cityId: cityId,
        postCode: postCode,
        email: draft.email,
        qcCode: _qcCode!,
        apartmentNumber: draft.apartmentNumber,
        loyaltyQcCode: AppSession.memberPrefill?.loyaltyQcCode,
        mobileQcCode: AppSession.memberPrefill?.mobileQcCode,
      );
      if (!mounted) return;
      if (!created) {
        setState(() => _submitting = false);
        _showError(
          'We could not create your account. Please check your details and try again.',
        );
        return;
      }
      _clientCreated = true;
    } on NetworkException {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('No connection. Please try again.');
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('Something went wrong. Tap Retry.');
      return;
    }

    await _lookupMember(phone);
  }

  Future<void> _lookupMember(String phone) async {
    setState(() => _submitting = true);
    Map<String, dynamic>? member;
    try {
      final lookup = await findMember(phone);
      if (!mounted) return;
      debugPrint(
        'HappyDocuments lookup for phone=$phone -> '
        'found=${lookup.found}, failed=${lookup.failed}, member=${lookup.member}',
      );
      member = lookup.member;
    } on NetworkException {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('No connection. Please try again.');
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('Something went wrong. Tap Retry.');
      return;
    }

    if (member == null) {
      setState(() => _submitting = false);
      _showError('We could not load your account. Please try again.');
      return;
    }
    _member = member;
    await _finishSignIn(phone, member);
  }

  Future<void> _finishSignIn(String phone, Map<String, dynamic> member) async {
    setState(() => _submitting = true);
    try {
      final finishResult = await finishSignIn(phone);
      if (!mounted) return;
      if (finishResult == FinishResult.noClient) {
        setState(() => _submitting = false);
        _showError('We could not load your account. Please try again.');
        return;
      }
      if (finishResult == FinishResult.noWallet) {
        setState(() => _submitting = false);
        _showError('We could not set up your wallet.');
        return;
      }

      AppSession.signIn(phone: phone, member: member);

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/home_screen', (_) => false);
    } on NetworkException {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('No connection. Please try again.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('Something went wrong. Tap Retry.');
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
    // Going back after the create would re-send it from a fresh screen.
    final locked = _submitting || _clientCreated;
    return PopScope(
      canPop: !locked,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: locked ? null : const AppBackButton(),
          automaticallyImplyLeading: false,
          elevation: 1,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              Navigator.of(
                                context,
                              ).pushNamed('/kyc/privacy_policy');
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
                                  onChanged: (v) =>
                                      _onPrivacyChanged(v ?? false),
                                  fillColor: _checkboxStyle,
                                  side: _checkboxSide,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 330),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acknowledges,
                              onChanged: (v) =>
                                  _onAcknowledgesChanged(v ?? false),
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isComplete ? _continue : null,
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(
                          Size.fromHeight(60),
                        ),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.disabled)
                              ? Colors.grey
                              : Colors.black,
                        ),
                        foregroundColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _clientCreated ? 'Retry' : 'I Accept',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
