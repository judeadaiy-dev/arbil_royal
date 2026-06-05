import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.darkOliveGrey,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.errorRed.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.error_outline, color: AppColors.errorRed, size: 60),
                ),
                const SizedBox(height: 24),
                Text(
                  'حدث خطأ غير متوقع',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      error,
                      style: GoogleFonts.tajawal(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة تشغيل التطبيق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
