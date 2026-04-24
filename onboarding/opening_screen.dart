import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'introduction_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loaderController;
  late AnimationController _spinController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loaderController, curve: Curves.easeIn),
    );

    // Continuously spinning loader
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _loaderController.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loaderController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Full-screen background image (your swirl/flame art) ──
          Image.asset(
            'assets/images/bg_opening_screen.jpg',
            fit: BoxFit.cover,
          ),

          // ── Centered logo + text + loader ───────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo image (your hand/G logo PNG)
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, child) => Opacity(
                    opacity: _logoOpacity.value,
                    child:
                        Transform.scale(scale: _logoScale.value, child: child),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),

                const SizedBox(height: 14),

                // "GABAY PH" bold white text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, child) => Opacity(
                    opacity: _textOpacity.value,
                    child: Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: child,
                    ),
                  ),
                  child: const Text(
                    'GABAY PH',
                    style: TextStyle(
                      color: Color(0xFF021A54),
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: Color(0x33021A54),
                          blurRadius: 14,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 52),

                // iOS-style radial spinning loader
                AnimatedBuilder(
                  animation: _loaderController,
                  builder: (_, child) =>
                      Opacity(opacity: _loaderOpacity.value, child: child),
                  child: AnimatedBuilder(
                    animation: _spinController,
                    builder: (_, __) => Transform.rotate(
                      angle: _spinController.value * 2 * math.pi,
                      child: const _RadialLoader(size: 38),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// iOS-style 8-spoke radial spinner with opacity fade on each spoke
class _RadialLoader extends StatelessWidget {
  final double size;
  const _RadialLoader({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RadialPainter()),
    );
  }
}

class _RadialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const int spokes = 8;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    for (int i = 0; i < spokes; i++) {
      final angle = (2 * math.pi / spokes) * i - math.pi / 2;
      final opacity = (i + 1) / spokes;
      paint.color =
          const Color(0xFF021A54).withOpacity(opacity.clamp(0.15, 1.0));

      final inner = size.width * 0.22;
      final outer = size.width * 0.46;

      canvas.drawLine(
        Offset(center.dx + inner * math.cos(angle),
            center.dy + inner * math.sin(angle)),
        Offset(center.dx + outer * math.cos(angle),
            center.dy + outer * math.sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RadialPainter old) => false;
}
