import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<PropertyModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final response = await supabase
          .from('properties')
          .select()
          .eq('is_featured', true)
          .limit(10);

      if (mounted) {
        setState(() {
          _favorites = response.map((json) => PropertyModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.skyBlueTop,
      appBar: AppBar(
        title: Text(
          'حسابي',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.tealGreen))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // كارد البروفايل
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.glassBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glassShadow,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.tealGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tealGreen.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.email ?? 'مستخدم',
                        style: GoogleFonts.tajawal(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkOliveGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'عضو منذ 2024',
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: AppColors.greyLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // الإعدادات
                _buildSectionTitle('الإعدادات'),
                const SizedBox(height: 12),
                _buildMenuItem(Icons.notifications_rounded, 'الإشعارات', () {}),
                _buildMenuItem(Icons.language_rounded, 'اللغة', () {}),
                _buildMenuItem(Icons.dark_mode_rounded, 'الوضع الليلي', () {}),
                const SizedBox(height: 24),
                
                // العقارات المفضلة
                _buildSectionTitle('العقارات المفضلة'),
                const SizedBox(height: 12),
                if (_favorites.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.favorite_border, size: 50, color: AppColors.greyLight),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد عقارات مفضلة',
                          style: GoogleFonts.tajawal(color: AppColors.greyLight),
                        ),
                      ],
                    ),
                  )
                else
                  ..._favorites.map((property) => _buildFavoriteCard(property)),
                
                const SizedBox(height: 24),
                
                // تسجيل الخروج
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout, color: AppColors.errorRed),
                    label: Text(
                      'تسجيل الخروج',
                      style: GoogleFonts.tajawal(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.errorRed, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkMatteGreen,
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.glassWhite.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.tealGreen),
        title: Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.greyLight),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFavoriteCard(PropertyModel property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glassWhite.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              property.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: AppColors.greyLight.withOpacity(0.3),
                child: const Icon(Icons.home_work, color: AppColors.tealGreen),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkOliveGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${property.price.toStringAsFixed(0)}',
                  style: GoogleFonts.tajawal(
                    color: AppColors.tealGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
