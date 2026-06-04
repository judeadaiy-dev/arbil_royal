import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/main_screen.dart'; // غيرنا من home_screen إلى main_screen
import 'core/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://jmsmrojtlstppnpwmkkk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptc21yb2p0bHN0cHBucHdta2trIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI4MTg2NDAsImV4cCI6MjA4ODM5NDY0MH0.j7gxr5CvrfvbJJzK_pMwVHiCE2AqpXUTThpeLEBmsos',
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
      // دعم اللغة العربية RTL
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // عربي
        Locale('en', ''), // إنجليزي احتياط
      ],
      locale: const Locale('ar', ''), // افتراضي عربي
      theme: ThemeData(
        textTheme: GoogleFonts.tajawalTextTheme(),
        scaffoldBackgroundColor: AppColors.whiteBottom, // أبيض من الخلفية المتدرجة
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.tealGreen, // أخضر تركوازي من الهوية الجديدة
          brightness: Brightness.light,
        ),
        // ستايل موحد للأزرار
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        // ستايل AppBar موحد
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.tajawal(
            color: AppColors.darkOliveGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: AppColors.darkOliveGrey),
        ),
      ),
      home: const MainScreen(), // صارت MainScreen مو HomeScreen
    );
  }
}
