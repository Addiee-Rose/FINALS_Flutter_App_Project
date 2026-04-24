import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _logoAnim;
  late Animation<double> _titleAnim;
  late Animation<double> _buttonsAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );
    _titleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );
    _buttonsAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image (your swirl/dark art) ──────────────
          Image.asset(
            'assets/images/bg_opening_screen.jpg',
            fit: BoxFit.cover,
          ),

          // ── No overlay — background shows through clearly ───────

          // ── Content ─────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 36),

                  // Logo image
                  AnimatedBuilder(
                    animation: _logoAnim,
                    builder: (_, child) => Transform.scale(
                      scale: _logoAnim.value,
                      child: Opacity(
                        opacity: _logoAnim.value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Title + subtitle
                  AnimatedBuilder(
                    animation: _titleAnim,
                    builder: (_, child) => Opacity(
                      opacity: _titleAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, 18 * (1 - _titleAnim.value)),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Let's Get Started",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF021A54),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Let's dive in into your account",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF021A54).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Social + action buttons
                  AnimatedBuilder(
                    animation: _buttonsAnim,
                    builder: (_, child) => Opacity(
                      opacity: _buttonsAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, 28 * (1 - _buttonsAnim.value)),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Social buttons — semi-transparent rounded pills
                        _SocialButton(
                          icon: Icons.apple,
                          label: 'Continue with Apple',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _SocialButton(
                          iconWidget: const _GoogleBadge(),
                          label: 'Continue with Google',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _SocialButton(
                          iconWidget: const _FacebookBadge(),
                          label: 'Continue with Facebook',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _SocialButton(
                          iconWidget: const _XBadge(),
                          label: 'Continue with X',
                          onTap: () {},
                        ),

                        const SizedBox(height: 28),

                        // Sign Up — gradient button
                        _GradientButton(
                          label: 'Sign Up',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SignUpScreen()),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Sign In — transparent outline button
                        _OutlineButton(
                          label: 'Sign in',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SignInScreen()),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      const Color(0xFF021A54).withOpacity(0.7)),
                            ),
                            Text(
                              '  •  ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      const Color(0xFF021A54).withOpacity(0.5)),
                            ),
                            Text(
                              'Terms of Service',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      const Color(0xFF021A54).withOpacity(0.7)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Semi-transparent social button pill
// ─────────────────────────────────────────────
class _SocialButton extends StatefulWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          // White/light pill — matches the screenshot
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF021A54).withOpacity(0.25),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 22),
            SizedBox(
              width: 22,
              height: 22,
              child: widget.iconWidget ??
                  Icon(widget.icon, color: const Color(0xFF021A54), size: 20),
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF021A54),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Gradient Sign Up button
// ─────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF021A54).withOpacity(0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFF021A54),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Outline Sign In button
// ─────────────────────────────────────────────
class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.45),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF021A54).withOpacity(0.2),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFF021A54),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Brand icon badges (white versions for dark bg)
// ─────────────────────────────────────────────
class _GoogleBadge extends StatelessWidget {
  const _GoogleBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _FacebookBadge extends StatelessWidget {
  const _FacebookBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _XBadge extends StatelessWidget {
  const _XBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'X',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
