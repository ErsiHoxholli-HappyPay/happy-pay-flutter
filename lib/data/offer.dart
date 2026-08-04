import '../models/offer.dart';
import '../models/partner.dart';

const neptun = Partner(
  name: "Neptun",
  logo: "https://picsum.photos/600/300?1",
  description:
      "Neptun was founded in 1993. It is the leading company...",
  website: "https://neptun.al",
  email: "info@neptun.al",
  instagram: "https://instagram.com/neptun",
  locations: [
    StoreLocation(
      name: "NEPTUN BELSH",
      address: "Rr. '31 Gushti'",
    ),
    StoreLocation(
      name: "NEPTUN TIRANA",
      address: "Rr. Myslym Shyri",
    ),
  ],
);

const maxOptika = Partner(
  name: "Max Optika",
  logo: "https://picsum.photos/600/300?2",
  description:
      "Max Optika was founded in 2000. It is the leading company...",
  website: "https://maxoptika.al",
  email: "info@maxoptika.al",
  instagram: "https://instagram.com/maxoptika",
  locations: [
    StoreLocation(
      name: "MAX OPTIKA BELSH",
      address: "Rr. '31 Gushti'",
    ),
    StoreLocation(
      name: "MAX OPTIKA TIRANA",
      address: "Rr. Myslym Shyri",
    ),
  ],
);

const mrWatch = Partner(
  name: "Mr. Watch",
  logo: "https://picsum.photos/600/300?3",
  description:
      "Mr. Watch was founded in 2005. It is the leading company...",
  website: "https://mrwatch.al",
  email: "info@mrwatch.al",
  instagram: "https://instagram.com/mrwatch",
  locations: [
    StoreLocation(
      name: "MR. WATCH BELSH",
      address: "Rr. '31 Gushti'",
    ),
    StoreLocation(
      name: "MR. WATCH TIRANA",
      address: "Rr. Myslym Shyri",
    ),
  ],
);

const offers = [
  Offer(
    id: '1',
    title: 'BLACK FRIDAY IN NEPTUN',
    image: 'https://picsum.photos/600/300?1',
    description:
        'Come on! Grab the lowest prices of the year...',
    partner: neptun,
  ),

  Offer(
    id: '2',
    title: 'Black Week has arrived',
    image: 'https://picsum.photos/600/300?2',
    description:
        'Come on! Grab the lowest prices of the year...',
    partner: maxOptika,
  ),

  Offer(
    id: '3',
    title: 'MR. WATCH 20% DISCOUNT',
    image: 'https://picsum.photos/600/300?3',
    partner: mrWatch,
    description:
        'Offer dedicated to haPPy members...',
    terms:
        'Products on offer are excluded...',
    points: 70,
  ),
];