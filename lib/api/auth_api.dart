// lib/api/auth_api.dart
import 'package:flutter/foundation.dart';

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
  debugPrint(
    '''Access Token Before clear: ${await TokenStore.instance.readAccess()} \n
    Refresh Token Before Clear: ${await TokenStore.instance.readRefresh()}''',
  );
  await TokenStore.instance.clear();
  debugPrint(
    'sendFirstCode: access after clear = ${await TokenStore.instance.readAccess()}',
  );

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
  final body = {'mobile_number': phone, 'page': 1, 'page_size': 100};
  debugPrint('findMember request: $body');
  final response = await _api.send(
    'POST',
    '/api/v1/qivos/search_member/',
    auth: Auth.customer,
    body: body,
  );
  debugPrint(
    'findMember response: status=${response.httpStatus}, body=${response.body}',
  );
  if (!response.hasBodyAnswer) {
    debugPrint('findMember result: failed (no body answer)');
    return const MemberLookup(failed: true);
  }
  final result = response.body?['response'];
  if (!response.isHttpOk ||
      result is! Map<String, dynamic> ||
      result['success'] != true) {
    debugPrint('findMember result: not found (isHttpOk=${response.isHttpOk})');
    return const MemberLookup();
  }
  final payload = result['payload'];
  final list = payload is Map<String, dynamic> ? payload['data'] : null;
  final first = list is List && list.isNotEmpty ? list.first : null;
  debugPrint('findMember result: member=$first');
  return first is Map<String, dynamic>
      ? MemberLookup(member: first)
      : const MemberLookup();
}

Future<String?> findClientUid(String phone) async {
  final response = await _api.send(
    'POST',
    '/api/v1/clients/search/',
    auth: Auth.staticToken,
    body: {'mobile_number': phone},
  );
  final uid = response.body?['uid'];
  return response.isHttpOk && uid is String && uid.isNotEmpty ? uid : null;
}

Future<Map<String, dynamic>?> loadClient(String uid) async {
  final response = await _api.send(
    'GET',
    '/api/v1/mobile/clients/$uid',
    auth: Auth.customer,
  );
  return response.isHttpOk && response.success ? response.data : null;
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
      loyaltyQcCode = _text(_first(m['loyaltyMembershipData'])?['QCCode']),
      mobileQcCode = _text(_first(m['telephoneList'])?['QCCode']),
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
  final String? loyaltyQcCode;
  final String? mobileQcCode;
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

// No leading zeros: the backend is only confirmed to accept e.g. 1990-5-3.
String apiDateOfBirth(DateTime date) =>
    '${date.year}-${date.month}-${date.day}';

bool isAdult(DateTime birth, {DateTime? today}) {
  final now = today ?? DateTime.now();
  var age = now.year - birth.year;
  if (now.month < birth.month ||
      (now.month == birth.month && now.day < birth.day)) {
    age--;
  }
  return age >= 18;
}

Future<bool> createClient({
  required String phone,
  required String firstName,
  required String lastName,
  required String gender,
  required DateTime dateOfBirth,
  required String street,
  required int cityId,
  required String postCode,
  String? email,
  String qcCode = '',
  String? apartmentNumber,
  String? relationshipCode,
  String? loyaltyQcCode,
  String? mobileQcCode,
}) async {
  final body = <String, dynamic>{
    'mobile_number': phone,
    'first_name': firstName,
    'last_name': lastName,
    'gender': gender,
    'date_of_birth': apiDateOfBirth(dateOfBirth),
    'address': street,
    'town': cityId.toString(),
    'post_code': postCode,
    'email': email,
    'qc_code': qcCode,
    'apartmentNumber': apartmentNumber,
    'relationship_code': relationshipCode,
    'loyalty_qc_code': loyaltyQcCode,
    'mobile_qc_code': mobileQcCode,
    'profile_picture': null,
  };
  debugPrint('createClient request: $body');
  final response = await _api.send(
    'POST',
    '/api/v1/mobile/clients/',
    auth: Auth.customer,
    body: body,
  );
  debugPrint(
    'createClient response: status=${response.httpStatus}, body=${response.body}',
  );
  return response.isHttpOk && response.success;
}

Future<bool> createWallet({
  required String clientUid,
  required String phone,
}) async {
  final response = await _api.send(
    'POST',
    '/api/v1/mobile/wallets/',
    auth: Auth.customer,
    body: {
      'owner_uid': clientUid,
      'type': 'INDIVIDUAL',
      'extra': {'mobile_number': phone},
    },
  );
  return response.isHttpOk && response.success;
}

enum FinishResult { ready, noClient, noWallet }

Future<FinishResult> finishSignIn(String phone) async {
  final uid = await findClientUid(phone);
  if (uid == null) return FinishResult.noClient;

  var client = await loadClient(uid);
  if (client == null) return FinishResult.noClient;

  if (client['wallet_uid'] == null) {
    final created = await createWallet(clientUid: uid, phone: phone);
    if (!created) return FinishResult.noWallet;
    client = await loadClient(uid);
    if (client == null) return FinishResult.noClient;
  }
  return FinishResult.ready;
}

class City {
  const City({required this.id, required this.name});
  final int id;
  final String name;
}

/// All cities, or null when a page could not be read.
Future<List<City>?> fetchAllCities() async {
  final cities = <City>[];
  for (var page = 1; page <= 50; page++) {
    final response = await _api.send(
      'GET',
      '/api/v1/mobile/cms/content/cities/?page=$page',
      auth: Auth.staticToken,
    );
    final results = response.body?['results'];
    if (!response.isHttpOk || results is! List) {
      return null;
    }
    for (final item in results) {
      if (item is Map<String, dynamic>) {
        final id = item['id'];
        final name = item['name'];
        if (id is int && name is String && name.isNotEmpty) {
          cities.add(City(id: id, name: name));
        }
      }
    }
    if (response.body?['next'] == null) {
      return cities..sort((a, b) => a.name.compareTo(b.name));
    }
  }
  return null;
}

/// Returns true when the backend confirmed the revoke.
/// The local session is cleared in every case.
Future<bool> signOut() async {
  final refresh = await TokenStore.instance.readRefresh() ?? '';
  var revoked = false;
  try {
    final response = await _api.send(
      'POST',
      '/api/v1/mobile/accounts/token/revoke/',
      auth: Auth.staticToken,
      body: {'refresh_token': refresh},
    );
    revoked = response.isHttpOk && response.success;
  } on NetworkException {
    revoked = false;
  }
  await TokenStore.instance.clear();
  return revoked;
}
