/// Everything the customer types across the four sign-up panels.
/// Read by the create-client step (#48).
class SignUpForm {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  String? email;
  String? city;
  String? street;
  String? postCode;
  bool acceptedTerms = false;
}
