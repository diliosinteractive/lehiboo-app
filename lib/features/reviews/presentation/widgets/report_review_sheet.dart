import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/review_enums.dart';
import '../providers/reviews_actions_provider.dart';

/// Modal pour signaler un avis inapproprié (cf. spec §2.8).
class ReportReviewSheet extends ConsumerStatefulWidget {
  final String reviewUuid;

  const ReportReviewSheet({super.key, required this.reviewUuid});

  static Future<bool> show(
    BuildContext context, {
    required String reviewUuid,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReportReviewSheet(reviewUuid: reviewUuid),
    );
    return result ?? false;
  }

  @override
  ConsumerState<ReportReviewSheet> createState() => _ReportReviewSheetState();
}

class _ReportReviewSheetState extends ConsumerState<ReportReviewSheet> {
  ReportReason _selectedReason = ReportReason.spam;
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;
  String? _serverError;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _serverError = null;
    });

    final details = _detailsController.text.trim();
    final result = await ref.read(reviewsActionsProvider.notifier).reportReview(
          reviewUuid: widget.reviewUuid,
          reason: _selectedReason,
          details: details.isEmpty ? null : details,
        );

    if (!mounted) return;

    switch (result) {
      case ReviewActionSuccess():
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.reviewsReportSuccess),
            backgroundColor: Colors.green,
          ),
        );
      case ReviewActionFailure(message: final msg):
        setState(() {
          _isSubmitting = false;
          _serverError = msg;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.reviewsReportTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.reviewsReportReasonQuestion,
                  style: const TextStyle(
                    fontSize: 14,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                RadioGroup<ReportReason>(
                  groupValue: _selectedReason,
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedReason = v);
                  },
                  child: Column(
                    children: ReportReason.values.map((reason) {
                      return RadioListTile<ReportReason>(
                        title: Text(_reportReasonLabel(context, reason)),
                        value: reason,
                        activeColor: HbColors.brandPrimary,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: context.l10n.reviewsReportDetailsOptionalLabel,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_serverError != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _serverError!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HbColors.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            context.l10n.reviewsReportSubmitAction,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _reportReasonLabel(BuildContext context, ReportReason reason) {
    switch (reason) {
      case ReportReason.spam:
        return context.l10n.reviewsReportReasonSpam;
      case ReportReason.inappropriate:
        return context.l10n.reviewsReportReasonInappropriate;
      case ReportReason.fake:
        return context.l10n.reviewsReportReasonFake;
      case ReportReason.offensive:
        return context.l10n.reviewsReportReasonOffensive;
      case ReportReason.other:
        return context.l10n.reviewsReportReasonOther;
    }
  }
}
