import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arbil_royal_app/models/property_model.dart';

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

  // دالة إضافية لجلب الإعدادات (رقم الواتساب، حقوق النشر)
  // مفيدة جداً للتحكم الديناميكي الذي طلبته
  Future<Map<String, dynamic>> getAppSettings() async {
    return await _supabase.from('app_config').select().single();
  }
}
