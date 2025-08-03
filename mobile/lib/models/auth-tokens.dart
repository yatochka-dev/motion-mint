class AuthTokens {
  final String accessToken;
  final DateTime expiresAt;

  AuthTokens({
    required this.accessToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory AuthTokens.fromGrpc({
    required String accessToken,
    required int expiresAtUnix,
  }) {
    return AuthTokens(
      accessToken: accessToken,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAtUnix * 1000),
    );
  }

  Map<String, String> toStorage() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.millisecondsSinceEpoch.toString(),
  };

  factory AuthTokens.fromStorage(Map<String, String?> map) {
    if (map.values.any((v) => v == null)) throw Exception('Missing token data');
    return AuthTokens(
      accessToken: map['accessToken']!,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['expiresAt']!),
      ),
    );
  }
}
