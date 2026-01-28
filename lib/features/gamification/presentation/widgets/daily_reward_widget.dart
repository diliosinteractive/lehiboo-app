
import 'package:flutter/material.dart';
import '../../data/models/daily_reward.dart';

class DailyRewardWidget extends StatelessWidget {
  final DailyRewardState state;
  final VoidCallback onClaim;
  final bool canClaim; // Utilise canClaimDaily du wallet
  final bool isLoading;

  const DailyRewardWidget({
    super.key,
    required this.state,
    required this.onClaim,
    this.canClaim = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Récompense Quotidienne',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.days.length,
            itemBuilder: (context, index) {
              final day = state.days[index];
              return _buildDayCard(day, state.currentDay);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SizedBox(
             width: double.infinity,
             child: ElevatedButton(
               onPressed: canClaim && !isLoading ? onClaim : null,
               style: ElevatedButton.styleFrom(
                 backgroundColor: canClaim ? const Color(0xFFFF601F) : Colors.grey.shade400,
                 foregroundColor: Colors.white,
                 padding: const EdgeInsets.symmetric(vertical: 12),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               ),
               child: isLoading
                   ? const SizedBox(
                       height: 20,
                       width: 20,
                       child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                     )
                   : Text(
                       canClaim ? 'Réclamer ma récompense' : 'Reviens demain !',
                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                     ),
             ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(DailyRewardDay day, int currentDay) {
    final isPast = day.dayNumber < currentDay;
    final isToday = day.dayNumber == currentDay;
    final isFuture = day.dayNumber > currentDay;
    final isJackpot = day.isJackpot;

    Color bgColor;
    if (isToday) {
      bgColor = const Color(0xFFFF601F);
    } else if (isPast) {
      bgColor = Colors.green.shade100;
    } else {
      bgColor = Colors.grey.shade100;
    }

    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: isToday ? Border.all(color: Colors.orange.shade800, width: 2) : Border.all(color: Colors.transparent),
        boxShadow: isToday ? [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'J-${day.dayNumber}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            isJackpot ? Icons.card_giftcard : Icons.monetization_on,
            color: isToday ? Colors.white : (isJackpot ? Colors.purple : Colors.amber),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '${day.hibonsReward}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : Colors.black87,
            ),
          ),
          if (isPast)
            const Icon(Icons.check_circle, color: Colors.green, size: 16),
        ],
      ),
    );
  }
}
