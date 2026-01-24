import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/business_register_provider.dart';

/// Step 5: Terms Acceptance and Summary Form
class TermsAcceptanceForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const TermsAcceptanceForm({
    super.key,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  ConsumerState<TermsAcceptanceForm> createState() => _TermsAcceptanceFormState();
}

class _TermsAcceptanceFormState extends ConsumerState<TermsAcceptanceForm> {
  bool _acceptTerms = false;
  bool _acceptBusinessTerms = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(businessRegisterProvider);
    _acceptTerms = state.acceptTerms;
    _acceptBusinessTerms = state.acceptBusinessTerms;
  }

  void _updateTerms() {
    ref.read(businessRegisterProvider.notifier).updateTerms(
      acceptTerms: _acceptTerms,
      acceptBusinessTerms: _acceptBusinessTerms,
    );
  }

  Future<void> _handleSubmit() async {
    _updateTerms();
    final success = await ref.read(businessRegisterProvider.notifier).submitRegistration();
    if (success) {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessRegisterProvider);

    // Listen for errors
    ref.listen<BusinessRegisterState>(businessRegisterProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(businessRegisterProvider.notifier).clearError();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          const Text(
            'Finalisation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vérifiez vos informations et acceptez les conditions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Récapitulatif',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),

                // Personal info
                _buildSummarySection(
                  icon: Icons.person_outline,
                  title: 'Informations personnelles',
                  items: [
                    '${state.firstName} ${state.lastName}',
                    state.email,
                    if (state.phone.isNotEmpty) state.phone,
                  ],
                ),
                const Divider(height: 24),

                // Company info
                _buildSummarySection(
                  icon: Icons.business_outlined,
                  title: 'Organisation',
                  items: [
                    state.companyName,
                    state.organizationType.label,
                    if (state.siret.isNotEmpty) 'SIRET: ${state.siret}',
                    '${state.address}, ${state.postalCode} ${state.city}',
                  ],
                ),
                const Divider(height: 24),

                // Usage mode
                _buildSummarySection(
                  icon: Icons.settings_outlined,
                  title: 'Utilisation',
                  items: [
                    state.usageMode.label,
                    if (state.defaultBudget.isNotEmpty)
                      'Budget: ${state.defaultBudget} EUR/mois',
                    if (state.usageMode == UsageMode.team &&
                        state.teamEmails.isNotEmpty)
                      'Invitations: ${state.teamEmails.split(',').where((e) => e.trim().isNotEmpty).length} collaborateurs',
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Terms acceptance
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                // General terms
                _buildCheckbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      children: [
                        const TextSpan(text: 'J\'accepte les '),
                        TextSpan(
                          text: 'conditions générales d\'utilisation',
                          style: const TextStyle(
                            color: Color(0xFFFF601F),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Open terms URL
                            },
                        ),
                        const TextSpan(text: ' et la '),
                        TextSpan(
                          text: 'politique de confidentialité',
                          style: const TextStyle(
                            color: Color(0xFFFF601F),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Open privacy URL
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Business terms
                _buildCheckbox(
                  value: _acceptBusinessTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptBusinessTerms = value ?? false;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      children: [
                        const TextSpan(text: 'J\'accepte les '),
                        TextSpan(
                          text: 'conditions spécifiques aux comptes professionnels',
                          style: const TextStyle(
                            color: Color(0xFFFF601F),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Open business terms URL
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: state.isLoading ||
                      !_acceptTerms ||
                      !_acceptBusinessTerms
                  ? null
                  : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Créer mon compte business',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Back button
          Center(
            child: TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Retour'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
            ),
          ),

          // Helper text
          const SizedBox(height: 24),
          Text(
            'En créant un compte, vous confirmez que les informations fournies sont exactes et que vous êtes autorisé à représenter cette organisation.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFFF601F).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF601F),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF601F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}
