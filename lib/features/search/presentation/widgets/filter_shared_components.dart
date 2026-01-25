import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/models/event_filter.dart';
import '../../../home/presentation/providers/home_providers.dart';

// =============================================================================
// FILTER CARD - Container blanc avec ombre pour chaque section
// =============================================================================

class FilterCard extends StatelessWidget {
  final Widget child;

  const FilterCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({super.key, required this.title, required this.icon});

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
// SELECTABLE CHIP - Chip avec animation et ombre
// =============================================================================

class SelectableChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
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
                    color: const Color(0xFFFF601F).withValues(alpha: 0.25),
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

// =============================================================================
// TOGGLE ROW - Ligne avec switch custom style Airbnb
// =============================================================================

class ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleRow({
    super.key,
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
                  ? const Color(0xFFFF601F).withValues(alpha: 0.1)
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
                      color: Colors.black.withValues(alpha: 0.1),
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

// =============================================================================
// DATE QUICK CHIP - Chip de date avec sous-titre
// =============================================================================

class DateQuickChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const DateQuickChip({
    super.key,
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
                    color: Colors.black.withValues(alpha: 0.15),
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

// =============================================================================
// MINI CALENDAR - Calendrier inline
// =============================================================================

class MiniCalendar extends StatefulWidget {
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final void Function(DateTime start, DateTime? end) onDateSelected;

  const MiniCalendar({
    super.key,
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onDateSelected,
  });

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
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
                            ? const Color(0xFFFF601F).withValues(alpha: 0.15)
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
// LOCATION SECTION - Section géolocalisation + villes
// =============================================================================

class LocationSection extends ConsumerWidget {
  final EventFilter filter;
  final bool isLoadingLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onClearLocation;
  final ValueChanged<double> onRadiusChanged;
  final void Function(String slug, String name) onCitySelected;
  final VoidCallback onClearCity;

  const LocationSection({
    super.key,
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
        const SectionTitle(title: 'Localisation', icon: Icons.location_on),
        const SizedBox(height: 20),

        // Géolocalisation
        GestureDetector(
          onTap: isLoadingLocation ? null : onLocationTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasLocation
                  ? const Color(0xFFFF601F).withValues(alpha: 0.08)
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
                        ? const Color(0xFFFF601F).withValues(alpha: 0.15)
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
              overlayColor: const Color(0xFFFF601F).withValues(alpha: 0.2),
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
                return SelectableChip(
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
              return SelectableChip(
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
// FILTER HEADER - Header uniforme style Airbnb
// =============================================================================

class FilterHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final VoidCallback onClear;
  final bool showClear;

  const FilterHeader({
    super.key,
    required this.title,
    required this.onClose,
    required this.onClear,
    this.showClear = true,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: onClose,
            icon: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          // Bouton Effacer souligné
          if (showClear)
            GestureDetector(
              onTap: onClear,
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
            )
          else
            const SizedBox(width: 50), // Placeholder for balance
        ],
      ),
    );
  }
}

// =============================================================================
// FILTER FOOTER - Footer uniforme avec bouton gradient et badge
// =============================================================================

class FilterFooter extends StatelessWidget {
  final String buttonText;
  final int activeFilterCount;
  final VoidCallback onPressed;
  final double bottomPadding;

  const FilterFooter({
    super.key,
    required this.buttonText,
    required this.activeFilterCount,
    required this.onPressed,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: onPressed,
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
                  color: const Color(0xFFFF601F).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (activeFilterCount > 0) ...[
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
                      '$activeFilterCount',
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
// FOOTER WITH CLEAR - Footer avec bouton effacer souligné à gauche
// =============================================================================

class FilterFooterWithClear extends StatelessWidget {
  final String buttonText;
  final int activeFilterCount;
  final VoidCallback onPressed;
  final VoidCallback onClear;
  final bool hasFilters;
  final double bottomPadding;
  final IconData? buttonIcon;

  const FilterFooterWithClear({
    super.key,
    required this.buttonText,
    required this.activeFilterCount,
    required this.onPressed,
    required this.onClear,
    required this.hasFilters,
    this.bottomPadding = 0,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Clear all button (style Airbnb - underlined text)
            GestureDetector(
              onTap: hasFilters ? onClear : null,
              child: Text(
                'Tout effacer',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasFilters ? Colors.black87 : Colors.grey.shade400,
                  decoration: hasFilters ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
            const Spacer(),
            // Action button
            GestureDetector(
              onTap: onPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF601F), Color(0xFFE8491D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF601F).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (buttonIcon != null) ...[
                      Icon(buttonIcon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      buttonText,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (activeFilterCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$activeFilterCount',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
