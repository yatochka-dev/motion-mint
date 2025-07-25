import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() => CupertinoPageRoute(builder: (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(child: Text('Home')), 
    );
  }
}
