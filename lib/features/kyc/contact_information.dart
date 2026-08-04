// contact_information.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool get _isComplete {
    final digits = _numberController.text.trim();
    final pattern = _nationalNumberPatterns[_prefixController.text];
    return digits.isNotEmpty && pattern != null && pattern.hasMatch(digits);
  }

  bool _acceptsPromo = false;

  @override
  void initState() {
    super.initState();
    _prefixController.text = '+355';
    for (final c in [_numberController, _prefixController]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _prefixController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      builder: (context, constraints) => DropdownMenu<String>(
                        hintText: '+355',
                        width: constraints.maxWidth,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          elevation: const WidgetStatePropertyAll(4),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          ),
                        ),
                        onSelected: (value) => setState(
                          () => _prefixController.text = value ?? '',
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
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
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isComplete
                    ? () => Navigator.of(
                        context,
                      ).pushNamed('/kyc/address_details')
                    : null,
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
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
