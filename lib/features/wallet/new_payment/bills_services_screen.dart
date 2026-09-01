import 'package:flutter/material.dart';
import '../../../widgets/back_button.dart';
import 'bill_entry_screen.dart';

class BillService {
  final String name;
  final IconData icon;
  final String companyName;
  final String contractLabel;
  final double amount;

  const BillService({
    required this.name,
    required this.icon,
    required this.companyName,
    required this.contractLabel,
    required this.amount,
  });
}

const _services = [
  BillService(
    name: 'Electricity bill',
    icon: Icons.bolt,
    companyName: 'Albanian Power Corporation',
    contractLabel: 'electricity contract number',
    amount: 400,
  ),
  BillService(
    name: 'Water bill',
    icon: Icons.water_drop_outlined,
    companyName: 'Albanian Water Utility',
    contractLabel: 'water contract number',
    amount: 250,
  ),
  BillService(
    name: 'Car tax',
    icon: Icons.directions_car_outlined,
    companyName: 'Road Transport Directorate',
    contractLabel: 'vehicle plate number',
    amount: 150,
  ),
  BillService(
    name: 'Parking fine',
    icon: Icons.local_parking,
    companyName: 'Municipal Parking Authority',
    contractLabel: 'fine reference number',
    amount: 75,
  ),
  BillService(
    name: 'Phone top-up',
    icon: Icons.phone_android,
    companyName: 'Mobile Provider',
    contractLabel: 'phone number',
    amount: 100,
  ),
];

class BillsServicesScreen extends StatelessWidget {
  const BillsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                8,
                16,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Text(
                "Choose a bill or service",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _services.length,
                itemBuilder: (_, i) {
                  final s = _services[i];
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BillEntryScreen(service: s),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(s.icon, size: 20),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
