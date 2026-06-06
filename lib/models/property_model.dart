import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  Future<void> _openDirections() async {
    if (property.latitude == null || property.longitude == null) {
      return;
    }
    
    final url = 'https://www.google.com/maps/search/?api=1&query=${property.latitude},${property.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callAgent() async {
    const phoneNumber = 'tel:+9647500000000';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    }
  }

  Future<void> _whatsappAgent() async {
    const whatsappUrl = 'https://wa.me/9647500000000';
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: property.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.greyLight.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.tealGreen),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.greyLight.withOpacity(0.3),
                      child: const Icon(Icons.home_work, size: 80, color: AppColors.tealGreen),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.tealGreen,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tealGreen.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        '\$${property.price.toStringAsFixed(0)}',
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    property.title,
                    style: GoogleFonts.tajawal(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkOliveGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // الموقع
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: AppColors.greyLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          property.location,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // المواصفات
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSpecItem(Icons.bed_rounded, '${property.rooms}', 'غرف'),
                        _buildDivider(),
                        _buildSpecItem(Icons.bathtub_rounded, '${property.bathrooms}', 'حمامات'),
                        _buildDivider(),
                        _buildSpecItem(Icons.square_foot_rounded, '${property.area.toStringAsFixed(0)}', 'م²'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // الوصف
                  Text(
                    'الوصف',
                    style: GoogleFonts.tajawal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkOliveGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'عقار مميز في موقع استراتيجي بمدينة أربيل. يتميز بتصميم عصري وتشطيبات عالية الجودة. قريب من جميع الخدمات والمرافق الأساسية. مناسب للسكن العائلي أو الاستثمار.',
                    style: GoogleFonts.tajawal(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // المميزات
                  Text(
                    'المميزات',
                    style: GoogleFonts.tajawal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkOliveGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFeatureChip('موقف سيارات'),
                      _buildFeatureChip('حديقة'),
                      _buildFeatureChip('أمن 24/7'),
                      _buildFeatureChip('مكيف مركزي'),
                      _buildFeatureChip('مطبخ مجهز'),
                      _buildFeatureChip('إطلالة مميزة'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // زر الاتجاهات
                  if (property.latitude!= null && property.longitude!= null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openDirections,
                        icon: const Icon(Icons.directions),
                        label: const Text('الاتجاهات على الخريطة'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.tealGreen, width: 2),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  
                  // أزرار الاتصال
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _callAgent,
                          icon: const Icon(Icons.phone),
                          label: const Text('اتصال'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _whatsappAgent,
                          icon: const Icon(Icons.message),
                          label: const Text('واتساب'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.tealGreen),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkOliveGrey,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.glassBorder,
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tealGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.tealGreen.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.tealGreen),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.tajawal(
              color: AppColors.tealGreen,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
