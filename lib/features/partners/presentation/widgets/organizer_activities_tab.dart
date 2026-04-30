import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/colors.dart';
import '../../../events/data/mappers/event_mapper.dart';
import '../../../events/domain/entities/event.dart';
import '../providers/organizer_profile_providers.dart';
import '../utils/event_timing_bucket.dart';

/// "Activités" tab — segmented toggle (Current/Upcoming vs Past) over a
/// paginated event list.
///
/// Spec §1, §4, §7
class OrganizerActivitiesTab extends ConsumerStatefulWidget {
  final String organizerIdentifier;

  const OrganizerActivitiesTab({super.key, required this.organizerIdentifier});

  @override
  ConsumerState<OrganizerActivitiesTab> createState() =>
      _OrganizerActivitiesTabState();
}

class _OrganizerActivitiesTabState
    extends ConsumerState<OrganizerActivitiesTab> {
  final _scrollController = ScrollController();
  EventTimingBucket _bucket = EventTimingBucket.currentUpcoming;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      ref
          .read(organizerEventsControllerProvider(widget.organizerIdentifier)
              .notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(
      organizerEventsControllerProvider(widget.organizerIdentifier),
    );

    return asyncState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: HbColors.brandPrimary),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Impossible de charger les activités.',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ),
      data: (state) {
        final now = DateTime.now();
        final events =
            state.events.map(EventMapper.toEvent).toList(growable: false);

        // Bucketing may throw UnimplementedError until the user fills in
        // bucketFor — fail soft so the rest of the screen stays usable.
        List<Event> current;
        List<Event> past;
        try {
          current = [
            for (final e in events)
              if (bucketFor(e, now) == EventTimingBucket.currentUpcoming) e,
          ];
          past = [
            for (final e in events)
              if (bucketFor(e, now) == EventTimingBucket.past) e,
          ];
        } on UnimplementedError {
          current = events;
          past = const [];
        }

        final visible = _bucket == EventTimingBucket.currentUpcoming
            ? current
            : past;

        if (events.isEmpty) {
          return _empty('Aucune activité publiée pour le moment.');
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          children: [
            _SegmentedToggle(
              bucket: _bucket,
              currentCount: current.length,
              pastCount: past.length,
              onChanged: (b) => setState(() => _bucket = b),
            ),
            const SizedBox(height: 16),
            if (visible.isEmpty)
              _empty(_bucket == EventTimingBucket.currentUpcoming
                  ? 'Pas d\'événement à venir.'
                  : 'Pas d\'événement passé.')
            else
              ...visible.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _OrganizerEventTile(event: e),
                  )),
            if (state.isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: HbColors.brandPrimary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _empty(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final EventTimingBucket bucket;
  final int currentCount;
  final int pastCount;
  final ValueChanged<EventTimingBucket> onChanged;

  const _SegmentedToggle({
    required this.bucket,
    required this.currentCount,
    required this.pastCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _segment(
              label: 'En cours ($currentCount)',
              selected: bucket == EventTimingBucket.currentUpcoming,
              onTap: () => onChanged(EventTimingBucket.currentUpcoming),
            ),
          ),
          Expanded(
            child: _segment(
              label: 'Passés ($pastCount)',
              selected: bucket == EventTimingBucket.past,
              onTap: () => onChanged(EventTimingBucket.past),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF1A1A2E) : Colors.grey[600],
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrganizerEventTile extends StatelessWidget {
  final Event event;
  const _OrganizerEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/event/${event.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 96,
              height: 96,
              child: event.coverImage != null && event.coverImage!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: event.coverImage!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[100]),
                      errorWidget: (_, __, ___) => _imageFallback(),
                    )
                  : _imageFallback(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF1A1A2E),
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          DateFormat('dd MMM yyyy', 'fr')
                              .format(event.startDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 13, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.city.isEmpty ? 'France' : event.city,
                          style: const TextStyle(
                            fontSize: 12,
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey[100],
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey[400],
      ),
    );
  }
}
