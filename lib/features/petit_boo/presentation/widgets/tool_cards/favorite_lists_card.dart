import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/petit_boo_theme.dart';
import '../../../../favorites/presentation/providers/favorite_lists_provider.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying user's favorite lists with navigation
class FavoriteListsCard extends ConsumerWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const FavoriteListsCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = _extractLists();
    final accentColor = schema.color != null
        ? parseHexColor(schema.color)
        : const Color(0xFFE74C3C);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(PetitBooTheme.spacing16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.folder_special,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: PetitBooTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schema.title ?? 'Mes listes de favoris',
                        style: PetitBooTheme.headingSm.copyWith(
                          color: PetitBooTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${lists.length} liste${lists.length > 1 ? 's' : ''}',
                        style: PetitBooTheme.bodySm.copyWith(
                          color: PetitBooTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigate to favorites
                _buildNavigateButton(context, accentColor),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: PetitBooTheme.grey200,
          ),

          // Lists
          if (lists.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: PetitBooTheme.spacing8,
              ),
              itemCount: lists.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: PetitBooTheme.spacing16,
                endIndent: PetitBooTheme.spacing16,
                color: PetitBooTheme.grey100,
              ),
              itemBuilder: (context, index) => _buildListItem(
                context,
                ref,
                lists[index],
                accentColor,
              ),
            ),
        ],
      ),
    );
  }

  /// Unwrap nested data if present (backend sometimes wraps in "data")
  Map<String, dynamic> _unwrapData() {
    if (data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return data;
  }

  List<_FavoriteListData> _extractLists() {
    final unwrapped = _unwrapData();

    // Try multiple possible keys for the lists array
    List<dynamic>? listsData;

    // Keys to try in order of priority
    const keysToTry = ['lists', 'favorite_lists', 'items', 'results'];

    for (final key in keysToTry) {
      if (unwrapped[key] is List) {
        listsData = unwrapped[key] as List<dynamic>;
        debugPrint('📂 FavoriteListsCard: Found lists in key "$key"');
        break;
      }
    }

    // If still null, check if unwrapped data itself is a list
    if (listsData == null && data['data'] is List) {
      listsData = data['data'] as List<dynamic>;
      debugPrint('📂 FavoriteListsCard: Found lists directly in "data" array');
    }

    if (listsData == null || listsData.isEmpty) {
      debugPrint('📂 FavoriteListsCard: No lists found. Data keys: ${unwrapped.keys.toList()}');
      debugPrint('📂 FavoriteListsCard: Full data: $data');
      return [];
    }

    debugPrint('📂 FavoriteListsCard: Found ${listsData.length} lists');

    return listsData.map((item) {
      if (item is Map<String, dynamic>) {
        return _FavoriteListData(
          id: item['id']?.toString() ?? item['uuid']?.toString() ?? '',
          name: item['name']?.toString() ?? item['title']?.toString() ?? 'Sans nom',
          eventsCount: _extractEventCount(item),
          emoji: _extractValidEmoji(item),
        );
      }
      return _FavoriteListData(id: '', name: item.toString(), eventsCount: 0);
    }).toList();
  }

  /// Extrait un emoji valide ou retourne null
  /// Ignore les valeurs textuelles qui ne sont pas des emojis
  String? _extractValidEmoji(Map<String, dynamic> item) {
    final emoji = item['emoji'] as String? ?? item['icon'] as String?;
    if (emoji == null || emoji.isEmpty) return null;

    // Un emoji valide est généralement 1-4 caractères (avec modificateurs)
    // et ne contient pas de lettres ASCII
    if (emoji.length > 4) return null;
    if (RegExp(r'[a-zA-Z]').hasMatch(emoji)) return null;

    return emoji;
  }

  int _extractEventCount(Map<String, dynamic> item) {
    // Try multiple keys for event count
    for (final key in ['events_count', 'count', 'total', 'items_count', 'nb_events']) {
      final value = item[key];
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Widget _buildNavigateButton(BuildContext context, Color accentColor) {
    return Material(
      color: accentColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/favorites');
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PetitBooTheme.spacing12,
            vertical: PetitBooTheme.spacing8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Voir tout',
                style: PetitBooTheme.label.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                color: accentColor,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(PetitBooTheme.spacing24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 40,
              color: PetitBooTheme.grey300,
            ),
            const SizedBox(height: PetitBooTheme.spacing12),
            Text(
              'Aucune liste pour le moment',
              style: PetitBooTheme.bodyMd.copyWith(
                color: PetitBooTheme.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Demande-moi d\'en créer une !',
              style: PetitBooTheme.bodySm.copyWith(
                color: PetitBooTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    WidgetRef ref,
    _FavoriteListData list,
    Color accentColor,
  ) {
    final hasEvents = list.eventsCount > 0;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        // Select this specific list before navigating
        ref.read(selectedFavoriteListProvider.notifier).state = list.id.isNotEmpty ? list.id : null;
        context.push('/favorites');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PetitBooTheme.spacing16,
          vertical: PetitBooTheme.spacing12,
        ),
        child: Row(
          children: [
            // Folder icon with color based on content
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hasEvents
                    ? accentColor.withValues(alpha: 0.1)
                    : PetitBooTheme.grey100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: list.emoji != null
                    ? Text(list.emoji!, style: const TextStyle(fontSize: 22))
                    : Icon(
                        hasEvents ? Icons.folder : Icons.folder_outlined,
                        color: hasEvents ? accentColor : PetitBooTheme.grey400,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(width: PetitBooTheme.spacing12),

            // List info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    style: PetitBooTheme.bodyMd.copyWith(
                      color: PetitBooTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatEventsCount(list.eventsCount),
                    style: PetitBooTheme.bodySm.copyWith(
                      color: PetitBooTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: PetitBooTheme.grey300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventsCount(int count) {
    if (count == 0) return 'Vide';
    if (count == 1) return '1 événement';
    return '$count événements';
  }
}

class _FavoriteListData {
  final String id;
  final String name;
  final int eventsCount;
  final String? emoji;

  _FavoriteListData({
    required this.id,
    required this.name,
    required this.eventsCount,
    this.emoji,
  });
}
