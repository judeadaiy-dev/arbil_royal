import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  final ImagePicker _picker = ImagePicker();
  
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
  File? _selectedImage;
  
  bool _isLoading = false;
  bool _isUploadingImage = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
      );
      
      if (image!= null) {
        setState(() {
          _selectedImage = File(image.path);
          _isUploadingImage = true;
        });
        
        await _uploadImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في اختيار الصورة: $e', style: GoogleFonts.tajawal()),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    
    try {
      final fileName = 'property_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'properties/$fileName';
      
      await supabase.storage.from('images').upload(
        filePath,
        _selectedImage!,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      
      final imageUrl = supabase.storage.from('images').getPublicUrl(filePath);
      
      if (mounted) {
        setState(() {
          _imageUrl = imageUrl;
          _isUploadingImage = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم رفع الصورة بنجاح', style: GoogleFonts.tajawal()),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل رفع الصورة: $e', style: GoogleFonts.tajawal()),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى رفع صورة للعقار', style: GoogleFonts.tajawal()),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }
    
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
      backgroundColor: AppColors.skyBlueTop,
      appBar: AppBar(
        title: Text('إضافة عقار جديد', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // رفع الصورة
            _buildSectionTitle('صورة العقار *'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _isUploadingImage? null : _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.glassWhite.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _imageUrl.isEmpty? AppColors.errorRed : AppColors.glassBorder,
                    width: 2,
                  ),
                ),
                child: _isUploadingImage
                 ? const Center(child: CircularProgressIndicator(color: AppColors.tealGreen))
                    : _selectedImage!= null
                     ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_rounded, size: 50, color: AppColors.tealGreen),
                              const SizedBox(height: 12),
                              Text(
                                'اضغط لاختيار صورة من الاستوديو',
                                style: GoogleFonts.tajawal(
                                  color: AppColors.darkOliveGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'مطلوبة',
                                style: GoogleFonts.tajawal(
                                  color: AppColors.errorRed,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            if (_imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.successGreen, size: 16),
                    const SizedBox(width: 6),
                    Text('تم رفع الصورة', style: GoogleFonts.tajawal(color: AppColors.successGreen, fontSize: 12)),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickImage,
                      child: Text('تغيير الصورة', style: GoogleFonts.tajawal(color: AppColors.tealGreen)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            
            // باقي الحقول
            _buildTextField(
              label: 'عنوان العقار *',
              validator: (val) => val!.isEmpty? 'مطلوب' : null,
              onSaved: (val) => _title = val!,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'اسم المنطقة - مثلا: شارع 60 *',
              validator: (val) => val!.isEmpty? 'مطلوب' : null,
              onSaved: (val) => _location = val!,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'السعر *',
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty? 'مطلوب' : null,
              onSaved: (val) => _price = double.parse(val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('موقع العقار على الخريطة'),
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
                  child: _buildTextField(
                    label: 'غرف',
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _rooms = int.parse(val?? '0'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'حمامات',
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _bathrooms = int.parse(val?? '0'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'المساحة م²',
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _area = double.parse(val?? '0'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: InputDecoration(
                labelText: 'نوع العقار',
                labelStyle: GoogleFonts.tajawal(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: AppColors.glassWhite.withOpacity(0.7),
              ),
              items: [
                DropdownMenuItem(value: 'house', child: Text('منزل', style: GoogleFonts.tajawal())),
                DropdownMenuItem(value: 'apartment', child: Text('شقة', style: GoogleFonts.tajawal())),
                DropdownMenuItem(value: 'land', child: Text('أرض', style: GoogleFonts.tajawal())),
                DropdownMenuItem(value: 'commercial', child: Text('تجاري', style: GoogleFonts.tajawal())),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text('عقار مميز', style: GoogleFonts.tajawal()),
              value: _isFeatured,
              onChanged: (val) => setState(() => _isFeatured = val!),
              activeColor: AppColors.tealGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: AppColors.glassWhite.withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading || _isUploadingImage? null : _saveProperty,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.tealGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: _isLoading
               ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'حفظ العقار',
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.tajawal(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: AppColors.glassWhite.withOpacity(0.7),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
