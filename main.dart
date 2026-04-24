import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/onboarding/opening_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Firebase initialization with web config ──────────────
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCzjgx2W_05CWYE2-wEvIHitGApzSlXZqk",
      authDomain: "gabayph-9441e.firebaseapp.com",
      projectId: "gabayph-9441e",
      storageBucket: "gabayph-9441e.firebasestorage.app",
      messagingSenderId: "95546685310",
      appId: "1:95546685310:web:705949c0f5939f8853e52f",
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const GabayPHApp());
}

class GabayPHApp extends StatelessWidget {
  const GabayPHApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GabayPH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B6FD4),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
