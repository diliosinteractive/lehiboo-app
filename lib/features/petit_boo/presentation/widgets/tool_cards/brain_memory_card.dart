import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/petit_boo_theme.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying user's brain memory with collapsible sections
/// Sections: family, location, preferences, constraints
class BrainMemoryCard extends StatefulWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const BrainMemoryCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  State<BrainMemoryCard> createState() => _BrainMemoryCardState();
}

class _BrainMemoryCardState extends State<BrainMemoryCard> {
  // Track expanded state for each section
  final Map<String, bool> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    // Initialize all sections as expanded by default
    final sections = widget.schema.sectionSchemas ?? [];
    for (final section in sections) {
      _expandedSections[section.key] = true;
    }
  }

  bool _hasAnyData() {
    final memoryData = widget.data['memory'] as Map<String, dynamic>? ?? widget.data;
    final sections = widget.schema.sectionSchemas ?? [];

    for (final section in sections) {
      final sectionData = memoryData[section.key];
      if (sectionData != null) {
        if (sectionData is List && sectionData.isNotEmpty) return true;
        if (sectionData is Map && sectionData.isNotEmpty) return true;
        if (sectionData is String && sectionData.isNotEmpty) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = parseHexColor(widget.schema.color);
    final memoryData = widget.data['memory'] as Map<String, dynamic>? ?? widget.data;
    final sections = widget.schema.sectionSchemas ?? _defaultSections;
    final hasData = _hasAnyData();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(PetitBooTheme.spacing16),
            child: Row(
              children: [
                // Icon in colored circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: PetitBooTheme.spacing12),

                // Title
                Expanded(
                  child: Text(
                    widget.schema.title ?? 'Ce que je sais de toi',
                    style: PetitBooTheme.headingSm,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: PetitBooTheme.border),

          // Empty state or sections
          if (!hasData)
            _buildEmptyState(accentColor)
          else
            // Sections
            ...sections.map((section) {
              final sectionData = memoryData[section.key];
              final items = _extractItems(sectionData);

              if (items.isEmpty) return const SizedBox.shrink();

              return _BrainSection(
                section: section,
                items: items,
                isExpanded: _expandedSections[section.key] ?? true,
                onToggle: () {
                  setState(() {
                    _expandedSections[section.key] =
                        !(_expandedSections[section.key] ?? true);
                  });
                },
              );
            }),

          // Footer link
          Padding(
            padding: const EdgeInsets.all(PetitBooTheme.spacing16),
            child: GestureDetector(
              onTap: () => context.push('/petit-boo/brain'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gérer ma mémoire',
                    style: PetitBooTheme.bodySm.copyWith(
                      color: PetitBooTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: PetitBooTheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PetitBooTheme.spacing24,
        vertical: PetitBooTheme.spacing32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: accentColor,
              size: 32,
            ),
          ),
          const SizedBox(height: PetitBooTheme.spacing16),
          Text(
            widget.schema.emptyMessage ?? 'Je ne sais encore rien. Discutons !',
            style: PetitBooTheme.bodyMd.copyWith(
              color: PetitBooTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PetitBooTheme.spacing16),
          Text(
            'Parle-moi de toi pour que je puisse te faire de meilleures recommandations.',
            style: PetitBooTheme.bodySm.copyWith(
              color: PetitBooTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<String> _extractItems(dynamic sectionData) {
    if (sectionData == null) return [];

    if (sectionData is List) {
      return sectionData.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    }

    if (sectionData is Map) {
      // Convert map entries to readable strings
      return sectionData.entries
          .map((e) => '${e.key}: ${e.value}')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    if (sectionData is String && sectionData.isNotEmpty) {
      return [sectionData];
    }

    return [];
  }

  static const _defaultSections = [
    BrainSectionSchemaDto(key: 'family', title: 'Famille', icon: 'family_restroom'),
    BrainSectionSchemaDto(key: 'location', title: 'Localisation', icon: 'location_on'),
    BrainSectionSchemaDto(key: 'preferences', title: 'Préférences', icon: 'thumb_up'),
    BrainSectionSchemaDto(key: 'constraints', title: 'Contraintes', icon: 'block'),
  ];
}

/// Collapsible section for brain memory
class _BrainSection extends StatelessWidget {
  final BrainSectionSchemaDto section;
  final List<String> items;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _BrainSection({
    required this.section,
    required this.items,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final sectionColor = _getSectionColor(section.key);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        InkWell(
          onTap: section.collapsible ? onToggle : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PetitBooTheme.spacing16,
              vertical: PetitBooTheme.spacing12,
            ),
            child: Row(
              children: [
                // Section icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: sectionColor.withValues(alpha: 0.1),
                    borderRadius: PetitBooTheme.borderRadiusMd,
                  ),
                  child: Icon(
                    _getSectionIcon(section.icon),
                    color: sectionColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: PetitBooTheme.spacing12),

                // Section title
                Expanded(
                  child: Text(
                    section.title,
                    style: PetitBooTheme.label.copyWith(
                      fontWeight: FontWeight.w600,
                      color: PetitBooTheme.textPrimary,
                    ),
                  ),
                ),

                // Item count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: PetitBooTheme.grey100,
                    borderRadius: PetitBooTheme.borderRadiusFull,
                  ),
                  child: Text(
                    '${items.length}',
                    style: PetitBooTheme.caption.copyWith(
                      color: PetitBooTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Expand/collapse icon
                if (section.collapsible) ...[
                  const SizedBox(width: PetitBooTheme.spacing8),
                  AnimatedRotation(
                    turns: isExpanded ? 0 : -0.25,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: PetitBooTheme.textTertiary,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Section content
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isExpanded ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: PetitBooTheme.spacing16,
                right: PetitBooTheme.spacing16,
                bottom: PetitBooTheme.spacing12,
              ),
              child: Wrap(
                spacing: PetitBooTheme.spacing8,
                runSpacing: PetitBooTheme.spacing8,
                children: items
                    .map((item) => _MemoryChip(
                          text: item,
                          color: sectionColor,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),

        const Divider(height: 1, color: PetitBooTheme.borderLight),
      ],
    );
  }

  Color _getSectionColor(String key) {
    return switch (key) {
      'family' => const Color(0xFF9B59B6), // Purple
      'location' => const Color(0xFFE74C3C), // Red
      'preferences' => const Color(0xFF27AE60), // Green
      'constraints' => const Color(0xFFF39C12), // Orange
      _ => PetitBooTheme.primary,
    };
  }

  IconData _getSectionIcon(String iconName) {
    return switch (iconName) {
      'family_restroom' => Icons.family_restroom,
      'location_on' => Icons.location_on,
      'thumb_up' => Icons.thumb_up,
      'block' => Icons.block,
      _ => Icons.label,
    };
  }
}

/// Chip displaying a memory item
class _MemoryChip extends StatelessWidget {
  final String text;
  final Color color;

  const _MemoryChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PetitBooTheme.spacing12,
        vertical: PetitBooTheme.spacing6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: PetitBooTheme.borderRadiusFull,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: PetitBooTheme.bodySm.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
