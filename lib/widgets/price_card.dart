import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '\$$price',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeature(Icons.bed, '$rooms غرف نوم'),
                _buildFeature(Icons.bathtub, '$bathrooms حمام'),
                _buildFeature(Icons.square_foot, '$area م²'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () async {
                final url = Uri.parse('https://wa.me/$whatsapp');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
              child: const Text("احجز الآن", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Icon(icon, color: AppColors.darkGreen),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(color: AppColors.darkGreen, fontSize: 12)),
        ],
      ),
    );
  }
}
