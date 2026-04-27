import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/score_provider.dart';
import 'providers/checklist_provider.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase may fail if google-services.json is missing; app still runs local features
  }
  await NotificationService.instance.init();
  await NotificationService.instance.scheduleDailyReminder();

  runApp(const RakshaKavachApp());
}

class RakshaKavachApp extends StatelessWidget {
  const RakshaKavachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScoreProvider()..load()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
      ],
      child: MaterialApp(
        title: 'Raksha-Kavach',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0xFFFFC107),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFFC107),
            brightness: Brightness.dark,
            primary: const Color(0xFFFFC107),
            onPrimary: Colors.black,
            surface: Colors.black,
          ),
          textTheme: GoogleFonts.rubikTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Color(0xFFFFC107),
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 64),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
