import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_theme.dart';
import 'package:qhawtak/features/auth/presentation/login_screen.dart';
import 'package:qhawtak/features/home/presentation/admin_home_shell.dart';
import 'package:qhawtak/features/splash/presentation/splash_screen.dart';

void main() {
  runApp(const QhawtakApp());
}

enum _AppStage { splash, login, home }

class QhawtakApp extends StatefulWidget {
  const QhawtakApp({super.key});

  @override
  State<QhawtakApp> createState() => _QhawtakAppState();
}

class _QhawtakAppState extends State<QhawtakApp> {
  _AppStage _stage = _AppStage.splash;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qhawtak Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: switch (_stage) {
        _AppStage.splash => SplashScreen(
            onFinished: () => setState(() => _stage = _AppStage.login),
          ),
        _AppStage.login => LoginScreen(
            onLoginSuccess: () => setState(() => _stage = _AppStage.home),
          ),
        _AppStage.home => AdminHomeShell(
            onLogout: () => setState(() => _stage = _AppStage.login),
          ),
      },
    );
  }
}
