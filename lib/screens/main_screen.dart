import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/app_colors.dart';
import '../main.dart';
import '../models/property_model.dart';
import '../widgets/ra_logo_painter.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'admin_panel_screen.dart';
import 'property_details_screen.dart';

class GlassNotification {
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
                onTap();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tealGreen.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.tealGreen.withOpacity(0.3), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.greyLight.withOpacity(0.3),
                            child: const Icon(Icons.home_work, color: AppColors.tealGreen),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.tealGreen.withOpacity(0.1),
                            child: const Icon(Icons.home_work, color: AppColors.tealGreen),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.tealGreen.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.apartment_rounded, size: 14, color: AppColors.tealGreen),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'أربيل رويال',
                                style: GoogleFonts.tajawal(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tealGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.tajawal(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkOliveGrey,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 18, color: AppColors.greyLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 5), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'الكل';
  List<PropertyModel> _allProperties = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasInternet = true;

  final List<String> _filters = ['الكل', 'جديد', 'منازل', 'شقق', 'أراضي', 'مميز'];

  @override
  void initState() {
    super.initState();
    _checkInternet();
    _loadProperties();
    _listenToNewProperties();
  }

  Future<void> _checkInternet() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _hasInternet = result!= ConnectivityResult.none);
    
    Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() => _hasInternet = result!= ConnectivityResult.none);
        if (_hasInternet && _allProperties.isEmpty) _loadProperties();
      }
    });
  }

  Future<void> _loadProperties() async {
    if (!_hasInternet) return;
    
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await supabase
       .from('properties')
       .select()
       .eq('is_active', true)
       .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _allProperties = response.map((json) => PropertyModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'خطأ في قاعدة البيانات: ${e.message}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ غير متوقع. تحقق من الاتصال بالإنترنت';
          _isLoading = false;
        });
      }
    }
  }

  void _listenToNewProperties() {
    supabase
     .channel('public:properties')
     .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'properties',
          callback: (payload) {
            if (!mounted) return;
            
            final newRecord = payload.newRecord;
            final title = newRecord['title'] as String??? 'عقار جديد';
            final imageUrl = newRecord['image_url'] as String??? '';
            
            GlassNotification.show(
              context,
              title: title,
              imageUrl: imageUrl,
              onTap: () {
                _loadProperties();
                setState(() => _currentIndex = 0);
              },
            );
            
            _loadProperties();
          },
        )
     .subscribe();
  }

  List<PropertyModel> get _filteredProperties {
    if (_selectedFilter == 'الكل') return _allProperties;
    if (_selectedFilter == 'مميز') {
      return _allProperties.where((p) => p.isFeatured).toList();
    }
    if (_selectedFilter == 'جديد') {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      return _allProperties.where((p) => p.createdAt.isAfter(weekAgo)).toList();
    }
    String dbType = _selectedFilter;
    if (_selectedFilter == 'منازل') dbType = 'house';
    if (_selectedFilter == 'شقق') dbType = 'apartment';
    if (_selectedFilter == 'أراضي') dbType = 'land';
    return _allProperties.where((p) => p.type == dbType).toList();
  }

  void _navigateWithFade(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) return _buildNoInternetScreen();

    final pages = [
      _buildHomeTab(),
      const MapScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.skyBlueTop, AppColors.whiteBottom],
            stops: const [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(index: _currentIndex, children: pages),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildAdminFab(),
    );
  }

  Widget _buildNoInternetScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const RALogo(width: 50, height: 35),
                  const SizedBox(width: 12),
                  Text(
                    'أربيل رويال',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkOliveGrey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 120, color: Colors.grey[300]),
                      const SizedBox(height: 24),
                      Text(
                        'لا يوجد اتصال بالإنترنت',
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'تحقق من الاتصال وحاول مرة أخرى',
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _checkInternet();
                          if (_hasInternet) _loadProperties();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget? _buildAdminFab() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    return FutureBuilder(
      future: supabase.from('profiles').select('role').eq('id', user.id).single(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) return const SizedBox.shrink();
        
        final role = snapshot.data?['role'] as String?;
        if (role!= 'admin') return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => _navigateWithFade(const AdminPanelScreen()),
          backgroundColor: AppColors.tealGreen,
          icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
          label: Text(
            'لوحتي',
            style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _buildHomeTab() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.tealGreen),
            const SizedBox(height: 16),
            Text('جاري التحميل...', style: GoogleFonts.tajawal(color: AppColors.darkOliveGrey)),
          ],
        ),
      );
    }

    if (_errorMessage!= null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: AppColors.errorRed.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(fontSize: 16, color: AppColors.darkOliveGrey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadProperties,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const RALogo(width: 50, height: 35),
              const SizedBox(width: 12),
              Text(
                'أربيل رويال',
                style: GoogleFonts.tajawal(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkOliveGrey,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.glassWhite.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder, width: 1),
                ),
                child: IconButton(
                  onPressed: _loadProperties,
                  icon: const Icon(Icons.refresh, color: AppColors.tealGreen),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ChoiceChip(
                  label: Text(filter, style: GoogleFonts.tajawal()),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedFilter = filter),
                  selectedColor: AppColors.tealGreen,
                  labelStyle: GoogleFonts.tajawal(
                    color: isSelected? Colors.white : AppColors.darkOliveGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _filteredProperties.isEmpty
           ? Center(
                  child: Text(
                    'لا توجد عقارات في هذا القسم',
                    style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProperties,
                  color: AppColors.tealGreen,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = _filteredProperties[index];
                      return _buildPropertyCard(property);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(PropertyModel property) {
    final isNew = DateTime.now().difference(property.createdAt).inDays < 7;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _navigateWithFade(PropertyDetailsScreen(property: property)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassWhite.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: 20,

