import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'providers/event_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_wrapper.dart';
import 'screens/login_screen.dart';
import 'screens/loading_screen.dart';
import 'utils/theme.dart';
import 'utils/db_helper.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Capturer les erreurs globales
  FlutterError.onError = (FlutterErrorDetails details) {
    print('[FlutterError] ❌ ${details.exception}');
    print('[FlutterError] Stack: ${details.stack}');
  };

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('[main] ✅ Firebase initialized successfully');
  } catch (e) {
    print('[main] ❌ Firebase initialization error: $e');
  }

  try {
    await initializeDatabase();
    DatabaseService.setUseMemoryStorage(true);

    await DatabaseService.init();
    print('[main] ✓ Database initialized');

    // Initialiser les notifications
    await NotificationService.instance.initialize();

    await initializeDateFormatting('fr_FR', null);
    print('[main] ✓ App initialization complete');
  } catch (e) {
    print('[main] ❌ Initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) {
          print('[main] Creating new AuthProvider instance');
          return AuthProvider();
        }),
        ChangeNotifierProvider<EventProvider>(create: (_) {
          print('[main] Creating new EventProvider instance');
          return EventProvider();
        }),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, themeProvider, authProvider, child) {
        print('[MyApp] 🔄 Building app - isAuthenticated: ${authProvider.isAuthenticated}');
        
        return MaterialApp(
          title: 'EventEase',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
          ],
          home: _buildHome(authProvider),
        );
      },
    );
  }

  Widget _buildHome(AuthProvider authProvider) {
    // Force afficher l'écran de connexion au démarrage
    // Ceci permet de toujours présenter l'UI de connexion d'abord.
    try {
      print('[MyApp] 🔁 Forcing LoginScreen at startup');
      return const LoginScreen();
    } catch (e) {
      print('[MyApp] ❌ Error building home: $e');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Une erreur s\'est produite'),
              const SizedBox(height: 8),
              Text(e.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Restart app
                  exit(0);
                },
                child: const Text('Redémarrer l\'app'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
