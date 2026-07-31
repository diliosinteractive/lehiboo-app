import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import '../../domain/entities/favorite_list.dart';
import '../providers/favorite_lists_provider.dart';
import '../../../petit_boo/presentation/widgets/animated_toast.dart';
import 'list_color_picker.dart';

/// Dialog pour éditer une liste de favoris existante
class EditListDialog extends ConsumerStatefulWidget {
  final FavoriteList list;

  const EditListDialog({
    super.key,
    required this.list,
    required this.ownerSession,
  });

  final AuthSessionKey ownerSession;

  /// Affiche le dialog et retourne la liste mise à jour ou null si annulé
  static Future<FavoriteList?> show(
    BuildContext context,
    FavoriteList list, {
    required AuthSessionKey ownerSession,
  }) {
    return showDialog<FavoriteList>(
      context: context,
      builder: (context) {
        final ownerAccountId = ownerSession.accountId;
        if (ownerAccountId == null) return const SizedBox.shrink();
        return AccountBoundRouteGuard<FavoriteList>(
          ownerAccountId: ownerAccountId,
          ownerSession: ownerSession,
          builder: (_) => EditListDialog(
            list: list,
            ownerSession: ownerSession,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends ConsumerState<EditListDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  late Color _selectedColor;
  late IconData _selectedIcon;
  bool _isLoading = false;
  bool _isDeleting = false;
  late final AuthSessionKey _ownerSession;
  late final String? _ownerAccountId;
  late final FavoriteListsNotifier _ownerNotifier;
  bool _sessionInvalid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list.name);
    _descriptionController =
        TextEditingController(text: widget.list.description ?? '');
    _selectedColor = widget.list.color;
    _selectedIcon = widget.list.icon;
    _ownerSession = widget.ownerSession;
    _ownerAccountId = _ownerSession.accountId;
    _ownerNotifier = ref.read(favoriteListsProvider.notifier);
  }

  bool get _ownsCurrentAccount =>
      !_sessionInvalid &&
      _ownerAccountId != null &&
      ref.read(authSessionUserIdProvider) == _ownerAccountId &&
      identical(ref.read(authSessionKeyProvider), _ownerSession) &&
      identical(ref.read(favoriteListsProvider.notifier), _ownerNotifier);

  void _handleSessionChange(AuthSessionKey nextSession) {
    if (identical(nextSession, _ownerSession) || _sessionInvalid) return;
    _sessionInvalid = true;
    _nameController.clear();
    _descriptionController.clear();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isDeleting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _nameController.text.trim() != widget.list.name ||
        (_descriptionController.text.trim()) !=
            (widget.list.description ?? '') ||
        _selectedColor.toARGB32() != widget.list.color.toARGB32() ||
        _selectedIcon.codePoint != widget.list.icon.codePoint;
  }

  Future<void> _updateList() async {
    if (!_ownsCurrentAccount || _formKey.currentState?.validate() != true) {
      return;
    }
    if (!_hasChanges) {
      Navigator.of(context).pop(widget.list);
      return;
    }

    setState(() => _isLoading = true);

    final colorKey = FavoriteListColors.toColorKey(_selectedColor);
    final iconKey = FavoriteListIcons.toIconKey(_selectedIcon);

    try {
      final updatedList = await _ownerNotifier.updateList(
        widget.list.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        color: colorKey,
        icon: iconKey,
      );

      if (!mounted || !_ownsCurrentAccount) return;
      setState(() => _isLoading = false);
      if (updatedList != null) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(updatedList);
      }
    } catch (error) {
      if (!mounted || !_ownsCurrentAccount) return;
      setState(() => _isLoading = false);
      PetitBooToast.error(
        context,
        ApiResponseHandler.extractError(
          error,
          fallback: context.l10n.favoriteListUpdateError,
        ),
      );
    }
  }

  Future<void> _deleteList() async {
    if (!_ownsCurrentAccount) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.favoriteListDeleteTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.favoriteListDeleteBody(widget.list.name),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.favoriteListDeleteMoveBody,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.messagesDeleteAction),
          ),
        ],
      ),
    );

    if (confirmed != true || !_ownsCurrentAccount) return;

    setState(() => _isDeleting = true);

    try {
      final success = await _ownerNotifier.deleteList(widget.list.id);

      if (!mounted || !_ownsCurrentAccount) return;
      setState(() => _isDeleting = false);
      if (success) {
        HapticFeedback.mediumImpact();
        final messenger = ScaffoldMessenger.of(context);
        final deletedMessage =
            context.l10n.favoriteListDeleted(widget.list.name);
        // Pop avec null pour indiquer suppression
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(deletedMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (!mounted || !_ownsCurrentAccount) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiResponseHandler.extractError(
              error,
              fallback: context.l10n.favoriteListDeleteError,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthSessionKey>(authSessionKeyProvider, (_, next) {
      _handleSessionChange(next);
    });
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    final currentSession = ref.watch(authSessionKeyProvider);
    if (_ownerAccountId == null ||
        currentAccountId != _ownerAccountId ||
        !identical(currentSession, _ownerSession) ||
        _sessionInvalid) {
      return const SizedBox.shrink(
        key: Key('edit-favorite-list-session-invalid'),
      );
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _selectedColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _selectedIcon,
                        color: _selectedColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.favoriteListEditTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            context.l10n.favoriteListFavoritesCount(
                              widget.list.favoritesCount,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Nom
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.favoriteListNameLabel,
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _selectedColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.favoriteListNameRequired;
                    }
                    if (value.trim().length < 2) {
                      return context.l10n.favoriteListNameMinLength;
                    }
                    if (value.trim().length > 50) {
                      return context.l10n.favoriteListNameMaxLength;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: context.l10n.favoriteListDescriptionLabel,
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _selectedColor, width: 2),
                    ),
                  ),
                  maxLines: 2,
                  maxLength: 150,
                ),

                const SizedBox(height: 24),

                // Couleur
                Text(
                  context.l10n.favoriteListColorLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ListColorPicker(
                  selectedColor: _selectedColor,
                  onColorSelected: (color) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedColor = color);
                  },
                ),

                const SizedBox(height: 24),

                // Icône
                Text(
                  context.l10n.favoriteListIconLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ListIconPicker(
                  selectedIcon: _selectedIcon,
                  accentColor: _selectedColor,
                  onIconSelected: (icon) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedIcon = icon);
                  },
                ),

                const SizedBox(height: 32),

                // Bouton supprimer
                if (!widget.list.isDefault) ...[
                  Center(
                    child: TextButton.icon(
                      onPressed: _isDeleting || _isLoading ? null : _deleteList,
                      icon: _isDeleting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_outline, color: Colors.red),
                      label: Text(
                        context.l10n.favoriteListDeleteThisAction,
                        style: TextStyle(
                          color: _isDeleting ? Colors.grey : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading || _isDeleting
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(context.l10n.commonCancel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _isLoading || _isDeleting ? null : _updateList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                context.l10n.commonSave,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
