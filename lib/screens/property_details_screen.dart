import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final PropertyModel property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // صورة العقار كاملة
          SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  property.imageUrl,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // باقي التفاصيل مع Glassmorphism
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title,
                              style: GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkOliveGrey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${property.price}',
                              style: GoogleFonts.tajawal(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.tealGreen),
                            ),
                            const SizedBox(height: 100), // مساحة للأزرار الثابتة
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // أزرار التواصل ثابتة أسفل الشاشة
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    border: Border(top: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => launchUrl(Uri.parse('https://wa.me/${property.whatsapp}')),
                          icon: const Icon(Icons.chat),
                          label: Text('واتساب', style: GoogleFonts.tajawal()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => launchUrl(Uri.parse('tel:${property.whatsapp}')),
                          icon: const Icon(Icons.call),
                          label: Text('اتصال', style: GoogleFonts.tajawal()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkMatteGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
