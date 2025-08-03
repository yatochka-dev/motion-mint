import 'package:mobile/gen/v1/auth.pb.dart';
import 'package:mobile/models/auth-tokens.dart';
import 'package:mobile/services/auth-storage.service.dart';
import 'package:riverpod/riverpod.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthTokens?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<AuthTokens?> {
  final _storage = SecureStorageService();

  @override
  Future<AuthTokens?> build() async {
    final tokens = await _storage.getTokens();
    if (tokens == null) return null;

    if (tokens.isExpired) {
      await _storage.clear();
      return null;
    }

    return tokens;
  }

  Future<void> login(Tokens grpcTokens) async {
    final tokens = AuthTokens.fromGrpc(
      accessToken: grpcTokens.accessToken,
      expiresAtUnix: grpcTokens.expiresAt.toInt(),
    );

    await _storage.saveTokens(tokens);
    state = AsyncData(tokens);
  }

  Future<void> logout() async {
    await _storage.clear();
    state = const AsyncData(null);
  }
}
