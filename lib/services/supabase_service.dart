import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/property_model.dart';

class SupabaseService {
  // استخدام الـ client المعرف مسبقاً في التطبيق
  final SupabaseClient _supabase = Supabase.instance.client;

  // دالة جلب العقارات (جاهزة للعمل فور ربطها بجدول 'properties')
  Stream<List<PropertyModel>> getPropertiesStream() {
    return _supabase
        .from('properties')
        .stream(primaryKey: ['id'])
        .order('id', ascending: false) // الأحدث أولاً
        .map((maps) => maps.map((map) => PropertyModel.fromJson(map)).toList());
  }

  // دالة جلب العقارات المميزة
  Future<List<PropertyModel>> getFeaturedProperties() async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('is_active', true)
          .eq('is_featured', true)
          .order('created_at', ascending: false)
          .limit(10);

      return response.map((json) => PropertyModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل في جلب العقارات المميزة: $e');
    }
  }

  // دالة إضافية لجلب الإعدادات (رقم الواتساب، حقوق النشر)
  // مفيدة جداً للتحكم الديناميكي الذي طلبته
  Future<Map<String, dynamic>> getAppSettings() async {
    return await _supabase.from('app_config').select().single();
  }

  // إضافة عقار جديد - للأدمن
  Future<void> addProperty(PropertyModel property) async {
    try {
      await _supabase.from('properties').insert(property.toJson());
    } catch (e) {
      throw Exception('فشل في إضافة العقار: $e');
    }
  }

  // تحديث عقار - للأدمن
  Future<void> updateProperty(int id, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from('properties')
          .update(data)
          .eq('id', id);
    } catch (e) {
      throw Exception('فشل في تحديث العقار: $e');
    }
  }
}
