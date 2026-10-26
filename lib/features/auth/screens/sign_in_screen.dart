import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_state.dart';
import '../widgets/auth_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await AuthState.instance.setSignedIn(true);
      if (!mounted) return;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Sign In',
      subtitle: 'Welcome back! Please enter your details.',
      children: [
        const SocialButtons(),
        Form(
          key: _formKey,
          child: Column(
            children: [
              AuthField(
                label: 'Email Address',
                hint: 'name@company.com',
                icon: Icons.mail_outline_rounded,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 20),
              AuthField(
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_rounded,
                isPassword: true,
                controller: _password,
                trailingLabel: AuthLink(text: 'Forgot Password?', onTap: () {}),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter your password' : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AuthCheckbox(
          value: _remember,
          onChanged: (v) => setState(() => _remember = v),
          label: const Text('Remember me for 30 days',
              style: TextStyle(color: AuthColors.muted, fontSize: 15)),
        ),
        const SizedBox(height: 24),
        AuthPrimaryButton(label: 'Sign In', onPressed: _submit),
        const SizedBox(height: 24),
        AuthFooter(
          prompt: "Don't have an account?",
          action: 'Sign Up',
          onTap: () => context.go('/sign-up'),
        ),
      ],
    );
  }
}
