import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';
import 'glass_container.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // مسافة بين البطاقات
      child: GlassContainer(
        borderRadius: 40, // زوايا كبيرة جداً
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة العقار - زوايا علوية فقط
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              child: Image.network(
                property.imageUrl,
                height: 240, // نص مساحة البطاقة تقريباً
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    property.title,
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkOliveGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        property.location, 
                        style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey)
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.location_on, size: 18, color: AppColors.darkOliveGrey),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // زر Pill-shaped أخضر تركوازي
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => launchUrl(Uri.parse('https://wa.me/${property.whatsapp}')),
                    child: Text("اتصل للمعاينة", style: GoogleFonts.tajawal(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
