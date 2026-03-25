import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => setState(() => _animateIn = true));
    _timer = Timer(const Duration(milliseconds: 1300), widget.onFinished);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFF5E9DA), Color(0xFFEED9C1)],
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _animateIn ? 1 : 0,
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: _animateIn ? 1 : 0.9,
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutBack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child:
                        const Icon(Icons.local_cafe_rounded, color: AppColors.primary, size: 46),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Qhawtak',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
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
