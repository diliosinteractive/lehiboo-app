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
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: contextMap.length,
                  separatorBuilder: (c, i) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final key = contextMap.keys.elementAt(index);
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
     return ListTile(
       contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
       title: Text(
         _formatKey(key),
         style: TextStyle(color: Colors.grey[600], fontSize: 13),
       ),
       subtitle: Text(
         value.toString(),
         style: const TextStyle(
           color: Color(0xFF222222), 
           fontSize: 16, 
           fontWeight: FontWeight.w500
         ),
       ),
       trailing: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           IconButton(
             icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
             onPressed: () => _showEditDialog(context, notifier, key, value),
           ),
           IconButton(
             icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
             onPressed: () => _confirmDelete(context, notifier, key),
           ),
         ],
       ),
     );
  }
  
  String _formatKey(String key) {
    // Convert camelCase or snake_case to Human Readable
    // e.g. favorite_food -> Favorite food
    // cuisineFavorite -> Cuisine favorite
    final formatted = key.replaceAll('_', ' ').replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
    if (formatted.isEmpty) return key;
    return formatted[0].toUpperCase() + formatted.substring(1).toLowerCase();
  }

  void _showEditDialog(BuildContext context, ChatNotifier notifier, String key, dynamic currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier ${_formatKey(key)}"),
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
        content: Text("Voulez-vous vraiment que Petit Boo oublie : ${_formatKey(key)} ?"),
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
