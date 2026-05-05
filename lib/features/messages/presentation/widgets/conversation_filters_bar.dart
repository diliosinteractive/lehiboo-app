import 'dart:async';
import 'package:flutter/material.dart';

class ConversationFiltersBar extends StatefulWidget {
  // Which rows to show
  final bool showSearch;
  final bool showStatus;
  final bool showPeriod;
  final bool showUnreadOnly;
  final bool showReason;

  // Current filter state
  final String? searchQuery;
  final String? statusFilter;
  final String? periodFilter;
  final bool unreadOnly;
  final String? reasonFilter;

  // Callbacks
  final ValueChanged<String?> onSearchChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPeriodChanged;
  final ValueChanged<bool> onUnreadOnlyChanged;
  final ValueChanged<String?> onReasonChanged;

  const ConversationFiltersBar({
    super.key,
    this.showSearch = true,
    this.showStatus = true,
    this.showPeriod = true,
    this.showUnreadOnly = true,
    this.showReason = false,
    this.searchQuery,
    this.statusFilter,
    this.periodFilter,
    this.unreadOnly = false,
    this.reasonFilter,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onPeriodChanged,
    required this.onUnreadOnlyChanged,
    required this.onReasonChanged,
  });

  @override
  State<ConversationFiltersBar> createState() => _ConversationFiltersBarState();
}

class _ConversationFiltersBarState extends State<ConversationFiltersBar> {
  late final TextEditingController _searchCtrl;
  Timer? _debounce;

  static const _primary = Color(0xFFFF601F);

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.searchQuery ?? '');
  }

  @override
  void didUpdateWidget(ConversationFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync external clear (e.g. "Tous" chip resets search)
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery != _searchCtrl.text) {
      _searchCtrl.text = widget.searchQuery ?? '';
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(value.trim().isEmpty ? null : value.trim());
    });
  }

  bool get _hasActiveFilter =>
      widget.unreadOnly ||
      widget.statusFilter != null ||
      widget.periodFilter != null ||
      widget.reasonFilter != null;

  @override
  Widget build(BuildContext context) {
    final hasChips = widget.showStatus ||
        widget.showPeriod ||
        widget.showUnreadOnly ||
        widget.showReason;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onTextChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          widget.onSearchChanged(null);
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: _primary),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
        if (hasChips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                if (_hasActiveFilter) ...[
                  _ResetChip(onTap: _resetAll),
                  const SizedBox(width: 6),
                ],
                if (widget.showUnreadOnly) ...[
                  _FilterChip(
                    label: 'Non lus',
                    selected: widget.unreadOnly,
                    onTap: () => widget.onUnreadOnlyChanged(!widget.unreadOnly),
                  ),
                  const SizedBox(width: 6),
                ],
                if (widget.showStatus) ...[
                  _FilterChip(
                    label: 'Ouverts',
                    selected: !widget.unreadOnly && widget.statusFilter == 'open',
                    onTap: () {
                      if (!widget.unreadOnly && widget.statusFilter == 'open') {
                        widget.onStatusChanged(null);
                      } else {
                        widget.onUnreadOnlyChanged(false);
                        widget.onStatusChanged('open');
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Fermés',
                    selected: !widget.unreadOnly && widget.statusFilter == 'closed',
                    onTap: () {
                      if (!widget.unreadOnly && widget.statusFilter == 'closed') {
                        widget.onStatusChanged(null);
                      } else {
                        widget.onUnreadOnlyChanged(false);
                        widget.onStatusChanged('closed');
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                ],
                if (widget.showPeriod) ...[
                  _FilterChip(
                    label: "Aujourd'hui",
                    selected: widget.periodFilter == 'today',
                    onTap: () => widget.onPeriodChanged(
                        widget.periodFilter == 'today' ? null : 'today'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Cette semaine',
                    selected: widget.periodFilter == 'week',
                    onTap: () => widget.onPeriodChanged(
                        widget.periodFilter == 'week' ? null : 'week'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Ce mois',
                    selected: widget.periodFilter == 'month',
                    onTap: () => widget.onPeriodChanged(
                        widget.periodFilter == 'month' ? null : 'month'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Plus ancien',
                    selected: widget.periodFilter == 'older',
                    onTap: () => widget.onPeriodChanged(
                        widget.periodFilter == 'older' ? null : 'older'),
                  ),
                  const SizedBox(width: 6),
                ],
                if (widget.showReason) ...[
                  _FilterChip(
                    label: 'Inapproprié',
                    selected: widget.reasonFilter == 'inappropriate',
                    onTap: () => widget.onReasonChanged(
                        widget.reasonFilter == 'inappropriate'
                            ? null
                            : 'inappropriate'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Harcèlement',
                    selected: widget.reasonFilter == 'harassment',
                    onTap: () => widget.onReasonChanged(
                        widget.reasonFilter == 'harassment'
                            ? null
                            : 'harassment'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Spam',
                    selected: widget.reasonFilter == 'spam',
                    onTap: () => widget.onReasonChanged(
                        widget.reasonFilter == 'spam' ? null : 'spam'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Autre',
                    selected: widget.reasonFilter == 'other',
                    onTap: () => widget.onReasonChanged(
                        widget.reasonFilter == 'other' ? null : 'other'),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  void _resetAll() {
    widget.onUnreadOnlyChanged(false);
    widget.onStatusChanged(null);
    widget.onPeriodChanged(null);
    widget.onReasonChanged(null);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _primary = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withValues(alpha: 0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _primary : Colors.grey.shade300,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? _primary : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ResetChip extends StatelessWidget {
  final VoidCallback onTap;

  const _ResetChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.close, size: 14, color: Colors.black54),
            SizedBox(width: 4),
            Text('Réinitialiser',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
