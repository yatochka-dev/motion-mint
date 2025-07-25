import 'package:mobile/gen/v1/auth.pb.dart';
import 'package:mobile/models/auth-tokens.dart';
import 'package:mobile/services/auth-storage.service.dart';
import 'package:mobile/services/auth.service.dart';
import 'package:riverpod/riverpod.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthTokens?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<AuthTokens?> {
  final _storage = SecureStorageService();

  @override
  Future<AuthTokens?> build() async {
    final tokens = await _storage.getTokens();
    if (tokens == null) return null;

    if (tokens.isExpired) {
      final refreshed = await _refreshToken(tokens.refreshToken);
      if (refreshed != null) {
        await _storage.saveTokens(refreshed);
        return refreshed;
      }
      await _storage.clear();
      return null;
    }

    return tokens;
  }

  Future<void> login(Tokens grpcTokens) async {
    final tokens = AuthTokens.fromGrpc(
      accessToken: grpcTokens.accessToken,
      refreshToken: grpcTokens.refreshToken,
      expiresAtUnix: grpcTokens.expiresAt.toInt(),
    );

    await _storage.saveTokens(tokens);
    state = AsyncData(tokens);
  }

  Future<void> logout() async {
    try {
      final svc = ref.read(authServiceProvider);
      await svc.logout();
    } catch (_) {}
    await _storage.clear();
    state = const AsyncData(null);
  }

  Future<AuthTokens?> _refreshToken(String refreshToken) async {
    try {
      final svc = ref.read(authServiceProvider);
      final newTokens = await svc.refresh(refreshToken);
      return AuthTokens.fromGrpc(
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
        expiresAtUnix: newTokens.expiresAt.toInt(),
      );
    } catch (_) {
      return null;
    }
  }
}
