import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/property_model.dart';
import '../services/supabase_service.dart';
import 'property_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  static const CameraPosition _erbil = CameraPosition(
    target: LatLng(36.1911, 44.0091),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final properties = await SupabaseService().getPropertiesStream().first;
    setState(() {
      _markers = properties.map((p) => Marker(
        markerId: MarkerId(p.id.toString()),
        position: LatLng(36.1911 + (p.id * 0.01), 44.0091 + (p.id * 0.01)), // استبدل بالإحداثيات الحقيقية
        infoWindow: InfoWindow(
          title: p.title,
          snippet: '\$${p.price}',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PropertyDetailsScreen(property: p)),
          ),
        ),
      )).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('الخريطة', style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: _erbil,
        markers: _markers,
        onMapCreated: (controller) => _controller = controller,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
