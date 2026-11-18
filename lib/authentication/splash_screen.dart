import 'package:flutter/material.dart';
import 'package:ncare/authentication/widgets/splash_background.dart';
import 'package:ncare/authentication/widgets/splash_footer.dart';
import 'package:ncare/authentication/widgets/splash_header.dart';
import 'package:ncare/authentication/widgets/splash_hero_card.dart';
import 'package:ncare/navigation/all_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final AnimationController _progressController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _illustrationSlide;
  late final Animation<double> _illustrationFade;
  late final Animation<double> _bottomFade;
  late final Animation<Offset> _bottomSlide;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Staggered Animations
    _logoFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _illustrationFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
    );

    _illustrationSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _bottomFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.5, 0.95, curve: Curves.easeIn),
    );

    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
    _progressController.forward();

    // Fast navigation to Onboarding screen after 1.3 seconds
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding1);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: h * 0.02),

                // Top Header Brand Section
                SplashHeader(
                  fadeAnimation: _logoFade,
                  scaleAnimation: _logoScale,
                ),

                const Spacer(),

                // Center Hero Card Illustration
                SplashHeroCard(
                  fadeAnimation: _illustrationFade,
                  slideAnimation: _illustrationSlide,
                ),

                const Spacer(),

                // Bottom Tagline & Progress Bar
                SplashFooter(
                  fadeAnimation: _bottomFade,
                  slideAnimation: _bottomSlide,
                  progressController: _progressController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
