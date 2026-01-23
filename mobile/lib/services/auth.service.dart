import 'dart:io' as io;

import 'package:connectrpc/connect.dart';
import 'package:connectrpc/io.dart' as connect_io;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:riverpod/riverpod.dart';

import 'package:mobile/gen/v1/auth.connect.client.dart';
import 'package:mobile/gen/v1/auth.pb.dart';
import 'package:mobile/shared/constants.dart';

class AuthService {
  // Use the constructor like in the pub.dev example
  late final AuthServiceClient _client = AuthServiceClient(
    protocol.Transport(
      baseUrl: BASE_URL,
      codec: const ProtoCodec(),
      httpClient: connect_io.createHttpClient(io.HttpClient()),
    ),
  );

  Future<Tokens> login(String email, String password) async {
    final tokens = await _client.login(LoginRequest(email: email, password: password));
    return tokens;
  }

  Future<Tokens> register(String name, String email, String password) async {
    final tokens = await _client.register(
      RegisterRequest(name: name, email: email, password: password),
    );
    return tokens;
  }
}

final authServiceProvider = Provider((ref) => AuthService());
