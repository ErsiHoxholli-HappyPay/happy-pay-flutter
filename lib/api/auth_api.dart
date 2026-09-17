// lib/api/auth_api.dart
import 'api_client.dart';
import 'token_store.dart';

final _api = ApiClient.instance;

/// Which way the customer is going. Keep it for the whole sign-in.
enum AuthMode { login, registration }

Future<ApiResponse> requestLoginCode(String phone) {
  return _api.send(
    'POST',
    '/api/v1/mobile/accounts/login/',
    auth: Auth.staticToken,
    body: {'mobile_number': phone},
  );
}

Future<ApiResponse> requestRegistrationCode(String phone) {
  return _api.send(
    'POST',
    '/api/v1/mobile/accounts/registration/',
    auth: Auth.staticToken,
    body: {'mobile_number': phone},
  );
}

enum SendCodeResult { codeSent, alreadyRegistered, failed }

class SendCodeOutcome {
  SendCodeOutcome(this.result, [this.mode]);
  final SendCodeResult result;
  final AuthMode? mode;
}

Future<SendCodeOutcome> sendFirstCode(String phone) async {
  await TokenStore.instance.clear();

  final login = await requestLoginCode(phone);
  if (login.isHttpOk && login.bodyStatusCode == 200) {
    return SendCodeOutcome(SendCodeResult.codeSent, AuthMode.login);
  }
  if (!login.hasBodyAnswer) {
    return SendCodeOutcome(SendCodeResult.failed);
  }

  final registration = await requestRegistrationCode(phone);
  if (registration.isHttpOk && registration.bodyStatusCode == 200) {
    return SendCodeOutcome(SendCodeResult.codeSent, AuthMode.registration);
  }
  if (registration.hasBodyAnswer &&
      registration.bodyStatusCode == 400 &&
      registration.errorId == 'user_already_exists') {
    return SendCodeOutcome(SendCodeResult.alreadyRegistered);
  }
  return SendCodeOutcome(SendCodeResult.failed);
}
