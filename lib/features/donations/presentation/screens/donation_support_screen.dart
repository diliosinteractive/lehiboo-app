import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/utils/order_checkout_error_mapper.dart';
import '../../data/repositories/donations_repository_impl.dart';

/// Écran « Soutenir Le Hiboo » — don volontaire seul via Stripe PaymentSheet.
///
/// Flux (cf. docs/DONATIONS_SYSTEM.md §7.1) :
/// create (`POST /mobile/donations`) → PaymentSheet → confirm-payment.
class DonationSupportScreen extends ConsumerStatefulWidget {
  const DonationSupportScreen({super.key});

  @override
  ConsumerState<DonationSupportScreen> createState() =>
      _DonationSupportScreenState();
}

class _DonationSupportScreenState extends ConsumerState<DonationSupportScreen> {
  /// Presets d'amont — 2 € mis en avant comme « populaire » (parité web).
  static const List<double> _presets = [1, 2, 5];
  static const double _minAmount = 1;
  static const double _maxAmount = 1000;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _customAmountController = TextEditingController();

  /// Montant courant sélectionné (preset ou saisie libre).
  double? _amount = 2;

  bool _isProcessing = false;
  bool _success = false;
  double _completedAmount = 0;
  String? _errorMessage;

  late final ConfettiController _confettiController;
  late String? _sessionAccountId;

  /// Monotonic token preventing an older async flow from becoming current
  /// again after an A -> B -> A session sequence.
  int _operationGeneration = 0;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _sessionAccountId = ref.read(authSessionUserIdProvider);
    _prefillContactForSession(_sessionAccountId);

    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (next == _sessionAccountId) return;

      _sessionAccountId = next;
      _operationGeneration++;
      _confettiController.stop();
      FocusManager.instance.primaryFocus?.unfocus();

      // Every draft and result on this public route belongs to the exact
      // nullable session that created it. A guest therefore gets a clean
      // form, while a newly authenticated account gets only its own contact
      // details.
      _emailController.clear();
      _nameController.clear();
      _customAmountController.clear();
      _prefillContactForSession(next);

      if (!mounted) return;
      setState(() {
        _amount = 2;
        _isProcessing = false;
        _success = false;
        _completedAmount = 0;
        _errorMessage = null;
      });
    });
  }

  void _prefillContactForSession(String? accountId) {
    if (accountId == null) return;

    final auth = ref.read(authProvider);
    final user = auth.isAuthenticated && auth.user?.id.trim() == accountId
        ? auth.user
        : null;
    if (user == null) return;

    _emailController.text = user.email;
    final displayName = user.displayName.trim();
    if (displayName.isNotEmpty) {
      _nameController.text = displayName;
    }
  }

  int _beginOperation() => ++_operationGeneration;

  bool _ownsOperation(String? accountId, int generation) {
    return mounted &&
        generation == _operationGeneration &&
        accountId == _sessionAccountId &&
        ref.read(authSessionUserIdProvider) == accountId;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _customAmountController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────── selection

  void _selectPreset(double value) {
    FocusScope.of(context).unfocus();
    setState(() {
      _amount = value;
      _customAmountController.clear();
      _errorMessage = null;
    });
  }

  void _onCustomAmountChanged(String raw) {
    final normalized = raw.replaceAll(',', '.').trim();
    setState(() {
      _amount = normalized.isEmpty ? null : double.tryParse(normalized);
      _errorMessage = null;
    });
  }

  bool get _isPreset =>
      _customAmountController.text.trim().isEmpty &&
      _amount != null &&
      _presets.contains(_amount);

  // ───────────────────────────────────────────────────────────── donate flow

  Future<void> _onDonatePressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final amount = _amount;
    if (amount == null || amount < _minAmount || amount > _maxAmount) {
      setState(() => _errorMessage = context.l10n.donationsAmountInvalid);
      return;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = context.l10n.donationsEmailRequired);
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _errorMessage = context.l10n.donationsEmailInvalid);
      return;
    }

    // Capture every value before the first await. Text controllers and
    // inherited localization/context state may already belong to another
    // account when a network response completes.
    final nameValue = _nameController.text.trim();
    final name = nameValue.isEmpty ? null : nameValue;
    final locale = context.appLanguageCode;
    final l10n = context.l10n;
    final accountId = _sessionAccountId;
    final generation = _beginOperation();
    final repo = ref.read(donationsRepositoryProvider);

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final checkout = await repo.createDonation(
        amount: amount,
        email: email,
        name: name,
        locale: locale,
        sourceScreen: 'settings',
      );
      if (!_ownsOperation(accountId, generation)) return;

      final ps = checkout.paymentSheet;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: ps.clientSecret,
          merchantDisplayName: ps.merchantDisplayName,
          customerId: ps.hasCustomer ? ps.customerId : null,
          customerEphemeralKeySecret: ps.hasCustomer ? ps.ephemeralKey : null,
        ),
      );
      if (!_ownsOperation(accountId, generation)) return;

      // iOS : laisser l'UI se stabiliser avant que Stripe ne parcoure la
      // hiérarchie de vues (même précaution que le checkout booking).
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!_ownsOperation(accountId, generation)) return;
      await WidgetsBinding.instance.endOfFrame;
      if (!_ownsOperation(accountId, generation)) return;

      await Stripe.instance.presentPaymentSheet();
      if (!_ownsOperation(accountId, generation)) return;

      // Paiement accepté côté Stripe. Le webhook fait foi ; on force juste une
      // réconciliation immédiate en best-effort (sans bloquer le succès).
      final piId = ps.paymentIntentId;
      if (piId != null && piId.isNotEmpty) {
        try {
          await repo.confirmPayment(
            uuid: checkout.donation.uuid,
            paymentIntentId: piId,
          );
        } catch (_) {
          // Ignoré : le webhook Stripe réconciliera le don.
        }
      }

      if (!_ownsOperation(accountId, generation)) return;
      HapticFeedback.heavyImpact();
      setState(() {
        _isProcessing = false;
        _success = true;
        _completedAmount = amount;
      });
      _confettiController.play();
    } on StripeException catch (e) {
      if (!_ownsOperation(accountId, generation)) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = OrderCheckoutErrorMapper.stripeUserMessage(
          e,
          l10n,
        );
      });
    } catch (e) {
      if (!_ownsOperation(accountId, generation)) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = ApiResponseHandler.extractError(
          e,
          fallback: l10n.donationsCheckoutFailed,
        );
      });
    }
  }

  // ───────────────────────────────────────────────────────────── build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.l10n.donationsTitle),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _success ? _buildSuccessView(context) : _buildForm(context),
      bottomNavigationBar: _success ? null : _buildConfirmBar(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(context),
            const SizedBox(height: 20),
            _buildAmountCard(context),
            const SizedBox(height: 16),
            _buildContactCard(context),
            const SizedBox(height: 16),
            _buildDisclaimer(context),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildError(context, _errorMessage!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: HbColors.brandPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.volunteer_activism,
            color: HbColors.brandPrimary,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.donationsHeaderTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: HbColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.donationsHeaderSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.donationsAmountLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            // Aligne les pastilles par le bas : le badge « Populaire » déborde
            // vers le haut sans décaler la ligne, robuste au text scaling.
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < _presets.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: _buildPresetChip(
                    _presets[i],
                    popular: _presets[i] == 2,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('donation-custom-amount-field'),
            controller: _customAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: _onCustomAmountChanged,
            decoration: _inputDecoration(
              context.l10n.donationsCustomAmountLabel,
            ).copyWith(
              prefixIcon: const Icon(Icons.euro, size: 20),
              helperText: context.l10n.donationsCustomAmountHelper,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(double value, {required bool popular}) {
    final selected = _isPreset && _amount == value;
    return GestureDetector(
      onTap: () => _selectPreset(value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (popular) ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.l10n.donationsPresetPopular,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: selected ? HbColors.brandPrimary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? HbColors.brandPrimary : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                _formatAmount(value),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : HbColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.donationsContactTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('donation-email-field'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(context.l10n.donationsEmailLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('donation-name-field'),
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration(context.l10n.donationsNameLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.l10n.donationsDisclaimer,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Container(
      key: const ValueKey('donation-error'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmBar(BuildContext context) {
    final amount = _amount;
    final label =
        (amount != null && amount >= _minAmount && amount <= _maxAmount)
            ? context.l10n.donationsCtaLabel(_formatAmount(amount))
            : context.l10n.donationsCtaLabelGeneric;

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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const ValueKey('donation-submit'),
              onPressed: _isProcessing ? null : _onDonatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isProcessing
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
                        const Icon(Icons.lock, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────── success

  Widget _buildSuccessView(BuildContext context) {
    return Stack(
      key: const ValueKey('donation-success'),
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 64,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.donationsSuccessTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.donationsSuccessSubtitle(
                      _formatAmount(_completedAmount)),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.l10n.commonClose,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 30,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.05,
            gravity: 0.2,
            colors: const [
              HbColors.brandPrimary,
              Colors.blue,
              Colors.green,
              Colors.purple,
              Colors.pink,
              Colors.orange,
              Colors.yellow,
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────── helpers

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
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

  String _formatAmount(double value) {
    return '${context.appAmount(value)} €';
  }
}
