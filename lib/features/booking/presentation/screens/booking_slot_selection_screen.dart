import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/core/widgets/feedback/hb_feedback.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_stepper_header.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_summary_card.dart';

class BookingSlotSelectionScreen extends ConsumerWidget {
  const BookingSlotSelectionScreen({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = bookingFlowControllerProvider(activity);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    // Mock slots for now, in real app this comes from slot repository provider
    final slots = [
      if (activity.nextSlot != null) activity.nextSlot!,
      // Add fake future slots for demo if needed
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Réserver : ${activity.title}')),
      body: Column(
        children: [
          BookingStepperHeader(step: state.step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingSummaryCard(state: state),
                  const SizedBox(height: 24),
                  Text('Choisir un créneau', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  if (slots.isEmpty)
                    const HbEmptyState(
                      title: 'Aucun créneau',
                      message: 'Aucun créneau disponible pour le moment.'
                    )
                  else
                    ...slots.map((slot) {
                      final isSelected = state.selectedSlot?.id == slot.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => controller.selectSlot(slot),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                              border: Border.all(
                                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time, 
                                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${slot.startDateTime}', // Format this properly
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  
                  const SizedBox(height: 24),
                  Text('Nombre de participants', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: state.quantity > 1 ? () => controller.updateQuantity(state.quantity - 1) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      Text('${state.quantity}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      IconButton.filledTonal(
                        onPressed: () => controller.updateQuantity(state.quantity + 1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 24),
                    HbErrorView(message: state.errorMessage!, onRetry: () {}), // Retry empty for now
                  ]
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: HbButton.primary(
              label: 'Continuer',
              onTap: () {
                controller.goToParticipantsStep().then((_) {
                  // Navigation triggered by state listener ideally, 
                  // but here verify state and push
                  final updatedState = ref.read(provider);
                  if (updatedState.errorMessage == null) {
                      context.push('/booking/${activity.id}/participants', extra: activity);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
