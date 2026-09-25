// contact_information.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class ContactInformationScreen extends StatefulWidget {
  const ContactInformationScreen({super.key});

  @override
  State<ContactInformationScreen> createState() =>
      _ContactInformationScreenState();
}

class _ContactInformationScreenState extends State<ContactInformationScreen> {
  final _numberController = TextEditingController();
  final _prefixController = TextEditingController();
  final _emailController = TextEditingController();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// National-number rules per calling code: expected digit length and
  /// the leading-digit pattern for that prefix's mobile ranges.
  /// Source: numbering plans for AKEP (AL), Ofcom (UK), NANP (US/CA).
  static final Map<String, RegExp> _nationalNumberPatterns = {
    '+355': RegExp(r'^6\d{8}$'), // Albania mobile: 6 + 8 digits = 9 digits
    '+44': RegExp(r'^7\d{9}$'), // UK mobile: 7 + 9 digits = 10 digits
    '+1': RegExp(
      r'^[2-9]\d{9}$',
    ), // NANP: 10 digits, area/exchange can't start 0/1
  };

  String? get _numberError {
    final digits = _numberController.text.trim();
    if (digits.isEmpty) return null;
    final pattern = _nationalNumberPatterns[_prefixController.text];
    if (pattern == null) return 'Unsupported country code';
    return pattern.hasMatch(digits)
        ? null
        : 'Invalid number for ${_prefixController.text}';
  }

  String? get _emailError {
    final email = _emailController.text.trim();
    if (email.isEmpty) return null;
    return _emailPattern.hasMatch(email) ? null : 'Enter a valid email';
  }

  // Nothing is required on this panel; only reject values that are present
  // but malformed.
  bool get _isComplete => _numberError == null && _emailError == null;

  bool _acceptsPromo = false;

  @override
  void initState() {
    super.initState();

    final rawPhone = AppSession.phone ?? '';
    final matchedPrefix = _nationalNumberPatterns.keys
        .where((code) => rawPhone.startsWith(code))
        .fold<String?>(null, (best, code) {
          if (best == null || code.length > best.length) return code;
          return best;
        });

    _prefixController.text = matchedPrefix ?? '+355';
    _numberController.text =
        (matchedPrefix == null
                ? rawPhone
                : rawPhone.substring(matchedPrefix.length))
            .replaceAll(RegExp(r'[^0-9]'), '');

    _emailController.text =
        AppSession.signUpDraft.email ?? AppSession.memberPrefill?.email ?? '';
    for (final c in [_numberController, _prefixController, _emailController]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _prefixController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _continue() {
    final email = _emailController.text.trim();
    AppSession.signUpDraft.email = email.isEmpty ? null : email;
    Navigator.of(context).pushNamed('/kyc/address_details');
  }

  final ButtonStyle _entryStyle =
      MenuItemButton.styleFrom(
        textStyle: const TextStyle(fontSize: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.black;
          if (states.contains(WidgetState.hovered)) return Colors.black12;
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return Colors.black87;
        }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const AppBackButton(), elevation: 1),
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
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Please provide your contact information to complete your profile.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  DropdownMenu<String>(
                                    enabled: false,
                                    initialSelection:
                                        _prefixController.text.isEmpty
                                        ? '+355'
                                        : _prefixController.text,
                                    hintText: '+355',
                                    width: constraints.maxWidth,
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12.0),
                                            ),
                                          ),
                                        ),
                                    menuStyle: MenuStyle(
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                            Colors.white,
                                          ),
                                      elevation: const WidgetStatePropertyAll(
                                        4,
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      padding: const WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 16,
                                        ),
                                      ),
                                    ),
                                    onSelected: (value) => setState(
                                      () =>
                                          _prefixController.text = value ?? '',
                                    ),
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                        value: '+1',
                                        label: '+1',
                                        style: _entryStyle,
                                      ),
                                      DropdownMenuEntry(
                                        value: '+44',
                                        label: '+44',
                                        style: _entryStyle,
                                      ),
                                      DropdownMenuEntry(
                                        value: '+355',
                                        label: '+355',
                                        style: _entryStyle,
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: _numberController,
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: '6x xxx xxxx',
                                errorText: _numberError,
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Email Address(Optional)',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          errorText: _emailError,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptsPromo,
                            onChanged: (v) =>
                                setState(() => _acceptsPromo = v ?? false),
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) => states.contains(WidgetState.selected)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          const Text(
                            'Send me promotional news and offers.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                    child: const Text(
                      'Continue',
                      style: TextStyle(
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
    );
  }
}
