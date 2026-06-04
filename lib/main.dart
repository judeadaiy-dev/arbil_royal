import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'core/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(const ArbilRoyalApp());
}

final supabase = Supabase.instance.client;

class ArbilRoyalApp extends StatelessWidget {
  const ArbilRoyalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أربيل رويال',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.tajawalTextTheme(), // هنا التغيير
        scaffoldBackgroundColor: AppColors.bgLight,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const HomeScreen(),
    );
  }
}
