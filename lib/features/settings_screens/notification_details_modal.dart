import 'package:flutter/material.dart';

class NotificationDetailsModal extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsModal({super.key, required this.notification});

  static Future<void> show(
    BuildContext context,
    NotificationModel notification,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (_) => NotificationDetailsModal(notification: notification),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SizedBox(
        height: screenHeight * 0.80,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Container(color: Colors.grey),
                  ),
                  Positioned(
                    top: 60,
                    left: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                notification.title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  notification.detailedText,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationModel {
  final String title;
  final String subtitle;
  final String detailedText;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.detailedText,
  });
}

final notification = [
  NotificationModel(
    title: 'Co-Branded Credit Card haPPy -Tirana Bank',
    subtitle:
        'Credit Card from Tirana Bank comes as a competitive advantage in Albanian market...',
    detailedText:
        '“Credit Card from Tirana Bank” comes as a competitive advantage in Albanian market in collaboration with haPPy Program, which offers you:'
        'Double haPPy points for every purchases in all stores: SPAR, NEPTUN, JUMBO, FGA'
        'Installments from 2-12 months with 0% interes for each purchase over 6,000 LEK / 50 EUR at Tirana Bank POS.'
        'Open coupon 500 ALL when you reach the reward level of 5.000/10.000 points'
        '*Open coupon means that the customer can use it in any of the stores: JUMBO/NEPTUN/SPAR/FGA for any purchase over 1,000 ALL, only for the payment with Tirana Bank Credit Card'
        'Personalized offers'
        'Bonus Points for special events',
  ),
  NotificationModel(
    title:
        'The new haPPy app brings together innovation and benefits for 490,000 loyal members!',
    subtitle:
        'Online applications have become one of the important elements of our lives, facilitating our everyday and essential activities - such as shopping.',
    detailedText: '',
  ),
  NotificationModel(
    title: 'Earn as much as you wish!',
    subtitle:
        'By joining the largest haPPy Loyalty Program, you are rewarded with the benefits and benefits created to your liking. By accumulating points you become part of two levels of reward. ',
    detailedText: '',
  ),
];
