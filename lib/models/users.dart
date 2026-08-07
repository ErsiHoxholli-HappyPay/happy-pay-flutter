class Users {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? birthDate;
  final String? address;
  final int? happyPoints;

  Users({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.lastName,
    this.email,
    this.gender,
    this.birthDate,
    this.address,
    this.happyPoints,
  });
}
