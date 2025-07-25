import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/models/auth-tokens.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(AuthTokens tokens) async {
    final data = tokens.toStorage();
    for (final entry in data.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  Future<AuthTokens?> getTokens() async {
    final access = await _storage.read(key: 'accessToken');
    final refresh = await _storage.read(key: 'refreshToken');
    final expiry = await _storage.read(key: 'expiresAt');

    if (access == null || refresh == null || expiry == null) return null;

    return AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(int.parse(expiry)),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'expiresAt');
  }
}
