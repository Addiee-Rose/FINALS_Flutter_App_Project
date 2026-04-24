import 'package:flutter/material.dart';
import 'auth_shared.dart';
import 'reset_password_success_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});
  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  static const _navy = Color(0xFF021A54);

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_newPassCtrl.text.isEmpty || _confirmPassCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in both fields')));
      return;
    }
    if (_newPassCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ResetPasswordSuccessScreen()),
      (route) => false,
    );
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
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios,
                  size: 20, color: Colors.black54),
            ),
            const SizedBox(height: 28),

            const Text('Secure Your Account🔒',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(
                "Enter Your new password below. Make sure it's strong and secure !",
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            const SizedBox(height: 32),

            // New password
            const FieldLabel('Create new password'),
            const SizedBox(height: 10),
            FilledField(
              controller: _newPassCtrl,
              hint: '••••••••••••',
              obscure: _obscureNew,
              suffixIcon: _obscureNew
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixTap: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 20),

            // Confirm password
            const FieldLabel('Confirm new password'),
            const SizedBox(height: 10),
            FilledField(
              controller: _confirmPassCtrl,
              hint: '••••••••••••',
              obscure: _obscureConfirm,
              suffixIcon: _obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixTap: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            const Spacer(),
            NavyButton(label: 'Save New Password', onTap: _save),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}
