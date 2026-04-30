import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/conversations_provider.dart';
import '../providers/support_conversations_provider.dart';
import '../widgets/conversation_tile.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';

class ConversationsListScreen extends ConsumerStatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  ConsumerState<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState
    extends ConsumerState<ConversationsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  Timer? _debounce;

  static const _primaryColor = Color(0xFFFF601F);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Safety check for unauthenticated users (e.g. deep links)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.unauthenticated) {
        GuestRestrictionDialog.show(context, featureName: 'voir vos messages');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref
          .read(conversationsProvider.notifier)
          .setSearchQuery(value.isEmpty ? null : value);
    });
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          children: [
            _VendorTab(searchController: _searchController, onSearchChanged: _onSearchChanged),
            const _SupportTab(),
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
      ),
    );
  }
}

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

class _VendorTab extends ConsumerWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _VendorTab({
    required this.searchController,
    required this.onSearchChanged,
  });

  static const _filters = [
    (label: 'Tous', status: null, unreadOnly: false),
    (label: 'Non lus', status: null, unreadOnly: true),
    (label: 'Ouverts', status: 'open', unreadOnly: false),
    (label: 'Fermés', status: 'closed', unreadOnly: false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationsProvider);
    final notifier = ref.read(conversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher…',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: _filters.map((f) {
                final isActive = f.unreadOnly
                    ? state.unreadOnly
                    : (!state.unreadOnly && state.statusFilter == f.status);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f.label),
                    selected: isActive,
                    onSelected: (_) {
                      if (f.unreadOnly) {
                        notifier.setUnreadOnly(!state.unreadOnly);
                      } else {
                        notifier.setUnreadOnly(false);
                        notifier.setStatusFilter(f.status);
                      }
                    },
                    selectedColor:
                        const Color(0xFFFF601F).withValues(alpha: 0.15),
                    checkmarkColor: const Color(0xFFFF601F),
                    labelStyle: TextStyle(
                      color: isActive
                          ? const Color(0xFFFF601F)
                          : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: state.conversations.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
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
              data: (conversations) {
                if (conversations.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.forum_outlined,
                            size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Aucune conversation',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final metrics = notification.metrics;
                      if (metrics.pixels >=
                          metrics.maxScrollExtent * 0.8) {
                        notifier.loadMore();
                      }
                    }
                    return false;
                  },
                  child: ListView.separated(
                    itemCount: conversations.length +
                        (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, index) {
                      if (index == conversations.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                              child: CircularProgressIndicator()),
                        );
                      }
                      final conversation = conversations[index];
                      return ConversationTile(
                        conversation: conversation,
                        onTap: () => context
                            .push('/messages/${conversation.uuid}'),
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

class _SupportTab extends ConsumerWidget {
  const _SupportTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(supportConversationsProvider);
    final notifier = ref.read(supportConversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: const Color(0xFFFF601F),
      child: state.conversations.when(
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
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(
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
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent * 0.8) {
                  notifier.loadMore();
                }
              }
              return false;
            },
            child: ListView.separated(
              itemCount:
                  conversations.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                if (index == conversations.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final conversation = conversations[index];
                return ConversationTile(
                  conversation: conversation,
                  onTap: () => context
                      .push('/messages/support/${conversation.uuid}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
