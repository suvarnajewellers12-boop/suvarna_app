import 'dart:async';
import 'package:flutter/material.dart';
import 'auth_choice_screen.dart';
import '../core/session_manager.dart';
import '../features/auth/presentation/mpin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // CHANGED: 3s → 2s
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(
          parent: _mainController,
          curve: Curves.easeOutCubic,
        ));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ));

    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
        ));

    _mainController.forward();

    // CHANGED: 3s → 2s
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final isLoggedIn = await SessionManager.isLoggedIn();

      if (isLoggedIn) {
        final username = await SessionManager.getUsername();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MPinScreen(
              mode: MPinMode.verify,
              username: username ?? '',
            ),
          ),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AuthChoiceScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  Widget _buildShimmer() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1, 0),
              end: const Alignment(1, 0),
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.4),
                Colors.transparent,
              ],
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Image.asset('assets/images/suvarna_logo.png', width: 120),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBDD),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.85),
              ),
              child: _buildShimmer(),
            ),
          ),
        ),
      ),
    );
  }
}