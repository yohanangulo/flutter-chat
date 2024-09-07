import 'package:flutter/material.dart';

import 'package:chat_app/core/presentation/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/firebase_options.dart';

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}
