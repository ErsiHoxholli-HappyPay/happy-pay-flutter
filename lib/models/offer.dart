import 'partner.dart';
class Offer {
  final String id;
  final String title;
  final String image;
  final String description;
  final String? terms;
  final int? points;
  final Partner partner;

  const Offer({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    this.terms,
    this.points,
    required this.partner,
  });
}