import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.assetPath,
    required this.checkboxLabel,
    this.nextScreen,
    this.onAccepted,
  });

  final String title;
  final String assetPath;
  final String checkboxLabel;
  final Widget? nextScreen;
  final VoidCallback? onAccepted;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  late final Future<String> _contentFuture = rootBundle.loadString(
    widget.assetPath,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<String>(
                future: _contentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Failed to load: ${snapshot.error}');
                  }
                  return SingleChildScrollView(
                    child: Text(snapshot.data ?? ''),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
