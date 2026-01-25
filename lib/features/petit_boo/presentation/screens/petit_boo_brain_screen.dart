import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../data/datasources/petit_boo_context_storage.dart';
import '../providers/petit_boo_chat_provider.dart';

/// Screen showing Petit Boo's "brain" - the user context/memory it has learned.
/// Allows users to view, edit, and delete information about themselves.
class PetitBooBrainScreen extends ConsumerStatefulWidget {
  const PetitBooBrainScreen({super.key});

  @override
  ConsumerState<PetitBooBrainScreen> createState() => _PetitBooBrainScreenState();
}

class _PetitBooBrainScreenState extends ConsumerState<PetitBooBrainScreen> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(petitBooChatProvider);
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
              child: const Icon(Icons.psychology, color: HbColors.brandPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Mémoire de Petit Boo',
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
              const Text(
                'Ce que je sais sur vous',
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
                    .where((e) => !e.key.startsWith('_')) // Filter internal keys
                    .map((e) => _buildMemoryItem(context, notifier, e.key, e.value))
                    .toList(),

              // Clear all button
              if (contextMap.isNotEmpty) ...[
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _confirmClearAll(context, notifier),
                    icon: Icon(Icons.delete_forever, color: HbColors.error),
                    label: Text(
                      'Tout effacer',
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

  Widget _buildMemoryToggleCard(bool isMemoryEnabled, PetitBooChatNotifier notifier) {
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
                isMemoryEnabled ? Icons.check_circle_outline : Icons.pause_circle_outline,
                color: isMemoryEnabled ? Colors.green[700] : Colors.grey[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isMemoryEnabled ? 'Mémoire activée' : 'Mémoire en pause',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMemoryEnabled ? Colors.green[900] : Colors.grey[800],
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
                ? 'Petit Boo apprend de vos échanges pour vous proposer des sorties qui vous ressemblent. Vous pouvez corriger ou supprimer ces infos ci-dessous.'
                : 'Petit Boo ne retient plus rien de vos nouvelles conversations. Les anciennes informations restent stockées mais ne sont pas utilisées.',
            style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
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
            "Je n'ai pas encore d'infos sur vous.",
            style: TextStyle(
              color: HbColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discutez avec moi pour que j\'apprenne vos goûts !',
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
          Icon(Icons.visibility_off_outlined, size: 48, color: HbColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Réactivez la mémoire pour voir et modifier vos informations.',
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
    final label = PetitBooContextStorage.getKeyLabel(key);
    final formattedValue = PetitBooContextStorage.formatValue(key, value);
    final icon = PetitBooContextStorage.getKeyIcon(key);

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
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Modifier'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Oublier'),
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
    final label = PetitBooContextStorage.getKeyLabel(key);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Nouvelle valeur',
            labelText: label,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
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
            child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
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
    final label = PetitBooContextStorage.getKeyLabel(key);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oublier cette info ?'),
        content: Text('Voulez-vous vraiment que Petit Boo oublie : $label ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () async {
              await notifier.removeContextKey(key);
              if (context.mounted) {
                Navigator.pop(context);
              }
              setState(() {});
            },
            child: Text('Oui, oublier', style: TextStyle(color: HbColors.error)),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, PetitBooChatNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tout effacer ?'),
        content: const Text(
          'Voulez-vous vraiment effacer toutes les informations que Petit Boo a apprises sur vous ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () async {
              await notifier.clearContext();
              if (context.mounted) {
                Navigator.pop(context);
              }
              setState(() {});
            },
            child: Text('Oui, tout effacer', style: TextStyle(color: HbColors.error)),
          ),
        ],
      ),
    );
  }
}
