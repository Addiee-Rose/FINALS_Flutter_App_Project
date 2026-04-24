import 'package:flutter/material.dart';
import 'auth_shared.dart';
import 'signin_screen.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

  static const _navy = Color(0xFF021A54);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(children: [
            // Status bar spacer
            const SizedBox(height: 20),

            const Spacer(),

            // Pink circle with phone icon
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFCEE3), Color(0xFFFF85BB)],
                  radius: 0.85,
                ),
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phone notch
                      Container(
                        width: 28,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Person icon inside phone
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFCEE3),
                        ),
                        child: const Icon(Icons.person,
                            size: 18, color: Color(0xFFFF85BB)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text("You're All Set !",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text('Your password has been updated.',
                style: TextStyle(fontSize: 14, color: Colors.grey[500])),

            const Spacer(),

            // Thin divider line
            Divider(color: Colors.grey[200], thickness: 1),
            const SizedBox(height: 16),

            NavyButton(
              label: 'Sign in',
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}
