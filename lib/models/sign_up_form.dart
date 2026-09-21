/// Everything the customer types across the four sign-up panels.
/// Read by the create-client step (#48). The phone number and the
/// loyalty QCCode come from AppSession, not from the form.
class SignUpForm {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? apiDateOfBirth;
  String? street;
  String? city;
  String? postCode;
  String? email;
  bool acceptedTerms = false;
}
