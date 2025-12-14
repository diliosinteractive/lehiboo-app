import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';

class AiBrainScreen extends ConsumerStatefulWidget {
  const AiBrainScreen({super.key});

  @override
  ConsumerState<AiBrainScreen> createState() => _AiBrainScreenState();
}

class _AiBrainScreenState extends ConsumerState<AiBrainScreen> {
  @override
  Widget build(BuildContext context) {
    // We watch the notifier itself to access properties directly, but improved:
    // Ideally we should select specific parts of the state or use a stream, 
    // but here we just rebuild when `toggleMemory` calls `state.copyWith()`.
    
    // Watch chatProvider to trigger rebuilds on state changes
    ref.watch(chatProvider); 
    
    final notifier = ref.read(chatProvider.notifier);
    final isMemoryEnabled = notifier.isMemoryEnabled;
    final contextMap = notifier.userContext;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF601F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology, color: Color(0xFFFF601F), size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Mémoire de Petit Boo",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Privacy Switch Section
          Container(
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
                      isMemoryEnabled ? Icons.check_circle_outline : Icons.pause_circle_outline,
                      color: isMemoryEnabled ? Colors.green[700] : Colors.grey[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isMemoryEnabled ? "Mémoire activée" : "Mémoire en pause",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMemoryEnabled ? Colors.green[900] : Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: isMemoryEnabled,
                      activeColor: const Color(0xFFFF601F),
                      onChanged: (value) async {
                         notifier.toggleMemory(value);
                         setState(() {}); // Local rebuild to be sure
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isMemoryEnabled
                      ? "Petit Boo apprend de vos échanges pour vous proposer des sorties qui vous ressemblent. Vous pouvez corriger ou supprimer ces infos ci-dessous."
                      : "Petit Boo ne retient plus rien de vos nouvelles conversations. Les anciennes informations restent stockées mais ne sont pas utilisées.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          
          if (isMemoryEnabled) ...[
             const Text(
              "Ce que je sais sur vous",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 16),
            
            // Memory List
            if (contextMap.isEmpty)
              _buildEmptyState()
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: contextMap.length,
                  itemBuilder: (context, index) {
                    final key = contextMap.keys.elementAt(index);
                    // Filter out internal keys (metadata)
                    if (key.startsWith('_')) return const SizedBox.shrink();
                    
                    final value = contextMap[key];
                    return _buildMemoryItem(context, notifier, key, value);
                  },
                ),
              ),
          ] else
             _buildDisabledState(),

        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.psychology_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            "Je n'ai pas encore d'infos sur vous.",
            style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 4),
          Text(
            "Discutez avec moi pour que j'apprenne vos goûts !",
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Text(
        "Réactivez la mémoire pour voir et modifier vos informations.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
  
  Widget _buildMemoryItem(BuildContext context, ChatNotifier notifier, String key, dynamic value) {
     final label = _translateKey(key);
     final formattedValue = _formatValue(key, value);
     final icon = _getIconForKey(key);

     return Container(
       margin: const EdgeInsets.only(bottom: 12),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Colors.grey[200]!),
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.02),
             blurRadius: 8,
             offset: const Offset(0, 2),
           ),
         ],
       ),
       child: ListTile(
         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
         leading: Container(
           padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(
             color: const Color(0xFFFF601F).withOpacity(0.1),
             shape: BoxShape.circle,
           ),
           child: Icon(icon, color: const Color(0xFFFF601F), size: 20),
         ),
         title: Text(
           label,
           style: TextStyle(
             color: Colors.grey[600],
             fontSize: 12,
             fontWeight: FontWeight.w500,
           ),
         ),
         subtitle: Padding(
           padding: const EdgeInsets.only(top: 4),
           child: Text(
             formattedValue,
             style: const TextStyle(
               color: Color(0xFF2D3748),
               fontSize: 16,
               fontWeight: FontWeight.w600,
             ),
           ),
         ),
         trailing: PopupMenuButton<String>(
           icon: const Icon(Icons.more_vert, color: Colors.grey),
           onSelected: (action) {
             if (action == 'edit') {
               _showEditDialog(context, notifier, key, value);
             } else if (action == 'delete') {
               _confirmDelete(context, notifier, key);
             }
           },
           itemBuilder: (context) => [
             const PopupMenuItem(
               value: 'edit',
               child: Row(
                 children: [
                   Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                   SizedBox(width: 12),
                   Text("Modifier"),
                 ],
               ),
             ),
             const PopupMenuItem(
               value: 'delete',
               child: Row(
                 children: [
                   Icon(Icons.delete_outline, size: 20, color: Colors.red),
                   SizedBox(width: 12),
                   Text("Oublier"),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
  }
  
  String _translateKey(String key) {
    const translations = {
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'nickname': 'Surnom',
      'age': 'Âge',
      'age_group': 'Tranche d\'âge',
      'birth_year': 'Année de naissance',
      'city': 'Ville',
      'region': 'Région',
      'favorite_activities': 'Activités favorites',
      'disliked_activities': 'Activités à éviter',
      'favorite_categories': 'Catégories préférées',
      'group_type': 'Type de groupe',
      'has_children': 'Enfants',
      'children_ages': 'Âges des enfants',
      'budget_preference': 'Budget',
      'max_distance': 'Distance max',
      'interests': 'Centres d\'intérêt',
      'dietary_preferences': 'Régime alimentaire',
      'mobility_constraints': 'Mobilité réduite',
      'pet_friendly_needed': 'Animaux acceptés',
      'preferred_times': 'Moments préférés',
      'notes': 'Autres infos',
    };
    return translations[key] ?? _formatHumanKey(key);
  }

  String _formatHumanKey(String key) {
    final formatted = key.replaceAll('_', ' ').replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
    if (formatted.isEmpty) return key;
    return formatted[0].toUpperCase() + formatted.substring(1).toLowerCase();
  }

  String _formatValue(String key, dynamic value) {
    if (value == null) return 'Non défini';
    
    // Handle booleans
    if (value is bool) {
      if (key == 'has_children' || key == 'mobility_constraints' || key == 'pet_friendly_needed') {
        return value ? 'Oui' : 'Non';
      }
    }

    // Handle lists
    if (value is List) {
       if (value.isEmpty) return 'Aucun';
       return value.join(', ');
    }
    
    final stringValue = value.toString();

    // Specific formatting for known enums
    if (key == 'age_group') {
      const map = {
        'child': 'Enfant',
        'teen': 'Ado',
        'young_adult': 'Jeune adulte',
        'adult': 'Adulte',
        'senior': 'Senior'
      };
      return map[stringValue] ?? stringValue;
    }
    
    if (key == 'group_type') {
      const map = {
        'solo': 'Solo',
        'couple': 'En couple',
        'family': 'En famille',
        'friends': 'Entre amis',
      };
      return map[stringValue] ?? stringValue;
    }

    if (key == 'budget_preference') {
       const map = {
        'free': 'Gratuit',
        'low': 'Éco (€)',
        'medium': 'Moyen (€€)',
        'high': 'Élevé (€€€)',
        'no_limit': 'Illimité',
      };
      return map[stringValue] ?? stringValue;
    }
    
    if (key == 'max_distance') {
      return '$stringValue km';
    }

    if (key == 'age' || key == 'birth_year') {
      return stringValue;
    }

    return stringValue;
  }

  IconData _getIconForKey(String key) {
    switch (key) {
      case 'first_name':
      case 'last_name':
      case 'nickname':
        return Icons.person_outline;
      case 'age':
      case 'age_group':
      case 'birth_year':
        return Icons.cake_outlined;
      case 'city':
      case 'region':
        return Icons.location_on_outlined;
      case 'max_distance':
        return Icons.map_outlined;
      case 'favorite_activities':
      case 'favorite_categories':
      case 'interests':
        return Icons.favorite_border;
      case 'disliked_activities':
        return Icons.thumb_down_outlined;
      case 'group_type':
      case 'has_children':
      case 'children_ages':
        return Icons.people_outline;
      case 'budget_preference':
        return Icons.euro_symbol;
      case 'dietary_preferences':
        return Icons.restaurant_menu;
      case 'pet_friendly_needed':
        return Icons.pets;
      case 'mobility_constraints':
        return Icons.accessible;
      case 'preferred_times':
        return Icons.schedule;
      default:
        return Icons.info_outline;
    }
  }

  void _showEditDialog(BuildContext context, ChatNotifier notifier, String key, dynamic currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier ${_translateKey(key)}"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Nouvelle valeur",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              notifier.updateBrainKey(key, controller.text);
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF601F)),
            child: const Text("Enregistrer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ChatNotifier notifier, String key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Oublier cette info ?"),
        content: Text("Voulez-vous vraiment que Petit Boo oublie : ${_translateKey(key)} ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Non")),
          TextButton(
            onPressed: () {
              notifier.removeBrainKey(key);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Oui, oublier", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
