import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_list_controller.dart';
import 'package:lehiboo/features/booking/presentation/providers/order_cart_provider.dart';
import 'package:lehiboo/features/booking/presentation/widgets/participant_form_card.dart';
import 'package:lehiboo/features/profile/presentation/providers/saved_participants_provider.dart';

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
  bool _isLoading = false;
  String? _errorMessage;
  String? _activeOrderUuid;
  DateTime? _activeOrderExpiresAt;
  Duration? _reservationRemaining;
  Timer? _reservationTimer;
  Duration? _cartHoldRemaining;
  Timer? _cartHoldTimer;

  @override
  void initState() {
    super.initState();
    _prefillForm();
    _updateCartHoldRemaining();
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
    if (expiresAt == null || !mounted) return;

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
    if (!mounted) return;

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
        _errorMessage =
            'Le délai du panier est dépassé. Ajoutez à nouveau vos billets pour continuer.';
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

  Future<void> _confirmClearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Vider le panier ?'),
        content: const Text(
          'Tous les billets ajoutes seront supprimes. Cette action est irreversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Vider'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(orderCartProvider.notifier).clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(orderCartProvider);
    final totalQuantity =
        items.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalAmount =
        items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    _ensureAttendees(items);

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: _isLoading ? null : _confirmClearCart,
              child: const Text('Vider'),
            ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimerNotice(),
                  const SizedBox(height: 16),
                  _buildCartSummary(items),
                  const SizedBox(height: 16),
                  _buildBuyerForm(),
                  const SizedBox(height: 16),
                  _buildParticipantsSection(items),
                  const SizedBox(height: 16),
                  _buildTermsSection(),
                  if (_errorMessage != null) _buildError(),
                ],
              ),
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _buildConfirmButton(
              totalQuantity: totalQuantity, totalAmount: totalAmount),
    );
  }

  Widget _buildTimerNotice() {
    final reservationRemaining = _reservationRemaining;
    if (_activeOrderUuid != null && reservationRemaining != null) {
      return _buildNotice(
        icon: Icons.timer_outlined,
        title: 'Places réservées',
        message:
            'Vos places sont bloquées encore ${_formatRemaining(reservationRemaining)}. Passé ce délai, elles seront libérées.',
      );
    }

    final cartHoldRemaining = _cartHoldRemaining;
    if (cartHoldRemaining == null) {
      return const SizedBox.shrink();
    }

    return _buildNotice(
      icon: Icons.shopping_bag_outlined,
      title: 'Panier conservé',
      message:
          'Votre sélection est conservée encore ${_formatRemaining(cartHoldRemaining)}. Les places seront bloquées à l\'étape paiement.',
    );
  }

  Widget _buildNotice({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD7AA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: HbColors.brandPrimary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.brown.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            const Text(
              'Votre panier est vide',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des billets depuis une fiche evenement pour payer plusieurs reservations en une fois.',
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
              child: const Text('Explorer les evenements'),
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

  Widget _buildParticipantsSection(List<OrderCartItem> items) {
    final savedParticipants =
        ref.watch(savedParticipantsProvider).valueOrNull ?? const [];

    var firstGlobal = true;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Participants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choisissez une personne enregistree ou renseignez chaque billet.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: HbColors.brandPrimary.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  size: 18,
                  color: HbColors.brandPrimary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Le prénom, la date de naissance, la ville et la relation aident l\'IA et l\'expérience Le Hiboo à proposer les offres et événements les plus pertinents.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final item in items)
            for (int i = 0; i < item.quantity; i++)
              Builder(
                builder: (context) {
                  final showSameAsBuyer = firstGlobal;
                  firstGlobal = false;
                  final attendees = _attendeesByCartItemId[item.id] ?? [];
                  final initial = i < attendees.length
                      ? attendees[i]
                      : const ParticipantInfo();

                  return ParticipantFormCard(
                    ticketTypeName: '${item.event.title} — ${item.ticket.name}',
                    participantIndex: i + 1,
                    totalForType: item.quantity,
                    showSameAsBuyer: showSameAsBuyer,
                    buyerInfo: _currentBuyerInfo,
                    initialValue: initial,
                    savedParticipants: savedParticipants,
                    onChanged: (info) {
                      setState(() {
                        final next = <ParticipantInfo>[
                          ...?_attendeesByCartItemId[item.id],
                        ];
                        if (i < next.length) {
                          next[i] = info;
                        }
                        _attendeesByCartItemId[item.id] = next;
                      });
                    },
                  );
                },
              ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(List<OrderCartItem> items) {
    final grouped = <String, List<OrderCartItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.event.organizerName, () => []).add(item);
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billets sélectionnés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...grouped.entries.map((vendorEntry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendorEntry.key.isEmpty ? 'Organisateur' : vendorEntry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...vendorEntry.value.map(_buildCartLine),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCartLine(OrderCartItem item) {
    final notifier = ref.read(orderCartProvider.notifier);
    final slotLabel = _formatSlot(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.event.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (slotLabel != null) ...[
            const SizedBox(height: 4),
            Text(slotLabel, style: TextStyle(color: Colors.grey.shade600)),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.ticket.name,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    notifier.updateQuantity(item.id, item.quantity - 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                item.quantity.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    notifier.updateQuantity(item.id, item.quantity + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => notifier.remove(item.id),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _formatPrice(item.lineTotal),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: HbColors.brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerForm() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vos coordonnees',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              decoration: _inputDecoration('Prenom *'),
              textCapitalization: TextCapitalization.words,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Le prenom est requis'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: _inputDecoration('Nom *'),
              textCapitalization: TextCapitalization.words,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Le nom est requis'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email *'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'L email est requis';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('Telephone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ageController,
              decoration: _inputDecoration('Age'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final age = int.tryParse(value);
                if (age != null && age >= 1 && age < 150) {
                  _customerBirthDate = ageToBirthDate(age);
                } else if (value.isEmpty) {
                  _customerBirthDate = null;
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _townController,
              decoration: _inputDecoration('Ville d appartenance'),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _acceptedTerms,
            activeColor: HbColors.brandPrimary,
            onChanged: (value) =>
                setState(() => _acceptedTerms = value ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
              child: Text(
                'J accepte les conditions generales de vente et la politique de confidentialite.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
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
                      totalAmount == 0 ? 'Gratuit' : _formatPrice(totalAmount),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: HbColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$totalQuantity billet${totalQuantity > 1 ? 's' : ''}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    if (_reservationRemaining != null && _isLoading) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: HbColors.brandPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Places réservées ${_formatRemaining(_reservationRemaining!)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: HbColors.brandPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitOrder,
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
                          Text(totalAmount == 0 ? 'Confirmer' : 'Payer'),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      setState(() {
        _errorMessage = 'Veuillez accepter les conditions generales de vente';
      });
      return;
    }

    final cartItems = ref.read(orderCartProvider);
    if (cartItems.isEmpty) return;
    if (!_validateParticipants(cartItems)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final dataSource = ref.read(bookingApiDataSourceProvider);
    var shouldCancelOrderOnError = false;

    try {
      final cartHoldExpiresAt = ref.read(orderCartHoldProvider);
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
        expiresAt: cartHoldExpiresAt?.toUtc().toIso8601String(),
      );

      var confirmedOrder = order;
      _activeOrderUuid = order.uuid;
      ref
          .read(orderCartHoldProvider.notifier)
          .syncServerExpiration(order.expiresAt);
      _startReservationTimer(order.expiresAt);

      if (order.totalAmount > 0) {
        shouldCancelOrderOnError = true;
        final paymentIntent =
            await dataSource.getOrderPaymentIntent(orderUuid: order.uuid);

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent.clientSecret,
            merchantDisplayName: 'Le Hiboo',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 500));

        final presentCompleter = Completer<void>();
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            await Stripe.instance.presentPaymentSheet();
            presentCompleter.complete();
          } catch (e) {
            presentCompleter.completeError(e);
          }
        });
        await presentCompleter.future;

        shouldCancelOrderOnError = false;
        confirmedOrder = await dataSource.confirmOrder(
          orderUuid: order.uuid,
          paymentIntentId: paymentIntent.paymentIntentId,
        );
      }

      _clearReservationTimer();
      ref.read(orderCartProvider.notifier).clear();
      ref.invalidate(bookingsListControllerProvider);
      HapticFeedback.heavyImpact();

      if (mounted) {
        context.go('/order-confirmation/${confirmedOrder.uuid}', extra: {
          'order': confirmedOrder,
        });
      }
    } on StripeException catch (e) {
      await _cancelActiveOrderIfNeeded(dataSource);

      setState(() {
        _isLoading = false;
        _errorMessage = e.error.localizedMessage ?? 'Paiement annule';
      });
    } catch (e) {
      if (shouldCancelOrderOnError) {
        await _cancelActiveOrderIfNeeded(dataSource);
      } else {
        _clearReservationTimer();
      }

      setState(() {
        _isLoading = false;
        _errorMessage = ApiResponseHandler.extractError(e);
      });
    }
  }

  bool _validateParticipants(List<OrderCartItem> cartItems) {
    for (final item in cartItems) {
      final attendees = _attendeesByCartItemId[item.id] ?? [];
      if (attendees.length != item.quantity) {
        setState(() {
          _errorMessage = 'Chaque billet doit avoir un participant renseigne';
        });
        return false;
      }

      for (final attendee in attendees) {
        if ((attendee.firstName ?? '').trim().isEmpty ||
            (attendee.relationship ?? '').trim().isEmpty ||
            (attendee.birthDate ?? '').trim().isEmpty ||
            (attendee.membershipCity ?? attendee.city ?? '').trim().isEmpty) {
          setState(() {
            _errorMessage =
                'Veuillez renseigner le prénom, la date de naissance, la ville et la relation de chaque participant';
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
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HbColors.brandPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  String? _formatSlot(OrderCartItem item) {
    final slot = item.selectedSlot;
    if (slot == null) return null;

    return [
      '${slot.date.day.toString().padLeft(2, '0')}/${slot.date.month.toString().padLeft(2, '0')}/${slot.date.year}',
      slot.startTime,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' - ');
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) return '${price.toInt()}€';
    return '${price.toStringAsFixed(2)}€';
  }
}
