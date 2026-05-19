import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/conversations_provider.dart';
import '../providers/support_conversations_provider.dart';
import '../providers/vendor_broadcasts_provider.dart';
import '../providers/vendor_conversations_provider.dart';
import '../providers/vendor_org_conversations_provider.dart';
import '../providers/admin_conversations_provider.dart';
import '../widgets/broadcast_tile.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/conversation_filters_bar.dart';
import '../widgets/new_conversation_form.dart';
import '../widgets/report_conversation_sheet.dart';
import '../../domain/entities/conversation.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';

class ConversationsListScreen extends ConsumerStatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  ConsumerState<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState
    extends ConsumerState<ConversationsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.unauthenticated) {
        GuestRestrictionDialog.show(
          context,
          featureName: context.l10n.guestFeatureViewMessages,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authProvider).user?.role ?? UserRole.subscriber;

    return switch (role) {
      UserRole.partner => const _VendorInbox(key: ValueKey('vendor')),
      UserRole.admin => const _AdminInbox(key: ValueKey('admin')),
      _ => const _SubscriberInbox(key: ValueKey('subscriber')),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared widgets
// ─────────────────────────────────────────────────────────────────────────────

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFF601F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Widget _buildConversationList<N extends StateNotifier<S>, S>({
  required BuildContext context,
  required AsyncValue<List> asyncConversations,
  required bool hasMore,
  required VoidCallback onLoadMore,
  required VoidCallback onRefresh,
  required String Function(dynamic conv) routeFor,
  required Widget emptyWidget,
  bool showLehibooAvatar = false,
  void Function(dynamic conv)? onReportTap,
}) {
  return asyncConversations.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text(context.l10n.messagesLoadError('$e'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    ),
    data: (conversations) {
      if (conversations.isEmpty) return emptyWidget;
      return NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollUpdateNotification &&
              n.metrics.pixels >= n.metrics.maxScrollExtent * 0.8) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          itemCount: conversations.length + (hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
          itemBuilder: (ctx, i) {
            if (i == conversations.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final conv = conversations[i];
            return ConversationTile(
              conversation: conv,
              onTap: () => ctx.push(routeFor(conv)),
              showLehibooAvatar: showLehibooAvatar,
              onReport: onReportTap != null ? () => onReportTap(conv) : null,
            );
          },
        ),
      );
    },
  );
}

Future<void> _showVendorReportSheet(
  BuildContext context,
  WidgetRef ref,
  Conversation conv,
) =>
    showConversationReportSheet(
      context,
      conversationUuid: conv.uuid,
      ref: ref,
    );

Widget _emptyConversations(BuildContext context, [String? label]) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.forum_outlined, size: 56, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            label ?? context.l10n.messagesNoConversations,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );

// ─────────────────────────────────────────────────────────────────────────────
// Subscriber inbox (role: user) — 2 tabs: Organisateurs + Support LeHiboo
// ─────────────────────────────────────────────────────────────────────────────

class _SubscriberInbox extends ConsumerStatefulWidget {
  const _SubscriberInbox({super.key});

  @override
  ConsumerState<_SubscriberInbox> createState() => _SubscriberInboxState();
}

class _SubscriberInboxState extends ConsumerState<_SubscriberInbox>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _primaryColor = Color(0xFFFF601F);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorState = ref.watch(conversationsProvider);
    final supportState = ref.watch(supportConversationsProvider);

    final vendorUnread = vendorState.conversations.valueOrNull
            ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
        0;
    final supportUnread = supportState.conversations.valueOrNull
            ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
        0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.messagesTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primaryColor,
          indicatorColor: _primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabOrganizers),
                  if (vendorUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: vendorUnread),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabSupportLeHiboo),
                  if (supportUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: supportUnread),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _SubscriberOrgTab(),
          _SupportTab(),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          if (_tabController.index == 0) {
            return FloatingActionButton.extended(
              onPressed: () => context.push('/messages/new'),
              backgroundColor: _primaryColor,
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              label: Text(context.l10n.messagesNewMessage,
                  style: const TextStyle(color: Colors.white)),
            );
          }
          return FloatingActionButton.extended(
            onPressed: () => context.push('/messages/support/new'),
            backgroundColor: _primaryColor,
            icon: const Icon(Icons.support_agent, color: Colors.white),
            label: Text(context.l10n.messagesContactSupport,
                style: const TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}

class _SubscriberOrgTab extends ConsumerWidget {
  const _SubscriberOrgTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationsProvider);
    final notifier = ref.read(conversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: true,
            showPeriod: true,
            showUnreadOnly: true,
            searchQuery: state.searchQuery,
            statusFilter: state.statusFilter,
            periodFilter: state.period,
            unreadOnly: state.unreadOnly,
            onSearchChanged: notifier.setSearchQuery,
            onStatusChanged: notifier.setStatusFilter,
            onPeriodChanged: notifier.setPeriod,
            onUnreadOnlyChanged: notifier.setUnreadOnly,
            onReasonChanged: (_) {},
          ),
          Expanded(
            child: _buildConversationList(
              context: context,
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/${conv.uuid}',
              emptyWidget: _emptyConversations(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportTab extends ConsumerWidget {
  const _SupportTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(supportConversationsProvider);
    final notifier = ref.read(supportConversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: true,
            showPeriod: true,
            showUnreadOnly: true,
            showReason: false,
            searchQuery: state.searchQuery,
            statusFilter: state.statusFilter,
            periodFilter: state.period,
            unreadOnly: state.unreadOnly,
            onSearchChanged: notifier.setSearchQuery,
            onStatusChanged: notifier.setStatusFilter,
            onPeriodChanged: notifier.setPeriod,
            onUnreadOnlyChanged: notifier.setUnreadOnly,
            onReasonChanged: (_) {},
          ),
          Expanded(
            child: _buildConversationList(
              context: context,
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/support/${conv.uuid}',
              showLehibooAvatar: true,
              emptyWidget: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.support_agent,
                        size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.messagesNoSupportConversations,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
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

// ─────────────────────────────────────────────────────────────────────────────
// Vendor inbox (role: partner) — 4 tabs
// ─────────────────────────────────────────────────────────────────────────────

class _VendorInbox extends ConsumerStatefulWidget {
  const _VendorInbox({super.key});

  @override
  ConsumerState<_VendorInbox> createState() => _VendorInboxState();
}

class _VendorInboxState extends ConsumerState<_VendorInbox>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static const _primaryColor = Color(0xFFFF601F);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientUnread = ref
            .watch(vendorConversationsProvider)
            .conversations
            .valueOrNull
            ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
        0;
    final supportUnread = ref
            .watch(vendorSupportProvider)
            .conversations
            .valueOrNull
            ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
        0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.messagesTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primaryColor,
          indicatorColor: _primaryColor,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabClients),
                  if (clientUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: clientUnread),
                  ],
                ],
              ),
            ),
            Tab(text: context.l10n.messagesTabBroadcasts),
            // TODO v2: restore Partenaires tab
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabSupport),
                  if (supportUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: supportUnread),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _VendorClientsTab(),
          _VendorBroadcastsTab(),
          // TODO v2: _VendorPartnersTab(),
          _VendorSupportTab(),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (ctx, _) {
          return switch (_tabController.index) {
            0 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext:
                        VendorToParticipantConversationContext()),
                backgroundColor: _primaryColor,
                icon:
                    const Icon(Icons.person_add_outlined, color: Colors.white),
                label: Text(context.l10n.messagesContactParticipant,
                    style: const TextStyle(color: Colors.white)),
              ),
            1 => FloatingActionButton.extended(
                onPressed: () => ctx.push('/messages/vendor/broadcasts/new'),
                backgroundColor: _primaryColor,
                icon: const Icon(Icons.campaign_outlined, color: Colors.white),
                label: Text(context.l10n.messagesNewBroadcast,
                    style: const TextStyle(color: Colors.white)),
              ),
            // TODO v2: case 2 => Partenaires FAB
            2 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext: VendorSupportConversationContext()),
                backgroundColor: _primaryColor,
                icon: const Icon(Icons.support_agent, color: Colors.white),
                label: Text(context.l10n.messagesSupportTicket,
                    style: const TextStyle(color: Colors.white)),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _VendorClientsTab extends ConsumerWidget {
  const _VendorClientsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorConversationsProvider);
    final notifier = ref.read(vendorConversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: true,
            showPeriod: true,
            showUnreadOnly: true,
            searchQuery: state.searchQuery,
            statusFilter: state.statusFilter,
            periodFilter: state.period,
            unreadOnly: state.unreadOnly,
            onSearchChanged: notifier.setSearchQuery,
            onStatusChanged: notifier.setStatusFilter,
            onPeriodChanged: notifier.setPeriod,
            onUnreadOnlyChanged: notifier.setUnreadOnly,
            onReasonChanged: (_) {},
          ),
          Expanded(
            child: _buildConversationList(
              context: context,
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/vendor/${conv.uuid}',
              emptyWidget:
                  _emptyConversations(context, context.l10n.messagesNoClients),
              onReportTap: (conv) =>
                  _showVendorReportSheet(context, ref, conv as Conversation),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorBroadcastsTab extends ConsumerWidget {
  const _VendorBroadcastsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorBroadcastsProvider);
    final notifier = ref.read(vendorBroadcastsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: false,
            showPeriod: true,
            showUnreadOnly: false,
            searchQuery: state.searchQuery,
            periodFilter: state.period,
            onSearchChanged: notifier.setSearchQuery,
            onPeriodChanged: notifier.setPeriod,
            onStatusChanged: (_) {},
            onUnreadOnlyChanged: (_) {},
            onReasonChanged: (_) {},
          ),
          Expanded(
            child: state.broadcasts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 8),
                    Text(context.l10n.messagesLoadError('$e'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: notifier.refresh,
                      child: Text(context.l10n.commonRetry),
                    ),
                  ],
                ),
              ),
              data: (broadcasts) {
                if (broadcasts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.campaign_outlined,
                            size: 56, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.messagesNoBroadcasts,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollUpdateNotification &&
                        n.metrics.pixels >= n.metrics.maxScrollExtent * 0.8) {
                      notifier.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    itemCount: broadcasts.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (ctx, i) {
                      if (i == broadcasts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final broadcast = broadcasts[i];
                      return BroadcastTile(
                        broadcast: broadcast,
                        onTap: () => ctx.push(
                            '/messages/vendor/broadcasts/${broadcast.uuid}'),
                      );
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

// TODO v2: restore the partners tab in `_VendorInbox`.
// ignore: unused_element
class _VendorPartnersTab extends ConsumerWidget {
  const _VendorPartnersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorOrgConversationsProvider);
    final notifier = ref.read(vendorOrgConversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: true,
            showPeriod: true,
            showUnreadOnly: true,
            searchQuery: state.searchQuery,
            statusFilter: state.statusFilter,
            periodFilter: state.period,
            unreadOnly: state.unreadOnly,
            onSearchChanged: notifier.setSearchQuery,
            onStatusChanged: notifier.setStatusFilter,
            onPeriodChanged: notifier.setPeriod,
            onUnreadOnlyChanged: notifier.setUnreadOnly,
            onReasonChanged: (_) {},
          ),
          Expanded(
            child: _buildConversationList(
              context: context,
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/vendor-org/${conv.uuid}',
              emptyWidget:
                  _emptyConversations(context, context.l10n.messagesNoPartners),
              onReportTap: (conv) =>
                  _showVendorReportSheet(context, ref, conv as Conversation),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorSupportTab extends ConsumerWidget {
  const _VendorSupportTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorSupportProvider);
    final notifier = ref.read(vendorSupportProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: _buildConversationList(
        context: context,
        asyncConversations: state.conversations,
        hasMore: state.hasMore,
        onLoadMore: notifier.loadMore,
        onRefresh: notifier.refresh,
        routeFor: (conv) => '/messages/vendor/${conv.uuid}',
        emptyWidget:
            _emptyConversations(context, context.l10n.messagesNoSupportTickets),
        showLehibooAvatar: true,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Admin inbox (role: admin) — 3 tabs
// ─────────────────────────────────────────────────────────────────────────────

class _AdminInbox extends ConsumerStatefulWidget {
  const _AdminInbox({super.key});

  @override
  ConsumerState<_AdminInbox> createState() => _AdminInboxState();
}

class _AdminInboxState extends ConsumerState<_AdminInbox>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static const _primaryColor = Color(0xFFFF601F);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(adminConversationsProvider('user_support'));
    final orgsState = ref.watch(adminConversationsProvider('vendor_admin'));
    final reportStats = ref.watch(adminReportStatsProvider);

    final usersUnread = usersState.conversations.valueOrNull
            ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
        0;
    final orgsUnread = orgsState.conversations.valueOrNull
            ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
        0;
    final pendingReports = reportStats.valueOrNull?.pending ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.messagesTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primaryColor,
          indicatorColor: _primaryColor,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabUsers),
                  if (usersUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: usersUnread),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabOrganizers),
                  if (orgsUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: orgsUnread),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.messagesTabReports),
                  if (pendingReports > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: pendingReports),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AdminConvTab(conversationType: 'user_support'),
          _AdminConvTab(conversationType: 'vendor_admin'),
          _AdminReportsTab(),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (ctx, _) {
          return switch (_tabController.index) {
            0 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext: AdminToUserConversationContext()),
                backgroundColor: _primaryColor,
                icon:
                    const Icon(Icons.person_add_outlined, color: Colors.white),
                label: Text(context.l10n.messagesContactUser,
                    style: const TextStyle(color: Colors.white)),
              ),
            1 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext: AdminToOrgConversationContext()),
                backgroundColor: _primaryColor,
                icon: const Icon(Icons.business_outlined, color: Colors.white),
                label: Text(context.l10n.messagesContactOrganizer,
                    style: const TextStyle(color: Colors.white)),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _AdminConvTab extends ConsumerWidget {
  final String conversationType;

  const _AdminConvTab({required this.conversationType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminConversationsProvider(conversationType));
    final notifier =
        ref.read(adminConversationsProvider(conversationType).notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: true,
            showPeriod: true,
            showUnreadOnly: true,
            searchQuery: state.searchQuery,
            statusFilter: state.statusFilter,
            periodFilter: state.period,
            unreadOnly: state.unreadOnly,
            onSearchChanged: notifier.setSearchQuery,
            onStatusChanged: notifier.setStatusFilter,
            onPeriodChanged: notifier.setPeriod,
            onUnreadOnlyChanged: notifier.setUnreadOnly,
            onReasonChanged: (_) {},
          ),
          Expanded(
            child: _buildConversationList(
              context: context,
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/admin/${conv.uuid}',
              emptyWidget: _emptyConversations(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminReportsTab extends ConsumerWidget {
  const _AdminReportsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminReportsProvider);
    final notifier = ref.read(adminReportsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          ConversationFiltersBar(
            showSearch: true,
            showStatus: false,
            showPeriod: false,
            showUnreadOnly: false,
            showReason: true,
            searchQuery: state.searchQuery,
            reasonFilter: state.reasonFilter,
            onSearchChanged: notifier.setSearch,
            onReasonChanged: notifier.setReasonFilter,
            onStatusChanged: (_) {},
            onPeriodChanged: (_) {},
            onUnreadOnlyChanged: (_) {},
          ),
          Expanded(
            child: state.reports.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 8),
                    Text(context.l10n.messagesLoadError('$e'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: notifier.refresh,
                      child: Text(context.l10n.commonRetry),
                    ),
                  ],
                ),
              ),
              data: (reports) {
                if (reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flag_outlined,
                            size: 56, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.messagesNoReports,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollUpdateNotification &&
                        n.metrics.pixels >= n.metrics.maxScrollExtent * 0.8) {
                      notifier.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    itemCount: reports.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (ctx, i) {
                      if (i == reports.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final report = reports[i];
                      final (statusLabel, statusColor) =
                          switch (report.status) {
                        'pending' => (
                            context.l10n.messagesStatusPending,
                            Colors.orange
                          ),
                        'reviewed' => (
                            context.l10n.messagesAdminReportStatusReviewed,
                            Colors.green
                          ),
                        'dismissed' => (
                            context.l10n.messagesAdminReportStatusDismissed,
                            Colors.grey.shade600
                          ),
                        'suspended' => (
                            context.l10n.messagesAdminReportStatusSuspended,
                            Colors.red
                          ),
                        _ => (report.status, Colors.grey.shade600),
                      };
                      final reasonLabel = switch (report.reason) {
                        'inappropriate' =>
                          context.l10n.messagesReasonInappropriate,
                        'harassment' => context.l10n.messagesReasonHarassment,
                        'spam' => context.l10n.messagesReasonSpam,
                        _ => context.l10n.messagesReasonOther,
                      };
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.flag, size: 18, color: statusColor),
                        ),
                        title: Text(
                          report.conversationSubject ??
                              context.l10n.messagesAdminReportFallbackTitle(
                                report.uuid.substring(0, 8),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              '${report.reporter?.name ?? '–'} → ${report.againstWhom?.name ?? '–'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                reasonLabel,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                                fontSize: 11,
                                color: statusColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onTap: () =>
                            ctx.push('/messages/admin/reports/${report.uuid}'),
                      );
                    },
                  ),
                );
              },
            ),
          ), // Expanded
        ],
      ), // Column
    );
  }
}
