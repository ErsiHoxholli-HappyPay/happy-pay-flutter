import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import '../../data/country_dial_codes.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _phoneController = TextEditingController();
  CountryDialCode _selectedCountry = countryDialCodes.first;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
                'Enter your phone number to get started',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'We will send you a verification code to confirm your number.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownMenu<CountryDialCode>(
                      initialSelection: _selectedCountry,
                      enableFilter: true,
                      requestFocusOnTap: true,

                      dropdownMenuEntries: countryDialCodes
                          .map(
                            (c) => DropdownMenuEntry(
                              value: c,
                              label: '${c.dialCode} ${c.isoCode}',
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        if (value != null) {
                          setState(() => _selectedCountry = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final fullNumber =
                      '${_selectedCountry.dialCode}${_phoneController.text}';
                  Navigator.of(
                    context,
                  ).pushNamed('/otp_code', arguments: fullNumber);
                },
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
                  'Send Code',
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
