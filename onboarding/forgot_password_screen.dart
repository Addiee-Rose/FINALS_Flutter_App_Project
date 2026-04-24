import 'package:flutter/material.dart';
import 'auth_shared.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  static const _navy = Color(0xFF021A54);

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OtpScreen(email: _emailCtrl.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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

            const Text('Forgot Password?🔑',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(
              "Enter your registered email address, and we'll send you an OTP code to reset your password.",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            const FieldLabel('Registered email address'),
            const SizedBox(height: 10),
            FilledField(
              controller: _emailCtrl,
              hint: 'jxxxxxxxxxxx@mail.com',
              keyboardType: TextInputType.emailAddress,
            ),

            const Spacer(),

            NavyButton(label: 'Send OTP Code', onTap: _sendOtp),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}
