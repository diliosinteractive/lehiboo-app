import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/colors.dart';
import '../../../events/data/mappers/event_mapper.dart';
import '../../../events/domain/entities/event.dart';
import '../../data/models/membership_dto.dart';
import '../providers/membership_state_providers.dart';
import '../providers/private_events_provider.dart';

/// "Mes événements privés" — spec §13.3.
///
/// Paginated list of events from orgs where the user is `active`. Search +
/// organization filter (active orgs only). Empty state guides the user to
/// discovery (`/search`) when no active memberships exist.
class PrivateEventsScreen extends ConsumerStatefulWidget {
  /// Optional initial filter from `?org=<uuid>` (e.g. tapped from a
  /// membership card's "Voir les événements privés" link).
  final String? initialOrgFilter;

  const PrivateEventsScreen({super.key, this.initialOrgFilter});

  @override
  ConsumerState<PrivateEventsScreen> createState() =>
      _PrivateEventsScreenState();
}

class _PrivateEventsScreenState extends ConsumerState<PrivateEventsScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.initialOrgFilter != null && widget.initialOrgFilter!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(privateEventsOrgFilterProvider.notifier).state =
            widget.initialOrgFilter;
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      ref.read(privateEventsControllerProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String q) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(privateEventsSearchProvider.notifier).state = q.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeOrgs = (ref.watch(myMembershipsListProvider).valueOrNull?.data ??
            const <MembershipDto>[])
        .where((m) => m.status == MembershipStatus.active)
        .map((m) => m.organization)
        .whereType<OrganizationSummaryDto>()
        .where((o) => (o.uuid ?? '').isNotEmpty)
        .toList();

    final selectedOrg = ref.watch(privateEventsOrgFilterProvider);
    final asyncState = ref.watch(privateEventsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mes événements privés',
          style: TextStyle(
            color: HbColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: HbColors.textPrimary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher un événement…',
                hintStyle: GoogleFonts.figtree(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          if (activeOrgs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: _OrgFilterDropdown(
                orgs: activeOrgs,
                selectedUuid: selectedOrg,
                onChanged: (uuid) =>
                    ref.read(privateEventsOrgFilterProvider.notifier).state =
                        uuid,
              ),
            ),
          Expanded(
            child: asyncState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: HbColors.brandPrimary),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Impossible de charger les événements.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              data: (state) {
                if (state.events.isEmpty) {
                  return _EmptyState(
                    hasActiveMemberships: activeOrgs.isNotEmpty,
                    isFiltered: ref.read(privateEventsSearchProvider).isNotEmpty ||
                        selectedOrg != null,
                  );
                }
                return RefreshIndicator(
                  color: HbColors.brandPrimary,
                  onRefresh: () => ref
                      .read(privateEventsControllerProvider.notifier)
                      .refresh(),
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.events.length +
                        (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[100],
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      if (index == state.events.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: HbColors.brandPrimary,
                            ),
                          ),
                        );
                      }
                      final event = EventMapper.toEvent(state.events[index]);
                      return _PrivateEventTile(event: event);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrgFilterDropdown extends StatelessWidget {
  final List<OrganizationSummaryDto> orgs;
  final String? selectedUuid;
  final ValueChanged<String?> onChanged;

  const _OrgFilterDropdown({
    required this.orgs,
    required this.selectedUuid,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: selectedUuid,
                isExpanded: true,
                hint: Text(
                  'Toutes les organisations',
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'Toutes les organisations',
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        color: HbColors.textPrimary,
                      ),
                    ),
                  ),
                  for (final o in orgs)
                    DropdownMenuItem<String?>(
                      value: o.uuid,
                      child: Text(
                        o.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          color: HbColors.textPrimary,
                        ),
                      ),
                    ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateEventTile extends StatelessWidget {
  final Event event;

  const _PrivateEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/event/${event.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    Row(
                      children: [
                        const Icon(Icons.lock_outline,
                            size: 13, color: HbColors.brandPrimary),
                        const SizedBox(width: 4),
                        Text(
                          'Privé',
                          style: GoogleFonts.figtree(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: HbColors.brandPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HbColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy', 'fr').format(event.startDate),
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (event.city.isNotEmpty)
                      Text(
                        event.city,
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: HbColors.brandPrimary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() => Container(
        color: Colors.grey[100],
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[400]),
      );
}

class _EmptyState extends StatelessWidget {
  final bool hasActiveMemberships;
  final bool isFiltered;

  const _EmptyState({
    required this.hasActiveMemberships,
    required this.isFiltered,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasActiveMemberships) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.lock_outline, size: 56, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "Aucun événement privé pour l'instant.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rejoignez des organisations pour découvrir leurs activités exclusives.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.push('/search'),
                  icon: const Icon(Icons.explore_outlined, size: 18),
                  label: const Text('Découvrir les organisations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.event_busy_outlined,
                  size: 56, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                isFiltered
                    ? 'Aucun événement privé correspondant.'
                    : "Aucun événement privé pour l'instant.",
                textAlign: TextAlign.center,
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
