import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/core/widgets/inputs/hb_text_field.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_stepper_header.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/core/utils/age_utils.dart';

class BookingParticipantScreen extends ConsumerStatefulWidget {
  const BookingParticipantScreen({super.key, required this.activity});
  final Activity activity;

  @override
  ConsumerState<BookingParticipantScreen> createState() =>
      _BookingParticipantScreenState();
}

class _BookingParticipantScreenState
    extends ConsumerState<BookingParticipantScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _townCtrl;
  String? _customerBirthDate;

  @override
  void initState() {
    super.initState();
    // Pre-fill if existing
    final provider = bookingFlowControllerProvider(widget.activity);
    final state = ref.read(provider);

    _firstNameCtrl = TextEditingController(text: state.buyerInfo?.firstName);
    _lastNameCtrl = TextEditingController(text: state.buyerInfo?.lastName);
    _emailCtrl = TextEditingController(text: state.buyerInfo?.email);
    _phoneCtrl = TextEditingController(text: state.buyerInfo?.phone);
    _ageCtrl = TextEditingController();
    _townCtrl = TextEditingController(text: state.buyerInfo?.town);

    // Prefill age from buyerInfo or user profile
    if (state.buyerInfo?.birthDate != null) {
      _customerBirthDate = state.buyerInfo!.birthDate;
      final age = computeAge(_customerBirthDate);
      if (age != null) _ageCtrl.text = age.toString();
    } else {
      final user = ref.read(currentUserProvider);
      if (user?.birthDate != null) {
        final birthDateStr =
            user!.birthDate!.toIso8601String().substring(0, 10);
        _customerBirthDate = birthDateStr;
        final age = computeAge(birthDateStr);
        if (age != null) _ageCtrl.text = age.toString();
      }
      if (_townCtrl.text.isEmpty &&
          user?.membershipCity != null &&
          user!.membershipCity!.isNotEmpty) {
        _townCtrl.text = user.membershipCity!;
      }
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _townCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final provider = bookingFlowControllerProvider(widget.activity);
      final controller = ref.read(provider.notifier);

      controller.updateBuyerInfo(BuyerInfo(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        birthDate: _customerBirthDate,
        town: _townCtrl.text.isNotEmpty ? _townCtrl.text : null,
      ));

      controller.goToPaymentStep().then((_) {
        if (!mounted) return;
        final updatedState = ref.read(provider);
        if (updatedState.errorMessage == null) {
          if (updatedState.isFree) {
            // Direct confirmation flow
            context.push('/booking/${widget.activity.id}/confirmation',
                extra: widget.activity);
          } else {
            context.push('/booking/${widget.activity.id}/payment',
                extra: widget.activity);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(updatedState.errorMessage!)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = bookingFlowControllerProvider(widget.activity);
    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bookingContactDetailsTitle)),
      body: Column(
        children: [
          BookingStepperHeader(step: state.step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.bookingBuyerContactTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _lastNameCtrl,
                      label: context.l10n.bookingLastNameLabel,
                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _firstNameCtrl,
                      label: context.l10n.bookingFirstNameLabelRequired,
                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _emailCtrl,
                      label: context.l10n.authEmailLabel,
                      hint: context.l10n.authEmailHint,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _phoneCtrl,
                      label: context.l10n.bookingPhoneLabel,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 24),
                    Text(
                      context.l10n.bookingAdditionalInfoOptional,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HbTextField(
                      controller: _ageCtrl,
                      label: context.l10n.bookingAgeLabel,
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
                    HbTextField(
                      controller: _townCtrl,
                      label: context.l10n.bookingMembershipCityLabel,
                    ),

                    const SizedBox(height: 32),
                    // Participant details logic omitted for brevity as per prompt, handling buyer as main contact
                    if (state.quantity > 1)
                      Text(context.l10n.bookingLegacyOtherParticipantsLater,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: HbButton.primary(
              label: state.isFree
                  ? context.l10n.bookingConfirmReservation
                  : context.l10n.bookingGoToPayment,
              isLoading: state.isSubmitting,
              onTap: _onSave,
            ),
          ),
        ],
      ),
    );
  }
}
