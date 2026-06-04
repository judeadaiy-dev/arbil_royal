import 'package:arbil_royal_app/main.dart';
import 'package:arbil_royal_app/models/property_model.dart';

class SupabaseService {
  Stream<List<PropertyModel>> getPropertiesStream() {
    return supabase
       .from('properties')
       .stream(primaryKey: ['id'])
       .order('id', ascending: false)
       .map((maps) => maps.map((map) => PropertyModel.fromJson(map)).toList());
  }
}
