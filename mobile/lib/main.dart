import 'package:flutter/cupertino.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/notifiers/auth.notifier.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    return auth.when(
      data: (tokens) => CupertinoApp(
        home: tokens == null ? const LoginPage() : const HomePage(),
      ),
      loading: () => const CupertinoApp(
        home: CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator())),
      ),
      error: (_, __) => const CupertinoApp(
        home: CupertinoPageScaffold(child: Center(child: Text('Error'))),
      ),
    );
  }
}
