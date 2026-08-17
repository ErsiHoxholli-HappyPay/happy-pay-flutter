import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.assetPath,
    required this.checkboxLabel,
    required this.nextScreen,
  });

  final String title;
  final String assetPath;
  final String checkboxLabel;
  final Widget nextScreen;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  bool _accepted = false;
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _accepted,
                  onChanged: (val) => setState(() => _accepted = val ?? false),
                ),
                Expanded(
                  child: Text(
                    widget.checkboxLabel,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _accepted
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => widget.nextScreen),
                    )
                  : null,
              style: ButtonStyle(
                minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
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
              child: const Text('Accept'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
