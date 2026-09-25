import 'package:flutter/material.dart';
import '../../api/api_client.dart' show NetworkException;
import '../../api/auth_api.dart' show City;
import '../../data/session.dart';
import '../../widgets/back_button.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  int? _cityId;
  List<City> _cities = [];
  bool _loadingCities = true;
  bool _citiesFailed = false;
  final _streetController = TextEditingController();
  final _apartmentNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();

  bool get _isComplete => _cityId != null;

  @override
  void initState() {
    super.initState();
    final draft = AppSession.signUpDraft;
    final prefill = AppSession.memberPrefill;
    _cityId = draft.cityId;
    _streetController.text = draft.street ?? prefill?.street ?? '';
    _apartmentNumberController.text = draft.apartmentNumber ?? '';
    _postalCodeController.text = draft.postCode ?? prefill?.postCode ?? '';
    _loadCities();
  }

  Future<void> _loadCities({bool retry = false}) async {
    setState(() {
      _loadingCities = true;
      _citiesFailed = false;
    });
    try {
      final cities = await AppSession.ensureCitiesLoaded(retry: retry);
      if (!mounted) return;
      if (cities == null) {
        setState(() {
          _loadingCities = false;
          _citiesFailed = true;
        });
        return;
      }
      setState(() {
        _cities = cities;
        _loadingCities = false;
        _cityId ??= _matchPrefillCityId(cities);
      });
    } on NetworkException {
      if (!mounted) return;
      setState(() {
        _loadingCities = false;
        _citiesFailed = true;
      });
    }
  }

  // Only preselects when the name from the member record is unambiguous:
  // two cities can share a name.
  int? _matchPrefillCityId(List<City> cities) {
    final name = AppSession.memberPrefill?.city?.trim();
    if (name == null || name.isEmpty) return null;
    final matches = cities.where(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );
    return matches.length == 1 ? matches.first.id : null;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _apartmentNumberController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _continue() {
    final draft = AppSession.signUpDraft;
    draft.cityId = _cityId;
    draft.street = _streetController.text.trim();
    draft.apartmentNumber = _apartmentNumberController.text.trim();
    draft.postCode = _postalCodeController.text.trim();
    Navigator.of(context).pushNamed('/kyc/happy_documents');
  }

  Widget _buildCityField() {
    if (_loadingCities) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_citiesFailed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'We could not load the list of cities.',
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _loadCities(retry: true),
            child: const Text('Retry'),
          ),
        ],
      );
    }
    return DropdownButtonFormField<int>(
      initialValue: _cityId,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Select City',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      items: [
        for (final city in _cities)
          DropdownMenuItem<int>(value: city.id, child: Text(city.name)),
      ],
      onChanged: (id) => setState(() => _cityId = id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const AppBackButton(), elevation: 0),
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
                        'Address details',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'City',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCityField(),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Road',
                        controller: _streetController,
                        hintText: 'Enter Road (Optional)',
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Apartment number',
                              controller: _apartmentNumberController,
                              hintText: 'Enter Apartment Number (Optional)',
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _LabeledField(
                              label: 'Postal number',
                              controller: _postalCodeController,
                              hintText: 'Enter Postal Code (Optional)',
                              onChanged: (_) => setState(() {}),
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

/// Label + text field pair, matching the app's field styling.
/// Pulled out because the same label/border/hint combo was about
/// to be duplicated across five fields.
class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
