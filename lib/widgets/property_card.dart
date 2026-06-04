import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // 20px rounded
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Glassmorphism
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    property.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text(
                        '\$${property.price}',
                        style: GoogleFonts.tajawal(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkOliveGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18, color: AppColors.darkOliveGrey),
                          const SizedBox(width: 4),
                          Text(
                            property.location,
                            style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Icon-row: Rooms, Bathrooms, Area
                      Row(
                        children: [
                          _buildIconData(Icons.bed_rounded, '${property.rooms}'),
                          const SizedBox(width: 16),
                          _buildIconData(Icons.bathtub_rounded, '${property.bathrooms}'),
                          const SizedBox(width: 16),
                          _buildIconData(Icons.square_foot_rounded, '${property.area} م²'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconData(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.darkOliveGrey),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey, fontSize: 14)),
      ],
    );
  }
}
