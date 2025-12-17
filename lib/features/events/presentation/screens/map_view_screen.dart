import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; // For attribution links
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/presentation/providers/event_providers.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:lehiboo/features/events/presentation/widgets/map_event_card.dart';
import 'package:lehiboo/features/search/presentation/widgets/filter_bottom_sheet.dart'; // Import filter sheet
import 'package:lehiboo/domain/entities/activity.dart'; 
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
// Note: MapTheme is no longer needed for styling as we use a specific tile provider

class MapViewScreen extends ConsumerStatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final double? initialZoom;

  const MapViewScreen({
    super.key, 
    this.initialLat, 
    this.initialLng, 
    this.initialZoom
  });

  @override
  ConsumerState<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends ConsumerState<MapViewScreen> {
  final MapController _mapController = MapController();
  final PageController _pageController = PageController(viewportFraction: 0.33);
  
  static const LatLng _kDefaultCenter = LatLng(50.4542, 3.9567);
  static const double _kDefaultZoom = 13.0;

  Timer? _debounceTimer;
  bool _isMapMovingFromPage = false;
  int _selectedIndex = -1;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    
    // If initial coordinates are provided, move there after build
    if (widget.initialLat != null && widget.initialLng != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(widget.initialLat!, widget.initialLng!), 
          widget.initialZoom ?? 13.0
        );
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _pageController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
     await Geolocator.requestPermission();
  }
  
  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (_isMapMovingFromPage) return;
    
    // Auto-refresh logic with debounce
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        _searchInArea();
      }
    });
  }

  void _searchInArea() {
    final bounds = _mapController.camera.visibleBounds;
    
    ref.read(eventFilterProvider.notifier).setBoundingBox(
      bounds.northEast.latitude,
      bounds.northEast.longitude,
      bounds.southWest.latitude,
      bounds.southWest.longitude,
    );
  }

  Future<void> _locateMe() async {
    setState(() => _isLocating = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15.0
      );
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de récupérer votre position')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _zoomIn() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom + 1,
    );
  }

  void _zoomOut() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom - 1,
    );
  }

  Activity _eventToActivity(Event event) {
     return Activity(
       id: event.id.toString(),
       title: event.title,
       slug: '',
       description: event.description,
       imageUrl: event.coverImage,
       isFree: event.isFree,
       priceMin: event.minPrice,
       city: null, 
       category: null, 
       tags: [],
       nextSlot: Slot(
          id: 'temp_${event.id}',
          activityId: event.id.toString(),
          startDateTime: event.startDate, // Use real dates
          endDateTime: event.endDate,
       )
     );
  }

  void _onMapReady() {
    if (widget.initialLat == null || widget.initialLng == null) {
      _locateMe();
    } else {
       Future.delayed(const Duration(milliseconds: 500), () {
        if(mounted) _searchInArea();
      });
    }
  }

  List<Marker> _buildMarkers(List<Event> events) {
    // 1. Group events by location (lat,lng)
    final Map<String, List<MapEntry<int, Event>>> groups = {};
    
    for (var i = 0; i < events.length; i++) {
      final event = events[i];
      final key = '${event.latitude}_${event.longitude}';
      groups.putIfAbsent(key, () => []).add(MapEntry(i, event));
    }

    // 2. Convert groups to markers
    final groupEntries = groups.values.toList();

    // 3. Sort groups so the one containing the selected index is last (z-index top)
    groupEntries.sort((a, b) {
      final aHasSelected = a.any((e) => e.key == _selectedIndex);
      final bHasSelected = b.any((e) => e.key == _selectedIndex);
      if (aHasSelected) return 1;
      if (bHasSelected) return -1;
      return 0;
    });

    return groupEntries.map((group) {
      final firstEntry = group.first;
      final position = LatLng(firstEntry.value.latitude, firstEntry.value.longitude);
      
      final isSelected = group.any((e) => e.key == _selectedIndex);
      
      final displayEntry = isSelected 
          ? group.firstWhere((e) => e.key == _selectedIndex)
          : group.first;
      
      final event = displayEntry.value;
      final count = group.length;

      return Marker(
        point: position,
        width: isSelected ? 100.0 : 60.0,
        height: isSelected ? 100.0 : 60.0,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            if (count == 1) {
              _pageController.animateToPage(
                displayEntry.key,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => _selectedIndex = displayEntry.key);
            } else {
              _showMultiEventList(context, group);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF601F) : Colors.white, 
                        width: 2
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                      ]
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                       'assets/images/logo-footer.png',
                       width: isSelected ? 40 : 28,
                       height: isSelected ? 40 : 28,
                    ),
                  ),
                  if (isSelected) 
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      constraints: const BoxConstraints(maxWidth: 100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
                      ),
                      child: Text(
                        (event.minPrice ?? 0) == 0 ? 'Gratuit' : '${(event.minPrice ?? 0).toStringAsFixed(0)}€',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                ],
              ),
              
              if (count > 1)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF601F),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _showMultiEventList(BuildContext context, List<MapEntry<int, Event>> group) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${group.length} événements ici',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: group.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = group[index];
                    final event = entry.value;
                    final isSelected = entry.key == _selectedIndex;
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${DateFormat('dd MMM HH:mm', 'fr_FR').format(event.startDate)} • ${(event.minPrice ?? 0) == 0 ? 'Gratuit' : '${(event.minPrice ?? 0).toStringAsFixed(0)}€'}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      trailing: isSelected 
                          ? const Icon(Icons.check_circle, color: Color(0xFFFF601F))
                          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        context.pop();
                        _pageController.jumpToPage(entry.key);
                        setState(() => _selectedIndex = entry.key);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPageChanged(int index, List<Event> events) {
    if (index >= 0 && index < events.length) {
      setState(() {
        _selectedIndex = index;
        _isMapMovingFromPage = true;
      });
      
      final event = events[index];
      _mapController.move(
          LatLng(event.latitude, event.longitude),
          _mapController.camera.zoom
      );

      setState(() {
        _isMapMovingFromPage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final filter = ref.watch(eventFilterProvider);
    final isLoading = eventsAsync.isLoading || eventsAsync.isRefreshing;

    return Scaffold(
      body: Stack(
        children: [
          // MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _kDefaultCenter,
              initialZoom: _kDefaultZoom,
              onPositionChanged: _onPositionChanged,
              onMapReady: _onMapReady,
              interactionOptions: const InteractionOptions(
                 flags: InteractiveFlag.all & ~InteractiveFlag.rotate, 
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.dilios.lehiboo',
              ),
              Builder(
                builder: (context) {
                  if (eventsAsync.hasValue) {
                     return MarkerLayer(
                       markers: _buildMarkers(eventsAsync.value!.events),
                     );
                  }
                  return const MarkerLayer(markers: []);
                },
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                  TextSourceAttribution(
                     'CartoDB',
                     onTap: () => launchUrl(Uri.parse('https://carto.com/attributions')),
                  ),
                ],
              ),
            ],
          ),
          
          // TOP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildDateChip('Aujourd\'hui', DateFilterType.today, filter),
                                const SizedBox(width: 8),
                                _buildDateChip('Demain', DateFilterType.tomorrow, filter),
                                const SizedBox(width: 8),
                                _buildDateChip('Ce week-end', DateFilterType.thisWeekend, filter),
                                const SizedBox(width: 8),
                                _buildDateChip('Cette semaine', DateFilterType.thisWeek, filter),
                                const SizedBox(width: 8),
                                _buildDateChip('Ce mois', DateFilterType.thisMonth, filter),
                                const SizedBox(width: 8),
                                _buildBooleanChip('Gratuit', filter.onlyFree, (val) {
                                  ref.read(eventFilterProvider.notifier).setOnlyFree(val);
                                }),
                                const SizedBox(width: 8),
                                _buildBooleanChip('En famille', filter.familyFriendly, (val) {
                                  ref.read(eventFilterProvider.notifier).setFamilyFriendly(val);
                                }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: Color(0xFFFF601F)),
                            onPressed: () => showFilterBottomSheet(context),
                          ),
                        ),
                      ],
                    ),
                    if (isLoading)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 14, 
                              height: 14, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF601F))
                            ),
                            SizedBox(width: 8),
                            Text("Recherche en cours...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // RIGHT SIDE CONTROLS
          Positioned(
             right: 16,
             bottom: 220, // Revert position
             child: Column(
               children: [
                 FloatingActionButton.small(
                   heroTag: 'zoom_in',
                   onPressed: _zoomIn,
                   backgroundColor: Colors.white,
                   child: const Icon(Icons.add, color: Colors.black87),
                 ),
                 const SizedBox(height: 8),
                 FloatingActionButton.small(
                   heroTag: 'zoom_out',
                   onPressed: _zoomOut,
                   backgroundColor: Colors.white,
                   child: const Icon(Icons.remove, color: Colors.black87),
                 ),
                 const SizedBox(height: 16),
                 FloatingActionButton(
                   heroTag: 'locate_me',
                   onPressed: _locateMe,
                   backgroundColor: Colors.white,
                   child: _isLocating 
                     ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                     : const Icon(Icons.my_location, color: Colors.black87),
                 ),
               ],
             ),
          ),

          // CAROUSEL
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            height: 200, // Revert height
            child: Builder(
              builder: (context) {
                if (eventsAsync.hasValue) {
                  final result = eventsAsync.value!;
                  if (result.events.isEmpty) {
                    return Center(
                      child: GestureDetector(
                        onTap: () => context.push('/ai-chat'),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  'assets/images/petit_boo.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Flexible(
                                child: Text(
                                  "Oups, c'est calme par ici !\nBesoin d'un coup de pouce ?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: result.events.length,
                    onPageChanged: (index) => _onPageChanged(index, result.events),
                    padEnds: true,
                    itemBuilder: (context, index) {
                      final event = result.events[index];
                      return AnimatedBuilder(
                         animation: _pageController,
                         builder: (context, child) {
                           double value = 1.0;
                           if (_pageController.position.haveDimensions) {
                             value = _pageController.page! - index;
                             value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                           } else {
                              value = (index == (_selectedIndex == -1 ? 0 : _selectedIndex)) ? 1.0 : 0.85;
                           }
                           return Center(
                             child: SizedBox(
                               height: Curves.easeOut.transform(value) * 200, // Revert height calculation
                               width: Curves.easeOut.transform(value) * 350, // Revert width calculation
                               child: child,
                             ),
                           );
                         },
                        child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: MapEventCard(activity: _eventToActivity(event)),
                        ),
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(String label, DateFilterType type, EventFilter filter) {
    final isSelected = filter.dateFilterType == type;
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          ref.read(eventFilterProvider.notifier).clearDateFilter();
        } else {
          ref.read(eventFilterProvider.notifier).setDateFilter(type);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBooleanChip(String label, bool isSelected, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}