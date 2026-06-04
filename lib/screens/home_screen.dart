import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';
import '../services/supabase_service.dart';
import '../widgets/property_card.dart';
import '../widgets/price_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      // استبدل الـ AppBar الحالي بهذا الكود:
appBar: AppBar(
  backgroundColor: AppColors.bgLight,
  elevation: 0,
  title: const Row(
    children: [
      Icon(Icons.diamond, color: AppColors.darkGreen),
      SizedBox(width: 8),
      Text('أربيل رويال', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold)),
    ],
  ),
  // لاحظ هنا قمنا بإغلاق الـ Row أعلاه، والآن نضيف الأزرار في actions
  actions: [
    IconButton(onPressed: () => _launchUrl('https://wa.me/9647500000000'), icon: const Icon(Icons.chat, color: AppColors.darkGreen)),
    IconButton(onPressed: () => _launchUrl('https://instagram.com/'), icon: const Icon(Icons.camera_alt, color: AppColors.darkGreen)),
    IconButton(onPressed: () => _launchUrl('https://facebook.com/'), icon: const Icon(Icons.facebook, color: AppColors.darkGreen)),
  ],
),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'فلل وبيوت للبيع في أربيل',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGreen),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'وجهتكم الأولى للعقارات الفاخرة في قلب كوردستان',
                    style: TextStyle(color: AppColors.darkGreen),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            StreamBuilder<List<PropertyModel>>(
              stream: SupabaseService().getPropertiesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final properties = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: properties.length,
                  itemBuilder: (context, index) => PropertyCard(property: properties[index]),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                'جدول الوحدات والأسعار',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGreen),
              ),
            ),
            const PriceCard(price: 145000, area: 200, rooms: 3, bathrooms: 2, whatsapp: '9647500000000'),
            const PriceCard(price: 280000, area: 450, rooms: 5, bathrooms: 4, whatsapp: '9647500000000'),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, color: AppColors.darkGreen),
                  SizedBox(width: 8),
                  Text(
                    'موقعنا في أربيل',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGreen),
                  ),
                ],
              ),
            ),
            _buildMapCard(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://maps.googleapis.com/maps/api/staticmap?center=Erbil&zoom=12&size=600x400&key=YOUR_GOOGLE_MAP_KEY',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(height: 250, color: Colors.grey[300], child: const Center(child: Text('الخريطة'))),
            ),
            ElevatedButton.icon(
              onPressed: () => _launchUrl('https://maps.app.goo.gl/'),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in Maps'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: AppColors.footerBg,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text('أربيل رويال', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            'نحن شركة عقارية رائدة نهدف لتوفير أفضل خيارات السكن في مدينة أربيل بجودة عالية وأسعار منافسة.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text('تواصل معنا', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('العنوان: أربيل - شارع 100 - بناية رويال', style: TextStyle(color: Colors.white70)),
          const Text('هاتف: 0750 000 0000', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          const Text('جميع الحقوق محفوظة © 2026 شركة أربيل رويال للاستثمار العقاري', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw Exception('Could not launch $url');
  }
}
