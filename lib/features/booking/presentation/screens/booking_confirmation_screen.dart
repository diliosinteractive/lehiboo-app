import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
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
  late final String? _ownerSessionUserId;
  late final AuthSessionKey _ownerSession;

  @override
  void initState() {
    super.initState();
    _ownerSessionUserId = ref.read(authSessionUserIdProvider);
    _ownerSession = ref.read(authSessionKeyProvider);
    // Poison the event detail cache as soon as we land here — the booking
    // has consumed a seat, so spots_remaining is now stale. Doing this in
    // initState (not on button tap) guarantees freshness regardless of
    // how the user navigates away (system back, swipe, deep link).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateEventData();
    });
  }

  void _invalidateEventData() {
    if (!identical(ref.read(authSessionKeyProvider), _ownerSession)) return;
    final id = widget.activity.id;
    ref.invalidate(
      eventDetailControllerProvider(eventDetailRequest(_ownerSession, id)),
    );
    ref.invalidate(
      eventAvailabilityProvider(eventAvailabilityRequest(_ownerSession, id)),
    );
    ref.invalidate(similarEventsProvider(id));
  }

  @override
  Widget build(BuildContext context) {
    final currentSessionUserId = ref.watch(authSessionUserIdProvider);
    final currentSession = ref.watch(authSessionKeyProvider);
    if (_ownerSessionUserId == null ||
        currentSessionUserId != _ownerSessionUserId ||
        !identical(currentSession, _ownerSession)) {
      return const Scaffold(
        key: Key('booking-confirmation-session-invalid'),
        body: SizedBox.shrink(),
      );
    }

    final activity = widget.activity;
    final provider = bookingFlowControllerProvider(activity);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
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
                  if (state.isSubmitting)
                    const CircularProgressIndicator()
                  else if (state.errorMessage != null)
                    Column(
                      children: [
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: controller.retryTickets,
                          icon: const Icon(Icons.refresh),
                          label: Text(context.l10n.commonRetry),
                        ),
                      ],
                    )
                  else if (state.tickets != null && state.tickets!.isNotEmpty)
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
                              if (ticket.qrCodeData?.trim().isNotEmpty ?? false)
                                QrImageView(
                                  data: ticket.qrCodeData!.trim(),
                                  version: QrVersions.auto,
                                  size: 150.0,
                                )
                              else
                                Text(
                                  context.l10n.bookingTicketsNotReady,
                                  textAlign: TextAlign.center,
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
                if (!identical(
                  ref.read(authSessionKeyProvider),
                  _ownerSession,
                )) {
                  return;
                }
                ref.invalidate(
                  eventDetailControllerProvider(
                    eventDetailRequest(_ownerSession, activity.id),
                  ),
                );
                ref.invalidate(
                  eventAvailabilityProvider(
                    eventAvailabilityRequest(_ownerSession, activity.id),
                  ),
                );
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
