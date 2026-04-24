import 'package:flutter/material.dart';
import 'dart:async';
import 'create_new_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // 4-digit OTP slots
  final List<String> _digits = ['', '', '', ''];
  int _focusedIndex = 0;
  int _secondsLeft = 60;
  Timer? _timer;
  bool _canResend = false;

  static const _navy = Color(0xFF021A54);
  static const _pink = Color(0xFFFF85BB);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _onDigitTap(String digit) {
    if (_focusedIndex >= 4) return;
    setState(() {
      _digits[_focusedIndex] = digit;
      if (_focusedIndex < 3) _focusedIndex++;
    });
    // Auto-verify when all 4 filled
    if (_digits.every((d) => d.isNotEmpty)) {
      _verify();
    }
  }

  void _onBackspace() {
    setState(() {
      if (_digits[_focusedIndex].isNotEmpty) {
        _digits[_focusedIndex] = '';
      } else if (_focusedIndex > 0) {
        _focusedIndex--;
        _digits[_focusedIndex] = '';
      }
    });
  }

  void _verify() {
    final otp = _digits.join();
    // In a real app: verify otp with backend
    // For demo we accept any 4-digit code
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CreateNewPasswordScreen()));
  }

  void _resend() {
    if (!_canResend) return;
    setState(() {
      _digits.fillRange(0, 4, '');
      _focusedIndex = 0;
    });
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP code resent to your email')));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // ── Scrollable top content ─────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios,
                          size: 20, color: Colors.black54),
                    ),
                    const SizedBox(height: 28),

                    const Text('Enter OTP Code🔐',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(
                      "We've sent a one-time password (OTP) to your email. Enter it below to verify your account.",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 36),

                    // ── 4 OTP boxes ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (i) {
                        final isFocused = i == _focusedIndex;
                        final isFilled = _digits[i].isNotEmpty;
                        return GestureDetector(
                          onTap: () => setState(() => _focusedIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isFocused ? _pink : Colors.grey[300]!,
                                width: isFocused ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _digits[i].isEmpty
                                    ? (isFocused ? '' : '_')
                                    : _digits[i],
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: isFilled
                                      ? Colors.black
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // Countdown + resend
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        children: [
                          const TextSpan(text: 'You can resend the code in '),
                          TextSpan(
                            text: '$_secondsLeft seconds',
                            style: const TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _resend,
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                          color: _canResend ? _pink : Colors.grey[400],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),

          // ── Custom number pad ────────────────────────────────────
          Container(
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(children: [
              _buildNumRow(['1', '2', '3']),
              _buildNumRow(['4', '5', '6']),
              _buildNumRow(['7', '8', '9']),
              _buildNumRow(['*', '0', '⌫']),
              const SizedBox(height: 8),
              // Home indicator
              Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildNumRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys
          .map((k) => _NumKey(
                label: k,
                onTap: () {
                  if (k == '⌫') {
                    _onBackspace();
                  } else if (k != '*') {
                    _onDigitTap(k);
                  }
                },
              ))
          .toList(),
    );
  }
}

class _NumKey extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NumKey({required this.label, required this.onTap});
  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> {
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
        duration: const Duration(milliseconds: 80),
        width: 100,
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: _pressed ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
