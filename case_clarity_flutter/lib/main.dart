import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client.dart';
import 'core/app_frame.dart';
import 'core/theme.dart';
import 'features/authentication/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Case Clarity',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      builder: (context, child) => AppFrame(
        child: child ?? const SizedBox.shrink(),
      ),
      home: const AuthGate(),
    );
  }
}
