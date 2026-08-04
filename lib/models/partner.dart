class Partner {
  final String name;
  final String logo;
  final String description;
  final String website;
  final String email;
  final String instagram;
  final List<StoreLocation> locations;
  const Partner({
    required this.name,
    required this.logo,
    required this.description,
    required this.website,
    required this.email,
    required this.instagram,
    required this.locations,
  });
}

class StoreLocation {
  final String name;
  final String address;

  const StoreLocation({
    required this.name,
    required this.address,
  });
}