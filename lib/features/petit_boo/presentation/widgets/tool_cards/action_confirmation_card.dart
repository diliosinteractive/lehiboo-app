import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/themes/petit_boo_theme.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';
import '../animated_toast.dart';

/// Card displaying action confirmation with animated feedback
/// Used for favorite add/remove, brain update, list create, etc.
class ActionConfirmationCard extends StatefulWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const ActionConfirmationCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  State<ActionConfirmationCard> createState() => _ActionConfirmationCardState();
}

class _ActionConfirmationCardState extends State<ActionConfirmationCard>
    with SingleTickerProviderStateMixin {
  // Cache statique des toasts déjà affichés (survit au recyclage des widgets)
  static final Set<String> _shownToastIds = {};

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _checkAnimation;

  /// Génère un ID unique pour ce toast basé sur les données
  String get _toastId {
    // Utiliser memory_id si disponible (backend l'envoie pour déduplication)
    final memoryId = widget.data['memory_id']?.toString();
    if (memoryId != null) return memoryId;

    // Sinon, hash basé sur tool + données clés
    final toolName = widget.schema.name;
    final key = widget.data['key']?.toString() ?? '';
    final value = widget.data['value']?.toString() ?? '';
    final listName = widget.data['list_name']?.toString() ?? '';
    return '$toolName:$key:$value:$listName'.hashCode.toString();
  }

  /// Vérifie si l'action a réussi (success != false)
  bool get _isSuccess => widget.data['success'] != false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale bounce animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 0.9),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Checkmark draw animation
    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show toast after first build if enabled AND not already shown
    // Uses static cache to survive widget recycling during scroll
    if (!_shownToastIds.contains(_toastId) &&
        widget.schema.showToast &&
        _isSuccess) {
      _shownToastIds.add(_toastId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showToast();
      });
    }
  }

  void _showToast() {
    final config = _getActionConfig(context);
    PetitBooToast.show(
      context,
      message: config.toastMessage,
      icon: config.icon,
      color: config.color,
    );
  }

  _ActionConfig _getActionConfig(BuildContext context) {
    final l10n = context.l10n;
    final actionType = widget.schema.actionType;
    final message = widget.data['message'] as String?;
    final eventTitle = widget.data['event_title'] as String?;
    final listName = widget.data['list_name'] as String?;
    final eventSlug = widget.data['event_slug'] as String?;

    // Brain-specific data
    final memoryKey =
        widget.data['key'] as String? ?? widget.data['memory_key'] as String?;
    final memoryValue = widget.data['value'];
    final valueSummary = widget.data['value_summary'] as String?;
    final section =
        widget.data['section'] as String? ?? widget.data['category'] as String?;

    return switch (actionType) {
      'favorite_add' => _ActionConfig(
          icon: Icons.favorite,
          color: PetitBooTheme.error,
          title: l10n.petitBooFavoriteAdded,
          subtitle: eventTitle ?? l10n.petitBooActionAddedSuccessfully,
          toastMessage: message ?? l10n.petitBooFavoriteAdded,
          route: eventSlug != null ? '/events/$eventSlug' : '/favorites',
          routeLabel: eventSlug != null
              ? l10n.petitBooActionView
              : l10n.petitBooActionMyFavorites,
          routeIcon: eventSlug != null ? Icons.visibility : Icons.favorite,
        ),
      'favorite_remove' => _ActionConfig(
          icon: Icons.favorite_border,
          color: PetitBooTheme.grey500,
          title: l10n.petitBooFavoriteRemoved,
          subtitle: eventTitle ?? l10n.petitBooActionRemovedSuccessfully,
          toastMessage: message ?? l10n.petitBooFavoriteRemoved,
          route: '/favorites',
          routeLabel: l10n.petitBooActionMyFavorites,
          routeIcon: Icons.favorite,
        ),
      'brain_update' => _ActionConfig(
          icon: Icons.psychology,
          color: const Color(0xFF9B59B6),
          title: _getBrainTitle(context, section),
          subtitle: _getBrainSubtitle(
              context, memoryKey, valueSummary, memoryValue, message),
          toastMessage: message ?? l10n.petitBooActionBrainNoted,
          route: '/petit-boo/brain',
          routeLabel: l10n.petitBooActionView,
          routeIcon: Icons.visibility,
        ),
      'list_create' => _ActionConfig(
          icon: Icons.folder_special,
          color: const Color(0xFF3498DB),
          title: l10n.petitBooActionListCreatedTitle,
          subtitle: listName ?? l10n.petitBooActionNewListCreated,
          toastMessage: message ??
              (listName != null
                  ? l10n.petitBooActionListCreatedWithName(listName)
                  : l10n.petitBooActionListCreatedTitle),
          route: '/favorites',
          routeLabel: l10n.petitBooActionViewList,
          routeIcon: Icons.folder_open,
        ),
      'move_to_list' => _ActionConfig(
          icon: Icons.drive_file_move,
          color: const Color(0xFF3498DB),
          title: l10n.petitBooActionMovedTitle,
          subtitle: eventTitle != null && listName != null
              ? l10n.petitBooActionMovedToList(eventTitle, listName)
              : message ?? l10n.petitBooActionMovedSuccessfully,
          toastMessage: message ?? l10n.petitBooActionMovedToListFallback,
          route: '/favorites',
          routeLabel: l10n.petitBooActionMyLists,
          routeIcon: Icons.folder,
        ),
      'list_rename' => _ActionConfig(
          icon: Icons.edit,
          color: const Color(0xFF3498DB),
          title: l10n.petitBooActionListRenamedTitle,
          subtitle: _getListRenameSubtitle(context, listName, message),
          toastMessage: message ??
              (listName != null
                  ? l10n.petitBooActionListRenamedWithName(listName)
                  : l10n.petitBooActionListRenamedTitle),
          route: '/favorites',
          routeLabel: l10n.petitBooActionView,
          routeIcon: Icons.visibility,
        ),
      'list_delete' => _ActionConfig(
          icon: Icons.delete_outline,
          color: const Color(0xFFE74C3C),
          title: l10n.petitBooActionListDeletedTitle,
          subtitle: listName != null
              ? l10n.petitBooActionListDeletedWithName(listName)
              : message ?? l10n.petitBooActionListDeletedTitle,
          toastMessage: message ?? l10n.petitBooActionListDeletedTitle,
          route: '/favorites',
          routeLabel: l10n.petitBooActionMyLists,
          routeIcon: Icons.folder,
        ),
      _ => _ActionConfig(
          icon: Icons.check_circle,
          color: PetitBooTheme.success,
          title: l10n.petitBooActionDoneTitle,
          subtitle: message ?? l10n.petitBooActionDoneSuccessfully,
          toastMessage: message ?? l10n.petitBooActionDoneTitle,
        ),
    };
  }

  String _getBrainTitle(BuildContext context, String? section) {
    final l10n = context.l10n;

    return switch (section) {
      'profile' => l10n.petitBooActionBrainProfileUpdated,
      'family' => l10n.petitBooActionBrainFamilyUpdated,
      'preferences' => l10n.petitBooActionBrainPreferenceSaved,
      'constraints' => l10n.petitBooActionBrainConstraintSaved,
      _ => l10n.petitBooActionBrainMemoryUpdated,
    };
  }

  String _getBrainSubtitle(
    BuildContext context,
    String? key,
    String? valueSummary,
    dynamic rawValue,
    String? message,
  ) {
    final l10n = context.l10n;

    // Priorité 1: value_summary du backend (lisible)
    if (valueSummary != null && valueSummary.isNotEmpty) {
      final readableKey = key != null ? _humanizeKey(context, key) : null;
      if (readableKey != null) {
        return '$readableKey : $valueSummary';
      }
      return l10n.petitBooActionBrainNotedValue(valueSummary);
    }

    // Priorité 2: Clé + valeur brute (si string)
    if (key != null && rawValue != null) {
      final readableKey = _humanizeKey(context, key);
      final valueStr = rawValue is String ? rawValue : rawValue.toString();
      // Tronquer si trop long
      final displayValue =
          valueStr.length > 50 ? '${valueStr.substring(0, 47)}...' : valueStr;
      return '$readableKey : $displayValue';
    }

    // Priorité 3: Juste la valeur
    if (rawValue != null) {
      final valueStr = rawValue is String ? rawValue : rawValue.toString();
      return l10n.petitBooActionBrainNotedValue(
        valueStr.length > 50 ? '${valueStr.substring(0, 47)}...' : valueStr,
      );
    }

    // Fallback au message ou texte par défaut
    return message ?? l10n.petitBooActionBrainRememberFallback;
  }

  String _humanizeKey(BuildContext context, String key) {
    final l10n = context.l10n;

    // Convertit les clés techniques en texte lisible
    return switch (key.toLowerCase()) {
      'name' || 'first_name' || 'prenom' => l10n.petitBooMemoryLabelFirstName,
      'city' || 'ville' || 'location' => l10n.petitBooMemoryLabelCity,
      'age' => l10n.petitBooMemoryLabelAge,
      'children' || 'enfants' => l10n.petitBooMemoryLabelChildrenAges,
      'interests' || 'interets' => l10n.petitBooMemoryLabelInterests,
      'budget' => l10n.petitBooMemoryLabelBudgetPreference,
      'accessibility' ||
      'handicap' =>
        l10n.petitBooMemoryLabelMobilityConstraints,
      'dietary' || 'alimentation' => l10n.petitBooMemoryLabelDietaryPreferences,
      _ => key.replaceAll('_', ' ').replaceAll('-', ' '),
    };
  }

  String _getListRenameSubtitle(
    BuildContext context,
    String? newName,
    String? message,
  ) {
    final l10n = context.l10n;

    // Check for old_name and new_name in data
    final oldName = widget.data['old_name'] as String?;
    final newNameFromData = widget.data['new_name'] as String? ?? newName;

    if (oldName != null && newNameFromData != null) {
      return l10n.petitBooActionListRenamedFromTo(oldName, newNameFromData);
    }
    if (newNameFromData != null) {
      return l10n.petitBooActionListNewName(newNameFromData);
    }
    return message ?? l10n.petitBooActionListRenamedSuccessfully;
  }

  @override
  Widget build(BuildContext context) {
    // Vérifier si l'action a réussi
    if (!_isSuccess) {
      return _buildErrorCard(context);
    }

    final config = _getActionConfig(context);
    final accentColor = widget.schema.color != null
        ? parseHexColor(widget.schema.color)
        : config.color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
      ),
      child: Padding(
        padding: const EdgeInsets.all(PetitBooTheme.spacing20),
        child: Row(
          children: [
            // Animated icon
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Main icon
                    Icon(
                      config.icon,
                      color: accentColor,
                      size: 28,
                    ),
                    // Animated checkmark overlay for success
                    AnimatedBuilder(
                      animation: _checkAnimation,
                      builder: (context, _) => Opacity(
                        opacity: _checkAnimation.value * 0.8,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Transform.translate(
                            offset: const Offset(8, 8),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: PetitBooTheme.success,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: PetitBooTheme.spacing16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    config.title,
                    style: PetitBooTheme.headingSm.copyWith(
                      color: PetitBooTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config.subtitle,
                    style: PetitBooTheme.bodySm.copyWith(
                      color: PetitBooTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Navigation button
            if (config.route != null) ...[
              const SizedBox(width: PetitBooTheme.spacing12),
              _buildNavigationButton(context, config, accentColor),
            ],
          ],
        ),
      ),
    );
  }

  /// Affiche une card d'erreur quand l'action a échoué
  Widget _buildErrorCard(BuildContext context) {
    final errorMessage = widget.data['error'] as String? ??
        widget.data['message'] as String? ??
        context.l10n.petitBooActionGenericError;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
        border: Border.all(color: PetitBooTheme.error.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PetitBooTheme.spacing16),
        child: Row(
          children: [
            // Error icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PetitBooTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: PetitBooTheme.error,
                size: 24,
              ),
            ),
            const SizedBox(width: PetitBooTheme.spacing12),
            // Error content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.petitBooActionErrorTitle,
                    style: PetitBooTheme.headingSm.copyWith(
                      color: PetitBooTheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    errorMessage,
                    style: PetitBooTheme.bodySm.copyWith(
                      color: PetitBooTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    _ActionConfig config,
    Color accentColor,
  ) {
    return Material(
      color: accentColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(config.route!);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PetitBooTheme.spacing12,
            vertical: PetitBooTheme.spacing10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (config.routeIcon != null)
                Icon(
                  config.routeIcon,
                  color: accentColor,
                  size: 16,
                ),
              if (config.routeIcon != null && config.routeLabel != null)
                const SizedBox(width: 6),
              if (config.routeLabel != null)
                Text(
                  config.routeLabel!,
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
}

/// Configuration for different action types
class _ActionConfig {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String toastMessage;
  final String? route;
  final String? routeLabel;
  final IconData? routeIcon;

  const _ActionConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.toastMessage,
    this.route,
    this.routeLabel,
    this.routeIcon,
  });
}
