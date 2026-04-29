import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/messages/presentation/widgets/new_conversation_form.dart';

/// Organizer section that displays differently based on the event source:
///
/// **Vendor** (organizer is NOT platform):
/// Logo + Name + Le Hiboo badge, verified status, venue type tags,
/// events count, and a "Nous contacter" button.
///
/// **Platform** (organizer IS platform — crawled or admin-created events):
/// Le Hiboo owl icon, "Rédigé par LEHIBOO EXPÉRIENCES",
/// and "Source infos : {originalOrganizerName}" when available.
class EventOrganizerCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onOrganizerTap;

  const EventOrganizerCard({
    super.key,
    required this.event,
    this.onOrganizerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.organizerIsPlatform ? 'Sources Infos' : 'Organisateur',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          event.organizerIsPlatform
              ? _PlatformOrganizerCard(event: event)
              : _VendorOrganizerCard(
                  event: event,
                  onOrganizerTap: onOrganizerTap,
                ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vendor card
// ─────────────────────────────────────────────────────────────────────────────

class _VendorOrganizerCard extends ConsumerWidget {
  final Event event;
  final VoidCallback? onOrganizerTap;

  const _VendorOrganizerCard({required this.event, this.onOrganizerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (onOrganizerTap != null) {
            onOrganizerTap!();
          } else {
            context.push('/partner/${event.organizerId}');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Avatar + Name + Le Hiboo badge + chevron
              Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            event.organizerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: HbColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Le Hiboo vendor badge
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/lehiboo_vendor_badge.png',
                            width: 22,
                            height: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Row 2: Verified status
              _buildVerifiedStatus(),

              // Row 3: Venue type tags
              if (event.organizerVenueTypes.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildVenueTypeTags(),
              ],

              // Row 4: Events count + followers
              const SizedBox(height: 10),
              _buildStats(),

              // Row 5: Contact button
              if (event.organizerAllowPublicContact) ...[
                const SizedBox(height: 14),
                _buildContactButton(context, ref),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: event.organizerLogo != null
            ? CachedNetworkImage(
                imageUrl: event.organizerLogo!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _avatarPlaceholder(),
                errorWidget: (_, __, ___) => _avatarPlaceholder(),
              )
            : _avatarPlaceholder(),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: HbColors.brandPrimary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          event.organizerName.isNotEmpty
              ? event.organizerName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: HbColors.brandPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedStatus() {
    final isVerified = event.organizerVerified;
    return Row(
      children: [
        Icon(
          isVerified ? Icons.verified : Icons.info_outline,
          size: 15,
          color: isVerified ? Colors.blue.shade600 : Colors.grey.shade500,
        ),
        const SizedBox(width: 5),
        Text(
          isVerified ? 'Organisateur vérifié' : 'Organisateur non vérifié',
          style: TextStyle(
            fontSize: 13,
            color: isVerified ? Colors.blue.shade600 : Colors.grey.shade500,
            fontWeight: isVerified ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildVenueTypeTags() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: event.organizerVenueTypes.map((type) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: HbColors.brandSecondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: HbColors.brandSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStats() {
    final count = event.organizerEventsCount;
    final followers = event.organizerFollowersCount ?? 0;
    return Row(
      children: [
        if (count != null && count > 0) ...[
          Icon(Icons.event_outlined, size: 15, color: Colors.grey.shade500),
          const SizedBox(width: 5),
          Text(
            '$count événement${count > 1 ? 's' : ''} publiés',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 14),
        ],
        const Icon(Icons.favorite_border, size: 15, color: HbColors.brandPrimary),
        const SizedBox(width: 5),
        Text(
          '$followers abonné${followers > 1 ? 's' : ''}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              HapticFeedback.lightImpact();
              final allowed = await GuestGuard.check(
                context: context,
                ref: ref,
                featureName: 'contacter un organisateur',
              );
              if (!allowed || !context.mounted) return;
              NewConversationForm.show(
                context,
                conversationContext: FromOrganizerConversationContext(
                  organizationUuid: event.organizerId,
                  organizationName: event.organizerName,
                  organizationLogoUrl: event.organizerLogo,
                  prefilledEventId: event.id,
                  prefilledEventTitle: event.title,
                ),
              );
            },
            icon: const Icon(Icons.mail_outline, size: 18),
            label: const Text('Contacter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/partner/${event.organizerId}');
            },
            style: TextButton.styleFrom(
              foregroundColor: HbColors.brandPrimary,
              backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Voir le profil',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Platform card (crawled / admin events)
// ─────────────────────────────────────────────────────────────────────────────

class _PlatformOrganizerCard extends StatelessWidget {
  final Event event;

  const _PlatformOrganizerCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final sourceName = event.originalOrganizerName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Owl icon + "Rédigé par" / "LEHIBOO EXPÉRIENCES"
          Row(
            children: [
              // Le Hiboo owl — grey-tinted for platform attribution
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      'assets/images/logo_picto_lehiboo_old.png',
                      // color: Colors.grey.shade500,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rédigé par',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'LEHIBOO EXPÉRIENCES',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: HbColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Source info (for crawled events)
          if (sourceName != null && sourceName.isNotEmpty) ...[
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                children: [
                  const TextSpan(text: 'Source infos : '),
                  TextSpan(
                    text: sourceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: HbColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
