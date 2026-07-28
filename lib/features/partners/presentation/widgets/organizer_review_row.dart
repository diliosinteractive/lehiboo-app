import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../reviews/data/models/review_dto.dart';

/// One review row in the organizer's reviews tab — spec §6ter.4 fields.
///
/// Includes a star row, body, author identity (avatar or initials), the
/// "Avis pour *Event Name*" link → event detail, the "Achat vérifié" badge,
/// helpful-count badge, and an optional inlined organizer reply card.
class OrganizerReviewRow extends StatelessWidget {
  final ReviewDto review;

  const OrganizerReviewRow({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final author = review.author;
    final isVerified =
        review.isVerifiedPurchase || review.isVerifiedPurchaseCamel;
    final helpful = review.helpfulCount > 0
        ? review.helpfulCount
        : review.helpfulCountCamel;
    final createdLabel = review.createdAtFormatted.isNotEmpty
        ? review.createdAtFormatted
        : review.createdAtFormattedCamel;

    final eventTitle = review.eventTitle ?? review.event?.title;
    final eventTarget = review.eventUuid ??
        review.event?.uuid ??
        review.eventSlug ??
        review.event?.slug;

    final showOrganizerReply = review.hasResponse ||
        (review.organizerResponse != null &&
            review.organizerResponse!.isNotEmpty) ||
        review.response != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthorAvatar(author: author),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author?.name.isNotEmpty == true
                          ? author!.name
                          : context.l10n.organizerReviewUserFallback,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HbColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (createdLabel.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          createdLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _StarRow(rating: review.rating),
            ],
          ),
          const SizedBox(height: 10),
          if (review.title != null && review.title!.isNotEmpty) ...[
            Text(
              review.title!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (review.comment.isNotEmpty)
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
          if (eventTitle != null && eventTitle.isNotEmpty) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: eventTarget == null
                  ? null
                  : () => context.push('/event/$eventTarget'),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    children: [
                      TextSpan(text: '${context.l10n.organizerReviewFor} '),
                      TextSpan(
                        text: eventTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: HbColors.brandPrimary,
                          decoration: TextDecoration.underline,
                          decorationColor: HbColors.brandPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (isVerified || helpful > 0) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (isVerified) const _VerifiedChip(),
                if (helpful > 0) _HelpfulChip(count: helpful),
              ],
            ),
          ],
          if (showOrganizerReply) ...[
            const SizedBox(height: 12),
            _OrganizerReplyCard(
              text: review.organizerResponse ?? review.response?.response ?? '',
              author: review.response?.author?.name ??
                  review.response?.organization?.name ??
                  '',
              createdLabel: review.response?.createdAtFormatted ??
                  review.response?.createdAtFormattedCamel ??
                  '',
            ),
          ],
        ],
      ),
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  final ReviewAuthorDto? author;

  const _AuthorAvatar({required this.author});

  @override
  Widget build(BuildContext context) {
    final initials = author?.initials ?? '';
    final url = author?.avatar;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HbColors.brandPrimary.withValues(alpha: 0.12),
      ),
      clipBehavior: Clip.antiAlias,
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _initials(initials),
            )
          : _initials(initials),
    );
  }

  Widget _initials(String text) => Center(
        child: Text(
          text.isEmpty ? '?' : text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: HbColors.brandPrimary,
          ),
        ),
      );
}

class _StarRow extends StatelessWidget {
  final int rating;

  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 16,
            color: HbColors.brandPrimary,
          ),
      ],
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 13, color: Colors.green.shade700),
          const SizedBox(width: 4),
          Text(
            context.l10n.organizerVerifiedPurchase,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpfulChip extends StatelessWidget {
  final int count;

  const _HelpfulChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.thumb_up_alt_outlined, size: 13, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            context.l10n.organizerHelpfulCount(count),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganizerReplyCard extends StatelessWidget {
  final String text;
  final String author;
  final String createdLabel;

  const _OrganizerReplyCard({
    required this.text,
    required this.author,
    required this.createdLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.06),
        border: const Border(
          left: BorderSide(color: HbColors.brandPrimary, width: 3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reply, size: 14, color: HbColors.brandPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  author.isNotEmpty
                      ? context.l10n.organizerReplyBy(author)
                      : context.l10n.organizerReplyFallback,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: HbColors.brandPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (createdLabel.isNotEmpty)
                Text(
                  createdLabel,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
