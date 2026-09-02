import '../models/pending_request.dart';
import '../models/users.dart';

// Holds the authenticated user for the lifetime of the app session.
class AppSession {
  AppSession._();
  static Users? currentUser;
  static Map<String, String>? preferredPaymentMethod;
  static double walletBalance = 3000;

  // Whether the current user has an email on file.
  static bool get hasEmail =>
      currentUser?.email != null && currentUser!.email!.trim().isNotEmpty;

  // In-session app language selection. Not persisted across restarts.
  static String selectedLanguage = 'English';

  // Pre-seeded with one dummy pending request for testing
  static final List<PendingRequest> pendingRequests = [
    PendingRequest(id: 'req-1', contactName: 'John Doe', amount: '1,000'),
  ];
}
