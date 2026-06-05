import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_colors.dart';
import '../main.dart';

class AuthDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _AuthDialogContent(),
    )?? false;
  }
}

class _AuthDialogContent extends StatefulWidget {
  const _AuthDialogContent();

  @override
  State<_AuthDialogContent> createState() => _AuthDialogContentState();
}

class _AuthDialogContentState extends State<_AuthDialogContent> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      if (_isLogin) {
        await supabase.auth.signInWithPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
      } else {
        await supabase.auth.signUp(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context, true); // رجع true = نجح
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message), 
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.tealGreen.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة + زر إغلاق
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.tealGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.lock_person_rounded, 
                      size: 32, color: AppColors.tealGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'سجل دخولك للمتابعة',
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkOliveGrey,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close, color: AppColors.greyLight),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'للتواصل أو الحجز يجب تسجيل الدخول أولاً',
                style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 24),
              
              // إيميل
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.tajawal(),
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  labelStyle: GoogleFonts.tajawal(),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.tealGreen),
                ),
                validator: (v) => 
                  v!.isEmpty ||!v.contains('@')? 'أدخل إيميل صحيح' : null,
              ),
              const SizedBox(height: 16),
              
              // باسوورد
              TextFormField(
                controller: _password,
                obscureText: true,
                style: GoogleFonts.tajawal(),
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: GoogleFonts.tajawal(),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.tealGreen),
                ),
                validator: (v) => 
                  v!.length < 6? '6 أحرف على الأقل' : null,
              ),
              const SizedBox(height: 24),
              
              // زر الدخول
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tealGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading
                     ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isLogin? 'تسجيل الدخول' : 'إنشاء حساب',
                          style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              
              // تبديل تسجيل/دخول
              TextButton(
                onPressed: () => setState(() => _isLogin =!_isLogin),
                child: Text(
                  _isLogin? 'ما عندك حساب؟ سجل الآن' : 'عندك حساب؟ سجل دخول',
                  style: GoogleFonts.tajawal(color: AppColors.tealGreen, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
