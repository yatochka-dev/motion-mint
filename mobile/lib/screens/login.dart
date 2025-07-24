import 'package:flutter/cupertino.dart';
import 'package:mobile/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() =>
      CupertinoPageRoute(builder: (_) => const LoginPage());

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: wire to auth backend
      print('login with ${_emailCtrl.text}');
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
