import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/notifiers/auth.notifier.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/register.dart';
import 'package:mobile/services/auth.service.dart';
import 'package:connectrpc/connect.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() =>
      CupertinoPageRoute(builder: (_) => const LoginPage());

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final svc = ref.read(authServiceProvider);
      try {
        final tokens = await svc.login(_emailCtrl.text, _pwdCtrl.text);
        await ref.read(authNotifierProvider.notifier).login(tokens);
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            HomePage.route(),
            (route) => false,
          );
        }
      } on ConnectException catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sign in'),
      ),
      child: SafeArea(
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(CupertinoIcons.person_crop_circle, size: 96),
                  const SizedBox(height: 32),
                  CupertinoFormSection.insetGrouped(
                    margin: EdgeInsets.zero,
                    children: [
                      CupertinoTextFormFieldRow(
                        controller: _emailCtrl,
                        prefix: const Text('Email'),
                        placeholder: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'Enter a valid email'
                            : null,
                      ),
                      CupertinoTextFormFieldRow(
                        controller: _pwdCtrl,
                        prefix: const Text('Password'),
                        placeholder: '••••••••',
                        obscureText: true,
                        validator: (v) =>
                            (v == null || v.length < 8) ? 'Min 8 chars' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: _submit,
                      child: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      const Text("No account?"),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            Navigator.of(context).push(RegisterPage.route()),
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
