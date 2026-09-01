class Contact {
  final String name;
  final String phoneNumber;
  final bool hasAccount;

  const Contact(
    this.name,
    this.phoneNumber, {
    this.hasAccount = true,
  });

  String get initials {
    final parts = name.trim().split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name[0].toUpperCase();
  }

  String get maskedPhone {
    if (phoneNumber.length < 6) return phoneNumber;
    return '${phoneNumber.substring(0, phoneNumber.length - 4)}****';
  }
}

final contacts = <Contact>[
  Contact('Ceridian Berenica', '+355 611 111 111'),
  Contact('Vince Bean', '+355 612 222 222'),
  Contact('Drilon Bybici', '+355 613 333 333',
      hasAccount: false),
  Contact('Enrike Cela', '+355 614 444 444',
      hasAccount: false),
  Contact('Ejla Dervishi', '+355 615 555 555'),
  Contact('Figide Gjadhi', '+355 616 666 666'),
  Contact('Flodan Gjaka', '+355 617 777 777',
      hasAccount: false),
  Contact('Besnik Hoxha', '+355 618 888 888',
      hasAccount: false),
  Contact('Aleksandra Xobrowski', '+355 619 999 999'),
  Contact('Drin Lika', '+355 621 111 222',
      hasAccount: false),
  Contact('Raden Moises', '+355 622 333 444'),
  Contact('Jonida Ago', '+355 623 444 555'),
  Contact('Artan Berberi', '+355 624 555 666',
      hasAccount: false),
  Contact('Klodiana Duka', '+355 625 666 777'),
];
