import '../models/users.dart';

// Holds the authenticated user for the lifetime of the app session.
class AppSession {
  AppSession._();
  static Users? currentUser;
}
