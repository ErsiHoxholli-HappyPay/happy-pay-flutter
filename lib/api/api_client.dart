// lib/api/api_client.dart
import 'package:dio/dio.dart';

import 'env.dart';
import 'token_store.dart';

/// Which Authorization header a call needs. See the table above.
enum Auth { staticToken, customer }

/// Thrown only when no answer came back: no connection, timeout.
class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// One answer from the backend. See section 2.5.
class ApiResponse {
  ApiResponse(this.httpStatus, this.body);

  final int httpStatus;

  /// The JSON body, or null when the body is not a JSON object.
  final Map<String, dynamic>? body;

  bool get isHttpOk => httpStatus >= 200 && httpStatus < 300;

  /// The original app reads the answer from the body only for these statuses.
  bool get hasBodyAnswer =>
      body != null &&
      (httpStatus == 200 || httpStatus == 400 || httpStatus == 404);

  /// The `status_code` field inside the body. Not the HTTP status.
  int? get bodyStatusCode {
    final value = body?['status_code'];
    return value is int ? value : null;
  }

  bool get success => body?['success'] == true;

  String? get errorId {
    final value = body?['id'];
    return value is String ? value : null;
  }

  Map<String, dynamic>? get data {
    final value = body?['data'];
    return value is Map<String, dynamic> ? value : null;
  }
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// Set once in main(). Runs after the tokens are cleared.
  void Function()? onSessionExpired;

  static BaseOptions _options() => BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    contentType: Headers.jsonContentType,
    headers: <String, String>{
      'User-Agent': 'PostmanRuntime/7.36.0',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
    },
    // Never throw on a status code. Each step decides.
    validateStatus: (_) => true,
  );

  final Dio _dio = Dio(_options());

  // Used for the refresh call only.
  final Dio _refreshDio = Dio(_options());

  Future<bool>? _refreshing;

  Future<ApiResponse> send(
    String method,
    String path, {
    required Auth auth,
    Map<String, dynamic>? body,
  }) async {
    var response = await _request(method, path, auth, body);
    if (response.httpStatus != 401 || auth != Auth.customer) {
      return response;
    }
    if (await _refreshOnce()) {
      response = await _request(method, path, auth, body);
      if (response.httpStatus != 401) {
        return response;
      }
    }
    await TokenStore.instance.clear();
    onSessionExpired?.call();
    return response;
  }

  Future<ApiResponse> _request(
    String method,
    String path,
    Auth auth,
    Map<String, dynamic>? body,
  ) async {
    final authorization = await _authorization(auth);
    try {
      final response = await _dio.request<dynamic>(
        '$kBaseUrl$path',
        data: body,
        options: Options(
          method: method,
          headers: <String, String>{'Authorization': authorization},
        ),
      );
      return ApiResponse(response.statusCode ?? 0, _jsonObject(response.data));
    } on DioException catch (e) {
      throw NetworkException(e.message ?? e.type.name);
    }
  }

  Future<String> _authorization(Auth auth) async {
    if (auth == Auth.staticToken) {
      return 'Token $kStaticToken';
    }
    final token = await TokenStore.instance.readAccess();
    if (token == null || token.isEmpty) {
      throw StateError('No access token. Confirm a code first.');
    }
    return 'Bearer $token';
  }

  Future<bool> _refreshOnce() {
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _refresh() async {
    final refreshToken = await TokenStore.instance.readRefresh();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    try {
      final response = await _refreshDio.post<dynamic>(
        '$kBaseUrl/api/v1/mobile/accounts/token/refresh/',
        data: <String, dynamic>{'refresh_token': refreshToken},
        options: Options(
          headers: <String, String>{'Authorization': 'Token $kStaticToken'},
        ),
      );
      final data = _jsonObject(response.data)?['data'];
      final access = data is Map<String, dynamic> ? data['access_token'] : null;
      if (response.statusCode == 200 && access is String && access.isNotEmpty) {
        await TokenStore.instance.saveAccess(access);
        return true;
      }
      return false;
    } on DioException {
      return false;
    }
  }

  static Map<String, dynamic>? _jsonObject(Object? value) =>
      value is Map<String, dynamic> ? value : null;
}
