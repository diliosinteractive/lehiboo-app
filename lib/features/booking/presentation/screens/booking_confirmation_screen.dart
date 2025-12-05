import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_stepper_header.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = bookingFlowControllerProvider(activity);
    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          BookingStepperHeader(step: state.step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 16),
                  Text('Réservation confirmée !', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Merci ${state.buyerInfo?.firstName}, votre réservation pour "${activity.title}" est validée.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (state.tickets != null && state.tickets!.isNotEmpty)
                    ...state.tickets!.map((ticket) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Billet #${ticket.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            if (ticket.qrCodeData != null)
                              QrImageView(
                                data: ticket.qrCodeData!,
                                version: QrVersions.auto,
                                size: 150.0,
                              ),
                            const SizedBox(height: 8),
                            Text(ticket.status ?? 'Valide', style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ))
                  else
                    const Text('Vos billets sont en cours de génération...'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: HbButton.secondary(
                  label: 'Retour à l\'accueil',
              onTap: () => context.go('/'),
            ),
          ),
        ],
      ),
    );
  }
}