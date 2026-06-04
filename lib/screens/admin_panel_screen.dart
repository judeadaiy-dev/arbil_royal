import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../main.dart';
import '../models/property_model.dart';
import 'property_details_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedTab = 0; // 0=قائمة العقارات, 1=إضافة جديد

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.tealGreen,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            children: [
              _buildTabButton('العقارات', 0),
              _buildTabButton('إضافة جديد', 1),
            ],
          ),
        ),
      ),
      body: _selectedTab == 0? const _PropertyListTab() : const _AddPropertyTab(),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected? Colors.white.withOpacity(0.2) : Colors.transparent,
            border: Border(bottom: BorderSide(color: isSelected? Colors.white : Colors.transparent, width: 3)),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(color: Colors.white, fontWeight: isSelected? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}

// تبويب 1: قائمة العقارات مع تعديل/حذف/إخفاء
class _PropertyListTab extends StatefulWidget {
  const _PropertyListTab();

  @override
  State<_PropertyListTab> createState() => _PropertyListTabState();
}

class _PropertyListTabState extends State<_PropertyListTab> {
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شريط بحث + إحصائيات
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو السعر...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
        // قائمة العقارات
        Expanded(
          child: StreamBuilder<List<PropertyModel>>(
            stream: supabase.from('properties').stream(primaryKey: ['id']).map((maps) => maps.map(PropertyModel.fromJson).toList()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              var properties = snapshot.data!;
              if (_searchQuery.isNotEmpty) {
                properties = properties.where((p) => 
                  p.title.contains(_searchQuery) || p.price.toString().contains(_searchQuery)
                ).toList();
              }
              return ListView.builder(
                itemCount: properties.length,
                itemBuilder: (context, index) => _buildAdminPropertyTile(properties[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminPropertyTile(PropertyModel p) {
    return Dismissible(
      key: Key(p.id.toString()),
      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
      confirmDismiss: (dir) async => await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('حذف العقار؟', style: GoogleFonts.tajawal()),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
      onDismissed: (_) => supabase.from('properties').delete().eq('id', p.id),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(p.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(p.title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        subtitle: Text('\$${p.price} - ${p.location}', style: GoogleFonts.tajawal()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(p.isFeatured? Icons.star : Icons.star_border, color: Colors.amber),
              onPressed: () => supabase.from('properties').update({'is_featured':!p.isFeatured}).eq('id', p.id),
            ),
            IconButton(
              icon: Icon(p.isActive? Icons.visibility : Icons.visibility_off),
              onPressed: () => supabase.from('properties').update({'is_active':!p.isActive}).eq('id', p.id),
            ),
          ],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailsScreen(property: p))),
      ),
    );
  }
}

// تبويب 2: إضافة عقار جديد - نفس الكود اللي عطيتك قبل + تعديلات
class _AddPropertyTab extends StatefulWidget {
  const _AddPropertyTab();

  @override
  State<_AddPropertyTab> createState() => _AddPropertyTabState();
}

class _AddPropertyTabState extends State<_AddPropertyTab> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _image = TextEditingController();
  final _price = TextEditingController();
  final _rooms = TextEditingController();
  final _bathrooms = TextEditingController();
  final _area = TextEditingController();
  final _whatsapp = TextEditingController();
  final _url = TextEditingController();
  LatLng? _selectedLocation;
  bool _isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _field(_title, 'عنوان العقار'),
            _field(_location, 'المدينة - إذا كتبت أربيل يتفعل الموقع تلقائياً'),
            _field(_image, 'رابط الصورة'),
            _field(_price, 'السعر', isNumber: true),
            Row(children: [
              Expanded(child: _field(_rooms, 'غرف النوم', isNumber: true)),
              const SizedBox(width: 12),
              Expanded(child: _field(_bathrooms, 'الحمامات', isNumber: true)),
            ]),
            _field(_area, 'المساحة م²', isNumber: true),
            _field(_whatsapp, 'رقم واتساب'),
            const SizedBox(height: 16),
            Text('حدد الموقع على الخريطة', style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.tealGreen)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(36.1911, 44.0091), zoom: 12),
                  onTap: (latLng) => setState(() => _selectedLocation = latLng),
                  markers: _selectedLocation!= null? {Marker(markerId: const MarkerId('s'), position: _selectedLocation!)} : {},
                ),
              ),
            ),
            const SizedBox(height: 12),
            _field(_url, 'رابط Google Maps اختياري'),
            SwitchListTile(
              title: Text('عقار مميز؟', style: GoogleFonts.tajawal()),
              value: _isFeatured,
              onChanged: (val) => setState(() => _isFeatured = val),
              activeColor: AppColors.tealGreen,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _publish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkMatteGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text('نشر العقار', style: GoogleFonts.tajawal(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        validator: (v) => v!.isEmpty? 'مطلوب' : null,
      ),
    );
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;
    
    // إذا كتب أربيل وما حدد موقع، نحط إحداثيات أربيل تلقائياً
    double? lat = _selectedLocation?.latitude;
    double? lng = _selectedLocation?.longitude;
    if ((lat == null || lng == null) && _location.text.contains('أربيل')) {
      lat = 36.1911;
      lng = 44.0091;
    }

    await supabase.from('properties').insert({
      'title': _title.text,
      'location': _location.text,
      'image_url': _image.text,
      'price': int.parse(_price.text),
      'rooms': int.parse(_rooms.text),
      'bathrooms': int.parse(_bathrooms.text),
      'area': int.parse(_area.text),
      'whatsapp': _whatsapp.text,
      'lat': lat,
      'lng': lng,
      'address_url': _url.text.isEmpty? null : _url.text,
      'is_featured': _isFeatured,
      'is_active': true,
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم النشر')));
      _formKey.currentState!.reset();
      setState(() => _selectedLocation = null);
    }
  }
}
