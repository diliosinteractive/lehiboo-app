import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite_list.dart';
import '../providers/favorite_lists_provider.dart';
import 'create_list_dialog.dart';
import 'edit_list_dialog.dart';

/// Sidebar affichant les listes de favoris (pour tablettes)
class FavoriteListsSidebar extends ConsumerWidget {
  final double width;

  const FavoriteListsSidebar({
    super.key,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(favoriteListsProvider);
    final selectedListId = ref.watch(selectedFavoriteListProvider);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          right: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_special, color: Color(0xFFFF601F)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Mes listes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 22),
                  onPressed: () => CreateListDialog.show(context),
                  tooltip: 'Nouvelle liste',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFF601F).withOpacity(0.1),
                    foregroundColor: const Color(0xFFFF601F),
                  ),
                ),
              ],
            ),
          ),

          // Listes
          Expanded(
            child: listsAsync.when(
              data: (lists) => _buildListView(context, ref, lists, selectedListId),
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
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteList> lists,
    String? selectedListId,
  ) {
    final totalCount = lists.fold(0, (sum, l) => sum + l.favoritesCount);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Tous les favoris
        _SidebarListItem(
          icon: Icons.favorite,
          iconColor: const Color(0xFFFF601F),
          title: 'Tous les favoris',
          count: totalCount,
          isSelected: selectedListId == null,
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(selectedFavoriteListProvider.notifier).state = null;
          },
        ),

        // Non classés
        _SidebarListItem(
          icon: Icons.favorite_border,
          iconColor: Colors.grey[600]!,
          title: 'Non classés',
          count: null, // On ne connaît pas le compte exact
          isSelected: selectedListId == 'uncategorized',
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(selectedFavoriteListProvider.notifier).state = 'uncategorized';
          },
        ),

        if (lists.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'MES LISTES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],

        // Listes personnalisées
        ...lists.map((list) => _SidebarListItem(
          icon: list.icon,
          iconColor: list.color,
          title: list.name,
          count: list.favoritesCount,
          isSelected: selectedListId == list.id,
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(selectedFavoriteListProvider.notifier).state = list.id;
          },
          onLongPress: () async {
            HapticFeedback.mediumImpact();
            final result = await EditListDialog.show(context, list);

            // Si la liste a été supprimée et était sélectionnée, revenir à "tous"
            if (result == null && selectedListId == list.id) {
              ref.read(selectedFavoriteListProvider.notifier).state = null;
            }
          },
        )),

        // Bouton créer
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextButton.icon(
            onPressed: () => CreateListDialog.show(context),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Nouvelle liste'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF601F),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _SidebarListItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.count,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected ? iconColor.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(isSelected ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? iconColor : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (count != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? iconColor.withOpacity(0.2) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? iconColor : Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Chips horizontaux pour la sélection de listes (version mobile)
class FavoriteListsChips extends ConsumerWidget {
  const FavoriteListsChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(favoriteListsProvider);
    final selectedListId = ref.watch(selectedFavoriteListProvider);

    return listsAsync.when(
      data: (lists) => _buildChips(context, ref, lists, selectedListId),
      loading: () => const SizedBox(
        height: 48,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF601F)),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildChips(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteList> lists,
    String? selectedListId,
  ) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Tous
          _FilterChip(
            label: 'Tous',
            icon: Icons.favorite,
            color: const Color(0xFFFF601F),
            isSelected: selectedListId == null,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(selectedFavoriteListProvider.notifier).state = null;
            },
          ),
          const SizedBox(width: 8),

          // Non classés
          _FilterChip(
            label: 'Non classés',
            icon: Icons.favorite_border,
            color: Colors.grey[600]!,
            isSelected: selectedListId == 'uncategorized',
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(selectedFavoriteListProvider.notifier).state = 'uncategorized';
            },
          ),

          // Listes personnalisées
          ...lists.map((list) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _FilterChip(
              label: list.name,
              icon: list.icon,
              color: list.color,
              count: list.favoritesCount,
              isSelected: selectedListId == list.id,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(selectedFavoriteListProvider.notifier).state = list.id;
              },
            ),
          )),

          // Bouton ajouter
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('Nouvelle'),
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () => CreateListDialog.show(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.color,
    this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
