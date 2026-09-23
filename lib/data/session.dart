import '../api/auth_api.dart';
import '../api/auth_api.dart' as auth_api;
import '../models/pending_request.dart';
import '../models/users.dart';

// Holds the authenticated user for the lifetime of the app session.
class AppSession {
  AppSession._();
  static Users? currentUser;
  static Map<String, String>? preferredPaymentMethod;
  // Wallet balance comes from the wallet call (#50); nothing until then.
  static double walletBalance = 0;

  // Whether the current user has an email on file.
  static bool get hasEmail =>
      currentUser?.email != null && currentUser!.email!.trim().isNotEmpty;

  // In-session app language selection. Not persisted across restarts.
  static String selectedLanguage = 'English';

  static final List<PendingRequest> pendingRequests = [];

  // The +355 number used for sign-in.
  static String? phone;
  // First entry from search_member, or null.
  static Map<String, dynamic>? loyaltyMember;

  // Values typed across the sign-up panels, sent together in createClient.
  static SignUpDraft signUpDraft = SignUpDraft();

  // Client id from clients/search (#50); needed by loadClient and createWallet.
  static String? clientUid;

  /// Pre-fill values from the loyalty member, or null when none was found.
  static MemberPrefill? get memberPrefill {
    final member = loyaltyMember;
    return member == null ? null : MemberPrefill.fromMember(member);
  }

  // Cached across the address panel so going back and forth doesn't re-fetch.
  static Future<List<City>?>? citiesFuture;

  /// Starts loading cities once and reuses the result. Pass `retry: true`
  /// after a failure to fetch again.
  static Future<List<City>?> ensureCitiesLoaded({bool retry = false}) {
    if (retry || citiesFuture == null) {
      citiesFuture = fetchAllCities();
    }
    return citiesFuture!;
  }

  /// Replaces the session user with the loyalty record of the signed-in customer.
  static void signIn({
    required String phone,
    required Map<String, dynamic> member,
  }) {
    final p = MemberPrefill.fromMember(member);
    AppSession.phone = phone;
    loyaltyMember = member;
    final address = [
      p.street,
      p.city,
      p.postCode,
    ].where((s) => s != null && s.trim().isNotEmpty).join(', ');
    currentUser = Users(
      id: p.qcCode ?? phone,
      phoneNumber: phone,
      // Screens read `name` as the full name.
      name: [p.firstName, p.lastName].whereType<String>().join(' ').trim(),
      lastName: p.lastName,
      email: p.email,
      gender: p.gender,
      birthDate: p.dateOfBirth?.toIso8601String().split('T').first,
      address: address.isEmpty ? null : address,
      happyPoints: p.points,
      // Known only after loadClient (#50).
      hasWalletKyc: false,
    );
  }

  /// Revokes the refresh token server-side (best effort) and clears the
  /// local session.
  static Future<void> signOut() async {
    await auth_api.signOut();
    currentUser = null;
    phone = null;
    loyaltyMember = null;
    clientUid = null;
  }
}

class SignUpDraft {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  String? email;
  // The chosen city's id, never its name: two cities can share a name.
  int? cityId;
  String? street;
  String? apartmentNumber;
  String? postCode;
}
