import 'package:flutter/cupertino.dart';

import 'package:mobile/services/auth.service.dart';
import 'package:mobile/shared/errors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static Route<void> route() =>
      CupertinoPageRoute(builder: (_) => const RegisterPage());

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _svc = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_pwdCtrl.text != _confirmCtrl.text) {
        showErrorMessage(context, "password_mismatch");

        return;
      }

      final err =
          await _svc.Register(_nameCtrl.text, _emailCtrl.text, _pwdCtrl.text);
      if (err != null) {
        showErrorMessage(context, err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Create account'),
      ),
      child: SafeArea(
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(CupertinoIcons.add_circled_solid, size: 96),
                  const SizedBox(height: 32),
                  CupertinoFormSection.insetGrouped(
                    margin: EdgeInsets.zero,
                    children: [
                      CupertinoTextFormFieldRow(
                        controller: _nameCtrl,
                        prefix: const Text('Name'),
                        placeholder: 'John Appleseed',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
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
                      CupertinoTextFormFieldRow(
                        controller: _confirmCtrl,
                        prefix: const Text('Confirm'),
                        placeholder: '••••••••',
                        obscureText: true,
                        validator: (v) =>
                            (v == null || v.length < 8) ? 'Min 8 chars' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    onPressed: _submit,
                    child: const Text('Create account'),
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
