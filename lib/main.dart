import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/gift.dart';
import 'models/recipient.dart';
import 'models/user.dart';
import 'models/gift_suggestion.dart';
import 'screens/login_screen.dart';
import 'services/gift_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(GiftAdapter());
  Hive.registerAdapter(RecipientAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(GiftSuggestionAdapter());

  // Open Hive boxes
  await Hive.openBox<Gift>('gifts');
  await Hive.openBox<Recipient>('recipients');
  await Hive.openBox<User>('users');
  await Hive.openBox<GiftSuggestion>('gift_suggestions');

  // Seed initial gift data
  final giftService = GiftService();
  await giftService.seedInitialData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gift Finder',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
