import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/conversations_provider.dart';
import '../providers/support_conversations_provider.dart';
import '../providers/vendor_conversations_provider.dart';
import '../providers/vendor_org_conversations_provider.dart';
import '../providers/admin_conversations_provider.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/conversation_filters_bar.dart';
import '../widgets/new_conversation_form.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/conversation.dart';
import 'package:lehiboo/domain/entities/user.dart';
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
        GuestRestrictionDialog.show(context, featureName: 'voir vos messages');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final role =
        ref.watch(authProvider).user?.role ?? UserRole.subscriber;

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
          Text('Erreur : $e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRefresh, child: const Text('Réessayer')),
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
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 72),
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
) async {
  String? selectedReason;
  final commentCtrl = TextEditingController();
  const primaryColor = Color(0xFFFF601F);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollCtrl) => SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Signaler cette conversation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  conv.subject,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  hint: const Text('Motif du signalement'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.5),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'inappropriate',
                        child: Text('Contenu inapproprié')),
                    DropdownMenuItem(
                        value: 'harassment', child: Text('Harcèlement')),
                    DropdownMenuItem(value: 'spam', child: Text('Spam')),
                    DropdownMenuItem(value: 'other', child: Text('Autre')),
                  ],
                  onChanged: (v) => setLocal(() => selectedReason = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Commentaire (optionnel)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.5),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: selectedReason == null
                            ? null
                            : () async {
                                Navigator.pop(ctx);
                                try {
                                  await ref
                                      .read(messagesRepositoryProvider)
                                      .reportConversation(
                                        conversationUuid: conv.uuid,
                                        reason: selectedReason!,
                                        comment: commentCtrl.text.trim().isEmpty
                                            ? null
                                            : commentCtrl.text.trim(),
                                      );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Conversation signalée avec succès')),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Erreur : $e'),
                                          backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                        child: const Text('Signaler'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  commentCtrl.dispose();
}

Widget _emptyConversations([String? label]) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.forum_outlined, size: 56, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            label ?? 'Aucune conversation',
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
        title: const Text('Messages'),
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
                  const Text('Organisateurs'),
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
                  const Text('Support LeHiboo'),
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
              label: const Text('Nouveau message',
                  style: TextStyle(color: Colors.white)),
            );
          }
          return FloatingActionButton.extended(
            onPressed: () => context.push('/messages/support/new'),
            backgroundColor: _primaryColor,
            icon: const Icon(Icons.support_agent, color: Colors.white),
            label: const Text('Contacter le support',
                style: TextStyle(color: Colors.white)),
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
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/${conv.uuid}',
              emptyWidget: _emptyConversations(),
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
      child: _buildConversationList(
        asyncConversations: state.conversations,
        hasMore: state.hasMore,
        onLoadMore: notifier.loadMore,
        onRefresh: notifier.refresh,
        routeFor: (conv) => '/messages/support/${conv.uuid}',
        emptyWidget: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.support_agent, size: 56, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Aucune conversation avec le support',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
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
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Messages'),
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
                  const Text('Clients'),
                  if (clientUnread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: clientUnread),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Diffusions'),
            const Tab(text: 'Partenaires'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Support'),
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
          _VendorBroadcastsStub(),
          _VendorPartnersTab(),
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
                icon: const Icon(Icons.person_add_outlined,
                    color: Colors.white),
                label: const Text('Contacter un participant',
                    style: TextStyle(color: Colors.white)),
              ),
            2 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext:
                        VendorToPartnerConversationContext()),
                backgroundColor: _primaryColor,
                icon: const Icon(Icons.handshake_outlined,
                    color: Colors.white),
                label: const Text('Contacter un partenaire',
                    style: TextStyle(color: Colors.white)),
              ),
            3 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext: VendorSupportConversationContext()),
                backgroundColor: _primaryColor,
                icon: const Icon(Icons.support_agent, color: Colors.white),
                label: const Text('Ticket support',
                    style: TextStyle(color: Colors.white)),
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
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/vendor/${conv.uuid}',
              emptyWidget: _emptyConversations('Aucun client'),
              onReportTap: (conv) =>
                  _showVendorReportSheet(context, ref, conv as Conversation),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorBroadcastsStub extends StatelessWidget {
  const _VendorBroadcastsStub();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.campaign_outlined, size: 56, color: Colors.grey),
          SizedBox(height: 12),
          Text('Bientôt disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

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
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/vendor-org/${conv.uuid}',
              emptyWidget: _emptyConversations('Aucun partenaire'),
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
        asyncConversations: state.conversations,
        hasMore: state.hasMore,
        onLoadMore: notifier.loadMore,
        onRefresh: notifier.refresh,
        routeFor: (conv) => '/messages/vendor/${conv.uuid}',
        emptyWidget: _emptyConversations('Aucun ticket support'),
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
    final usersState =
        ref.watch(adminConversationsProvider('user_support'));
    final orgsState =
        ref.watch(adminConversationsProvider('vendor_admin'));
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
        title: const Text('Messages'),
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
                  const Text('Utilisateurs'),
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
                  const Text('Organisateurs'),
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
                  const Text('Signalements'),
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
                icon: const Icon(Icons.person_add_outlined,
                    color: Colors.white),
                label: const Text('Contacter un utilisateur',
                    style: TextStyle(color: Colors.white)),
              ),
            1 => FloatingActionButton.extended(
                onPressed: () => NewConversationForm.show(ctx,
                    conversationContext: AdminToOrgConversationContext()),
                backgroundColor: _primaryColor,
                icon: const Icon(Icons.business_outlined,
                    color: Colors.white),
                label: const Text('Contacter un organisateur',
                    style: TextStyle(color: Colors.white)),
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
              asyncConversations: state.conversations,
              hasMore: state.hasMore,
              onLoadMore: notifier.loadMore,
              onRefresh: notifier.refresh,
              routeFor: (conv) => '/messages/admin/${conv.uuid}',
              emptyWidget: _emptyConversations(),
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
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text('Erreur : $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: notifier.refresh,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag_outlined, size: 56, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Aucun signalement',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollUpdateNotification &&
                  n.metrics.pixels >=
                      n.metrics.maxScrollExtent * 0.8) {
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
                final (statusLabel, statusColor) = switch (report.status) {
                  'pending' => ('En attente', Colors.orange),
                  'reviewed' => ('Traité', Colors.green),
                  'dismissed' => ('Ignoré', Colors.grey.shade600),
                  'suspended' => ('Suspendu', Colors.red),
                  _ => (report.status, Colors.grey.shade600),
                };
                final reasonLabel = switch (report.reason) {
                  'inappropriate' => 'Contenu inapproprié',
                  'harassment' => 'Harcèlement',
                  'spam' => 'Spam',
                  _ => 'Autre',
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
                        'Signalement ${report.uuid.substring(0, 8)}',
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
                  onTap: () => ctx.push(
                      '/messages/admin/reports/${report.uuid}'),
                );
              },
            ),
          );
        },
      ),
    ),   // Expanded
        ],
      ),   // Column
    );
  }
}
