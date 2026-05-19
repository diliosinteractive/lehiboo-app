import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../features/petit_boo/presentation/widgets/animated_toast.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminders_provider.dart';

class RemindersListScreen extends ConsumerStatefulWidget {
  const RemindersListScreen({super.key});

  @override
  ConsumerState<RemindersListScreen> createState() =>
      _RemindersListScreenState();
}

class _RemindersListScreenState extends ConsumerState<RemindersListScreen> {
  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(remindersListProvider);

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.l10n.remindersTitle),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        color: HbColors.brandPrimary,
        onRefresh: () =>
            ref.read(remindersListProvider.notifier).loadReminders(),
        child: remindersAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: HbColors.brandPrimary),
          ),
          error: (error, _) => _buildError(),
          data: (reminders) {
            if (reminders.isEmpty) return _buildEmpty();

            // Separate upcoming from past
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final upcoming =
                reminders.where((r) => !r.slotDate.isBefore(today)).toList();
            final past =
                reminders.where((r) => r.slotDate.isBefore(today)).toList();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                if (upcoming.isNotEmpty) ...[
                  _buildSectionHeader(
                      context.l10n.remindersUpcoming, upcoming.length),
                  ...upcoming.map((r) => _buildReminderCard(r)),
                ],
                if (past.isNotEmpty) ...[
                  if (upcoming.isNotEmpty) const SizedBox(height: 24),
                  _buildSectionHeader(context.l10n.remindersPast, past.length),
                  ...past.map((r) => _buildReminderCard(r, isPast: true)),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: HbColors.brandPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder, {bool isPast = false}) {
    return Dismissible(
      key: ValueKey('${reminder.eventUuid}_${reminder.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(reminder),
      child: GestureDetector(
        onTap: () => context.push('/event/${reminder.eventSlug}'),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // Event image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: reminder.eventImage != null
                    ? CachedNetworkImage(
                        imageUrl: reminder.eventImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.event, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.eventTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isPast ? Colors.grey : HbColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 13,
                            color: isPast ? Colors.grey : Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatSlotDate(context, reminder),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isPast ? Colors.grey : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (reminder.venueName != null ||
                        reminder.city != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 13,
                              color:
                                  isPast ? Colors.grey : Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              [reminder.venueName, reminder.city]
                                  .where((s) => s != null && s.isNotEmpty)
                                  .join(', '),
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isPast ? Colors.grey : Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Notification badges
              Column(
                children: [
                  if (reminder.notified7Days)
                    _buildBadge(context.l10n.remindersDaysBeforeBadge(7), true),
                  if (reminder.notified1Day) ...[
                    if (reminder.notified7Days) const SizedBox(height: 4),
                    _buildBadge(context.l10n.remindersDaysBeforeBadge(1), true),
                  ],
                  if (!reminder.notified7Days && !reminder.notified1Day)
                    Icon(
                      Icons.notifications_active,
                      size: 20,
                      color:
                          isPast ? Colors.grey.shade400 : HbColors.brandPrimary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, bool sent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: sent
            ? HbColors.success.withValues(alpha: 0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sent ? Icons.check_circle : Icons.schedule,
            size: 10,
            color: sent ? HbColors.success : Colors.grey,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: sent ? HbColors.success : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(Reminder reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.remindersDeleteTitle),
        content: Text(
          context.l10n.remindersDeleteBody(
            reminder.eventTitle,
            _formatSlotDate(context, reminder),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.messagesDeleteAction),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(remindersListProvider.notifier).deleteReminder(
            eventUuid: reminder.eventUuid,
            slotUuid: reminder.id,
          );
      if (mounted) {
        PetitBooToast.show(
          context,
          message: context.l10n.remindersDeleted,
          icon: Icons.delete_outline,
        );
      }
      return true;
    }
    return false;
  }

  String _formatSlotDate(BuildContext context, Reminder reminder) {
    final d = reminder.slotDate;
    var result =
        DateFormat('EEE d MMM yyyy', context.l10n.localeName).format(d);

    if (reminder.startTime != null) {
      final start = _stripSeconds(reminder.startTime!);
      if (reminder.endTime != null) {
        result = context.l10n.remindersDateFromTo(
          result,
          start,
          _stripSeconds(reminder.endTime!),
        );
      } else {
        result = context.l10n.remindersDateAtTime(result, start);
      }
    }
    return result;
  }

  static String _stripSeconds(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return time;
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: HbColors.brandPrimary,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.remindersEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.remindersEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              context.l10n.remindersLoadError,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(remindersListProvider.notifier).loadReminders(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(context.l10n.commonRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
