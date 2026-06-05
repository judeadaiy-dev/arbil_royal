import 'package:flutter/material.dart';

class AppColors {
  // لون الخلفية الموحد - الدرجة الفاتحة المائلة للزرقة من صورك
  static const Color backgroundColor = Color(0xFFE0EBF0);
  static const Color skyBlueTop = Color(0xFFE0F7FA); // للـ Gradient
  static const Color whiteBottom = Color(0xFFFFFFFF); // للـ Gradient
  
  // الألوان الأساسية للعناصر
  static const Color tealGreen = Color(0xFF5DB09E); // لون الأزرار والتفاصيل
  static const Color darkMatteGreen = Color(0xFF4A6564); // النصوص الغامقة
  
  // ألوان الـ Glassmorphism - الشفافية
  static const Color glassWhite = Color(0xCCFFFFFF); // كرت شفاف 80%
  static const Color glassWhiteLight = Color(0xB3FFFFFF); // كرت شفاف 70%
  static const Color glassBorder = Color(0x40FFFFFF); // حواف بيضاء 25%
  static const Color glassShadow = Color(0x1A000000); // ظل خفيف 10%
  
  // ألوان إضافية للنصوص
  static const Color darkOliveGrey = Color(0xFF37474F);
  static const Color greyLight = Color(0xFFB0BEC5);
  static const Color errorRed = Color(0xFFEF5350);
}
