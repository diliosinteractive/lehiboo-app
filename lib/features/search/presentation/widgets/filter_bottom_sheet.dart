import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';
import '../../../thematiques/presentation/providers/thematiques_provider.dart';
import '../../../thematiques/data/models/thematique_dto.dart';
import '../../../home/presentation/providers/home_providers.dart';

/// Show the filter bottom sheet
Future<void> showFilterBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  );
}

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late EventFilter _tempFilter;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _tempFilter = ref.read(eventFilterProvider);
  }

  /// Compte les filtres actifs pour le badge
  int get _activeFilterCount {
    int count = 0;
    if (_tempFilter.dateFilterType != null || _tempFilter.startDate != null) count++;
    if (_tempFilter.onlyFree || _tempFilter.priceMin > 0 || _tempFilter.priceMax < 500) count++;
    if (_tempFilter.citySlug != null) count++;
    if (_tempFilter.latitude != null) count++;
    count += _tempFilter.thematiquesSlugs.length;
    count += _tempFilter.categoriesSlugs.length;
    if (_tempFilter.familyFriendly) count++;
    if (_tempFilter.accessiblePMR) count++;
    if (_tempFilter.onlineOnly) count++;
    if (_tempFilter.inPersonOnly) count++;
    if (_tempFilter.sortBy != SortOption.relevance) count++;
    return count;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Activez la localisation');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Permission refusée');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Activez la localisation dans les paramètres');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      setState(() {
        _tempFilter = _tempFilter.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          radiusKm: _tempFilter.radiusKm,
          citySlug: null,
          cityName: null,
        );
      });
    } catch (e) {
      _showError('Position introuvable');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header style Airbnb
              _buildHeader(filterNotifier),
              // Filter sections
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  children: [
                    // 1. Section Localisation (NOUVELLE)
                    _FilterCard(
                      child: _LocationFilterSection(
                        filter: _tempFilter,
                        isLoadingLocation: _isLoadingLocation,
                        onLocationTap: _getCurrentLocation,
                        onClearLocation: () {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              latitude: null,
                              longitude: null,
                            );
                          });
                        },
                        onRadiusChanged: (radius) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(radiusKm: radius);
                          });
                        },
                        onCitySelected: (slug, name) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              citySlug: slug,
                              cityName: name,
                              latitude: null,
                              longitude: null,
                            );
                          });
                        },
                        onClearCity: () {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              citySlug: null,
                              cityName: null,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 2. Section Date améliorée
                    _FilterCard(
                      child: _DateFilterSection(
                        selectedType: _tempFilter.dateFilterType,
                        startDate: _tempFilter.startDate,
                        endDate: _tempFilter.endDate,
                        onTypeChanged: (type) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              dateFilterType: type,
                              startDate: null,
                              endDate: null,
                            );
                          });
                        },
                        onCustomDateSelected: (start, end) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              dateFilterType: DateFilterType.custom,
                              startDate: start,
                              endDate: end,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 3. Section Budget
                    _FilterCard(
                      child: _PriceFilterSection(
                        onlyFree: _tempFilter.onlyFree,
                        priceMin: _tempFilter.priceMin,
                        priceMax: _tempFilter.priceMax,
                        onFreeChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(onlyFree: value);
                          });
                        },
                        onRangeChanged: (min, max) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              priceMin: min,
                              priceMax: max,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 4. Section Catégories
                    Consumer(
                      builder: (context, ref, child) {
                        final filterOptions = ref.watch(filterOptionsProvider);
                        if (filterOptions.categories.isEmpty) return const SizedBox();

                        return _FilterCard(
                          child: _CategoriesFilterSection(
                            selectedSlugs: _tempFilter.categoriesSlugs,
                            categories: filterOptions.categories,
                            onChanged: (slugs) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(categoriesSlugs: slugs);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // 5. Section Thématiques
                    Consumer(
                      builder: (context, ref, child) {
                        final thematiquesAsync = ref.watch(thematiquesProvider);
                        return thematiquesAsync.when(
                          data: (thematiques) => _FilterCard(
                            child: _ThematiquesFilterSection(
                              selectedSlugs: _tempFilter.thematiquesSlugs,
                              thematiques: thematiques,
                              onChanged: (slugs) {
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(thematiquesSlugs: slugs);
                                });
                              },
                            ),
                          ),
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(color: Color(0xFFFF601F)),
                            ),
                          ),
                          error: (_, __) => const SizedBox(),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // 6. Section Public
                    _FilterCard(
                      child: _AudienceFilterSection(
                        familyFriendly: _tempFilter.familyFriendly,
                        accessiblePMR: _tempFilter.accessiblePMR,
                        onFamilyChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(familyFriendly: value);
                          });
                        },
                        onPMRChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(accessiblePMR: value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 7. Section Format
                    _FilterCard(
                      child: _FormatFilterSection(
                        onlineOnly: _tempFilter.onlineOnly,
                        inPersonOnly: _tempFilter.inPersonOnly,
                        onOnlineChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              onlineOnly: value,
                              inPersonOnly: value ? false : _tempFilter.inPersonOnly,
                            );
                          });
                        },
                        onInPersonChanged: (value) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(
                              inPersonOnly: value,
                              onlineOnly: value ? false : _tempFilter.onlineOnly,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 8. Section Tri
                    _FilterCard(
                      child: _SortFilterSection(
                        selectedSort: _tempFilter.sortBy,
                        onChanged: (sort) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(sortBy: sort);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 100 + bottomPadding),
                  ],
                ),
              ),
              // Footer sticky amélioré
              _buildFooter(filterNotifier, bottomPadding),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(EventFilterNotifier filterNotifier) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          // Close button style Airbnb (cercle avec bordure)
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.black87),
            ),
          ),
          const Spacer(),
          // Titre centré
          Text(
            'Filtres',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          // Bouton Effacer souligné
          GestureDetector(
            onTap: () {
              filterNotifier.resetAll();
              setState(() => _tempFilter = const EventFilter());
            },
            child: Text(
              'Effacer',
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF601F),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFFF601F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(EventFilterNotifier filterNotifier, double bottomPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            filterNotifier.applyFilters(_tempFilter);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF601F), Color(0xFFE8491D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF601F).withValues(alpha:0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Appliquer les filtres',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_activeFilterCount > 0) ...[
                  const SizedBox(width: 10),
                  // Badge compteur
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_activeFilterCount',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFFF601F),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FILTER CARD - Container blanc avec ombre pour chaque section
// =============================================================================

class _FilterCard extends StatelessWidget {
  final Widget child;

  const _FilterCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

// =============================================================================
// SECTION TITLE - Titre de section uniforme
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFFF601F)),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION LOCALISATION (NOUVELLE)
// =============================================================================

class _LocationFilterSection extends ConsumerWidget {
  final EventFilter filter;
  final bool isLoadingLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onClearLocation;
  final ValueChanged<double> onRadiusChanged;
  final void Function(String slug, String name) onCitySelected;
  final VoidCallback onClearCity;

  const _LocationFilterSection({
    required this.filter,
    required this.isLoadingLocation,
    required this.onLocationTap,
    required this.onClearLocation,
    required this.onRadiusChanged,
    required this.onCitySelected,
    required this.onClearCity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLocation = filter.latitude != null;
    final citiesAsync = ref.watch(homeCitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Localisation', icon: Icons.location_on),
        const SizedBox(height: 20),

        // Géolocalisation
        GestureDetector(
          onTap: isLoadingLocation ? null : onLocationTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasLocation
                  ? const Color(0xFFFF601F).withValues(alpha:0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasLocation ? const Color(0xFFFF601F) : Colors.grey.shade200,
                width: hasLocation ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hasLocation
                        ? const Color(0xFFFF601F).withValues(alpha:0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFF601F),
                          ),
                        )
                      : Icon(
                          Icons.near_me,
                          color: hasLocation
                              ? const Color(0xFFFF601F)
                              : Colors.grey.shade600,
                          size: 24,
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À proximité',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        hasLocation
                            ? 'Dans un rayon de ${filter.radiusKm.toInt()} km'
                            : 'Utiliser ma position actuelle',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLocation)
                  IconButton(
                    onPressed: onClearLocation,
                    icon: Icon(Icons.close, size: 20, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ),

        // Slider rayon (visible si géoloc active)
        if (hasLocation) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Rayon : ',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${filter.radiusKm.toInt()} km',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF601F),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFFF601F),
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: const Color(0xFFFF601F),
              overlayColor: const Color(0xFFFF601F).withValues(alpha:0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: filter.radiusKm,
              min: 5,
              max: 100,
              divisions: 19,
              onChanged: onRadiusChanged,
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Villes populaires
        Text(
          'VILLES POPULAIRES',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        citiesAsync.when(
          data: (cities) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: cities.take(6).map((city) {
                final isSelected = filter.citySlug == city.slug;
                return _SelectableChip(
                  label: city.name,
                  icon: Icons.location_city,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) {
                      onClearCity();
                    } else {
                      onCitySelected(city.slug, city.name);
                    }
                  },
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFFF601F),
              ),
            ),
          ),
          error: (_, __) => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ('Paris', 'paris'),
              ('Lyon', 'lyon'),
              ('Marseille', 'marseille'),
              ('Bordeaux', 'bordeaux'),
              ('Toulouse', 'toulouse'),
              ('Nantes', 'nantes'),
            ].map((city) {
              final isSelected = filter.citySlug == city.$2;
              return _SelectableChip(
                label: city.$1,
                icon: Icons.location_city,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    onClearCity();
                  } else {
                    onCitySelected(city.$2, city.$1);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION DATE AMELIOREE
// =============================================================================

class _DateFilterSection extends StatefulWidget {
  final DateFilterType? selectedType;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateFilterType?> onTypeChanged;
  final void Function(DateTime start, DateTime? end) onCustomDateSelected;

  const _DateFilterSection({
    required this.selectedType,
    required this.startDate,
    required this.endDate,
    required this.onTypeChanged,
    required this.onCustomDateSelected,
  });

  @override
  State<_DateFilterSection> createState() => _DateFilterSectionState();
}

class _DateFilterSectionState extends State<_DateFilterSection> {
  bool _showCalendar = false;

  String _formatDateRange() {
    if (widget.startDate == null) return '';
    final formatter = DateFormat('d MMM', 'fr_FR');
    if (widget.endDate == null || widget.startDate == widget.endDate) {
      return formatter.format(widget.startDate!);
    }
    return '${formatter.format(widget.startDate!)} - ${formatter.format(widget.endDate!)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final daysUntilSaturday = (DateTime.saturday - today.weekday) % 7;
    final saturday = today.add(Duration(
      days: daysUntilSaturday == 0 && now.weekday != DateTime.saturday ? 7 : daysUntilSaturday,
    ));
    final sunday = saturday.add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Date', icon: Icons.calendar_today),
        const SizedBox(height: 16),

        // Quick date chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _DateQuickChip(
              label: "Aujourd'hui",
              subtitle: DateFormat('d MMM', 'fr_FR').format(today),
              isSelected: widget.selectedType == DateFilterType.today,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.today ? null : DateFilterType.today,
              ),
            ),
            _DateQuickChip(
              label: 'Demain',
              subtitle: DateFormat('d MMM', 'fr_FR').format(tomorrow),
              isSelected: widget.selectedType == DateFilterType.tomorrow,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.tomorrow ? null : DateFilterType.tomorrow,
              ),
            ),
            _DateQuickChip(
              label: 'Ce week-end',
              subtitle: '${DateFormat('d').format(saturday)}-${DateFormat('d MMM', 'fr_FR').format(sunday)}',
              isSelected: widget.selectedType == DateFilterType.thisWeekend,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.thisWeekend ? null : DateFilterType.thisWeekend,
              ),
            ),
            _DateQuickChip(
              label: 'Cette semaine',
              isSelected: widget.selectedType == DateFilterType.thisWeek,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.thisWeek ? null : DateFilterType.thisWeek,
              ),
            ),
            _DateQuickChip(
              label: 'Ce mois',
              isSelected: widget.selectedType == DateFilterType.thisMonth,
              onTap: () => widget.onTypeChanged(
                widget.selectedType == DateFilterType.thisMonth ? null : DateFilterType.thisMonth,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Bouton dates personnalisées
        GestureDetector(
          onTap: () => setState(() => _showCalendar = !_showCalendar),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.selectedType == DateFilterType.custom
                  ? const Color(0xFFFF601F).withValues(alpha:0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.selectedType == DateFilterType.custom
                    ? const Color(0xFFFF601F)
                    : Colors.grey.shade200,
                width: widget.selectedType == DateFilterType.custom ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: widget.selectedType == DateFilterType.custom
                      ? const Color(0xFFFF601F)
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selectedType == DateFilterType.custom && widget.startDate != null
                        ? _formatDateRange()
                        : 'Choisir des dates personnalisées',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: widget.selectedType == DateFilterType.custom
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: widget.selectedType == DateFilterType.custom
                          ? const Color(0xFFFF601F)
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                Icon(
                  _showCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),

        // Mini Calendar (visible si ouvert)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _showCalendar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _MiniCalendar(
              selectedStartDate: widget.startDate,
              selectedEndDate: widget.endDate,
              onDateSelected: widget.onCustomDateSelected,
            ),
          ),
          secondChild: const SizedBox(height: 0),
        ),
      ],
    );
  }
}

class _DateQuickChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateQuickChip({
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: subtitle != null ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: isSelected ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniCalendar extends StatefulWidget {
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final void Function(DateTime start, DateTime? end) onDateSelected;

  const _MiniCalendar({
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onDateSelected,
  });

  @override
  State<_MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<_MiniCalendar> {
  late DateTime _currentMonth;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _rangeStart = widget.selectedStartDate;
    _rangeEnd = widget.selectedEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = (firstDayOfMonth.weekday - 1) % 7;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.grey.shade700),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy', 'fr_FR').format(_currentMonth),
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.grey.shade700),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekday headers
          Row(
            children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayNumber = index - startingWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isPast = date.isBefore(todayDate);
              final isToday = date.isAtSameMomentAs(todayDate);
              final isSelected = _isDateSelected(date);
              final isInRange = _isDateInRange(date);

              return GestureDetector(
                onTap: isPast ? null : () => _onDateTap(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFF601F)
                        : isInRange
                            ? const Color(0xFFFF601F).withValues(alpha:0.15)
                            : null,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: const Color(0xFFFF601F), width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isPast
                            ? Colors.grey.shade300
                            : isSelected
                                ? Colors.white
                                : isToday
                                    ? const Color(0xFFFF601F)
                                    : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isDateSelected(DateTime date) {
    if (_rangeStart != null && _isSameDay(date, _rangeStart!)) return true;
    if (_rangeEnd != null && _isSameDay(date, _rangeEnd!)) return true;
    return false;
  }

  bool _isDateInRange(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = date;
        _rangeEnd = null;
      } else {
        if (date.isBefore(_rangeStart!)) {
          _rangeEnd = _rangeStart;
          _rangeStart = date;
        } else {
          _rangeEnd = date;
        }
      }
    });

    widget.onDateSelected(_rangeStart!, _rangeEnd);
  }
}

// =============================================================================
// SECTION BUDGET
// =============================================================================

class _PriceFilterSection extends StatelessWidget {
  final bool onlyFree;
  final double priceMin;
  final double priceMax;
  final ValueChanged<bool> onFreeChanged;
  final void Function(double, double) onRangeChanged;

  static const double _sliderMin = 0;
  static const double _sliderMax = 500;

  const _PriceFilterSection({
    required this.onlyFree,
    required this.priceMin,
    required this.priceMax,
    required this.onFreeChanged,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final clampedMin = priceMin.clamp(_sliderMin, _sliderMax);
    final clampedMax = priceMax.clamp(_sliderMin, _sliderMax);
    final validMin = clampedMin <= clampedMax ? clampedMin : _sliderMin;
    final validMax = clampedMax >= clampedMin ? clampedMax : _sliderMax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Budget', icon: Icons.euro),
        const SizedBox(height: 16),

        // Toggle gratuit
        _ToggleRow(
          title: 'Gratuit uniquement',
          subtitle: 'Afficher seulement les activités gratuites',
          icon: Icons.local_offer,
          isSelected: onlyFree,
          onTap: () => onFreeChanged(!onlyFree),
        ),

        if (!onlyFree) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fourchette de prix',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${validMin.toInt()}€ - ${validMax.toInt()}€${validMax >= _sliderMax ? '+' : ''}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF601F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFFF601F),
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: const Color(0xFFFF601F),
              overlayColor: const Color(0xFFFF601F).withValues(alpha:0.2),
              trackHeight: 4,
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: RangeSlider(
              values: RangeValues(validMin, validMax),
              min: _sliderMin,
              max: _sliderMax,
              divisions: 50,
              onChanged: (values) {
                onRangeChanged(values.start, values.end);
              },
            ),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// SECTION CATEGORIES
// =============================================================================

class _CategoriesFilterSection extends StatefulWidget {
  final List<String> selectedSlugs;
  final List<EventCategoryInfo> categories;
  final ValueChanged<List<String>> onChanged;

  const _CategoriesFilterSection({
    required this.selectedSlugs,
    required this.categories,
    required this.onChanged,
  });

  @override
  State<_CategoriesFilterSection> createState() => _CategoriesFilterSectionState();
}

class _CategoriesFilterSectionState extends State<_CategoriesFilterSection> {
  bool _isExpanded = false;
  static const int _initialLimit = 8;

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return const SizedBox();

    final showAll = _isExpanded || widget.categories.length <= _initialLimit;
    final displayedCategories = showAll
        ? widget.categories
        : widget.categories.take(_initialLimit).toList();
    final hiddenCount = widget.categories.length - _initialLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Catégories', icon: Icons.grid_view_rounded),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: displayedCategories.map((c) {
            final isSelected = widget.selectedSlugs.contains(c.slug);
            IconData iconData = Icons.label_outline;
            if (c.icon != null) {
              if (c.icon!.contains('music')) {
                iconData = Icons.music_note;
              } else if (c.icon!.contains('movie')) {
                iconData = Icons.movie;
              } else if (c.icon!.contains('sport')) {
                iconData = Icons.sports;
              } else if (c.icon!.contains('restaurant')) {
                iconData = Icons.restaurant;
              } else if (c.icon!.contains('child')) {
                iconData = Icons.child_care;
              } else if (c.icon!.contains('palette')) {
                iconData = Icons.palette;
              } else if (c.icon!.contains('school')) {
                iconData = Icons.school;
              } else if (c.icon!.contains('book')) {
                iconData = Icons.menu_book;
              } else if (c.icon!.contains('park')) {
                iconData = Icons.park;
              } else if (c.icon!.contains('computer')) {
                iconData = Icons.computer;
              } else if (c.icon!.contains('castle')) {
                iconData = Icons.castle;
              } else if (c.icon!.contains('fitness')) {
                iconData = Icons.fitness_center;
              }
            }

            return _SelectableChip(
              label: c.name,
              icon: iconData,
              isSelected: isSelected,
              onTap: () {
                final newList = List<String>.from(widget.selectedSlugs);
                if (isSelected) {
                  newList.remove(c.slug);
                } else {
                  newList.add(c.slug);
                }
                widget.onChanged(newList);
              },
            );
          }).toList(),
        ),
        if (widget.categories.length > _initialLimit) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Voir moins' : 'Voir plus ($hiddenCount)',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFFF601F),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFFFF601F),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// SECTION THEMATIQUES
// =============================================================================

class _ThematiquesFilterSection extends StatelessWidget {
  final List<String> selectedSlugs;
  final List<ThematiqueDto> thematiques;
  final ValueChanged<List<String>> onChanged;

  const _ThematiquesFilterSection({
    required this.selectedSlugs,
    required this.thematiques,
    required this.onChanged,
  });

  static const _iconMapping = {
    'concert': Icons.music_note,
    'spectacle': Icons.theater_comedy,
    'sport': Icons.sports,
    'atelier': Icons.build,
    'exposition': Icons.museum,
    'festival': Icons.celebration,
    'conference': Icons.mic,
    'cinema': Icons.movie,
    'gastronomie': Icons.restaurant,
    'marche': Icons.store,
    'nature': Icons.park,
    'visite': Icons.location_city,
    'famille-enfants': Icons.child_care,
    'art-culture': Icons.palette,
    'musique-concert': Icons.music_note,
    'cinema-spectacle': Icons.theater_comedy,
    'cuisine-gastronomie': Icons.restaurant,
    'formation-education': Icons.school,
    'litterature-lecture': Icons.menu_book,
    'mode-design': Icons.checkroom,
    'nature-environnement': Icons.park,
    'numerique-technologie': Icons.computer,
    'patrimoine-histoire': Icons.castle,
    'sport-bien-etre': Icons.fitness_center,
  };

  @override
  Widget build(BuildContext context) {
    if (thematiques.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Thématiques', icon: Icons.category),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: thematiques.map((t) {
            final isSelected = selectedSlugs.contains(t.slug);
            final icon = _iconMapping[t.slug] ??
                _iconMapping[t.slug.split('-').last] ??
                Icons.local_activity;

            return _SelectableChip(
              label: t.name,
              icon: icon,
              isSelected: isSelected,
              onTap: () {
                final newList = List<String>.from(selectedSlugs);
                if (isSelected) {
                  newList.remove(t.slug);
                } else {
                  newList.add(t.slug);
                }
                onChanged(newList);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION PUBLIC
// =============================================================================

class _AudienceFilterSection extends StatelessWidget {
  final bool familyFriendly;
  final bool accessiblePMR;
  final ValueChanged<bool> onFamilyChanged;
  final ValueChanged<bool> onPMRChanged;

  const _AudienceFilterSection({
    required this.familyFriendly,
    required this.accessiblePMR,
    required this.onFamilyChanged,
    required this.onPMRChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Public', icon: Icons.people),
        const SizedBox(height: 16),
        _ToggleRow(
          title: 'En famille',
          subtitle: 'Activités adaptées aux enfants',
          icon: Icons.family_restroom,
          isSelected: familyFriendly,
          onTap: () => onFamilyChanged(!familyFriendly),
        ),
        const Divider(height: 24),
        _ToggleRow(
          title: 'Accessible PMR',
          subtitle: 'Accessibilité mobilité réduite',
          icon: Icons.accessible,
          isSelected: accessiblePMR,
          onTap: () => onPMRChanged(!accessiblePMR),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION FORMAT
// =============================================================================

class _FormatFilterSection extends StatelessWidget {
  final bool onlineOnly;
  final bool inPersonOnly;
  final ValueChanged<bool> onOnlineChanged;
  final ValueChanged<bool> onInPersonChanged;

  const _FormatFilterSection({
    required this.onlineOnly,
    required this.inPersonOnly,
    required this.onOnlineChanged,
    required this.onInPersonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Format', icon: Icons.videocam),
        const SizedBox(height: 16),
        _ToggleRow(
          title: 'En ligne',
          subtitle: 'Activités virtuelles',
          icon: Icons.videocam_outlined,
          isSelected: onlineOnly,
          onTap: () => onOnlineChanged(!onlineOnly),
        ),
        const Divider(height: 24),
        _ToggleRow(
          title: 'En présentiel',
          subtitle: 'Activités sur place',
          icon: Icons.location_on_outlined,
          isSelected: inPersonOnly,
          onTap: () => onInPersonChanged(!inPersonOnly),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION TRI
// =============================================================================

class _SortFilterSection extends StatelessWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption> onChanged;

  const _SortFilterSection({
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Trier par', icon: Icons.sort),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SelectableChip(
              label: 'Pertinence',
              isSelected: selectedSort == SortOption.relevance,
              onTap: () => onChanged(SortOption.relevance),
            ),
            _SelectableChip(
              label: 'Date (proche)',
              isSelected: selectedSort == SortOption.dateAsc,
              onTap: () => onChanged(SortOption.dateAsc),
            ),
            _SelectableChip(
              label: 'Prix croissant',
              isSelected: selectedSort == SortOption.priceAsc,
              onTap: () => onChanged(SortOption.priceAsc),
            ),
            _SelectableChip(
              label: 'Prix décroissant',
              isSelected: selectedSort == SortOption.priceDesc,
              onTap: () => onChanged(SortOption.priceDesc),
            ),
            _SelectableChip(
              label: 'Popularité',
              isSelected: selectedSort == SortOption.popularity,
              onTap: () => onChanged(SortOption.popularity),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// COMPOSANTS REUTILISABLES
// =============================================================================

/// Chip sélectionnable amélioré avec animation
class _SelectableChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF601F).withValues(alpha:0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Toggle row style Airbnb avec switch custom
class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // Icon container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF601F).withValues(alpha:0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade600,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Custom toggle switch
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF601F) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
