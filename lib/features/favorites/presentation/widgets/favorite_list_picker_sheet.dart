import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite_list.dart';
import '../providers/favorite_lists_provider.dart';
import 'create_list_dialog.dart';

/// Résultat de la sélection dans le picker
class FavoriteListPickerResult {
  /// ID de la liste sélectionnée (null = non classé)
  final String? listId;

  /// Indique si l'utilisateur veut retirer des favoris
  final bool removeFromFavorites;

  const FavoriteListPickerResult({
    this.listId,
    this.removeFromFavorites = false,
  });

  /// Constructeur pour "Retirer des favoris"
  const FavoriteListPickerResult.remove()
      : listId = null,
        removeFromFavorites = true;
}

/// Bottom sheet pour sélectionner une liste de favoris
class FavoriteListPickerSheet extends ConsumerWidget {
  /// ID de la liste actuelle de l'événement (pour marquer la sélection)
  final String? currentListId;

  /// Si l'événement est déjà dans les favoris
  final bool isAlreadyFavorite;

  /// Titre personnalisé
  final String? title;

  const FavoriteListPickerSheet({
    super.key,
    this.currentListId,
    this.isAlreadyFavorite = false,
    this.title,
  });

  /// Affiche le bottom sheet et retourne le résultat de sélection
  static Future<FavoriteListPickerResult?> show(
    BuildContext context, {
    String? currentListId,
    bool isAlreadyFavorite = false,
    String? title,
  }) {
    return showModalBottomSheet<FavoriteListPickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FavoriteListPickerSheet(
        currentListId: currentListId,
        isAlreadyFavorite: isAlreadyFavorite,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(favoriteListsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Color(0xFFFF601F)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title ?? (isAlreadyFavorite ? 'Déplacer vers...' : 'Ajouter aux favoris'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Contenu
              Expanded(
                child: listsAsync.when(
                  data: (lists) => _buildListContent(context, ref, lists, scrollController),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF601F)),
                  ),
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur de chargement',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => ref.refresh(favoriteListsProvider),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteList> lists,
    ScrollController scrollController,
  ) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Option "Non classé" / Tous les favoris
        _ListOptionTile(
          icon: Icons.favorite_border,
          iconColor: Colors.grey[600]!,
          title: 'Non classé',
          subtitle: 'Favoris sans liste',
          isSelected: currentListId == null && !isAlreadyFavorite,
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop(const FavoriteListPickerResult(listId: null));
          },
        ),

        const Divider(height: 1, indent: 16, endIndent: 16),

        // Listes existantes
        ...lists.map((list) => _ListOptionTile(
          icon: list.icon,
          iconColor: list.color,
          title: list.name,
          subtitle: '${list.favoritesCount} favori${list.favoritesCount > 1 ? 's' : ''}',
          isSelected: currentListId == list.id,
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop(FavoriteListPickerResult(listId: list.id));
          },
        )),

        const Divider(height: 1, indent: 16, endIndent: 16),

        // Créer une nouvelle liste
        _ListOptionTile(
          icon: Icons.add_circle_outline,
          iconColor: const Color(0xFFFF601F),
          title: 'Créer une liste',
          subtitle: 'Nouvelle collection de favoris',
          showChevron: true,
          onTap: () async {
            final newList = await CreateListDialog.show(context);
            if (newList != null && context.mounted) {
              Navigator.of(context).pop(FavoriteListPickerResult(listId: newList.id));
            }
          },
        ),

        // Option retirer des favoris (si déjà favori)
        if (isAlreadyFavorite) ...[
          const Divider(height: 1, indent: 16, endIndent: 16),
          _ListOptionTile(
            icon: Icons.heart_broken_outlined,
            iconColor: Colors.red,
            title: 'Retirer des favoris',
            subtitle: 'Supprimer de tous les favoris',
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(const FavoriteListPickerResult.remove());
            },
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }
}

class _ListOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final bool showChevron;
  final VoidCallback onTap;

  const _ListOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    this.showChevron = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? iconColor.withOpacity(0.1) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? iconColor : Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: iconColor, size: 24)
              else if (showChevron)
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
