import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/services/crash_reporter.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/domain/extensions/user_participant_extension.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/booking/domain/models/refund_policy.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_list_controller.dart';
import 'package:lehiboo/features/booking/presentation/providers/order_cart_provider.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';
import 'package:lehiboo/features/booking/presentation/utils/order_checkout_error_mapper.dart';
import 'package:lehiboo/features/booking/presentation/widgets/cart_summary_section.dart';
import 'package:lehiboo/features/booking/presentation/widgets/participant_form_card.dart';
import 'package:lehiboo/features/booking/presentation/widgets/participants_overview_block.dart';
import 'package:lehiboo/features/booking/presentation/widgets/saved_participant_picker_sheet.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';
import 'package:lehiboo/features/profile/presentation/providers/saved_participants_provider.dart';
import 'package:lehiboo/shared/legal/legal_links.dart';

class OrderCartScreen extends ConsumerStatefulWidget {
  const OrderCartScreen({super.key});

  @override
  ConsumerState<OrderCartScreen> createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends ConsumerState<OrderCartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _townController = TextEditingController();

  String? _customerBirthDate;
  final Map<String, List<ParticipantInfo>> _attendeesByCartItemId = {};
  bool _acceptedTerms = false;
  bool _acceptedRefundPolicy = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _confirmationOutcomeUncertain = false;
  String? _activeOrderUuid;
  DateTime? _activeOrderExpiresAt;
  Duration? _reservationRemaining;
  Timer? _reservationTimer;
  Duration? _cartHoldRemaining;
  Timer? _cartHoldTimer;
  late final String? _ownerSessionUserId;
  bool _ownsCurrentSession = false;

  bool get _isCurrentAccount {
    return mounted &&
        _ownsCurrentSession &&
        _ownerSessionUserId != null &&
        ref.read(authSessionUserIdProvider) == _ownerSessionUserId;
  }

  @override
  void initState() {
    super.initState();
    _ownerSessionUserId = ref.read(authSessionUserIdProvider);
    _ownsCurrentSession = _ownerSessionUserId != null;
    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (!mounted || next == _ownerSessionUserId) return;
      _reservationTimer?.cancel();
      _cartHoldTimer?.cancel();
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _ageController.clear();
      _townController.clear();
      _attendeesByCartItemId.clear();
      setState(() {
        _ownsCurrentSession = false;
        _customerBirthDate = null;
        _acceptedTerms = false;
        _acceptedRefundPolicy = false;
        _isLoading = false;
        _errorMessage = null;
        _confirmationOutcomeUncertain = false;
        _activeOrderUuid = null;
        _activeOrderExpiresAt = null;
        _reservationRemaining = null;
        _cartHoldRemaining = null;
      });
    });
    _prefillForm();
    // Defer past the current frame: _updateCartHoldRemaining may clear the
    // cart provider when a stale hold has expired, and Riverpod forbids
    // mutating providers during widget mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isCurrentAccount) return;
      _updateCartHoldRemaining();
    });
    _cartHoldTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCartHoldRemaining(),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _townController.dispose();
    _reservationTimer?.cancel();
    _cartHoldTimer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Buyer form prefill from logged-in user

  void _prefillForm() {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    var firstName = user.firstName ?? '';
    var lastName = user.lastName ?? '';
    if (firstName.isEmpty && lastName.isEmpty && user.displayName.isNotEmpty) {
      final parts = user.displayName.trim().split(' ');
      firstName = parts.isNotEmpty ? parts.first : '';
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';

    if (user.birthDate != null) {
      final birthDate = user.birthDate!.toIso8601String().substring(0, 10);
      _customerBirthDate = birthDate;
      final age = computeAge(birthDate);
      if (age != null) _ageController.text = age.toString();
    }
    if (user.membershipCity != null && user.membershipCity!.isNotEmpty) {
      _townController.text = user.membershipCity!;
    }
  }

  // ---------------------------------------------------------------------------
  // Timers

  void _startReservationTimer(String? expiresAt) {
    _reservationTimer?.cancel();
    _activeOrderExpiresAt =
        expiresAt == null ? null : DateTime.tryParse(expiresAt)?.toLocal();

    if (_activeOrderExpiresAt == null) {
      _reservationRemaining = null;
      return;
    }

    _updateReservationRemaining();
    _reservationTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateReservationRemaining(),
    );
  }

  void _updateReservationRemaining() {
    final expiresAt = _activeOrderExpiresAt;
    if (expiresAt == null || !_isCurrentAccount) return;

    final remaining = expiresAt.difference(DateTime.now());
    setState(() {
      _reservationRemaining = remaining.isNegative ? Duration.zero : remaining;
    });
  }

  void _clearReservationTimer() {
    _reservationTimer?.cancel();
    _reservationTimer = null;
    _activeOrderUuid = null;
    _activeOrderExpiresAt = null;
    _reservationRemaining = null;
  }

  void _updateCartHoldRemaining() {
    if (!_isCurrentAccount) return;

    final expiresAt = ref.read(orderCartHoldProvider);
    if (expiresAt == null) {
      setState(() => _cartHoldRemaining = null);
      return;
    }

    final remaining = expiresAt.difference(DateTime.now());
    final normalized = remaining.isNegative ? Duration.zero : remaining;

    if (normalized == Duration.zero &&
        _activeOrderUuid == null &&
        ref.read(orderCartProvider).isNotEmpty) {
      ref.read(orderCartProvider.notifier).clear();
      setState(() {
        _cartHoldRemaining = null;
        _errorMessage = context.l10n.bookingCartHoldExpired;
      });
      return;
    }

    setState(() {
      _cartHoldRemaining = normalized;
    });
  }

  String _formatRemaining(Duration remaining) {
    final totalSeconds = remaining.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _cancelActiveOrderIfNeeded(
    BookingApiDataSource dataSource,
  ) async {
    final orderUuid = _activeOrderUuid;
    if (orderUuid == null || orderUuid.isEmpty) return;

    try {
      await dataSource.cancelOrder(orderUuid: orderUuid);
    } catch (_) {
      // The server expiration job remains the fallback if this best-effort
      // release cannot complete from the device.
    } finally {
      _clearReservationTimer();
    }
  }

  // ---------------------------------------------------------------------------
  // Cart actions

  Future<void> _confirmClearCart() async {
    if (!_isCurrentAccount) return;
    final ownerAccountId = _ownerSessionUserId!;
    final ownerNotifier = ref.read(orderCartProvider.notifier);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AccountBoundRouteGuard<bool>(
        ownerAccountId: ownerAccountId,
        invalidResult: false,
        builder: (_) => AlertDialog(
          title: Text(context.l10n.bookingClearCartTitle),
          content: Text(context.l10n.bookingClearCartBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.commonCancel),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.bookingClear),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true &&
        _isCurrentAccount &&
        ref.read(authSessionUserIdProvider) == ownerAccountId &&
        identical(ref.read(orderCartProvider.notifier), ownerNotifier)) {
      ownerNotifier.clear();
    }
  }

  void _ensureAttendees(List<OrderCartItem> items) {
    final activeIds = items.map((item) => item.id).toSet();
    _attendeesByCartItemId.removeWhere((key, _) => !activeIds.contains(key));

    for (final item in items) {
      final current = _attendeesByCartItemId[item.id] ?? const [];
      if (current.length == item.quantity) continue;

      _attendeesByCartItemId[item.id] = List.generate(
        item.quantity,
        (index) =>
            index < current.length ? current[index] : const ParticipantInfo(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Participant prefill helpers

  void _updateAttendee(String itemId, int index, ParticipantInfo info) {
    setState(() {
      final next = <ParticipantInfo>[
        ...?_attendeesByCartItemId[itemId],
      ];
      if (index < next.length) {
        next[index] = info;
      }
      _attendeesByCartItemId[itemId] = next;
    });
  }

  void _fillAllFromProfile() {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    final profileInfo = user.toParticipantInfo();

    setState(() {
      for (final entry in _attendeesByCartItemId.entries) {
        final updated = <ParticipantInfo>[];
        for (final attendee in entry.value) {
          updated.add(attendee.isBlank
              ? profileInfo.copyWith(saveForLater: false)
              : attendee);
        }
        _attendeesByCartItemId[entry.key] = updated;
      }
    });
  }

  Future<void> _pickSavedForFirstEmpty(
    List<SavedParticipant> savedParticipants,
  ) async {
    if (!_isCurrentAccount) return;
    final ownerAccountId = _ownerSessionUserId!;
    final selected = await showSavedParticipantPickerSheet(
      context,
      ownerAccountId: ownerAccountId,
      participants: savedParticipants,
    );
    if (selected == null ||
        !_isCurrentAccount ||
        _ownerSessionUserId != ownerAccountId) {
      return;
    }

    // Find first blank slot across all items.
    for (final entry in _attendeesByCartItemId.entries) {
      for (var i = 0; i < entry.value.length; i++) {
        if (entry.value[i].isBlank) {
          final info = selected.toParticipantInfo();
          _updateAttendee(entry.key, i, info);
          return;
        }
      }
    }

    // No blank slot — replace the first one.
    if (_attendeesByCartItemId.isNotEmpty) {
      final firstEntry = _attendeesByCartItemId.entries.first;
      _updateAttendee(firstEntry.key, 0, selected.toParticipantInfo());
    }
  }

  void _goToCompleteProfile() {
    context.push('/profile/edit');
  }

  // ---------------------------------------------------------------------------
  // Build

  @override
  Widget build(BuildContext context) {
    if (!_ownsCurrentSession) {
      return const Scaffold(
        key: Key('order-cart-session-invalid'),
        body: SizedBox.shrink(),
      );
    }

    final items = ref.watch(orderCartProvider);
    final totalQuantity =
        items.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalAmount =
        items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    final refundPolicies = _refundPoliciesForItems(items);
    _ensureAttendees(items);

    final user = ref.watch(authProvider).user;
    final userParticipantInfo = user?.toParticipantInfo();
    final userIsComplete = userParticipantInfo?.isComplete ?? false;
    final savedParticipants =
        ref.watch(savedParticipantsProvider).valueOrNull ?? const [];

    final allAttendees =
        _attendeesByCartItemId.values.expand((e) => e).toList();
    final completedCount = allAttendees.where((a) => a.isComplete).length;
    final totalParticipants = allAttendees.length;

    final firstIncompleteIndex = allAttendees.indexWhere((a) => !a.isComplete);

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.l10n.bookingCartTitle),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
        actions: [
          if (_cartHoldRemaining != null && _activeOrderUuid == null)
            _CartTimerChip(
              label: context.l10n
                  .bookingCartHoldLabel(_formatRemaining(_cartHoldRemaining!)),
              onTap: _showCartHoldInfo,
            ),
          if (_activeOrderUuid != null && _reservationRemaining != null)
            _CartTimerChip(
              label: context.l10n.bookingPlacesHoldLabel(
                _formatRemaining(_reservationRemaining!),
              ),
              onTap: _showCartHoldInfo,
              highlight: true,
            ),
          if (items.isNotEmpty)
            TextButton(
              onPressed: _isLoading ? null : _confirmClearCart,
              child: Text(context.l10n.bookingClear),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: items.isEmpty
            ? _buildEmptyState()
            : SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CartSummarySection(
                      items: items,
                      onUpdateQuantity:
                          ref.read(orderCartProvider.notifier).updateQuantity,
                      onRemove: ref.read(orderCartProvider.notifier).remove,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.bookingParticipantsTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HbColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.bookingParticipantsInstruction,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    ParticipantsOverviewBlock(
                      completedCount: completedCount,
                      totalCount: totalParticipants,
                      savedParticipants: savedParticipants,
                      user: user,
                      userIsComplete: userIsComplete,
                      onFillFromProfile:
                          user != null ? _fillAllFromProfile : null,
                      onPickSavedParticipant: savedParticipants.isEmpty
                          ? null
                          : () => _pickSavedForFirstEmpty(savedParticipants),
                      onCompleteProfile:
                          user != null ? _goToCompleteProfile : null,
                    ),
                    const SizedBox(height: 16),
                    ..._buildParticipantCards(
                      items: items,
                      savedParticipants: savedParticipants,
                      firstIncompleteIndex: firstIncompleteIndex,
                    ),
                    const SizedBox(height: 16),
                    _buildBuyerForm(),
                    const SizedBox(height: 12),
                    _buildTermsSection(refundPolicies),
                    if (_errorMessage != null) _buildError(),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _buildConfirmButton(
              totalQuantity: totalQuantity, totalAmount: totalAmount),
    );
  }

  void _showCartHoldInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.bookingCartHoldTitle),
        content: Text(context.l10n.bookingCartHoldBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.bookingUnderstood),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: HbColors.brandPrimary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.bookingEmptyCartTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.bookingEmptyCartBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/explore'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
              ),
              child: Text(context.l10n.bookingExploreEvents),
            ),
          ],
        ),
      ),
    );
  }

  BuyerInfo get _currentBuyerInfo => BuyerInfo(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        birthDate: _customerBirthDate,
        town: _townController.text.trim(),
      );

  List<Widget> _buildParticipantCards({
    required List<OrderCartItem> items,
    required List<SavedParticipant> savedParticipants,
    required int firstIncompleteIndex,
  }) {
    final cards = <Widget>[];
    var globalIndex = 0;

    for (final item in items) {
      final attendees = _attendeesByCartItemId[item.id] ?? const [];
      for (var i = 0; i < item.quantity; i++) {
        final initial =
            i < attendees.length ? attendees[i] : const ParticipantInfo();
        final cardIndex = globalIndex;

        cards.add(
          ParticipantFormCard(
            key: ValueKey('${item.id}-$i'),
            ownerAccountId: _ownerSessionUserId!,
            ticketTypeName: item.ticket.name,
            participantIndex: cardIndex + 1,
            totalForType: item.quantity,
            buyerInfo: _currentBuyerInfo,
            initialValue: initial,
            savedParticipants: savedParticipants,
            eventTitle: item.event.title,
            slotLabel: context.bookingCartItemSlotLabel(item),
            initiallyExpanded: cardIndex == firstIncompleteIndex,
            onChanged: (info) => _updateAttendee(item.id, i, info),
          ),
        );

        globalIndex++;
      }
    }

    return cards;
  }

  Widget _buildBuyerForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.bookingContactDetailsTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.bookingContactDetailsSubtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(builder: (context, constraints) {
              final fieldWidth = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: _inputDecoration(
                          context.l10n.bookingFirstNameLabelRequired),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? context.l10n.bookingFirstNameRequired
                              : null,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: _inputDecoration(
                          context.l10n.bookingLastNameLabelRequired),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? context.l10n.bookingLastNameRequired
                              : null,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration:
                  _inputDecoration(context.l10n.bookingEmailLabelRequired),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.bookingEmailRequired;
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return context.l10n.bookingEmailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            LayoutBuilder(builder: (context, constraints) {
              final fieldWidth = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: _phoneController,
                      decoration:
                          _inputDecoration(context.l10n.bookingPhoneLabel),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: _townController,
                      decoration: _inputDecoration(
                          context.l10n.bookingMembershipCityLabel),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(List<RefundPolicyEntry> refundPolicies) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (refundPolicies.isNotEmpty) ...[
            _buildRefundPolicyAcceptance(refundPolicies),
            const Divider(height: 22),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptedTerms,
                activeColor: HbColors.brandPrimary,
                onChanged: (value) =>
                    setState(() => _acceptedTerms = value ?? false),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                  child: RichText(
                    text: TextSpan(
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      children: [
                        TextSpan(text: context.l10n.bookingTermsPrefix),
                        TextSpan(
                          text: context.l10n.legalSales.toLowerCase(),
                          style: const TextStyle(
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                LegalLinks.open(context, LegalDocument.sales),
                        ),
                        TextSpan(text: context.l10n.bookingTermsConnector),
                        TextSpan(
                          text: context.l10n.legalPrivacy.toLowerCase(),
                          style: const TextStyle(
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => LegalLinks.open(
                                  context,
                                  LegalDocument.privacy,
                                ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefundPolicyAcceptance(
    List<RefundPolicyEntry> refundPolicies,
  ) {
    final hasMultiple = refundPolicies.length > 1;
    final prefix = hasMultiple
        ? context.l10n.bookingRefundPoliciesAcceptancePrefix
        : context.l10n.bookingRefundPolicyAcceptancePrefix;
    final linkText = hasMultiple
        ? context.l10n.bookingRefundPoliciesAcceptanceLink
        : context.l10n.bookingRefundPolicyAcceptanceLink;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptedRefundPolicy,
          activeColor: HbColors.brandPrimary,
          onChanged: (value) =>
              setState(() => _acceptedRefundPolicy = value ?? false),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(
              () => _acceptedRefundPolicy = !_acceptedRefundPolicy,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                children: [
                  TextSpan(text: prefix),
                  TextSpan(
                    text: linkText,
                    style: const TextStyle(
                      color: HbColors.brandPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _openRefundPolicies(refundPolicies),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                  if (_confirmationOutcomeUncertain)
                    TextButton(
                      onPressed: () => context.go('/my-bookings'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(top: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(context.l10n.bookingViewMyBookings),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton({
    required int totalQuantity,
    required double totalAmount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      totalAmount == 0
                          ? context.l10n.commonFree
                          : _formatPrice(totalAmount),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: HbColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.l10n.bookingTicketsCount(totalQuantity),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading || _confirmationOutcomeUncertain
                    ? null
                    : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(totalAmount == 0 ? Icons.check : Icons.lock,
                              size: 18),
                          const SizedBox(width: 8),
                          Text(totalAmount == 0
                              ? context.l10n.bookingConfirm
                              : context.l10n.bookingContinueToPayment),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Submit

  Future<void> _submitOrder() async {
    if (!_isCurrentAccount) return;
    final ownerAccountId = _ownerSessionUserId!;
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) return;

    final cartItems = ref.read(orderCartProvider);
    if (cartItems.isEmpty) return;

    final refundPolicies = _refundPoliciesForItems(cartItems);
    if (refundPolicies.isNotEmpty && !_acceptedRefundPolicy) {
      setState(() {
        _errorMessage = refundPolicies.length > 1
            ? context.l10n.bookingRefundPoliciesRequired
            : context.l10n.bookingRefundPolicyRequired;
      });
      return;
    }

    if (!_acceptedTerms) {
      setState(() {
        _errorMessage = context.l10n.bookingAcceptSalesRequired;
      });
      return;
    }

    if (!_validateParticipants(cartItems)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _confirmationOutcomeUncertain = false;
    });

    final dataSource = ref.read(bookingApiDataSourceProvider);
    var shouldCancelOrderOnError = false;
    var paymentWasCompleted = false;
    // Suit l'étape en cours pour que Crashlytics indique précisément où le
    // checkout a cassé (création commande / paiement / confirmation).
    var checkoutStep = 'create_order';

    try {
      final order = await dataSource.createOrder(
        items: _buildOrderItemsPayload(cartItems),
        customerEmail: _emailController.text.trim(),
        customerFirstName: _firstNameController.text.trim(),
        customerLastName: _lastNameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerBirthDate: _customerBirthDate,
        customerTown: _townController.text.trim().isEmpty
            ? null
            : _townController.text.trim(),
        acceptRefundPolicy: _acceptedRefundPolicy,
      );
      if (!_isCurrentAccount) return;

      var confirmedOrder = order;
      _activeOrderUuid = order.uuid;
      ref
          .read(orderCartHoldProvider.notifier)
          .syncServerExpiration(order.expiresAt);
      _startReservationTimer(order.expiresAt);

      if (order.totalAmount > 0) {
        shouldCancelOrderOnError = true;
        checkoutStep = 'payment_intent';
        final paymentIntent =
            await dataSource.getOrderPaymentIntent(orderUuid: order.uuid);
        if (!_isCurrentAccount) return;

        checkoutStep = 'init_payment_sheet';
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent.clientSecret,
            merchantDisplayName: 'Le Hiboo',
          ),
        );
        if (!_isCurrentAccount) return;

        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!_isCurrentAccount) return;
        await WidgetsBinding.instance.endOfFrame;
        if (!_isCurrentAccount) return;

        checkoutStep = 'present_payment_sheet';
        if (!mounted) {
          throw StateError(
            'Payment screen closed before Stripe sheet presentation.',
          );
        }

        await Stripe.instance.presentPaymentSheet();
        paymentWasCompleted = true;
        if (!_isCurrentAccount) return;

        shouldCancelOrderOnError = false;
        checkoutStep = 'confirm_order';
        confirmedOrder = await dataSource.confirmOrder(
          orderUuid: order.uuid,
          paymentIntentId: paymentIntent.paymentIntentId,
        );
        if (!_isCurrentAccount) return;
      }

      // Best-effort: persist any participant the user marked "Save to Mes participants".
      // Failures here must not block the booking confirmation.
      final persistedParticipants =
          await _persistFlaggedParticipants(ownerAccountId);
      if (!persistedParticipants || !_isCurrentAccount) return;

      // Capture the cart contents BEFORE clearing — we need them below to
      // invalidate per-event caches so "spots remaining" reflects the seats
      // we just consumed when the user navigates back to the event detail.
      final bookedItems = ref.read(orderCartProvider);
      if (!_isCurrentAccount) return;

      _clearReservationTimer();
      ref.read(orderCartProvider.notifier).clear();
      ref.invalidate(bookingsListControllerProvider);
      _invalidateBookedEventsCache(bookedItems);
      HapticFeedback.heavyImpact();

      if (_isCurrentAccount) {
        if (!mounted) return;
        context.go('/order-confirmation/${confirmedOrder.uuid}', extra: {
          'ownerAccountId': ownerAccountId,
          'order': confirmedOrder,
        });
      }
    } on StripeException catch (e, stack) {
      if (!_isCurrentAccount) return;
      await _cancelActiveOrderIfNeeded(dataSource);
      if (!_isCurrentAccount) return;

      // L'annulation par l'utilisateur (fermeture de la payment sheet) est
      // attendue — inutile de polluer Crashlytics. Tout le reste (carte
      // refusée, échec de config Stripe, etc.) est remonté.
      if (e.error.code != FailureCode.Canceled) {
        await CrashReporter.recordError(
          e,
          stack,
          reason: 'Stripe payment failed',
          context: {
            'step': checkoutStep,
            'order_uuid': _activeOrderUuid,
            'stripe_code': e.error.code.name,
            'stripe_message': e.error.message,
          },
        );
      }

      if (!_isCurrentAccount) return;
      setState(() {
        _isLoading = false;
        _confirmationOutcomeUncertain = false;
        _errorMessage =
            OrderCheckoutErrorMapper.stripeUserMessage(e, context.l10n);
      });
    } catch (e, stack) {
      if (!_isCurrentAccount) return;
      if (shouldCancelOrderOnError) {
        await _cancelActiveOrderIfNeeded(dataSource);
      } else {
        _clearReservationTimer();
      }
      if (!_isCurrentAccount) return;

      final isExpectedValidation =
          OrderCheckoutErrorMapper.isExpectedValidation(e);

      // Availability conflicts are a normal checkout race: refresh the event
      // caches so returning to its detail page fetches current ticket flags.
      if (isExpectedValidation) {
        _invalidateBookedEventsCache(cartItems);
        if (kDebugMode) {
          debugPrint(
            'Order checkout validation failed at $checkoutStep: '
            '${e is DioException ? e.response?.data : e}',
          );
        }
      } else {
        await CrashReporter.recordError(
          e,
          stack,
          reason: 'Order checkout failed',
          context: {
            'step': checkoutStep,
            'order_uuid': _activeOrderUuid,
          },
        );
      }

      if (!_isCurrentAccount) return;
      final confirmationOutcomeUncertain = paymentWasCompleted &&
          OrderCheckoutErrorMapper.isConfirmationOutcomeUncertain(e);
      setState(() {
        _isLoading = false;
        _confirmationOutcomeUncertain = confirmationOutcomeUncertain;
        // Raw response bodies belong in logs, never in user-facing UI.
        _errorMessage = OrderCheckoutErrorMapper.userMessage(
          e,
          context.l10n,
          paymentWasCompleted: paymentWasCompleted,
        );
      });
    }
  }

  Future<bool> _persistFlaggedParticipants(String ownerAccountId) async {
    if (!_isCurrentAccount || _ownerSessionUserId != ownerAccountId) {
      return false;
    }
    final actions = ref.read(savedParticipantsActionsProvider);
    final flagged = _attendeesByCartItemId.values
        .expand((list) => list)
        .where((p) => p.saveForLater && p.isComplete)
        .toList();

    if (flagged.isEmpty) return true;

    for (final attendee in flagged) {
      if (!_isCurrentAccount || _ownerSessionUserId != ownerAccountId) {
        return false;
      }
      try {
        final draft = SavedParticipant(
          uuid: '',
          relationship: attendee.relationship,
          displayName:
              '${attendee.firstName ?? ''} ${attendee.lastName ?? ''}'.trim(),
          firstName: attendee.firstName ?? '',
          lastName: attendee.lastName ?? '',
          email: attendee.email,
          phone: attendee.phone,
          birthDate: attendee.birthDate,
          membershipCity: attendee.membershipCity ?? attendee.city,
        );
        await actions.create(draft);
      } catch (_) {
        // Silent — user can retry from /profile/mes-participants.
      }
      if (!_isCurrentAccount || _ownerSessionUserId != ownerAccountId) {
        return false;
      }
    }
    return true;
  }

  /// Refresh every event-level cache for the events the user just paid for,
  /// so the next visit to an event detail screen shows the post-booking
  /// "spots remaining" instead of the pre-booking number still sitting in
  /// Riverpod's family caches.
  ///
  /// Lives here (not in OrderSuccessScreen) because the cart is the only
  /// place that holds the full [Event] entity per line — including both the
  /// UUID (`event.id`) and the slug. The event detail route accepts either
  /// as the path param, so the family cache may be keyed by slug for users
  /// who arrived via a deep link / story / question card. Invalidating only
  /// the UUID key would leave those slug-keyed entries stale.
  void _invalidateBookedEventsCache(List<OrderCartItem> bookedItems) {
    final owner = ref.read(authSessionKeyProvider);
    final seenIds = <String>{};
    for (final item in bookedItems) {
      final event = item.event;
      if (!seenIds.add(event.id)) continue;

      ref.invalidate(
        eventAvailabilityProvider(eventAvailabilityRequest(owner, event.id)),
      );
      ref.invalidate(
        eventDetailControllerProvider(eventDetailRequest(owner, event.id)),
      );

      final slug = event.slug;
      if (slug.isNotEmpty && slug != event.id) {
        ref.invalidate(
          eventDetailControllerProvider(eventDetailRequest(owner, slug)),
        );
      }
    }
  }

  List<RefundPolicyEntry> _refundPoliciesForItems(List<OrderCartItem> items) {
    final entries = <RefundPolicyEntry>[];
    final seenEventIds = <String>{};

    for (final item in items) {
      if (!seenEventIds.add(item.event.id)) continue;

      final policy = item.event.vendorCancellationPolicy?.trim();
      if (policy == null || policy.isEmpty) continue;

      entries.add(
        RefundPolicyEntry(
          eventTitle: item.event.title,
          policy: policy,
        ),
      );
    }

    return entries;
  }

  void _openRefundPolicies(List<RefundPolicyEntry> refundPolicies) {
    if (refundPolicies.isEmpty || !_isCurrentAccount) return;

    context.push(
      '/refund-policy',
      extra: RefundPolicyRouteArgs(
        ownerAccountId: _ownerSessionUserId,
        title: refundPolicies.length > 1
            ? context.l10n.refundPolicyListTitle
            : context.l10n.refundPolicyTitle,
        policies: refundPolicies,
      ),
    );
  }

  bool _validateParticipants(List<OrderCartItem> cartItems) {
    for (final item in cartItems) {
      final attendees = _attendeesByCartItemId[item.id] ?? [];
      if (attendees.length != item.quantity) {
        setState(() {
          _errorMessage = context.l10n.bookingEveryTicketNeedsParticipant;
        });
        return false;
      }

      for (final attendee in attendees) {
        if (!attendee.isComplete) {
          setState(() {
            _errorMessage = context.l10n.bookingParticipantsMissingCartDetails;
          });
          return false;
        }
      }
    }
    return true;
  }

  List<Map<String, dynamic>> _buildOrderItemsPayload(
    List<OrderCartItem> cartItems,
  ) {
    return cartItems
        .map((item) => {
              'event_id': item.event.id,
              'slot_id': item.slotId,
              'ticket_type_id': item.ticket.id,
              'quantity': item.quantity,
              'attendees': (_attendeesByCartItemId[item.id] ?? [])
                  .map((attendee) => {
                        'first_name': attendee.firstName ?? '',
                        'last_name': attendee.lastName ?? '',
                        'relationship': attendee.relationship ?? '',
                        if ((attendee.email ?? '').isNotEmpty)
                          'email': attendee.email,
                        if ((attendee.phone ?? '').isNotEmpty)
                          'phone': attendee.phone,
                        'birth_date': attendee.birthDate ?? '',
                        if (attendee.age != null) 'age': attendee.age,
                        'membership_city':
                            attendee.membershipCity ?? attendee.city ?? '',
                      })
                  .toList(),
            })
        .toList();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      isDense: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: HbColors.brandPrimary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  String _formatPrice(double price) {
    return context.appCalculatedEuroAmount(price);
  }
}

class _CartTimerChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  const _CartTimerChip({
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = highlight ? Colors.white : HbColors.brandPrimary;
    final bg = highlight
        ? HbColors.brandPrimary
        : HbColors.brandPrimary.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: HbColors.brandPrimary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 14, color: fg),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
