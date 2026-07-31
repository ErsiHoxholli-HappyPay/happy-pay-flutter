class Offer {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String logo;
  final String description;
  final String? terms;
  final int? points;

  const Offer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.logo,
    required this.description,
    this.terms,
    this.points,
  });

  bool get isHappyOffer => points != null;
}