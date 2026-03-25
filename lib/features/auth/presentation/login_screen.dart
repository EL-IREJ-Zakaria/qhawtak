import 'package:flutter/material.dart';
import 'package:qhawtak/shared/widgets/animated_network_image.dart';
import 'package:qhawtak/shared/widgets/qhawtak_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'owner@qhawtak.com');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => setState(() => _animateIn = true));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _animateIn ? 1 : 0),
              duration: const Duration(milliseconds: 340),
              curve: Curves.easeOutCubic,
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value.clamp(0, 1),
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 24),
                    child: child,
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const AnimatedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80',
                            height: 140,
                            borderRadius: 16,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Admin Login',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          const Text('Sign in to manage live coffee orders.'),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) return 'Email is required';
                              if (!value.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                            validator: (String? value) {
                              if (value == null || value.length < 6) return 'Minimum 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          QhawtakButton(label: 'Sign In', onPressed: _submit),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot password?'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
