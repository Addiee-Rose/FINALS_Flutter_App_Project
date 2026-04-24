import 'package:flutter/material.dart';
import 'auth_shared.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  static const _navy = Color(0xFF021A54);
  static const _pink = Color(0xFFFF85BB);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Email/Password Sign In ──────────────────────────────
  Future<void> _handleSignIn() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      // TODO: Navigate to home screen
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Sign in failed. Please try again.';
      if (e.code == 'user-not-found')
        message = 'No account found with this email.';
      if (e.code == 'wrong-password') message = 'Incorrect password.';
      if (e.code == 'invalid-email') message = 'Invalid email address.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Google Sign In ──────────────────────────────────────
  Future<void> _handleGoogleSignIn() async {
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
          SnackBar(content: Text('Google sign in failed: ${e.message}')));
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
              const Text('Welcome Back!✌️',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Text(
                  'Access your Personalized study plans and continue learning.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 32),

              // Email
              const FieldLabel('Email'),
              const SizedBox(height: 8),
              FilledField(
                controller: _emailCtrl,
                hint: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password
              const FieldLabel('Password'),
              const SizedBox(height: 8),
              FilledField(
                controller: _passwordCtrl,
                hint: 'Password',
                prefixIcon: Icons.lock_outline,
                obscure: _obscure,
                suffixIcon: _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixTap: () => setState(() => _obscure = !_obscure),
              ),
              const SizedBox(height: 20),

              // Remember me + Forgot Password
              Row(children: [
                GestureDetector(
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      border: Border.all(color: _pink, width: 2),
                      borderRadius: BorderRadius.circular(4),
                      color: _rememberMe
                          ? _pink.withOpacity(0.12)
                          : Colors.transparent,
                    ),
                    child: _rememberMe
                        ? const Icon(Icons.check, size: 14, color: _pink)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Remember me', style: TextStyle(fontSize: 13)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen())),
                  child: const Text('Forgot Password ?',
                      style: TextStyle(
                          color: _pink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 24),

              // Don't have account
              Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text("Don't have an account? ",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen())),
                    child: const Text('Sign Up',
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
                onGoogleTap: _handleGoogleSignIn,
              ),
              const SizedBox(height: 40),

              NavyButton(label: 'Sign In', onTap: _handleSignIn),
              const SizedBox(height: 24),
            ]),
          ),
        ),

        // Loading overlay
        if (_isLoading) _SignInLoadingOverlay(),
      ]),
    );
  }
}

class _SignInLoadingOverlay extends StatefulWidget {
  @override
  State<_SignInLoadingOverlay> createState() => _SignInLoadingOverlayState();
}

class _SignInLoadingOverlayState extends State<_SignInLoadingOverlay>
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
      color: Colors.white.withOpacity(0.85),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedBuilder(
            animation: _spin,
            builder: (_, __) => Transform.rotate(
              angle: _spin.value * math.pi * 2,
              child: const PinkDotSpinner(size: 52),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Please wait....',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('You will be directed to the homepage',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ]),
      ),
    );
  }
}
