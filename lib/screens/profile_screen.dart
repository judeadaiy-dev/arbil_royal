import 'package:flutter/material.dart';
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
            Icon(Icons.account_circle_outlined, 
              size: 120, color: AppColors.tealGreen.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(
              'سجل دخولك للوصول لحسابك',
              style: GoogleFonts.tajawal(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: AppColors.darkOliveGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text('تسجيل الدخول', style: GoogleFonts.tajawal(fontSize: 18)),
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
        // كرت معلومات المستخدم
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.tealGreen,
                child: Text(
                  user!.email![0].toUpperCase(),
                  style: GoogleFonts.tajawal(
                    fontSize: 28, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
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
            icon: Icons.admin_panel_settings,
            title: 'لوحتي',
            subtitle: 'إدارة العقارات والمنشورات',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
            ),
          ),
        
        _buildMenuTile(
          icon: Icons.favorite_border,
          title: 'المفضلة',
          subtitle: 'العقارات التي أعجبتك',
          onTap: () {
            // تروح لتبويب المفضلة
          },
        ),
        
        _buildMenuTile(
          icon: Icons.support_agent,
          title: 'الدعم الفني',
          subtitle: 'تواصل معنا للمساعدة',
          onTap: () {
            // واتساب دعم
          },
        ),
        
        _buildMenuTile(
          icon: Icons.info_outline,
          title: 'عن التطبيق',
          subtitle: 'أربيل رويال الإصدار 1.0.0',
          onTap: () {},
        ),
        
        const SizedBox(height: 16),
        
        // زر تسجيل الخروج
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.errorRed),
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
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.tealGreen, size: 28),
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
