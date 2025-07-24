import 'dart:io' as io;

import 'package:connectrpc/connect.dart';
import 'package:connectrpc/io.dart' as connect_io;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mobile/gen/v1/auth.connect.client.dart';
import 'package:mobile/gen/v1/auth.pb.dart';
import 'package:mobile/shared/constants.dart';
import 'package:mobile/shared/storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  // Use the constructor like in the pub.dev example
  late final AuthServiceClient _client = AuthServiceClient(
    protocol.Transport(
      baseUrl: BASE_URL,
      codec: const ProtoCodec(),
      httpClient: connect_io.createHttpClient(io.HttpClient()),
    ),
  );

  Future<String?> Register(String name, String email, String password) async {
    try {

      final tokens = await _client.register(
          RegisterRequest(name: name, email: email, password: password));

      await _storage.write(key: REFRESH_TOKEN_KEY, value: tokens.refreshToken);
      await _storage.write(key: ACCESS_TOKEN_KEY, value: tokens.accessToken);
      await _storage.write(key: EXPIRES_AT_KEY, value: tokens.expiresAt.toString());
    } on ConnectException catch (e) {
      return e.message;
    }
    return null;
  }
}
