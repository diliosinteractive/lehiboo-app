import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';

/// Compact empty/error feedback used by asynchronous home sections.
///
/// Error messages are announced as live regions and retries are labelled,
/// awaitable, and protected against duplicate taps.
class HomeSectionFeedback extends StatefulWidget {
  final String message;
  final bool isError;
  final Future<void> Function()? onRetry;

  const HomeSectionFeedback({
    super.key,
    required this.message,
    this.isError = false,
    this.onRetry,
  });

  @override
  State<HomeSectionFeedback> createState() => _HomeSectionFeedbackState();
}

class _HomeSectionFeedbackState extends State<HomeSectionFeedback> {
  bool _isRetrying = false;

  Future<void> _retry() async {
    final onRetry = widget.onRetry;
    if (onRetry == null || _isRetrying) return;

    setState(() => _isRetrying = true);
    try {
      await onRetry();
    } catch (_) {
      // The owning AsyncValue renders the resulting error state.
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final foreground =
        widget.isError ? Colors.red.shade700 : Colors.grey.shade700;
    final background =
        widget.isError ? Colors.red.shade50 : Colors.grey.shade100;

    return Semantics(
      container: true,
      liveRegion: widget.isError,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.isError
                    ? Icons.error_outline_rounded
                    : Icons.event_busy_outlined,
                color: foreground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(color: foreground),
                ),
              ),
              if (widget.onRetry != null) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _isRetrying ? null : _retry,
                  icon: _isRetrying
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, size: 18),
                  label: Text(
                    _isRetrying ? l10n.commonLoading : l10n.commonRetry,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
