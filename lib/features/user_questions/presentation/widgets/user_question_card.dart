import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../../events/domain/entities/event_question.dart';
import 'question_status_badge.dart';

class UserQuestionCard extends StatelessWidget {
  final EventQuestion question;

  const UserQuestionCard({super.key, required this.question});

  bool get _canNavigate {
    final event = question.event;
    return event != null && !event.isDeleted && event.slug.isNotEmpty;
  }

  void _onTap(BuildContext context) {
    if (!_canNavigate) return;
    context.push('/event/${question.event!.slug}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventTitle = question.event?.title.isNotEmpty == true
        ? question.event!.title
        : 'Événement supprimé';
    final isDeleted = question.event?.isDeleted == true;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _canNavigate ? () => _onTap(context) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          isDeleted
                              ? Icons.event_busy_outlined
                              : Icons.event_outlined,
                          size: 16,
                          color: isDeleted
                              ? Colors.grey[500]
                              : HbColors.brandSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            eventTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDeleted
                                  ? Colors.grey[500]
                                  : HbColors.textSlate,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  QuestionStatusBadge(status: question.status, compact: true),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                question.question,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: HbColors.textSlate,
                  height: 1.35,
                ),
              ),
              if (question.status == QuestionStatus.rejected) ...[
                const SizedBox(height: 10),
                _RejectedNotice(),
              ],
              if (question.hasAnswer) ...[
                const SizedBox(height: 12),
                _AnswerBlock(answer: question.answer!),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${question.helpfulCount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (question.createdAtFormatted.isNotEmpty)
                    Text(
                      question.createdAtFormatted,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerBlock extends StatelessWidget {
  final QuestionAnswer answer;

  const _AnswerBlock({required this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final org = answer.organizationName.isNotEmpty
        ? answer.organizationName
        : 'Organisateur';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HbColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HbColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (answer.isOfficial)
                const Icon(
                  Icons.verified,
                  size: 14,
                  color: HbColors.success,
                )
              else
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 14,
                  color: HbColors.brandSecondary,
                ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  org,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: HbColors.textSlate,
                  ),
                ),
              ),
              if (answer.createdAtFormatted.isNotEmpty)
                Text(
                  answer.createdAtFormatted,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            answer.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: HbColors.textSlate,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _RejectedNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: HbColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 14, color: HbColors.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Cette question a été rejetée par la modération.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: HbColors.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
