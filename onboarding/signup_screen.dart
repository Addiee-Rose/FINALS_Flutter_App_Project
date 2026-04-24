import 'package:flutter/material.dart';
import 'auth_shared.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _agreed = false;
  bool _isLoading = false;

  static const _navy = Color(0xFF021A54);
  static const _pink = Color(0xFFFF85BB);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Email/Password Sign Up ──────────────────────────────
  Future<void> _handleSignUp() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to Terms & Conditions')));
      return;
    }
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password must be at least 6 characters')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      // TODO: Navigate to home screen
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Sign up failed. Please try again.';
      if (e.code == 'email-already-in-use')
        message = 'An account already exists with this email.';
      if (e.code == 'invalid-email') message = 'Invalid email address.';
      if (e.code == 'weak-password') message = 'Password is too weak.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Google Sign Up ──────────────────────────────────────
  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      // TODO: Navigate to home screen
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign up failed: ${e.message}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Back
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back_ios,
                    size: 20, color: Colors.black54),
              ),
              const SizedBox(height: 28),

              // Title
              const Text('Join GabayPH Today!',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, color: _navy)),
              const SizedBox(height: 8),
              Text(
                  'Get personalized study plans and more. Sign Up with your email to get started.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 32),

              // Email
              const FieldLabel('Email'),
              const SizedBox(height: 8),
              UnderlineField(
                controller: _emailCtrl,
                hint: 'Enter email',
                suffixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Password
              const FieldLabel('Password'),
              const SizedBox(height: 8),
              UnderlineField(
                controller: _passwordCtrl,
                hint: 'Enter Password',
                obscure: _obscure,
                suffixIcon: _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixTap: () => setState(() => _obscure = !_obscure),
              ),
              const SizedBox(height: 28),

              // Terms checkbox
              Row(children: [
                GestureDetector(
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      border: Border.all(color: _pink, width: 2),
                      borderRadius: BorderRadius.circular(4),
                      color: _agreed
                          ? _pink.withOpacity(0.12)
                          : Colors.transparent,
                    ),
                    child: _agreed
                        ? const Icon(Icons.check, size: 14, color: _pink)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('I agree to GabayPH Terms & Conditions.',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ]),
              const SizedBox(height: 20),

              // Already have account
              Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Already have an account? ',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const SignInScreen())),
                    child: const Text('Sign in',
                        style: TextStyle(
                            color: _pink,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ]),
              ),
              const SizedBox(height: 28),

              const OrDivider(),
              const SizedBox(height: 20),
              SocialIconsRow(
                onGoogleTap: _handleGoogleSignUp,
              ),
              const SizedBox(height: 40),

              NavyButton(label: 'Sign Up', onTap: _handleSignUp),
              const SizedBox(height: 24),
            ]),
          ),
        ),

        // Loading overlay
        if (_isLoading) _SignUpLoadingOverlay(),
      ]),
    );
  }
}

// ══════════════════════════════════════════════
// SIGN-UP SUCCESS / LOADING OVERLAY
// ══════════════════════════════════════════════
class _SignUpLoadingOverlay extends StatefulWidget {
  @override
  State<_SignUpLoadingOverlay> createState() => _SignUpLoadingOverlayState();
}

class _SignUpLoadingOverlayState extends State<_SignUpLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _spin;
  @override
  void initState() {
    super.initState();
    _spin =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Pink checkmark circle with orbiting dots
            SizedBox(
                width: 110,
                height: 110,
                child: CustomPaint(painter: _CheckCirclePainter())),
            const SizedBox(height: 22),
            const Text('Sign up\nSuccessful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFFF85BB),
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Please wait....',
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 22),
            AnimatedBuilder(
              animation: _spin,
              builder: (_, __) => Transform.rotate(
                angle: _spin.value * math.pi * 2,
                child: const PinkDotSpinner(size: 44),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _CheckCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    const r = 42.0;

    // Pink gradient circle
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFCEE3), Color(0xFFFF85BB)],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, paint);

    // White check
    final cp = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(c.dx - 16, c.dy + 2)
      ..lineTo(c.dx - 4, c.dy + 15)
      ..lineTo(c.dx + 18, c.dy - 14);
    canvas.drawPath(path, cp);

    // Orbiting dots
    final dp = Paint()..color = const Color(0xFFFF85BB);
    for (int i = 0; i < 10; i++) {
      final angle = (i / 10) * math.pi * 2;
      final x = c.dx + (r + 13) * math.cos(angle);
      final y = c.dy + (r + 13) * math.sin(angle);
      canvas.drawCircle(Offset(x, y), i % 3 == 0 ? 5 : 3.5, dp);
    }
  }

  @override
  bool shouldRepaint(_CheckCirclePainter o) => false;
}

class PinkDotSpinner extends StatelessWidget {
  final double size;
  const PinkDotSpinner({required this.size});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size, height: size, child: CustomPaint(painter: PinkDotPainter()));
}

class PinkDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    const count = 10;
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * math.pi * 2 - math.pi / 2;
      final opacity = (i + 1) / count;
      canvas.drawCircle(
        Offset(c.dx + 16 * math.cos(angle), c.dy + 16 * math.sin(angle)),
        2.8,
        Paint()..color = const Color(0xFFFF85BB).withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(PinkDotPainter o) => false;
}
