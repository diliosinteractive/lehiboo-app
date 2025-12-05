import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/repositories/activity_repository.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'dart:async';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _query = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityRepository = ref.watch(activityRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Rechercher'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Rechercher une activité, une ville...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? _buildEmptyState()
                : FutureBuilder<List<Activity>>(
                    future: activityRepository.searchActivities(query: _query),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      }
                      final activities = snapshot.data ?? [];
                      if (activities.isEmpty) {
                        return const Center(child: Text('Aucun résultat trouvé'));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: activities.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return EventCard(activity: activities[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Tapez votre recherche',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}