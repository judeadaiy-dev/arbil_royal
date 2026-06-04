import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';
import '../services/supabase_service.dart';
import '../widgets/property_card.dart';
import '../widgets/price_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. الخلفية المتدرجة حسب الـ Specification
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.skyBlueTop, AppColors.whiteBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // 2. الهيدر: أيقونات يسار + الاسم يمين مع جوهرة
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // الأيقونات على اليسار
          actions: [
            IconButton(
              onPressed: () => _launchUrl('https://wa.me/9647500000000'),
              icon: const Icon(Icons.chat, color: AppColors.darkOliveGrey),
            ),
            IconButton(
              onPressed: () => _launchUrl('https://instagram.com/'),
              icon: const Icon(Icons.camera_alt, color: AppColors.darkOliveGrey),
            ),
            IconButton(
              onPressed: () => _launchUrl('https://facebook.com/'),
              icon: const Icon(Icons.facebook, color: AppColors.darkOliveGrey),
            ),
            const SizedBox(width: 8),
          ],
          // اسم الشركة مع الجوهرة على اليمين
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.diamond, color: AppColors.darkOliveGrey, size: 20),
              const SizedBox(width: 6),
              Text(
                'أربيل رويال',
                style: GoogleFonts.tajawal(
                  color: AppColors.darkOliveGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          // 3. Padding خارجي عشان ما تتداخل العناصر مع الحواف
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'فلل وبيوت للبيع في أربيل',
                style: GoogleFonts.tajawal(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkOliveGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'وجهتكم الأولى للعقارات الفاخرة في قلب كوردستان',
                style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // بطاقات العقارات من Supabase
              StreamBuilder<List<PropertyModel>>(
                stream: SupabaseService().getPropertiesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.tealGreen));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'لا توجد عقارات حالياً',
                      style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey),
                    );
                  }
                  final properties = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: properties.length,
                    itemBuilder: (context, index) => PropertyCard(property: properties[index]),
                  );
                },
              ),
              
              const SizedBox(height: 30),
              Text(
                'جدول الوحدات والأسعار',
                style: GoogleFonts.tajawal(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkOliveGrey,
                ),
              ),
              const SizedBox(height: 20),
              const PriceCard(price: 145000, area: 200, rooms: 3, bathrooms: 2, whatsapp: '9647500000000'),
              const PriceCard(price: 280000, area: 450, rooms: 5, bathrooms: 4, whatsapp: '9647500000000'),
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, color: AppColors.darkOliveGrey),
                  const SizedBox(width: 8),
                  Text(
                    'موقعنا في أربيل',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkOliveGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMapCard(),
              const SizedBox(height: 40),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            'https://maps.googleapis.com/maps/api/staticmap?center=Erbil&zoom=12&size=600x400&key=YOUR_GOOGLE_MAP_KEY',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              height: 250,
              color: Colors.grey[300],
              child: Center(
                child: Text('الخريطة', style: GoogleFonts.tajawal()),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _launchUrl('https://maps.app.goo.gl/'),
            icon: const Icon(Icons.open_in_new),
            label: Text('Open in Maps', style: GoogleFonts.tajawal()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: AppColors.darkOliveGrey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkMatteGreen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Text(
            'أربيل رويال',
            style: GoogleFonts.tajawal(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'نحن شركة عقارية رائدة نهدف لتوفير أفضل خيارات السكن في مدينة أربيل بجودة عالية وأسعار منافسة.',
            style: GoogleFonts.tajawal(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'تواصل معنا',
            style: GoogleFonts.tajawal(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('العنوان: أربيل - شارع 100 - بناية رويال', style: GoogleFonts.tajawal(color: Colors.white70)),
          Text('هاتف: 0750 000 0000', style: GoogleFonts.tajawal(color: Colors.white70)),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'جميع الحقوق محفوظة © 2026 شركة أربيل رويال للاستثمار العقاري',
            style: GoogleFonts.tajawal(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw Exception('Could not launch $url');
  }
}
