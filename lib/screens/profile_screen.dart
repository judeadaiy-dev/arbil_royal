import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_colors.dart';
import '../main.dart';
import 'admin_panel_screen.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  // غير هذا الإيميل لإيميل الأدمن مالك
  static const String adminEmail = 'barqaday@gmail.com';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? get user => supabase.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.skyBlueTop, AppColors.whiteBottom],
          ),
        ),
        child: SafeArea(
          child: user == null? _buildNotLoggedIn() : _buildLoggedIn(),
        ),
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.tealGreen.withOpacity(0.3), width: 3),
              ),
              child: Icon(Icons.person_outline_rounded, 
                size: 80, color: AppColors.tealGreen.withOpacity(0.7)),
            ),
            const SizedBox(height: 32),
            Text(
              'تصفح بحرية تامة',
              style: GoogleFonts.tajawal(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: AppColors.darkOliveGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'التسجيل مطلوب فقط عند التواصل أو الحجز',
              style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AuthDialog.show(context);
                  if (mounted) setState(() {});
                },
                icon: const Icon(Icons.login),
                label: Text('تسجيل الدخول اختياري', style: GoogleFonts.tajawal(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedIn() {
    final isAdmin = user?.email == ProfileScreen.adminEmail;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        // كرت معلومات المستخدم
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.tealGreen.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.tealGreen, AppColors.darkMatteGreen],
                  ),
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    user!.email![0].toUpperCase(),
                    style: GoogleFonts.tajawal(
                      fontSize: 28, 
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك',
                      style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user!.email!,
                      style: GoogleFonts.tajawal(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkOliveGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // زر لوحة التحكم - يظهر بس للأدمن
        if (isAdmin)
          _buildMenuTile(
            icon: Icons.admin_panel_settings_rounded,
            title: 'لوحتي',
            subtitle: 'إدارة العقارات والمنشورات',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
            ),
          ),
        
        _buildMenuTile(
          icon: Icons.favorite_rounded,
          title: 'المفضلة',
          subtitle: 'العقارات التي أعجبتك',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('قريباً')),
            );
          },
        ),
        
        _buildMenuTile(
          icon: Icons.support_agent_rounded,
          title: 'الدعم الفني',
          subtitle: 'تواصل معنا للمساعدة',
          onTap: () async {
            final url = 'https://wa.me/9647500000000';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
          },
        ),
        
        _buildMenuTile(
          icon: Icons.info_rounded,
          title: 'عن التطبيق',
          subtitle: 'أربيل رويال الإصدار 1.0.0',
          onTap: () {},
        ),
        
        const SizedBox(height: 16),
        
        // زر تسجيل الخروج
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.errorRed),
            title: Text(
              'تسجيل الخروج',
              style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold,
                color: AppColors.errorRed,
              ),
            ),
            onTap: () async {
              await supabase.auth.signOut();
              if (mounted) setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.tealGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.tealGreen, size: 24),
          ),
          title: Text(
            title,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              color: AppColors.darkOliveGrey,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 13),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.greyLight),
          onTap: onTap,
        ),
      ),
    );
  }
}
