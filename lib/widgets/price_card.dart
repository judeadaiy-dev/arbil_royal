import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'glass_container.dart';

class PriceCard extends StatelessWidget {
  final int price;
  final int area;
  final int rooms;
  final int bathrooms;
  final String whatsapp;

  const PriceCard({
    super.key,
    required this.price,
    required this.area,
    required this.rooms,
    required this.bathrooms,
    required this.whatsapp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GlassContainer(
        borderRadius: 40,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '\$$price',
              style: GoogleFonts.tajawal(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.darkOliveGrey,
              ),
            ),
            const SizedBox(height: 20),
            // ثلاثة مربعات مصفوفة أفقياً
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeature(Icons.square_foot, '$area م²'),
                _buildFeature(Icons.bathtub, '$bathrooms حمام'),
                _buildFeature(Icons.bed, '$rooms غرف نوم'),
              ],
            ),
            const SizedBox(height: 24),
            // زر أخضر غامق - أسفل يمين - زاوية منحنية من جهة واحدة
            Align(
              alignment: Alignment.centerLeft, // يسار لأن RTL
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkMatteGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(8), // منحنية خفيف
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                onPressed: () => launchUrl(Uri.parse('https://wa.me/$whatsapp')),
                child: Text("احجز الآن", style: GoogleFonts.tajawal(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          Icon(icon, color: AppColors.darkOliveGrey, size: 22),
          const SizedBox(height: 6),
          Text(
            text, 
            style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey, fontSize: 13)
          ),
        ],
      ),
    );
  }
}
