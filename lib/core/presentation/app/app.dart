import 'package:chat_app/chat/presentation/chat_screen.dart';
import 'package:chat_app/splash/presentation/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/auth/presentation/auth_screen.dart';
import 'package:chat_app/core/presentation/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget _buildScreen(BuildContext context, AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SplashScreen();
    }
    if (snapshot.hasData) {
      return const ChatScreen();
    }
    return const AuthScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: AppTheme().theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: _buildScreen,
      ),
    );
  }
}
