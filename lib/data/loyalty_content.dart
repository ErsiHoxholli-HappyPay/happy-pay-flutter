// Mock loyalty content loaders. No backend endpoints are documented yet for
// these; swap each function body for a real ApiClient.instance.send(...) call
// once one is available, keeping the same signature.
import '../models/offer.dart';
import '../models/partner.dart';
import '../models/points_history.dart';
import 'offer.dart' as offer_data;

Future<List<PointsHistoryEntry>> fetchPointsHistoryPreview() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return [
    PointsHistoryEntry(title: 'Max Optika', date: DateTime.now(), points: 3),
    PointsHistoryEntry(title: 'Spar', date: DateTime.now(), points: 15),
    PointsHistoryEntry(title: 'Neptun', date: DateTime.now(), points: 22),
  ];
}

Future<List<Offer>> fetchOffersPreview() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return offer_data.offers;
}

Future<List<Partner>> fetchPartnersPreview() async {
  await Future.delayed(const Duration(milliseconds: 600));
  final seen = <String>{};
  return [
    for (final offer in offer_data.offers)
      if (seen.add(offer.partner.name)) offer.partner,
  ];
}
