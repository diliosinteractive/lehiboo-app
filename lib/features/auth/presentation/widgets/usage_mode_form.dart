import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/business_register_provider.dart';

/// Step 4: Usage Mode Form
class UsageModeForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const UsageModeForm({
    super.key,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  ConsumerState<UsageModeForm> createState() => _UsageModeFormState();
}

class _UsageModeFormState extends ConsumerState<UsageModeForm> {
  final _formKey = GlobalKey<FormState>();
  final _teamEmailsController = TextEditingController();
  final _defaultBudgetController = TextEditingController();

  UsageMode _usageMode = UsageMode.personal;

  @override
  void initState() {
    super.initState();
    // Pre-fill from state if available
    final state = ref.read(businessRegisterProvider);
    _usageMode = state.usageMode;
    _teamEmailsController.text = state.teamEmails;
    _defaultBudgetController.text = state.defaultBudget;
  }

  @override
  void dispose() {
    _teamEmailsController.dispose();
    _defaultBudgetController.dispose();
    super.dispose();
  }

  void _saveToState() {
    ref.read(businessRegisterProvider.notifier).updateUsageMode(
      usageMode: _usageMode,
      teamEmails: _teamEmailsController.text,
      defaultBudget: _defaultBudgetController.text,
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    _saveToState();
    final success = ref.read(businessRegisterProvider.notifier).submitUsageMode();
    if (success) {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessRegisterProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Mode d\'utilisation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comment comptez-vous utiliser LeHiboo ?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Usage mode selection
            ...UsageMode.values.map((mode) {
              final isSelected = _usageMode == mode;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _usageMode = mode;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFF601F)
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? const Color(0xFFFF601F).withValues(alpha: 0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xFFFF601F).withValues(alpha: 0.1)
                                : Colors.grey[100],
                          ),
                          child: Icon(
                            mode == UsageMode.personal
                                ? Icons.person
                                : Icons.groups,
                            color: isSelected
                                ? const Color(0xFFFF601F)
                                : Colors.grey[600],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mode.label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFFFF601F)
                                      : const Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mode.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Radio indicator
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFF601F)
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFFF601F),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Team emails (only show if team mode is selected)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _teamEmailsController,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Emails des collaborateurs (optionnel)',
                      hintText: 'email1@exemple.com, email2@exemple.com',
                      helperText: 'Séparez les emails par des virgules',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.email_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF601F),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final emails = value
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty);
                        for (final email in emails) {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(email)) {
                            return 'Email invalide: $email';
                          }
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              crossFadeState: _usageMode == UsageMode.team
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            // Default budget (optional)
            TextFormField(
              controller: _defaultBudgetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Budget mensuel par défaut (optionnel)',
                hintText: '500',
                prefixIcon: const Icon(Icons.euro_outlined),
                suffixText: 'EUR',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF601F),
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un montant valide';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF601F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continuer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
          ],
        ),
      ),
    );
  }
}
