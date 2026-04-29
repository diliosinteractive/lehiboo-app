import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/data/models/booking_api_dto.dart';
import 'package:lehiboo/features/booking/domain/models/checkout_params.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/widgets/participant_forms_section.dart';
import 'package:lehiboo/core/utils/age_utils.dart';

/// Écran de checkout unifié
/// Combine: Récapitulatif + Formulaire acheteur + Paiement Stripe
class CheckoutScreen extends ConsumerStatefulWidget {
  final CheckoutParams params;

  const CheckoutScreen({super.key, required this.params});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour le formulaire
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _townController = TextEditingController();

  // Birth date backing value for API (computed from age)
  String? _customerBirthDate;

  // Attendees per ticket type
  late Map<String, List<ParticipantInfo>> _attendeesMap;

  // État
  bool _isLoading = false;
  bool _acceptedTerms = false;
  bool _acceptNewsletter = false;
  String? _errorMessage;

  // Booking créé (pour le paiement - utilisé pour la navigation)
  // ignore: unused_field
  CreateBookingResponseDto? _bookingResponse;

  @override
  void initState() {
    super.initState();
    _initAttendeesMap();
    _prefillForm();
  }

  void _initAttendeesMap() {
    _attendeesMap = {};
    for (final entry in widget.params.ticketQuantities.entries) {
      if (entry.value > 0) {
        _attendeesMap[entry.key] = List.generate(
          entry.value,
          (_) => const ParticipantInfo(),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _townController.dispose();
    super.dispose();
  }

  /// Pré-remplit le formulaire avec les données de l'utilisateur connecté
  void _prefillForm() {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user != null) {
      debugPrint('🔍 Checkout prefill: firstName=${user.firstName}, lastName=${user.lastName}, displayName=${user.displayName}');

      // Utiliser firstName/lastName si disponibles
      String firstName = user.firstName ?? '';
      String lastName = user.lastName ?? '';

      // Fallback: extraire depuis displayName si firstName/lastName sont vides
      if (firstName.isEmpty && lastName.isEmpty && user.displayName.isNotEmpty) {
        final parts = user.displayName.trim().split(' ');
        if (parts.length >= 2) {
          firstName = parts.first;
          lastName = parts.sublist(1).join(' ');
        } else if (parts.length == 1) {
          firstName = parts.first;
        }
      }

      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';

      // Birth date -> age
      if (user.birthDate != null) {
        final birthDateStr =
            user.birthDate!.toIso8601String().substring(0, 10);
        _customerBirthDate = birthDateStr;
        final age = computeAge(birthDateStr);
        if (age != null) {
          _ageController.text = age.toString();
        }
      }
      // Town
      if (user.membershipCity != null && user.membershipCity!.isNotEmpty) {
        _townController.text = user.membershipCity!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Finaliser ma réservation'),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Récapitulatif de la commande
            _buildOrderSummary(),

            const SizedBox(height: 16),

            // Formulaire acheteur
            _buildBuyerForm(),

            const SizedBox(height: 16),

            // Formulaires participants
            _buildParticipantsSection(),

            const SizedBox(height: 16),

            // CGV
            _buildTermsSection(),

            // Message d'erreur
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
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
              ),

            // Espace pour le bouton
            SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildOrderSummary() {
    final event = widget.params.event;
    final tickets = widget.params.ticketQuantities;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Récapitulatif',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Event info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: event.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: event.images.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.event, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),

              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HbColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Date
                    if (widget.params.formattedDate != null)
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.params.formattedDate!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    // Lieu
                    if (event.venue.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${event.venue}, ${event.city}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Billets sélectionnés
          ...tickets.entries.where((e) => e.value > 0).map((entry) {
            final ticket = event.tickets.firstWhere(
              (t) => t.id == entry.key,
              orElse: () => const Ticket(id: '', name: 'Billet', price: 0),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${entry.value}x ${ticket.name}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    _formatPrice(ticket.price * entry.value),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HbColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              Text(
                widget.params.isFree
                    ? 'Gratuit'
                    : _formatPrice(widget.params.totalPrice),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      widget.params.isFree ? Colors.green : HbColors.brandPrimary,
                ),
              ),
            ],
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
              'Vos coordonnées',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Prénom
            TextFormField(
              controller: _firstNameController,
              decoration: _inputDecoration('Prénom *'),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le prénom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Nom
            TextFormField(
              controller: _lastNameController,
              decoration: _inputDecoration('Nom *'),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email *'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'L\'email est requis';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Téléphone
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('Téléphone'),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            // Informations complémentaires (optionnel)
            Text(
              'Informations complémentaires (optionnel)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // Age
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

            // Ville
            TextFormField(
              controller: _townController,
              decoration: _inputDecoration('Ville d\'appartenance'),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value != null && value.length > 255) {
                  return 'La ville ne doit pas dépasser 255 caractères';
                }
                return null;
              },
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

  Widget _buildParticipantsSection() {
    return ParticipantFormsSection(
      ticketQuantities: widget.params.ticketQuantities,
      eventTickets: widget.params.event.tickets,
      buyerInfo: _currentBuyerInfo,
      attendeesMap: _attendeesMap,
      onAttendeeChanged: (ticketTypeId, index, info) {
        setState(() {
          _attendeesMap[ticketTypeId]?[index] = info;
        });
      },
    );
  }

  Widget _buildTermsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() => _acceptedTerms = value ?? false);
              },
              activeColor: HbColors.brandPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _acceptedTerms = !_acceptedTerms);
              },
              child: Text.rich(
                TextSpan(
                  text: 'J\'accepte les ',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  children: [
                    TextSpan(
                      text: 'conditions générales de vente',
                      style: TextStyle(
                        color: HbColors.brandPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(
                        color: HbColors.brandPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final isFree = widget.params.isFree;

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
              // Prix total
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isFree ? 'Gratuit' : _formatPrice(widget.params.totalPrice),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isFree ? Colors.green : HbColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${widget.params.totalTickets} billet${widget.params.totalTickets > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Bouton confirmer
              ElevatedButton(
                onPressed: _isLoading ? null : _onConfirmPressed,
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
                          Icon(
                            isFree ? Icons.check : Icons.lock,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isFree ? 'Confirmer' : 'Payer',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _onConfirmPressed() async {
    // Dismiss keyboard before any async work — iOS PaymentSheet cannot
    // present while the keyboard is animating, which silently hangs
    // presentPaymentSheet on iOS (Android tolerates it).
    FocusManager.instance.primaryFocus?.unfocus();

    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Vérifier les CGV
    if (!_acceptedTerms) {
      setState(() {
        _errorMessage = 'Veuillez accepter les conditions générales de vente';
      });
      return;
    }

    // Validate participants: attendees.length == quantity and all have names
    for (final entry in widget.params.ticketQuantities.entries) {
      if (entry.value <= 0) continue;
      final attendees = _attendeesMap[entry.key] ?? [];
      if (attendees.length != entry.value) {
        setState(() {
          _errorMessage = 'Chaque billet doit avoir un participant renseigné';
        });
        return;
      }
      for (final a in attendees) {
        if ((a.firstName ?? '').trim().isEmpty ||
            (a.lastName ?? '').trim().isEmpty) {
          setState(() {
            _errorMessage =
                'Veuillez renseigner le prénom et le nom de chaque participant';
          });
          return;
        }
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookingDataSource = ref.read(bookingApiDataSourceProvider);

      // Construire la liste des items avec attendees
      final items = widget.params.ticketQuantities.entries
          .where((e) => e.value > 0)
          .map((e) => BookingTicketRequestDto(
                ticketTypeId: e.key,
                quantity: e.value,
                attendees: (_attendeesMap[e.key] ?? [])
                    .map((p) => AttendeeRequestDto(
                          firstName: p.firstName ?? '',
                          lastName: p.lastName ?? '',
                          email: p.email,
                          phone: p.phone,
                          birthDate: p.birthDate,
                          age: p.age,
                          city: p.city,
                          membershipCity: p.membershipCity,
                        ))
                    .toList(),
              ))
          .toList();

      // 1. Créer la réservation (status: pending)
      final bookingResponse = await bookingDataSource.createBooking(
        eventId: widget.params.event.id,
        slotId: widget.params.slotId,
        items: items,
        customerEmail: _emailController.text.trim(),
        customerFirstName: _firstNameController.text.trim(),
        customerLastName: _lastNameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerBirthDate: _customerBirthDate,
        customerTown: _townController.text.trim().isNotEmpty
            ? _townController.text.trim()
            : null,
        promoCode: widget.params.couponCode,
        paymentMethod: widget.params.isFree ? 'free' : 'card',
        acceptTerms: _acceptedTerms,
        acceptNewsletter: _acceptNewsletter,
      );

      _bookingResponse = bookingResponse;
      final bookingUuid = bookingResponse.uuid;
      final isFree = bookingResponse.totalAmount == 0;

      if (isFree) {
        // 2a. Événement gratuit: confirmer directement
        await bookingDataSource.confirmFreeBooking(bookingUuid: bookingUuid);
      } else {
        // 2b. Événement payant: récupérer le PaymentIntent
        final paymentIntent = await bookingDataSource.getPaymentIntent(
          bookingUuid: bookingUuid,
        );

        final cs = paymentIntent.clientSecret;
        final csPrefix = cs.length >= 10 ? cs.substring(0, 10) : cs;
        debugPrint(
            '🔵 Stripe init starting | clientSecret len=${cs.length} prefix=$csPrefix paymentIntentId=${paymentIntent.paymentIntentId} amount=${paymentIntent.amount}');

        // 3. Configurer et afficher le Payment Sheet Stripe
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent.clientSecret,
            merchantDisplayName: 'Le Hiboo',
            style: ThemeMode.system,
            appearance: PaymentSheetAppearance(
              primaryButton: PaymentSheetPrimaryButtonAppearance(
                colors: PaymentSheetPrimaryButtonTheme(
                  light: PaymentSheetPrimaryButtonThemeColors(
                    background: HbColors.brandPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
        debugPrint('🟢 Stripe init OK');

        // Let iOS finish any in-flight animations (keyboard dismissal,
        // route transition) before presenting the Payment Sheet — without
        // this gap the iOS SDK can hang waiting for a stable rootVC.
        await Future.delayed(const Duration(milliseconds: 250));

        // Afficher le Payment Sheet
        debugPrint('🔵 Stripe present starting');
        try {
          await Stripe.instance.presentPaymentSheet().timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              debugPrint('🔴 presentPaymentSheet TIMED OUT after 20s — SDK never returned');
              throw TimeoutException(
                'Stripe presentPaymentSheet timeout (iOS native bridge stuck)',
              );
            },
          );
        } catch (e) {
          debugPrint('🔴 presentPaymentSheet caught: ${e.runtimeType}: $e');
          rethrow;
        }
        debugPrint('🟢 Stripe present OK');

        // 4. Confirmer la réservation après paiement réussi
        debugPrint('🔵 confirmBooking starting');
        await bookingDataSource.confirmBooking(
          bookingUuid: bookingUuid,
          paymentIntentId: paymentIntent.paymentIntentId,
        );
        debugPrint('🟢 confirmBooking OK');
      }

      // 5. Naviguer vers la confirmation avec confettis
      HapticFeedback.heavyImpact();
      if (mounted) {
        context.go('/booking-confirmation/$bookingUuid', extra: {
          'booking': bookingResponse,
          'event': widget.params.event,
          'selectedSlot': widget.params.selectedSlot,
        });
      }
    } on StripeException catch (e, st) {
      // Paiement annulé ou échoué
      debugPrint('🔴 StripeException: code=${e.error.code} message=${e.error.message} localized=${e.error.localizedMessage}');
      debugPrint('🔴 StripeException stack: $st');
      setState(() {
        _isLoading = false;
        _errorMessage = e.error.localizedMessage ?? 'Paiement annulé';
      });
    } catch (e, st) {
      debugPrint('🔴 Checkout error: $e');
      debugPrint('🔴 Checkout stack: $st');
      setState(() {
        _isLoading = false;
        _errorMessage = ApiResponseHandler.extractError(e);
      });
    }
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      return '${price.toInt()}€';
    }
    return '${price.toStringAsFixed(2)}€';
  }
}
