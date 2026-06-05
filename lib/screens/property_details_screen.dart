import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../main.dart';
import '../models/property_model.dart';
import 'auth_screen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyModel property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  
  Future<void> _contactWhatsApp() async {
    // إذا ما مسجل دخول، طلعله Dialog التسجيل
    if (supabase.auth.currentUser == null) {
      final loggedIn = await AuthDialog.show(context);
      if (!loggedIn ||!mounted) return;
    }
    
    // بعد التسجيل أو إذا مسجل أصلاً، كمل للواتساب
    final message = 'مرحباً، مهتم بالعقار: ${widget.property.title} في ${widget.property.location}';
    final url = 'https://wa.me/${widget.property.whatsapp}?text=${Uri.encodeComponent(message)}';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح واتساب')),
        );
      }
    }
  }

  Future<void> _openMap() async {
    if (widget.property.lat == null || widget.property.lng == null) return;
    
    final url = 'https://www.google.com/maps/search/?api=1&query=${widget.property.lat},${widget.property.lng}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final hasLocation = p.lat!= null && p.lng!= null;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.skyBlueTop, AppColors.whiteBottom],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // صورة + زر رجوع
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.darkOliveGrey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.greyLight,
                      child: const Icon(Icons.home_work, size: 80),
                    ),
                  ),
                ),
              ),
            ),
            
            // التفاصيل
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // السعر + الموقع
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${p.price}',
                                style: GoogleFonts.tajawal(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tealGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18, color: AppColors.greyLight),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      p.location,
                                      style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (p.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.tealGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'مميز',
                              style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // العنوان
                    Text(
                      p.title,
                      style: GoogleFonts.tajawal(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkOliveGrey,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // المواصفات
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSpec(Icons.bed, '${p.rooms}', 'غرف'),
                          _buildSpec(Icons.bathtub_outlined, '${p.bathrooms}', 'حمام'),
                          _buildSpec(Icons.square_foot, '${p.area}', 'م²'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // أزرار الإجراء
                    Row(
                      children: [
                        if (hasLocation)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _openMap,
                              icon: const Icon(Icons.map),
                              label: Text('الخريطة', style: GoogleFonts.tajawal()),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.tealGreen,
                                side: const BorderSide(color: AppColors.tealGreen, width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ),
                        if (hasLocation) const SizedBox(width: 12),
                        Expanded(
                          flex: hasLocation? 1 : 2,
                          child: ElevatedButton.icon(
                            onPressed: _contactWhatsApp,
                            icon: const Icon(Icons.phone_android),
                            label: Text('واتساب', style: GoogleFonts.tajawal(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tealGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpec(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.tealGreen, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkOliveGrey,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }
}
