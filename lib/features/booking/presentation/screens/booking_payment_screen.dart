import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_stepper_header.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_summary_card.dart';

// TODO(lehiboo): Implement real Stripe integration here
class BookingPaymentScreen extends ConsumerWidget {
  const BookingPaymentScreen({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = bookingFlowControllerProvider(activity);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: Column(
        children: [
          BookingStepperHeader(step: state.step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                   BookingSummaryCard(state: state),
                   const SizedBox(height: 32),
                   Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey[300]!),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: Column(
                       children: [
                         const Row(
                           children: [
                             Icon(Icons.credit_card),
                             SizedBox(width: 8),
                             Text('Carte bancaire (Simulé)', style: TextStyle(fontWeight: FontWeight.bold)),
                           ],
                         ),
                         const SizedBox(height: 16),
                         TextField(
                           decoration: const InputDecoration(
                             labelText: 'Numéro de carte',
                             hintText: '4242 4242 4242 4242',
                             border: OutlineInputBorder(),
                           ),
                           readOnly: true, // Simulation
                           onTap: () {},
                         ),
                         const SizedBox(height: 12),
                         const Row(
                            children: [
                              Expanded(
                                child: TextField(
                                   decoration: InputDecoration(labelText: 'MM/AA', hintText: '12/26', border: OutlineInputBorder()),
                                   readOnly: true,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                   decoration: InputDecoration(labelText: 'CVC', hintText: '123', border: OutlineInputBorder()),
                                   readOnly: true,
                                ),
                              ),
                            ],
                         )
                       ],
                     ),
                   ),
                   if (state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                      ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: HbButton.primary(
              label: 'Payer ${state.totalPrice} ${state.currency}',
              isLoading: state.isSubmitting,
              onTap: () {
                 // Simulate Stripe Success
                 controller.submitPaidBooking(paymentIntentId: 'pi_fake_12345').then((_) {
                     final updatedState = ref.read(provider);
                     if (updatedState.errorMessage == null) {
                         context.push('/booking/${activity.id}/confirmation', extra: activity);
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
