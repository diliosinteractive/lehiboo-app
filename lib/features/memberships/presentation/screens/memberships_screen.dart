import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/membership_dto.dart';
import '../providers/membership_state_providers.dart';
import '../providers/memberships_screen_providers.dart';
import '../widgets/invitation_card.dart';
import '../widgets/membership_card.dart';

/// "Mes adhésions" — spec §13.1.
///
/// Fetches `/me/memberships` once and splits client-side into 4 tabs
/// (Active, En attente, Refusées, Invitations). Search is client-side.
/// Pull-to-refresh re-fetches both endpoints (per spec §14.1 step 8).
class MembershipsScreen extends ConsumerStatefulWidget {
  /// Optional initial tab from `?tab=` query (push-notification deep-links).
  /// Accepts `active` / `pending` / `rejected` / `invitations`.
  final String? initialTab;

  const MembershipsScreen({super.key, this.initialTab});

  @override
  ConsumerState<MembershipsScreen> createState() => _MembershipsScreenState();
}

class _MembershipsScreenState extends ConsumerState<MembershipsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _resolveInitialIndex(widget.initialTab),
    );
  }

  static int _resolveInitialIndex(String? tab) {
    return switch (tab) {
      'active' => 0,
      'pending' => 1,
      'rejected' => 2,
      'invitations' => 3,
      _ => 0,
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(membershipsSearchProvider.notifier).state = q.trim();
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(myMembershipsListProvider);
    ref.invalidate(myInvitationsProvider);
    await Future.wait([
      ref.read(myMembershipsListProvider.future),
      ref.read(myInvitationsProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final listAsync = ref.watch(myMembershipsListProvider);
    final invitationsAsync = ref.watch(myInvitationsProvider);
    final searchQuery = ref.watch(membershipsSearchProvider).toLowerCase();

    final all = listAsync.valueOrNull?.data ?? const <MembershipDto>[];
    final filtered = searchQuery.isEmpty
        ? all
        : all.where((m) {
            final name = m.organization?.name.toLowerCase() ?? '';
            return name.contains(searchQuery);
          }).toList();

    final active =
        filtered.where((m) => m.status == MembershipStatus.active).toList();
    final pending =
        filtered.where((m) => m.status == MembershipStatus.pending).toList();
    final rejected =
        filtered.where((m) => m.status == MembershipStatus.rejected).toList();
    final invitations = invitationsAsync.valueOrNull ?? const [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.profileMembershipsTitle,
          style: const TextStyle(
            color: HbColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: HbColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48 + 56),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: l10n.membershipSearchOrganizationHint,
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
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: HbColors.brandPrimary,
                labelColor: HbColors.brandPrimary,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: GoogleFonts.figtree(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: l10n.membershipTabActive(active.length)),
                  Tab(text: l10n.membershipTabPending(pending.length)),
                  Tab(text: l10n.membershipTabRejected(rejected.length)),
                  Tab(
                    text: l10n.membershipTabInvitations(invitations.length),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: listAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (e, _) => _ErrorState(onRetry: _refresh),
        data: (_) => RefreshIndicator(
          color: HbColors.brandPrimary,
          onRefresh: _refresh,
          child: TabBarView(
            controller: _tabController,
            children: [
              _MembershipList(
                items: active,
                emptyCopy: l10n.membershipEmptyActive,
                showDiscoverCta: true,
              ),
              _MembershipList(
                items: pending,
                emptyCopy: l10n.membershipEmptyPending,
              ),
              _MembershipList(
                items: rejected,
                emptyCopy: l10n.membershipEmptyRejected,
              ),
              _InvitationsList(
                items: invitations,
                onAccepted: () => _tabController.animateTo(0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MembershipList extends StatelessWidget {
  final List<MembershipDto> items;
  final String emptyCopy;
  final bool showDiscoverCta;

  const _MembershipList({
    required this.items,
    required this.emptyCopy,
    this.showDiscoverCta = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
            child: Column(
              children: [
                Icon(Icons.workspaces_outline,
                    size: 56, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  emptyCopy,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                if (showDiscoverCta) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/search'),
                    icon: const Icon(Icons.explore_outlined, size: 18),
                    label: Text(context.l10n.membershipDiscoverOrganizations),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HbColors.brandPrimary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: items.length,
      itemBuilder: (context, index) => MembershipCard(membership: items[index]),
    );
  }
}

class _InvitationsList extends StatelessWidget {
  final List<dynamic> items;
  final VoidCallback onAccepted;

  const _InvitationsList({required this.items, required this.onAccepted});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
            child: Column(
              children: [
                Icon(Icons.mark_email_unread_outlined,
                    size: 56, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  context.l10n.membershipEmptyInvitations,
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
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: items.length,
      itemBuilder: (context, index) => InvitationCard(
        invitation: items[index],
        onAccepted: onAccepted,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.membershipLoadError,
              style: GoogleFonts.figtree(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.commonRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
