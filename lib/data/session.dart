import '../api/auth_api.dart';
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

  /// Pre-fill values from the loyalty member, or null when none was found.
  static MemberPrefill? get memberPrefill {
    final member = loyaltyMember;
    return member == null ? null : MemberPrefill.fromMember(member);
  }

  /// Replaces the session user with the loyalty record of the signed-in customer.

  static void signOut() {
    currentUser = null;
    phone = null;
    loyaltyMember = null;
    signUpDraft = SignUpDraft();
  }
}

class SignUpDraft {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  String? email;
  String? city;
  String? street;
  String? postCode;
}
