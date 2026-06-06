import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../main.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();
  
  String _title = '';
  String _location = '';
  double _price = 0;
  int _rooms = 0;
  int _bathrooms = 0;
  double _area = 0;
  String _type = 'house';
  String _imageUrl = '';
  bool _isFeatured = false;
  
  LatLng _selectedLocation = const LatLng(36.1911, 44.0091);
  bool _isLoading = false;

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await supabase.from('properties').insert({
        'title': _title,
        'location': _location,
        'price': _price,
        'rooms': _rooms,
        'bathrooms': _bathrooms,
        'area': _area,
        'type': _type,
        'image_url': _imageUrl,
        'is_featured': _isFeatured,
        'latitude': _selectedLocation.latitude,
        'longitude': _selectedLocation.longitude,
        'is_active': true,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إضافة العقار بنجاح', style: GoogleFonts.tajawal()),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e', style: GoogleFonts.tajawal()),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة عقار جديد')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'عنوان العقار'),
              validator: (val) => val!.isEmpty? 'مطلوب' : null,
              onSaved: (val) => _title = val!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'اسم المنطقة - مثلا: شارع 60'),
              validator: (val) => val!.isEmpty? 'مطلوب' : null,
              onSaved: (val) => _location = val!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'السعر'),
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty? 'مطلوب' : null,
              onSaved: (val) => _price = double.parse(val!),
            ),
            const SizedBox(height: 24),
            Text(
              'اضغط على الخريطة لتحديد موقع العقار:',
              style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.glassBorder, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 13.0,
                    onTap: (tapPosition, point) {
                      setState(() => _selectedLocation = point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.arbilroyal.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.errorRed,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'الإحداثيات: ${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}',
              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'غرف'),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _rooms = int.parse(val?? '0'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'حمامات'),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _bathrooms = int.parse(val?? '0'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'المساحة م²'),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _area = double.parse(val?? '0'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'رابط الصورة'),
              onSaved: (val) => _imageUrl = val!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'نوع العقار'),
              items: const [
                DropdownMenuItem(value: 'house', child: Text('منزل')),
                DropdownMenuItem(value: 'apartment', child: Text('شقة')),
                DropdownMenuItem(value: 'land', child: Text('أرض')),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text('عقار مميز', style: GoogleFonts.tajawal()),
              value: _isFeatured,
              onChanged: (val) => setState(() => _isFeatured = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading? null : _saveProperty,
              child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('حفظ العقار'),
            ),
          ],
        ),
      ),
    );
  }
}
