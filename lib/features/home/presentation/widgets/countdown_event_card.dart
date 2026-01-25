import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

/// Card événement avec countdown FOMO pour créer l'urgence
/// Affiche un timer en temps réel jusqu'à la date de l'événement ou la deadline de réservation
class CountdownEventCard extends ConsumerStatefulWidget {
  final Activity activity;

  /// Date limite pour le countdown (deadline booking ou début de l'événement)
  final DateTime? deadline;

  /// Nombre de places restantes (optionnel)
  final int? remainingSpots;

  /// Message personnalisé (ex: "Plus que X places !")
  final String? urgencyMessage;

  const CountdownEventCard({
    super.key,
    required this.activity,
    this.deadline,
    this.remainingSpots,
    this.urgencyMessage,
  });

  @override
  ConsumerState<CountdownEventCard> createState() => _CountdownEventCardState();
}

class _CountdownEventCardState extends ConsumerState<CountdownEventCard>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();

    // Timer pour mettre à jour le countdown chaque seconde
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });

    // Animation pulse pour l'urgence
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _calculateRemaining() {
    final targetDate = widget.deadline ?? widget.activity.nextSlot?.startDateTime;
    if (targetDate == null) {
      setState(() => _remaining = Duration.zero);
      return;
    }

    final now = DateTime.now();
    final diff = targetDate.difference(now);

    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  String _formatCountdown() {
    if (_remaining == Duration.zero) {
      return 'Maintenant !';
    }

    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    if (hours > 24) {
      final days = _remaining.inDays;
      return '$days jour${days > 1 ? 's' : ''} ${hours.remainder(24)}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else if (minutes > 0) {
      return '${minutes}min ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  bool get _isUrgent => _remaining.inHours < 6;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/event/${widget.activity.id}', extra: widget.activity),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isUrgent
                ? [
                    const Color(0xFFFF4444).withOpacity(0.1),
                    const Color(0xFFFF601F).withOpacity(0.15),
                  ]
                : [
                    const Color(0xFFFF601F).withOpacity(0.08),
                    const Color(0xFFFFB347).withOpacity(0.1),
                  ],
          ),
          border: Border.all(
            color: _isUrgent
                ? const Color(0xFFFF4444).withOpacity(0.3)
                : const Color(0xFFFF601F).withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (_isUrgent ? const Color(0xFFFF4444) : const Color(0xFFFF601F))
                  .withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with overlays
            Stack(
              children: [
                // Main image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: widget.activity.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.activity.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(color: Color(0xFFFF601F)),
                              ),
                            ),
                            errorWidget: (context, url, error) => _buildFallbackImage(),
                          )
                        : _buildFallbackImage(),
                  ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Countdown badge (top left) with pulse animation
                Positioned(
                  top: 12,
                  left: 12,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = _isUrgent
                          ? 1.0 + (_pulseController.value * 0.05)
                          : 1.0;

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isUrgent
                                ? const Color(0xFFFF4444)
                                : const Color(0xFFFF601F),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: (_isUrgent
                                        ? const Color(0xFFFF4444)
                                        : const Color(0xFFFF601F))
                                    .withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isUrgent ? Icons.timer : Icons.access_time,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatCountdown(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Remaining spots badge (top right)
                if (widget.remainingSpots != null && widget.remainingSpots! > 0)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.remainingSpots! <= 5
                            ? const Color(0xFFFF4444)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.remainingSpots} place${widget.remainingSpots! > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: widget.remainingSpots! <= 5
                              ? Colors.white
                              : const Color(0xFF2D3748),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Favorite button (bottom right)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: FavoriteButton(
                    event: _activityToEvent(),
                    iconSize: 20,
                    containerSize: 36,
                  ),
                ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Urgency message
                  if (widget.urgencyMessage != null || _isUrgent)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        widget.urgencyMessage ??
                            (widget.remainingSpots != null
                                ? 'Plus que ${widget.remainingSpots} places !'
                                : 'Dernières heures pour réserver !'),
                        style: TextStyle(
                          color: _isUrgent
                              ? const Color(0xFFFF4444)
                              : const Color(0xFFFF601F),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  // Title
                  Text(
                    widget.activity.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Location & Date row
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.activity.city?.name ?? 'France',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.activity.nextSlot != null) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(widget.activity.nextSlot!.startDateTime),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // CTA Button + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      if (widget.activity.priceMin != null && widget.activity.priceMin != -1)
                        Text(
                          widget.activity.priceMin == 0
                              ? 'Gratuit'
                              : 'À partir de ${widget.activity.priceMin!.toStringAsFixed(0)}€',
                          style: TextStyle(
                            color: widget.activity.priceMin == 0
                                ? Colors.green[700]
                                : const Color(0xFF2D3748),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      // CTA Button
                      ElevatedButton(
                        onPressed: () => context.push('/event/${widget.activity.id}', extra: widget.activity),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isUrgent
                              ? const Color(0xFFFF4444)
                              : const Color(0xFFFF601F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Réserver',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: const Color(0xFFFF601F),
      child: Center(
        child: Image.asset(
          'assets/images/logo_picto_lehiboo.png',
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    String dayPart;
    if (dateOnly == today) {
      dayPart = 'Aujourd\'hui';
    } else if (dateOnly == tomorrow) {
      dayPart = 'Demain';
    } else {
      final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      dayPart = '${weekdays[date.weekday - 1]} ${date.day}/${date.month}';
    }

    final timePart = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$dayPart à $timePart';
  }

  Event _activityToEvent() {
    return Event(
      id: widget.activity.id,
      slug: widget.activity.slug,
      title: widget.activity.title,
      description: '',
      shortDescription: '',
      category: EventCategory.other,
      targetAudiences: [],
      startDate: widget.activity.nextSlot?.startDateTime ?? DateTime.now(),
      endDate: widget.activity.nextSlot?.endDateTime ?? DateTime.now(),
      venue: widget.activity.city?.name ?? '',
      address: '',
      city: widget.activity.city?.name ?? '',
      postalCode: '',
      latitude: 0,
      longitude: 0,
      images: widget.activity.imageUrl != null ? [widget.activity.imageUrl!] : [],
      coverImage: widget.activity.imageUrl,
      priceType: widget.activity.priceMin == 0 ? PriceType.free : PriceType.paid,
      minPrice: widget.activity.priceMin,
      maxPrice: widget.activity.priceMax,
      isIndoor: false,
      isOutdoor: false,
      tags: [],
      organizerId: widget.activity.partner?.id ?? '',
      organizerName: widget.activity.partner?.name ?? '',
      organizerLogo: widget.activity.partner?.logoUrl,
      isFavorite: false,
      isFeatured: false,
      isRecommended: false,
      status: EventStatus.upcoming,
      hasDirectBooking: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      views: 0,
    );
  }
}

/// Card avec design complet + countdown pour carousel horizontal
class _FullCountdownCard extends StatefulWidget {
  final Activity activity;
  final int? remainingSpots;

  const _FullCountdownCard({
    required this.activity,
    this.remainingSpots,
  });

  @override
  State<_FullCountdownCard> createState() => _FullCountdownCardState();
}

class _FullCountdownCardState extends State<_FullCountdownCard> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemaining() {
    final targetDate = widget.activity.nextSlot?.startDateTime;
    if (targetDate == null) {
      setState(() => _remaining = Duration.zero);
      return;
    }
    final now = DateTime.now();
    final diff = targetDate.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  String _formatCountdown() {
    if (_remaining == Duration.zero) return 'Now!';
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}min';
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h${remainingMinutes.toString().padLeft(2, '0')}';
  }

  bool get _isUrgent => _remaining.inHours < 6;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/event/${widget.activity.id}', extra: widget.activity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image avec countdown badge
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.activity.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.activity.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) => _buildFallback(),
                          )
                        : _buildFallback(),
                  ),
                ),
                // Countdown badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isUrgent ? const Color(0xFFFF4444) : const Color(0xFFFF601F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _formatCountdown(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Places restantes badge
                if (widget.remainingSpots != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.remainingSpots}',
                        style: TextStyle(
                          color: widget.remainingSpots! <= 5 ? const Color(0xFFFF4444) : const Color(0xFF2D3748),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FavoriteButton(
                    event: _activityToEvent(),
                    iconSize: 18,
                    containerSize: 32,
                  ),
                ),
              ],
            ),
          ),
          // Contenu - même design que EventCard
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 4, right: 4, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Titre
                  Text(
                    widget.activity.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Organisateur
                  if (widget.activity.partner != null)
                    Text(
                      'Par ${widget.activity.partner!.name}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFF601F)),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                          height: 1.1,
                        ),
                      ),
                      Text(
                        ' (124)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Location + Duration
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.activity.city?.name ?? 'France',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.1),
                        ),
                        if (widget.activity.durationMinutes != null && widget.activity.durationMinutes! > 0) ...[
                          const TextSpan(text: ' • '),
                          TextSpan(
                            text: _formatDuration(widget.activity.durationMinutes!),
                            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.1),
                          ),
                        ],
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Prix
                  if (widget.activity.priceMin != null && widget.activity.priceMin != -1)
                    Text(
                      widget.activity.priceMin == 0
                          ? 'Gratuit'
                          : 'À partir de ${widget.activity.priceMin!.toStringAsFixed(0)}€',
                      style: TextStyle(
                        color: widget.activity.priceMin == 0 ? Colors.green[700] : const Color(0xFFFF601F),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.1,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: const Color(0xFFFF601F),
      child: Center(
        child: Image.asset(
          'assets/images/logo_picto_lehiboo.png',
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => const Icon(Icons.event, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Event _activityToEvent() {
    return Event(
      id: widget.activity.id,
      slug: widget.activity.slug,
      title: widget.activity.title,
      description: '',
      shortDescription: '',
      category: EventCategory.other,
      targetAudiences: [],
      startDate: widget.activity.nextSlot?.startDateTime ?? DateTime.now(),
      endDate: widget.activity.nextSlot?.endDateTime ?? DateTime.now(),
      venue: widget.activity.city?.name ?? '',
      address: '',
      city: widget.activity.city?.name ?? '',
      postalCode: '',
      latitude: 0,
      longitude: 0,
      images: widget.activity.imageUrl != null ? [widget.activity.imageUrl!] : [],
      coverImage: widget.activity.imageUrl,
      priceType: widget.activity.priceMin == 0 ? PriceType.free : PriceType.paid,
      minPrice: widget.activity.priceMin,
      maxPrice: widget.activity.priceMax,
      isIndoor: false,
      isOutdoor: false,
      tags: [],
      organizerId: widget.activity.partner?.id ?? '',
      organizerName: widget.activity.partner?.name ?? '',
      organizerLogo: widget.activity.partner?.logoUrl,
      isFavorite: false,
      isFeatured: false,
      isRecommended: false,
      status: EventStatus.upcoming,
      hasDirectBooking: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      views: 0,
    );
  }
}

/// Card compacte pour carousel horizontal (legacy)
class _CompactCountdownCard extends StatefulWidget {
  final Activity activity;
  final int? remainingSpots;

  const _CompactCountdownCard({
    required this.activity,
    this.remainingSpots,
  });

  @override
  State<_CompactCountdownCard> createState() => _CompactCountdownCardState();
}

class _CompactCountdownCardState extends State<_CompactCountdownCard> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemaining() {
    final targetDate = widget.activity.nextSlot?.startDateTime;
    if (targetDate == null) {
      setState(() => _remaining = Duration.zero);
      return;
    }
    final now = DateTime.now();
    final diff = targetDate.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  String _formatCountdown() {
    if (_remaining == Duration.zero) return 'Now!';
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}min';
    }
  }

  bool get _isUrgent => _remaining.inHours < 6;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/event/${widget.activity.id}', extra: widget.activity),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec countdown
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: widget.activity.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.activity.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) => _buildFallback(),
                            )
                          : _buildFallback(),
                    ),
                  ),
                  // Countdown badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isUrgent ? const Color(0xFFFF4444) : const Color(0xFFFF601F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer, color: Colors.white, size: 11),
                          const SizedBox(width: 3),
                          Text(
                            _formatCountdown(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Places restantes
                  if (widget.remainingSpots != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.remainingSpots}',
                          style: TextStyle(
                            color: widget.remainingSpots! <= 5 ? const Color(0xFFFF4444) : const Color(0xFF2D3748),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.activity.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Prix
                  if (widget.activity.priceMin != null && widget.activity.priceMin != -1)
                    Text(
                      widget.activity.priceMin == 0
                          ? 'Gratuit'
                          : 'Dès ${widget.activity.priceMin!.toStringAsFixed(0)}€',
                      style: TextStyle(
                        color: widget.activity.priceMin == 0 ? Colors.green[700] : const Color(0xFFFF601F),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: const Color(0xFFFF601F),
      child: Center(
        child: Image.asset(
          'assets/images/logo_picto_lehiboo.png',
          width: 40,
          height: 40,
          errorBuilder: (_, __, ___) => const Icon(Icons.event, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

/// Section urgency - carousel horizontal avec design complet
class UrgencySection extends ConsumerWidget {
  const UrgencySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(homeTodayActivitiesProvider);

    return activitiesAsync.when(
      data: (activities) {
        final now = DateTime.now();
        final urgentActivities = activities.where((activity) {
          if (activity.nextSlot == null) return false;
          final diff = activity.nextSlot!.startDateTime.difference(now);
          return diff.inHours >= 0 && diff.inHours <= 12;
        }).take(6).toList();

        if (urgentActivities.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4444).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF4444),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avant qu\'il soit trop tard',
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          'Ces événements commencent bientôt',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Carousel horizontal - même taille que les autres sections
            SizedBox(
              height: 380,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: urgentActivities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final activity = urgentActivities[index];
                  return SizedBox(
                    width: 200,
                    child: _FullCountdownCard(
                      activity: activity,
                      remainingSpots: (activity.id.hashCode % 10) + 1,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
