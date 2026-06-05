import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../main.dart';
import '../models/property_model.dart';
import 'property_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<PropertyModel> _properties = [];
  bool _isLoading = true;
  PropertyModel? _selectedProperty;
  String _selectedFilter = 'الكل';

  // إحداثيات أربيل - وسط المدينة
  static const LatLng _erbilCenter = LatLng(36.1911, 44.0091);
  final List<String> _filters = ['الكل', 'منازل', 'شقق', 'أراضي'];

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      final response = await supabase
         .from('properties')
         .select()
         .eq('is_active', true)
         .not('latitude', 'is', null)
         .not('longitude', 'is', null);

      if (mounted) {
        setState(() {
          _properties = response.map((json) => PropertyModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل العقارات: $e', style: GoogleFonts.tajawal()),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  List<PropertyModel> get _filteredProperties {
    if (_selectedFilter == 'الكل') return _properties;
    String dbType = _selectedFilter;
    if (_selectedFilter == 'منازل') dbType = 'house';
    if (_selectedFilter == 'شقق') dbType = 'apartment';
    if (_selectedFilter == 'أراضي') dbType = 'land';
    return _properties.where((p) => p.type == dbType).toList();
  }

  Future<void> _openDirections(PropertyModel property) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${property.latitude},${property.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكن فتح الخرائط', style: GoogleFonts.tajawal())),
        );
      }
    }
  }

  void _showPropertyBottomSheet(PropertyModel property) {
    setState(() => _selectedProperty = property);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassWhite.withOpacity(0.95),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.glassBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.tealGreen.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      property.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.greyLight.withOpacity(0.3),
                        child: const Icon(Icons.home_work, color: AppColors.tealGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkOliveGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: AppColors.greyLight),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property.location,
                                style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '\$${property.price}',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealGreen,
                    ),
                  ),
                  const Spacer(),
                  _buildSpec(Icons.bed_rounded, '${property.rooms}'),
                  const SizedBox(width: 12),
                  _buildSpec(Icons.bathtub_rounded, '${property.bathrooms}'),
                  const SizedBox(width: 12),
                  _buildSpec(Icons.square_foot_rounded, '${property.area}m²'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyDetailsScreen(property: property),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('التفاصيل'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openDirections(property),
                      icon: const Icon(Icons.directions),
                      label: const Text('الاتجاهات'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.tealGreen),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey, fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _erbilCenter,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                setState(() => _selectedProperty = null);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.arbilroyal.app',
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: _filteredProperties.map((property) {
                  final isSelected = _selectedProperty?.id == property.id;
                  return Marker(
                    point: LatLng(property.latitude!, property.longitude!),
                    width: isSelected? 60 : 50,
                    height: isSelected? 60 : 50,
                    child: GestureDetector(
                      onTap: () => _showPropertyBottomSheet(property),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected 
                             ? AppColors.tealGreen 
                              : AppColors.tealGreen.withOpacity(0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: isSelected? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tealGreen.withOpacity(0.5),
                              blurRadius: isSelected? 15 : 10,
                              spreadRadius: isSelected? 3 : 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                            if (isSelected)
                              Text(
                                '\$${(property.price / 1000).toStringAsFixed(0)}K',
                                style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          
          // شريط علوي زجاجي + فلتر
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glassShadow,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.map_rounded, color: AppColors.tealGreen, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'خريطة العقارات',
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkOliveGrey,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tealGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_filteredProperties.length} عقار',
                          style: GoogleFonts.tajawal(
                            color: AppColors.tealGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                 ? AppColors.tealGreen 
                                  : AppColors.glassWhite.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected? AppColors.tealGreen : AppColors.glassBorder,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: GoogleFonts.tajawal(
                                color: isSelected? Colors.white : AppColors.darkOliveGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // زر الموقع الحالي + تحديث
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glassBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glassShadow,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _loadProperties,
                    icon: const Icon(Icons.refresh, color: AppColors.tealGreen),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glassBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glassShadow,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => _mapController.move(_erbilCenter, 13.0),
                    icon: const Icon(Icons.my_location, color: AppColors.tealGreen),
                  ),
                ),
              ],
            ),
          ),
          
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.tealGreen),
              ),
            ),
        ],
      ),
    );
  }
}
