import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greend/pages/home_screen.dart';
import 'package:greend/pages/account_screen.dart';
import 'package:greend/pages/payment_screen.dart';
import 'package:greend/authentication/login_or_register.dart';
import 'package:greend/themes/theme_provider.dart';
import 'package:greend/ai/chat_screen.dart'; 
import 'package:greend/ai/chat_provider.dart'; 
import 'package:greend/ai/product_provider.dart'; 
import 'package:google_generative_ai/google_generative_ai.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'AIzaSyANzAFn1PPNYnMH0_TTMv-js8aOz4ih_DA',
  );

  if (apiKey.isEmpty) {
    throw Exception("API_KEY is missing! Provide it using --dart-define=API_KEY=your_api_key_here.");
  }

  // Initialize GenerativeModel
  final generativeModel = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()), // ProductProvider
        ChangeNotifierProvider(
          create: (context) => ChatProvider(generativeModel, context.read<ProductProvider>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('username') && prefs.containsKey('password');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'GreenD',
          theme: themeProvider.themeData,
          routes: {
            '/home': (context) => const HomeScreen(),
            '/account': (context) => const AccountScreen(),
            '/payment': (context) => const PaymentScreen(),
            '/aiChat': (context) => const ChatScreen(),
          },
          home: FutureBuilder<bool>(
            future: _isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return snapshot.data == true
                  ? const HomeScreen()
                  : const LoginOrRegister();
            },
          ),
        );
      },
    );
  }
}