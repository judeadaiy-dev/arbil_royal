import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/error_screen.dart';
import 'core/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. معالج الأخطاء - يطبع الخطأ على الشاشة بدل الخروج المفاجئ
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorScreen(error: details.exception.toString()));
  };
  
  // 2. معالج أخطاء async
  runZonedGuarded(() async {
    await Supabase.initialize(
      url: 'https://jmsmrojtlstppnpwmkkk.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptc21yb2p0bHN0cHBucHdta2trIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI4MTg2NDAsImV4cCI6MjA4ODM5NDY0MH0.j7gxr5CvrfvbJJzK_pMwVHiCE2AqpXUTThpeLEBmsos',
    );
    
    runApp(const ArbilRoyalApp());
  }, (error, stack) {
    runApp(ErrorScreen(error: error.toString()));
  });
}

final supabase = Supabase.instance.client;

class ArbilRoyalApp extends StatelessWidget {
  const ArbilRoyalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أربيل رويال',
      debugShowCheckedModeBanner: false,
      
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      locale: const Locale('ar', ''),
      
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        primaryColor: AppColors.tealGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.tealGreen,
          primary: AppColors.tealGreen,
          secondary: AppColors.darkMatteGreen,
          surface: AppColors.whiteBottom,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.tajawalTextTheme().apply(
          bodyColor: AppColors.darkOliveGrey,
          displayColor: AppColors.darkOliveGrey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tealGreen,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.tealGreen,
            textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            side: const BorderSide(color: AppColors.tealGreen, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.tealGreen,
            textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
          ),
        ),
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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.glassWhite.withOpacity(0.8),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.glassBorder, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.glassBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.tealGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
          ),
          labelStyle: GoogleFonts.tajawal(color: AppColors.darkOliveGrey),
          hintStyle: GoogleFonts.tajawal(color: AppColors.greyLight),
          prefixIconColor: AppColors.tealGreen,
          suffixIconColor: AppColors.tealGreen,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.glassWhite.withOpacity(0.7),
          selectedColor: AppColors.tealGreen,
          labelStyle: GoogleFonts.tajawal(color: AppColors.darkOliveGrey),
          secondaryLabelStyle: GoogleFonts.tajawal(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.glassBorder, width: 1),
          ),
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkOliveGrey.withOpacity(0.95),
          contentTextStyle: GoogleFonts.tajawal(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          elevation: 10,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white.withOpacity(0.9),
          selectedItemColor: AppColors.tealGreen,
          unselectedItemColor: AppColors.greyLight,
          selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.tealGreen,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.glassWhite.withOpacity(0.8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.glassBorder, width: 1.5),
          ),
          margin: const EdgeInsets.all(8),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.glassBorder,
          thickness: 1,
          space: 1,
        ),
      ),
      
      home: const SplashScreen(),
    );
  }
}
