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
  SendCodeOutcome(this.result, [this.mode, this.code]);
  final SendCodeResult result;
  final AuthMode? mode;
  final String? code;
}

String? _codeFrom(ApiResponse response) {
  final value =
      response.data?['otp'] ??
      response.data?['code'] ??
      response.data?['otp_code'];
  if (value == null) return null;
  final text = value.toString();
  return text.isNotEmpty ? text : null;
}

Future<SendCodeOutcome> sendFirstCode(String phone) async {
  await TokenStore.instance.clear();

  final login = await requestLoginCode(phone);
  if (login.isHttpOk && login.bodyStatusCode == 200) {
    return SendCodeOutcome(
      SendCodeResult.codeSent,
      AuthMode.login,
      _codeFrom(login),
    );
  }
  if (!login.hasBodyAnswer) {
    return SendCodeOutcome(SendCodeResult.failed);
  }

  final registration = await requestRegistrationCode(phone);
  if (registration.isHttpOk && registration.bodyStatusCode == 200) {
    return SendCodeOutcome(
      SendCodeResult.codeSent,
      AuthMode.registration,
      _codeFrom(registration),
    );
  }
  if (registration.hasBodyAnswer &&
      registration.bodyStatusCode == 400 &&
      registration.errorId == 'user_already_exists') {
    return SendCodeOutcome(SendCodeResult.alreadyRegistered);
  }
  return SendCodeOutcome(SendCodeResult.failed);
}

enum ConfirmResult { confirmed, rejected, failed }

Future<ConfirmResult> _confirm(String path, String phone, String code) async {
  final response = await _api.send(
    'POST',
    path,
    auth: Auth.staticToken,
    body: {'mobile_number': phone, 'otp_code': code},
  );
  final access = response.data?['access_token'];
  final refresh = response.data?['refresh_token'];
  if (response.isHttpOk &&
      response.success &&
      access is String &&
      access.isNotEmpty) {
    await TokenStore.instance.saveBoth(
      access: access,
      refresh: refresh is String ? refresh : '',
    );
    return ConfirmResult.confirmed;
  }
  return response.hasBodyAnswer ? ConfirmResult.rejected : ConfirmResult.failed;
}

Future<ConfirmResult> confirmLoginCode(String phone, String code) {
  return _confirm('/api/v1/mobile/accounts/login/confirm/', phone, code);
}

Future<ConfirmResult> confirmRegistrationCode(String phone, String code) {
  return _confirm('/api/v1/mobile/accounts/registration/confirm/', phone, code);
}

//Look up the loyalty member
class MemberLookup {
  const MemberLookup({this.member, this.failed = false});

  /// The first member entry, or null when no member was found.
  final Map<String, dynamic>? member;

  /// True when there was no readable answer at all.
  final bool failed;

  bool get found => member != null;
}

Future<MemberLookup> findMember(String phone) async {
  final response = await _api.send(
    'POST',
    '/api/v1/qivos/search_member/',
    auth: Auth.customer,
    body: {'mobile_number': phone, 'page': 1, 'page_size': 100},
  );
  if (!response.hasBodyAnswer) {
    return const MemberLookup(failed: true);
  }
  final result = response.body?['response'];
  if (!response.isHttpOk ||
      result is! Map<String, dynamic> ||
      result['success'] != true) {
    return const MemberLookup();
  }
  final payload = result['payload'];
  final list = payload is Map<String, dynamic> ? payload['data'] : null;
  final first = list is List && list.isNotEmpty ? list.first : null;
  return first is Map<String, dynamic>
      ? MemberLookup(member: first)
      : const MemberLookup();
}

/// Values to pre-fill the sign-up form. Any of them can be null.
class MemberPrefill {
  MemberPrefill.fromMember(Map<String, dynamic> m)
    : qcCode = _text(m['QCCode']),
      firstName = _text(m['firstName']),
      lastName = _text(m['lastName']),
      gender = _text(m['gender']),
      dateOfBirth = DateTime.tryParse(_text(m['dateOfBirth']) ?? ''),
      city = _text(_first(m['addressList'])?['town']),
      street = _text(_first(m['addressList'])?['addressLine1']),
      postCode = _text(_first(m['addressList'])?['postCode']),
      email = _text(_first(m['emailList'])?['emailAddress']),
      points = _int(_first(m['loyaltyMembershipData'])?['pointBalance']);

  final String? qcCode;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? city;
  final String? street;
  final String? postCode;
  final String? email;
  final int? points;

  static String? _text(Object? value) => value?.toString();

  static int? _int(Object? value) => value is int ? value : null;

  static Map<String, dynamic>? _first(Object? list) {
    if (list is List && list.isNotEmpty) {
      final first = list.first;
      if (first is Map<String, dynamic>) return first;
    }
    return null;
  }
}
