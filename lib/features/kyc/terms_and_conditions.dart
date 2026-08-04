import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../widgets/back_button.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  Future<String> _loadTermsAndConditions() =>
      rootBundle.loadString('lib/assets/legal/terms_and_conditions.txt');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const AppBackButton(), elevation: 0),
      body: FutureBuilder<String>(
        future: _loadTermsAndConditions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Terms and Conditions',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          snapshot.data ?? '',
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load terms and conditions.'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
