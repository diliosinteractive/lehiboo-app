import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/widgets/feedback/hb_feedback.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_list_controller.dart';

class BookingsListScreen extends ConsumerWidget {
  const BookingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes réservations')),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const HbEmptyState(
              title: 'Aucune réservation',
              message: 'Vous n\'avez aucune réservation pour le moment.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // ref.refresh(bookingsListControllerProvider); // Ideally trigger reload
              // For now since it's fake data, we can just re-read or invalid
              ref.invalidate(bookingsListControllerProvider);
            },
            child: ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final dateStr = booking.slot?.startDateTime != null 
                    ? DateFormat('dd/MM/yyyy HH:mm').format(booking.slot!.startDateTime!) 
                    : 'Date inconnue';

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: booking.activity?.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              booking.activity!.imageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_,__,___) => const Icon(Icons.broken_image),
                            ),
                          )
                        : const CircleAvatar(child: Icon(Icons.event)),
                    title: Text(
                      booking.activity?.title ?? 'Activité #${booking.activityId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Le $dateStr'),
                         const SizedBox(height: 4),
                        Text(
                          '${booking.quantity} place(s) • ${booking.status}',
                          style: TextStyle(
                            color: booking.status == 'confirmed' ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                         // Go to confirmation/ticket screen for details
                         // context.push('/booking-confirmation/${booking.id}'); 
                         // Note: BookingConfirmationScreen requires Activity object in current impl, 
                         // but here we might not have full activity if shallow fetched?
                         // In Fake Repo we return full structure so it works.
                         if (booking.activity != null) {
                            context.push('/booking/${booking.activity!.id}/confirmation', extra: booking.activity!);
                         }
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => HbErrorView(
          message: 'Erreur de chargement: $err',
          onRetry: () => ref.refresh(bookingsListControllerProvider),
        ),
      ),
    );
  }
}