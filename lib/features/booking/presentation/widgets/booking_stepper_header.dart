import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

class BookingStepperHeader extends StatelessWidget {
  const BookingStepperHeader({super.key, required this.step});

  final BookingStep step;

  @override
  Widget build(BuildContext context) {
    int currentStepIndex = step.when(
      selectSlot: () => 1,
      participants: () => 2,
      payment: () => 3,
      confirmation: () => 4,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          _StepIndicator(index: 1, currentIndex: currentStepIndex, label: 'Créneau'),
          _StepDashedLine(active: currentStepIndex > 1),
          _StepIndicator(index: 2, currentIndex: currentStepIndex, label: 'Infos'),
          _StepDashedLine(active: currentStepIndex > 2),
             // Hide payment step if skipping might be confusing, but for now simple linear
          _StepIndicator(index: 3, currentIndex: currentStepIndex, label: 'Paiement'),
          
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.index, required this.currentIndex, required this.label});
  final int index;
  final int currentIndex;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isActive = index <= currentIndex;
    final isCurrent = index == currentIndex;
    final color = isActive ? Theme.of(context).primaryColor : Colors.grey[300];

    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Text(
            '$index',
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        if (isCurrent) ...[
             const SizedBox(height: 4),
             Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold))
        ]
      ],
    );
  }
}

class _StepDashedLine extends StatelessWidget {
  const _StepDashedLine({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: active ? Colors.purple : Colors.grey[200],
      ),
    );
  }
}
