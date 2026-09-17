// lib/api/auth_api.dart
import 'api_client.dart';

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
