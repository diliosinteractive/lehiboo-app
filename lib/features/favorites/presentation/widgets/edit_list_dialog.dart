import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
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
  });

  /// Affiche le dialog et retourne la liste mise à jour ou null si annulé
  static Future<FavoriteList?> show(BuildContext context, FavoriteList list) {
    return showDialog<FavoriteList>(
      context: context,
      builder: (context) => EditListDialog(list: list),
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list.name);
    _descriptionController =
        TextEditingController(text: widget.list.description ?? '');
    _selectedColor = widget.list.color;
    _selectedIcon = widget.list.icon;
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
        _selectedColor.value != widget.list.color.value ||
        _selectedIcon.codePoint != widget.list.icon.codePoint;
  }

  Future<void> _updateList() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) {
      Navigator.of(context).pop(widget.list);
      return;
    }

    setState(() => _isLoading = true);

    final colorKey = FavoriteListColors.toColorKey(_selectedColor);
    final iconKey = FavoriteListIcons.toIconKey(_selectedIcon);

    final updatedList =
        await ref.read(favoriteListsProvider.notifier).updateList(
              widget.list.id,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              color: colorKey,
              icon: iconKey,
            );

    if (mounted) {
      setState(() => _isLoading = false);

      if (updatedList != null) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(updatedList);
      } else {
        PetitBooToast.error(context, context.l10n.favoriteListUpdateError);
      }
    }
  }

  Future<void> _deleteList() async {
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

    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    final success = await ref
        .read(favoriteListsProvider.notifier)
        .deleteList(widget.list.id);

    if (mounted) {
      setState(() => _isDeleting = false);

      if (success) {
        HapticFeedback.mediumImpact();
        // Pop avec null pour indiquer suppression
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.favoriteListDeleted(widget.list.name)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.favoriteListDeleteError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        color: _selectedColor.withOpacity(0.1),
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
