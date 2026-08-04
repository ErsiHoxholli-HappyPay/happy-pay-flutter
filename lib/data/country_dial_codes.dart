class CountryDialCode {
  const CountryDialCode(this.name, this.isoCode, this.dialCode);
  final String name;
  final String isoCode;
  final String dialCode;
}

// Trimmed sample — replace with your actual target markets or a full list.
const countryDialCodes = [
  CountryDialCode('Albania', 'AL', '+355'),
  CountryDialCode('Canada', 'CA', '+1'),
  CountryDialCode('United Kingdom', 'GB', '+44'),
  CountryDialCode('Australia', 'AU', '+61'),
  CountryDialCode('Germany', 'DE', '+49'),
  CountryDialCode('France', 'FR', '+33'),
  CountryDialCode('India', 'IN', '+91'),
  CountryDialCode('United States', 'US', '+1'),
];
