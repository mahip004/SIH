import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 🔹 import this
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 🔹 use this
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rainwater Harvesting App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.light,
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return userProvider.user == null
                ? const LoginScreen()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
