import 'package:flutter/material.dart';
import 'package:landlord_tenant/sharedPreferences/adminSharedPreference.dart';
import 'package:landlord_tenant/views/Login/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures that bindings are initialized before you run the app
  await SharedPreferencesManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
    );
  }
}
