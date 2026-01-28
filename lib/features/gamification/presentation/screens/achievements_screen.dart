
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/gamification_items.dart';
import '../providers/gamification_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Soft blue-grey background
      appBar: AppBar(
        title: const Text('Mes Trophées', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: achievementsAsync.when(
        data: (achievements) {
          if (achievements.isEmpty) {
            return _buildComingSoon(context);
          }
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
               return _buildBadgeCard(context, achievements[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => _buildComingSoon(context),
      ),
    );
  }

  Widget _buildComingSoon(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.construction_rounded,
                size: 64,
                color: Colors.orange.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bientôt disponible !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Les trophées et badges arrivent très bientôt.\nContinue à explorer pour débloquer des récompenses !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(BuildContext context, Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;

    return GestureDetector(
      onTap: () => _showDetail(context, achievement),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isUnlocked 
            ? const LinearGradient(
                colors: [Color(0xFFFFF176), Color(0xFFFFCC80)], // Gold/Orange
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey.shade200, Colors.grey.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          boxShadow: [
             BoxShadow(
               color: isUnlocked ? Colors.orange.withOpacity(0.3) : Colors.black.withOpacity(0.05),
               blurRadius: 10,
               offset: const Offset(0, 5),
             ),
          ],
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                   BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: Icon(
                isUnlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
                size: 32,
                color: isUnlocked ? Colors.orange : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 12),
            
            // Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 15,
                  color: isUnlocked ? Colors.brown.shade800 : Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            if (!isUnlocked) ...[
               const SizedBox(height: 8),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                 child: LinearProgressIndicator(
                   value: achievement.progressCurrent / achievement.progressTarget,
                   backgroundColor: Colors.white54,
                   color: Colors.grey.shade500,
                   minHeight: 6,
                   borderRadius: BorderRadius.circular(3),
                 ),
               ),
            ]
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: achievement.isUnlocked ? Colors.orange : Colors.grey.shade300, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: achievement.isUnlocked ? Colors.orange.shade50 : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement.isUnlocked ? Icons.stars_rounded : Icons.lock_clock,
                  size: 48,
                  color: achievement.isUnlocked ? Colors.orange : Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                achievement.title, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)
              ),
              
              const SizedBox(height: 8),
              
              Text(
                achievement.description, 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)
              ),
              
              const SizedBox(height: 24),
              
              // Progress Bar
              Column(
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Progression", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                       Text("${achievement.progressCurrent}/${achievement.progressTarget}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
                     ],
                   ),
                   const SizedBox(height: 8),
                   ClipRRect(
                     borderRadius: BorderRadius.circular(8),
                     child: LinearProgressIndicator(
                       value: achievement.progressCurrent / achievement.progressTarget,
                       backgroundColor: Colors.grey.shade200,
                       color: achievement.isUnlocked ? Colors.green : Colors.orange,
                       minHeight: 12,
                     ),
                   ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF601F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Top !', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
