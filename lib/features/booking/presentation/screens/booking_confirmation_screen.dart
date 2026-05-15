import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_stepper_header.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  const BookingConfirmationScreen({super.key, required this.activity});
  final Activity activity;

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Poison the event detail cache as soon as we land here — the booking
    // has consumed a seat, so spots_remaining is now stale. Doing this in
    // initState (not on button tap) guarantees freshness regardless of
    // how the user navigates away (system back, swipe, deep link).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateEventData();
    });
  }

  void _invalidateEventData() {
    final id = widget.activity.id;
    ref.invalidate(eventDetailControllerProvider(id));
    ref.invalidate(eventAvailabilityProvider(id));
    ref.invalidate(similarEventsProvider(id));
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    final provider = bookingFlowControllerProvider(activity);
    final state = ref.watch(provider);
    final firstName = state.buyerInfo?.firstName?.trim() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.bookingConfirmedTitle),
        automaticallyImplyLeading: false,
      ),
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
                  Text(
                    context.l10n.bookingConfirmedTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.bookingConfirmedBody(
                      firstName,
                      activity.title,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (state.tickets != null && state.tickets!.isNotEmpty)
                    ...state.tickets!.map(
                      (ticket) => Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                context.l10n.bookingTicketId(ticket.id),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (ticket.qrCodeData != null)
                                QrImageView(
                                  data: ticket.qrCodeData!,
                                  version: QrVersions.auto,
                                  size: 150.0,
                                ),
                              const SizedBox(height: 8),
                              Text(
                                context.bookingTicketStatusLabel(ticket.status),
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Text(context.l10n.bookingTicketsGenerating),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: HbButton.secondary(
              label: context.l10n.bookingBackHome,
              onTap: () {
                ref.invalidate(eventDetailControllerProvider(activity.id));
                ref.invalidate(eventAvailabilityProvider(activity.id));
                ref.invalidate(similarEventsProvider(activity.id));
                ref.invalidate(homeFeedProvider);
                context.go('/');
              },
            ),
          ),
        ],
      ),
    );
  }
}
