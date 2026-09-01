class Business {
  final String id;
  final String name;
  final String category;

  const Business({
    required this.id,
    required this.name,
    required this.category,
  });

  String get initials {
    final parts = name.trim().split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
