// complete_profile.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  static const int _minNameLength = 3;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  String? _gender;

  String? _nameError(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null; // handled by button-disable, not inline error
    }
    if (trimmed.length < _minNameLength) {
      return 'Minimum $_minNameLength characters';
    }
    return null;
  }

  /// Validates dd/mm/yyyy as a real calendar date, not just digit shape.
  /// DateTime() silently rolls over invalid values (e.g. Feb 30 -> Mar 2),
  /// so comparing the constructed date's components back to the input
  /// catches that instead of accepting a normalized-but-wrong date.
  bool _isValidDate(String day, String month, String year) {
    if (day.length != 2 || month.length != 2 || year.length != 4) return false;
    final d = int.tryParse(day);
    final m = int.tryParse(month);
    final y = int.tryParse(year);
    if (d == null || m == null || y == null) return false;
    if (m < 1 || m > 12) return false;
    final date = DateTime(y, m, d);
    return date.year == y && date.month == m && date.day == d;
  }

  String? get _dateError {
    final day = _dayController.text.trim();
    final month = _monthController.text.trim();
    final year = _yearController.text.trim();
    if (day.isEmpty && month.isEmpty && year.isEmpty) return null;
    if (day.length < 2 || month.length < 2 || year.length < 4) {
      return null; // still typing
    }
    return _isValidDate(day, month, year)
        ? null
        : 'Enter a valid date (dd/mm/yyyy)';
  }

  bool get _isComplete =>
      _firstNameController.text.trim().length >= _minNameLength &&
      _lastNameController.text.trim().length >= _minNameLength &&
      _gender != null &&
      _isValidDate(
        _dayController.text.trim(),
        _monthController.text.trim(),
        _yearController.text.trim(),
      );

  @override
  void initState() {
    super.initState();
    for (final c in [
      _firstNameController,
      _lastNameController,
      _dayController,
      _monthController,
      _yearController,
    ]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
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
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please provide your details as they are written on official documents, such as a passport or national ID.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'First Name',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            errorText: _nameError(_firstNameController.text),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last Name',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            errorText: _nameError(_lastNameController.text),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) => DropdownMenu<String>(
                  label: const Text('Gender'),
                  width: constraints.maxWidth,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
                  onSelected: (value) => setState(() => _gender = value),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      value: 'Male',
                      label: 'Male',
                      style: _entryStyle,
                    ),
                    DropdownMenuEntry(
                      value: 'Female',
                      label: 'Female',
                      style: _entryStyle,
                    ),
                    DropdownMenuEntry(
                      value: 'Other',
                      label: 'Other',
                      style: _entryStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Date of Birth',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dayController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'DD',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _monthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'MM',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'YYYY',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_dateError != null) ...[
                const SizedBox(height: 6),
                Text(
                  _dateError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: _isComplete
                    ? () => Navigator.of(
                        context,
                      ).pushNamed('/kyc/contact_information')
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
