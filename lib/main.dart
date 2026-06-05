import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/main_screen.dart';
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
        Locale('ar', ''),
        Locale('en', ''),
      ],
      locale: const Locale('ar', ''),
      
      // الثيم الكامل بتصميم Glassmorphism
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        
        // ألوان الهوية
        primaryColor: AppColors.tealGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.tealGreen,
          primary: AppColors.tealGreen,
          secondary: AppColors.darkMatteGreen,
          surface: AppColors.whiteBottom,
          brightness: Brightness.light,
        ),
        
        // خط Tajawal لكل التطبيق
        textTheme: GoogleFonts.tajawalTextTheme().apply(
          bodyColor: AppColors.darkOliveGrey,
          displayColor: AppColors.darkOliveGrey,
        ),
        
        // ستايل الأزرار المرتفعة - زجاجي
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tealGreen,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            elevation: 0,
            shadowColor: AppColors.tealGreen.withOpacity(0.4),
          ),
        ),
        
        // ستايل الأزرار الخارجية
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.tealGreen,
            textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(color: AppColors.tealGreen, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        
        // ستايل AppBar شفاف
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
        
        // ستايل حقول الإدخال زجاجي
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
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          ),
          labelStyle: GoogleFonts.tajawal(color: AppColors.darkOliveGrey),
          hintStyle: GoogleFonts.tajawal(color: AppColors.greyLight),
          prefixIconColor: AppColors.tealGreen,
        ),
        
        // ستايل الـ Chips للفلاتر - زجاجي
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
          pressElevation: 2,
        ),
        
        // ستايل SnackBar زجاجي
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
        
        // ستايل BottomNavigationBar زجاجي
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white.withOpacity(0.9),
          selectedItemColor: AppColors.tealGreen,
          unselectedItemColor: AppColors.greyLight,
          selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        
        // ستايل Dialog زجاجي
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        
        // ستايل FloatingActionButton
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.tealGreen,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          ),
        ),
      ),
      
      home: const MainScreen(),
    );
  }
}
