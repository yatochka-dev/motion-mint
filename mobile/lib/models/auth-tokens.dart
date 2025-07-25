class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory AuthTokens.fromGrpc({
    required String accessToken,
    required String refreshToken,
    required int expiresAtUnix,
  }) {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAtUnix * 1000),
    );
  }

  Map<String, String> toStorage() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt.millisecondsSinceEpoch.toString(),
  };

  factory AuthTokens.fromStorage(Map<String, String?> map) {
    if (map.values.any((v) => v == null)) throw Exception('Missing token data');
    return AuthTokens(
      accessToken: map['accessToken']!,
      refreshToken: map['refreshToken']!,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['expiresAt']!),
      ),
    );
  }
}
