import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/themes/colors.dart';
import '../../../domain/entities/event_question.dart';

/// Card Q&A au design plat (avatar + nom/temps, question, bloc réponse,
/// bouton Utile). Match le design de la capture user.
class QuestionCard extends StatelessWidget {
  final EventQuestion question;

  /// Appelé au tap sur le bouton "Utile". L'auth gate doit être gérée en amont.
  final VoidCallback? onToggleHelpful;

  /// Affiche la question en entier (pas de truncation).
  final bool expanded;

  const QuestionCard({
    super.key,
    required this.question,
    this.onToggleHelpful,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: HbColors.grey200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AuthorRow(
            author: question.author,
            timeAgo: question.createdAtFormatted,
            isPinned: question.isPinned,
          ),
          const SizedBox(height: 10),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 15,
              color: HbColors.textPrimary,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
            maxLines: expanded ? null : 3,
            overflow: expanded ? null : TextOverflow.ellipsis,
          ),
          if (question.answer != null) ...[
            const SizedBox(height: 12),
            _AnswerBlock(answer: question.answer!),
          ],
          const SizedBox(height: 10),
          _HelpfulButton(
            count: question.helpfulCount,
            voted: question.userVoted,
            onTap: onToggleHelpful,
          ),
        ],
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final QuestionAuthor? author;
  final String timeAgo;
  final bool isPinned;

  const _AuthorRow({
    required this.author,
    required this.timeAgo,
    required this.isPinned,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(author: author),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  author?.name ?? context.l10n.eventAnonymous,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (timeAgo.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: HbColors.grey500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isPinned)
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.push_pin,
              size: 14,
              color: HbColors.brandPrimary,
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final QuestionAuthor? author;
  const _Avatar({required this.author});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = author?.avatarUrl;
    final initials = author?.initials ?? '';

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          placeholder: (_, __) => _fallback(initials),
          errorWidget: (_, __, ___) => _fallback(initials),
        ),
      );
    }

    return _fallback(initials);
  }

  Widget _fallback(String initials) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: HbColors.surfaceLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: initials.isNotEmpty
          ? Text(
              initials.toUpperCase(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: HbColors.textSecondary,
              ),
            )
          : const Icon(
              Icons.person_outline,
              size: 18,
              color: HbColors.grey500,
            ),
    );
  }
}

class _AnswerBlock extends StatelessWidget {
  final QuestionAnswer answer;
  const _AnswerBlock({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: HbColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HbColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (answer.isOfficial)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: HbColors.surfaceLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: HbColors.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.eventOfficialAnswer,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          if (answer.isOfficial) const SizedBox(height: 10),
          Text(
            answer.text,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
              height: 1.5,
            ),
          ),
          if (answer.organizationName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  answer.organizationName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textSecondary,
                  ),
                ),
                if (answer.createdAtFormatted.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '· ${answer.createdAtFormatted}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: HbColors.grey500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HelpfulButton extends StatelessWidget {
  final int count;
  final bool voted;
  final VoidCallback? onTap;

  const _HelpfulButton({
    required this.count,
    required this.voted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final color = voted ? HbColors.brandPrimary : HbColors.textSecondary;

    return InkWell(
      onTap: disabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap!();
            },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              voted ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              count > 0
                  ? context.l10n.eventHelpfulCount(count)
                  : context.l10n.eventHelpful,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
