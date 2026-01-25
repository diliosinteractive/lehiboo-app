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
                    backgroundColor: const Color(0xFFFF601F).withValues(alpha: 0.1),
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
        color: isSelected ? iconColor.withValues(alpha: 0.15) : Colors.transparent,
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
                    color: iconColor.withValues(alpha: isSelected ? 0.2 : 0.1),
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
                      color: isSelected ? iconColor.withValues(alpha: 0.2) : Colors.grey[200],
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
/// Design amélioré avec scroll fluide et indicateurs visuels
class FavoriteListsChips extends ConsumerStatefulWidget {
  const FavoriteListsChips({super.key});

  @override
  ConsumerState<FavoriteListsChips> createState() => _FavoriteListsChipsState();
}

class _FavoriteListsChipsState extends ConsumerState<FavoriteListsChips> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftFade = false;
  bool _showRightFade = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateFadeState);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateFadeState);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateFadeState() {
    final showLeft = _scrollController.offset > 10;
    final showRight = _scrollController.offset <
        _scrollController.position.maxScrollExtent - 10;

    if (showLeft != _showLeftFade || showRight != _showRightFade) {
      setState(() {
        _showLeftFade = showLeft;
        _showRightFade = showRight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(favoriteListsProvider);
    final selectedListId = ref.watch(selectedFavoriteListProvider);

    return listsAsync.when(
      data: (lists) => _buildChips(context, lists, selectedListId),
      loading: () => Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildChips(
    BuildContext context,
    List<FavoriteList> lists,
    String? selectedListId,
  ) {
    final totalCount = lists.fold(0, (sum, l) => sum + l.favoritesCount);

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Liste scrollable
          ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            physics: const BouncingScrollPhysics(),
            children: [
              // Tous
              _FolderChip(
                label: 'Tous',
                icon: Icons.favorite,
                color: const Color(0xFFFF601F),
                count: totalCount,
                isSelected: selectedListId == null,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(selectedFavoriteListProvider.notifier).state = null;
                },
              ),
              const SizedBox(width: 10),

              // Non classés
              _FolderChip(
                label: 'Non classés',
                icon: Icons.folder_off_outlined,
                color: Colors.grey[500]!,
                isSelected: selectedListId == 'uncategorized',
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(selectedFavoriteListProvider.notifier).state =
                      'uncategorized';
                },
              ),

              // Listes personnalisées
              ...lists.map((list) => Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _FolderChip(
                      label: list.name,
                      icon: list.icon,
                      color: list.color,
                      count: list.favoritesCount,
                      isSelected: selectedListId == list.id,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(selectedFavoriteListProvider.notifier).state =
                            list.id;
                      },
                      onLongPress: () async {
                        HapticFeedback.mediumImpact();
                        final result = await EditListDialog.show(context, list);
                        if (result == null && selectedListId == list.id) {
                          ref.read(selectedFavoriteListProvider.notifier).state =
                              null;
                        }
                      },
                    ),
                  )),

              // Bouton ajouter
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _AddFolderButton(
                  onTap: () => CreateListDialog.show(context),
                ),
              ),
            ],
          ),

          // Gradient de fondu à gauche
          if (_showLeftFade)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Gradient de fondu à droite
          if (_showRightFade)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip de dossier amélioré avec design moderne
class _FolderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _FolderChip({
    required this.label,
    required this.icon,
    required this.color,
    this.count,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicateur de couleur (petit cercle)
            if (!isSelected)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

            // Icône
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8),

            // Label
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Compteur
            if (count != null && count! > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : color,
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

/// Bouton pour ajouter une nouvelle liste
class _AddFolderButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddFolderButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFFF601F).withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFFF601F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.add,
                size: 16,
                color: Color(0xFFFF601F),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Créer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF601F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

