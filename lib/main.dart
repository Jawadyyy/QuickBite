import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/screens/splash/splash_screen.dart';
import 'package:restaurant/services/cart_service.dart';
import 'package:restaurant/services/firestore_service.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider<CartService>(create: (_) => CartService()),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: appTheme,
        home: SplashScreen(),
      ),
    );
  }
}
