import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../providers/petit_boo_chat_provider.dart';

/// Screen showing Petit Boo's "brain" - the user context/memory it has learned.
/// Allows users to view, edit, and delete information about themselves.
class PetitBooBrainScreen extends ConsumerStatefulWidget {
  const PetitBooBrainScreen({super.key});

  @override
  ConsumerState<PetitBooBrainScreen> createState() =>
      _PetitBooBrainScreenState();
}

class _PetitBooBrainScreenState extends ConsumerState<PetitBooBrainScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(petitBooChatProvider);
    final notifier = ref.read(petitBooChatProvider.notifier);
    final isMemoryEnabled = notifier.isMemoryEnabled;
    final contextMap = notifier.userContext;

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: HbColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.psychology,
                  color: HbColors.brandPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.petitBooBrainTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Switch Section
            _buildMemoryToggleCard(isMemoryEnabled, notifier),

            const SizedBox(height: 24),

            if (isMemoryEnabled) ...[
              Text(
                context.l10n.petitBooMemoryKnownTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Memory List
              if (contextMap.isEmpty)
                _buildEmptyState()
              else
                ...contextMap.entries
                    .where(
                        (e) => !e.key.startsWith('_')) // Filter internal keys
                    .map((e) =>
                        _buildMemoryItem(context, notifier, e.key, e.value)),

              // Clear all button
              if (contextMap.isNotEmpty) ...[
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _confirmClearAll(context, notifier),
                    icon: Icon(Icons.delete_forever, color: HbColors.error),
                    label: Text(
                      context.l10n.petitBooMemoryClearAll,
                      style: TextStyle(color: HbColors.error),
                    ),
                  ),
                ),
              ],
            ] else
              _buildDisabledState(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryToggleCard(
      bool isMemoryEnabled, PetitBooChatNotifier notifier) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMemoryEnabled ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMemoryEnabled ? Colors.green[100]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isMemoryEnabled
                    ? Icons.check_circle_outline
                    : Icons.pause_circle_outline,
                color: isMemoryEnabled ? Colors.green[700] : Colors.grey[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isMemoryEnabled
                      ? l10n.petitBooMemoryEnabled
                      : l10n.petitBooMemoryPaused,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        isMemoryEnabled ? Colors.green[900] : Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ),
              Switch(
                value: isMemoryEnabled,
                activeColor: HbColors.brandPrimary,
                onChanged: (value) async {
                  await notifier.toggleMemory(value);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isMemoryEnabled
                ? l10n.petitBooMemoryEnabledDescription
                : l10n.petitBooMemoryPausedDescription,
            style:
                TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Center(
              child: Text('🧠', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.petitBooMemoryEmptyTitle,
            style: TextStyle(
              color: HbColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.petitBooMemoryEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: HbColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.visibility_off_outlined,
              size: 48, color: HbColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            context.l10n.petitBooMemoryDisabledBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: HbColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryItem(
    BuildContext context,
    PetitBooChatNotifier notifier,
    String key,
    dynamic value,
  ) {
    final label = _contextKeyLabel(context, key);
    final formattedValue = _formatContextValue(context, key, value);
    final icon = _contextKeyIcon(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: HbColors.brandPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: HbColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            formattedValue,
            style: const TextStyle(
              color: HbColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: HbColors.textSecondary),
          onSelected: (action) {
            if (action == 'edit') {
              _showEditDialog(context, notifier, key, value);
            } else if (action == 'delete') {
              _confirmDelete(context, notifier, key);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(context.l10n.petitBooMemoryEditAction),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  const SizedBox(width: 12),
                  Text(context.l10n.petitBooMemoryForgetAction),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    PetitBooChatNotifier notifier,
    String key,
    dynamic currentValue,
  ) {
    final controller = TextEditingController(text: currentValue.toString());
    final label = _contextKeyLabel(context, key);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.petitBooMemoryEditTitle(label)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: context.l10n.petitBooMemoryNewValueHint,
            labelText: label,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await notifier.updateContextKey(key, controller.text);
              if (context.mounted) {
                Navigator.pop(context);
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
            ),
            child: Text(
              context.l10n.commonSave,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    PetitBooChatNotifier notifier,
    String key,
  ) {
    final label = _contextKeyLabel(context, key);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.petitBooMemoryForgetTitle),
        content: Text(context.l10n.petitBooMemoryForgetBody(label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.petitBooMemoryNoKeep),
          ),
          TextButton(
            onPressed: () async {
              await notifier.removeContextKey(key);
              if (context.mounted) {
                Navigator.pop(context);
              }
              setState(() {});
            },
            child: Text(
              context.l10n.petitBooMemoryForgetConfirm,
              style: TextStyle(color: HbColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, PetitBooChatNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.petitBooMemoryClearAllTitle),
        content: Text(context.l10n.petitBooMemoryClearAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.petitBooMemoryNoKeep),
          ),
          TextButton(
            onPressed: () async {
              await notifier.clearContext();
              if (context.mounted) {
                Navigator.pop(context);
              }
              setState(() {});
            },
            child: Text(
              context.l10n.petitBooMemoryClearAllConfirm,
              style: TextStyle(color: HbColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _contextKeyLabel(BuildContext context, String key) {
    final l10n = context.l10n;

    switch (key) {
      case 'first_name':
        return l10n.petitBooMemoryLabelFirstName;
      case 'last_name':
        return l10n.petitBooMemoryLabelLastName;
      case 'nickname':
        return l10n.petitBooMemoryLabelNickname;
      case 'age':
        return l10n.petitBooMemoryLabelAge;
      case 'birth_year':
        return l10n.petitBooMemoryLabelBirthYear;
      case 'age_group':
        return l10n.petitBooMemoryLabelAgeGroup;
      case 'city':
        return l10n.petitBooMemoryLabelCity;
      case 'region':
        return l10n.petitBooMemoryLabelRegion;
      case 'country':
        return l10n.petitBooMemoryLabelCountry;
      case 'latitude':
        return l10n.petitBooMemoryLabelLatitude;
      case 'longitude':
        return l10n.petitBooMemoryLabelLongitude;
      case 'max_distance':
        return l10n.petitBooMemoryLabelMaxDistance;
      case 'favorite_activities':
        return l10n.petitBooMemoryLabelFavoriteActivities;
      case 'disliked_activities':
        return l10n.petitBooMemoryLabelDislikedActivities;
      case 'favorite_categories':
        return l10n.petitBooMemoryLabelFavoriteCategories;
      case 'budget_preference':
        return l10n.petitBooMemoryLabelBudgetPreference;
      case 'group_type':
        return l10n.petitBooMemoryLabelGroupType;
      case 'has_children':
        return l10n.petitBooMemoryLabelHasChildren;
      case 'children_ages':
        return l10n.petitBooMemoryLabelChildrenAges;
      case 'dietary_preferences':
        return l10n.petitBooMemoryLabelDietaryPreferences;
      case 'mobility_constraints':
        return l10n.petitBooMemoryLabelMobilityConstraints;
      case 'pet_friendly_needed':
        return l10n.petitBooMemoryLabelPetFriendlyNeeded;
      case 'preferred_times':
        return l10n.petitBooMemoryLabelPreferredTimes;
      case 'preferred_language':
        return l10n.petitBooMemoryLabelPreferredLanguage;
      case 'interests':
        return l10n.petitBooMemoryLabelInterests;
      case '_lastUpdated':
        return l10n.petitBooMemoryLabelLastUpdated;
      default:
        return key;
    }
  }

  String _contextKeyIcon(String key) {
    switch (key) {
      case 'first_name':
      case 'last_name':
      case 'nickname':
        return '👤';
      case 'age':
      case 'birth_year':
      case 'age_group':
        return '🎂';
      case 'city':
      case 'region':
      case 'country':
      case 'latitude':
      case 'longitude':
        return '📍';
      case 'max_distance':
        return '📏';
      case 'favorite_activities':
      case 'interests':
        return '❤️';
      case 'disliked_activities':
        return '👎';
      case 'favorite_categories':
        return '🏷️';
      case 'budget_preference':
        return '💰';
      case 'group_type':
        return '👥';
      case 'has_children':
      case 'children_ages':
        return '👶';
      case 'dietary_preferences':
        return '🍽️';
      case 'mobility_constraints':
        return '♿';
      case 'pet_friendly_needed':
        return '🐾';
      case 'preferred_times':
      case '_lastUpdated':
        return '🕐';
      case 'preferred_language':
        return '🌐';
      default:
        return '📝';
    }
  }

  String _formatContextValue(BuildContext context, String key, dynamic value) {
    final l10n = context.l10n;

    if (value == null) return l10n.petitBooMemoryUndefined;

    if (value is List) {
      return value.join(', ');
    }

    if (value is bool) {
      return value ? l10n.petitBooMemoryYes : l10n.petitBooMemoryNo;
    }

    if (key == 'age_group') {
      switch (value) {
        case 'young_adult':
          return l10n.petitBooMemoryAgeGroupYoungAdult;
        case 'adult':
          return l10n.petitBooMemoryAgeGroupAdult;
        case 'senior':
          return l10n.petitBooMemoryAgeGroupSenior;
        default:
          return value.toString();
      }
    }

    if (key == 'budget_preference') {
      switch (value) {
        case 'low':
          return l10n.petitBooMemoryBudgetLow;
        case 'medium':
          return l10n.petitBooMemoryBudgetMedium;
        case 'high':
          return l10n.petitBooMemoryBudgetHigh;
        default:
          return value.toString();
      }
    }

    if (key == 'group_type') {
      switch (value) {
        case 'solo':
          return l10n.petitBooMemoryGroupSolo;
        case 'couple':
          return l10n.petitBooMemoryGroupCouple;
        case 'family':
          return l10n.petitBooMemoryGroupFamily;
        case 'friends':
          return l10n.petitBooMemoryGroupFriends;
        default:
          return value.toString();
      }
    }

    if (key == '_lastUpdated') {
      try {
        final date = DateTime.parse(value.toString());
        return context
            .appDateFormat('d/M/y HH:mm', enPattern: 'M/d/y h:mm a')
            .format(date);
      } catch (e) {
        return value.toString();
      }
    }

    return value.toString();
  }
}
