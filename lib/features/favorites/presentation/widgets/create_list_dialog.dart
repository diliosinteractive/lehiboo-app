import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite_list.dart';
import '../providers/favorite_lists_provider.dart';
import 'list_color_picker.dart';

/// Dialog pour créer une nouvelle liste de favoris
class CreateListDialog extends ConsumerStatefulWidget {
  const CreateListDialog({super.key});

  /// Affiche le dialog et retourne la liste créée ou null si annulé
  static Future<FavoriteList?> show(BuildContext context) {
    return showDialog<FavoriteList>(
      context: context,
      builder: (context) => const CreateListDialog(),
    );
  }

  @override
  ConsumerState<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends ConsumerState<CreateListDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Color _selectedColor = FavoriteListColors.values['orange']!;
  IconData _selectedIcon = FavoriteListIcons.values['heart']!;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createList() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final colorKey = FavoriteListColors.toColorKey(_selectedColor);
    final iconKey = FavoriteListIcons.toIconKey(_selectedIcon);

    final newList = await ref.read(favoriteListsProvider.notifier).createList(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      color: colorKey,
      icon: iconKey,
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (newList != null) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(newList);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création de la liste'),
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
                          const Text(
                            'Nouvelle liste',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Organisez vos favoris',
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
                    labelText: 'Nom de la liste',
                    hintText: 'Ex: Concerts à voir',
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
                      return 'Veuillez entrer un nom';
                    }
                    if (value.trim().length < 2) {
                      return 'Le nom doit contenir au moins 2 caractères';
                    }
                    if (value.trim().length > 50) {
                      return 'Le nom ne peut pas dépasser 50 caractères';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                ),

                const SizedBox(height: 16),

                // Description (optionnelle)
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (optionnelle)',
                    hintText: 'Ex: Mes événements musicaux préférés',
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
                const Text(
                  'Couleur',
                  style: TextStyle(
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
                const Text(
                  'Icône',
                  style: TextStyle(
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

                // Boutons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createList,
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
                            : const Text(
                                'Créer',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
