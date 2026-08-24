import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/id_directions_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

enum Documents {
  drivingLicence('Driving Licence', 'Driving Licence'),
  nationalId('National Id', 'National Id'),
  passport('Passport', 'Passport');

  final String label;
  final String title;
  const Documents(this.label, this.title);
}

class GovDocuments extends StatelessWidget {
  const GovDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('ID Verification', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Please provide one of the following documents',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We only accept documents issued by Albania.Your documents must not be expired.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            for (int i = 0; i < Documents.values.length; i++)
              _ConsentTile(
                document: Documents.values[i],
                isFirst: i == 0,
                isLast: i == Documents.values.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.document,
    required this.isFirst,
    required this.isLast,
  });

  final Documents document;
  final bool isFirst;
  final bool isLast;

  static const _borderSide = BorderSide(color: _borderColor);
  static const _borderColor = Color.fromARGB(199, 85, 79, 79);

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IdDirectionsScreen(title: document.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: isFirst ? _borderSide : BorderSide.none,
          left: _borderSide,
          right: _borderSide,
          bottom: _borderSide,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
          topRight: isFirst ? const Radius.circular(12) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: InkWell(
        onTap: () => _navigate(context),
        child: Row(
          children: [
            Text(document.label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
