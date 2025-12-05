import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/widgets/buttons/hb_button.dart';
import 'package:lehiboo/core/widgets/inputs/hb_text_field.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_stepper_header.dart';

class BookingParticipantScreen extends ConsumerStatefulWidget {
  const BookingParticipantScreen({super.key, required this.activity});
  final Activity activity;

  @override
  ConsumerState<BookingParticipantScreen> createState() => _BookingParticipantScreenState();
}

class _BookingParticipantScreenState extends ConsumerState<BookingParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

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
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
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
          ));

          controller.goToPaymentStep().then((_) {
              final updatedState = ref.read(provider);
              if (updatedState.errorMessage == null) {
                  if (updatedState.isFree) {
                       // Direct confirmation flow
                       context.push('/booking/${widget.activity.id}/confirmation', extra: widget.activity);
                  } else {
                       context.push('/booking/${widget.activity.id}/payment', extra: widget.activity);
                  }
              } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(updatedState.errorMessage ?? 'Erreur'))
                  );
              }
          });
      }
  }

  @override
  Widget build(BuildContext context) {
    final provider = bookingFlowControllerProvider(widget.activity);
    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(title: const Text('Vos informations')),
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
                    Text('Informations de contact', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _lastNameCtrl,
                      label: 'Nom',

                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _firstNameCtrl,
                      label: 'Prénom',
                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'exemple@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    HbTextField(
                      controller: _phoneCtrl,
                      label: 'Téléphone',
                      keyboardType: TextInputType.phone,
                    ),
                    
                    const SizedBox(height: 32),
                     // Participant details logic omitted for brevity as per prompt, handling buyer as main contact
                     if (state.quantity > 1) 
                         const Text('Note : Les détails des autres participants seront demandés ultérieurement.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: HbButton.primary(
              label: state.isFree ? 'Confirmer la réservation' : 'Aller au paiement',
              isLoading: state.isSubmitting,
              onTap: _onSave,
            ),
          ),
        ],
      ),
    );
  }
}
