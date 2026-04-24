import 'package:flutter/material.dart';
import 'dart:math' as math;

// ════════════════════════════════════════════════════
// SHARED AUTH WIDGETS
// Used by: signup_screen, signin_screen,
//          forgot_password_screen, create_new_password_screen,
//          reset_password_success_screen
// ════════════════════════════════════════════════════

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF021A54)));
}

class UnderlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? suffixIcon;
  final bool obscure;
  final TextInputType? keyboardType;
  final VoidCallback? onSuffixTap;
  const UnderlineField(
      {required this.controller,
      required this.hint,
      this.suffixIcon,
      this.obscure = false,
      this.keyboardType,
      this.onSuffixTap});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: Colors.grey[500], size: 20))
            : null,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF021A54), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

class FilledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscure;
  final TextInputType? keyboardType;
  final VoidCallback? onSuffixTap;
  const FilledField(
      {required this.controller,
      required this.hint,
      this.prefixIcon,
      this.suffixIcon,
      this.obscure = false,
      this.keyboardType,
      this.onSuffixTap});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey[400], size: 20)
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: Colors.grey[400], size: 20))
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF021A54), width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Divider(color: Colors.grey[300])),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or continue with',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]))),
      Expanded(child: Divider(color: Colors.grey[300])),
    ]);
  }
}

class SocialIconsRow extends StatelessWidget {
  final VoidCallback onGoogleTap;
  const SocialIconsRow({
    required this.onGoogleTap,
  });
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      // Google
      GestureDetector(
        onTap: onGoogleTap,
        child: SocialIcon(
            child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Center(
                    child: Text('G',
                        style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontSize: 16,
                            fontWeight: FontWeight.bold))))),
      ),
    ]);
  }
}

class SocialIcon extends StatelessWidget {
  final Widget child;
  const SocialIcon({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 56,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[300]!, width: 1.2)),
      child: Center(child: child),
    );
  }
}

class NavyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const NavyButton({required this.label, required this.onTap});
  @override
  State<NavyButton> createState() => NavyButtonState();
}

class NavyButtonState extends State<NavyButton> {
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
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF021A54),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF021A54).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5))
          ],
        ),
        child: Center(
            child: Text(widget.label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700))),
      ),
    );
  }
}
