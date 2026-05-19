import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/l10n.dart';
import '../providers/business_register_provider.dart';
import 'password_strength_indicator.dart';

/// Step 1: Personal Information Form
class PersonalInfoForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;

  const PersonalInfoForm({
    super.key,
    required this.onSubmit,
  });

  @override
  ConsumerState<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _membershipCityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _birthDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill from state if available
    final state = ref.read(businessRegisterProvider);
    _firstNameController.text = state.firstName;
    _lastNameController.text = state.lastName;
    _emailController.text = state.email;
    _phoneController.text = state.phone;
    _membershipCityController.text = state.membershipCity ?? '';
    if (state.birthDate != null) {
      _birthDate = DateTime.tryParse(state.birthDate!);
    }
    _passwordController.text = state.password;
    _confirmPasswordController.text = state.passwordConfirmation;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _membershipCityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveToState() {
    ref.read(businessRegisterProvider.notifier).updatePersonalInfo(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          birthDate: _birthDate != null
              ? '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}'
              : null,
          membershipCity: _membershipCityController.text.trim().isNotEmpty
              ? _membershipCityController.text.trim()
              : null,
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
        );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _saveToState();
    final success =
        await ref.read(businessRegisterProvider.notifier).submitPersonalInfo();
    if (success) {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(businessRegisterProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              l10n.authPersonalInfoTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.authPersonalInfoSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Name fields row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      label: l10n.authFirstNameLabel,
                      hint: l10n.authFirstNameHint,
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return l10n.authValidationMin2Chars;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      label: l10n.authLastNameLabel,
                      hint: l10n.authLastNameHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return l10n.authValidationMin2Chars;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: l10n.authProfessionalEmailLabel,
                hint: l10n.authProfessionalEmailHint,
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authEmailRequired;
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return l10n.authEmailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone field (optional)
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: l10n.authPhoneOptionalLabel,
                hint: l10n.authPhoneHint,
                icon: Icons.phone_outlined,
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final cleaned = value.replaceAll(RegExp(r'[\s\-\.]'), '');
                  if (!RegExp(r'^(\+33|0033|0)[1-9]\d{8}$').hasMatch(cleaned)) {
                    return l10n.authPhoneInvalid;
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Birth date picker (optional)
            GestureDetector(
              onTap: () async {
                final maxDate =
                    DateTime.now().subtract(const Duration(days: 15 * 365));
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _birthDate ?? maxDate,
                  firstDate: DateTime(1920),
                  lastDate: maxDate,
                  helpText: l10n.authBirthDateHelp,
                  // locale: const Locale('fr'),
                );
                if (picked != null) {
                  setState(() => _birthDate = picked);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: _inputDecoration(
                    label: l10n.authBirthDateLabelOptional,
                    hint: l10n.authDateHint,
                    icon: Icons.cake_outlined,
                    suffixIcon: _birthDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () => setState(() => _birthDate = null),
                          )
                        : null,
                  ),
                  controller: TextEditingController(
                    text: _birthDate != null
                        ? context
                            .appDateFormat('dd/MM/yyyy',
                                enPattern: 'MM/dd/yyyy')
                            .format(_birthDate!)
                        : '',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Membership city (optional)
            TextFormField(
              controller: _membershipCityController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              maxLength: 120,
              decoration: _inputDecoration(
                label: l10n.authCityOptionalLabel,
                hint: l10n.authCityHint,
                icon: Icons.location_city_outlined,
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              onChanged: (value) => setState(() {}),
              decoration: _inputDecoration(
                label: l10n.authPasswordLabel,
                hint: l10n.authPasswordMinimumHint,
                icon: Icons.lock_outlined,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authPasswordCreateRequired;
                }
                if (value.length < 8) {
                  return l10n.authPasswordMinLengthShort;
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return l10n.authPasswordNeedsUppercaseShort;
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return l10n.authPasswordNeedsNumberShort;
                }
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return l10n.authPasswordNeedsSpecialShort;
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            PasswordStrengthIndicator(
              password: _passwordController.text,
              showRequirements: true,
            ),
            const SizedBox(height: 16),

            // Confirm password field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              decoration: _inputDecoration(
                label: l10n.authConfirmPasswordLabel,
                hint: l10n.authConfirmPasswordHint,
                icon: Icons.lock_outlined,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authConfirmPasswordRequired;
                }
                if (value != _passwordController.text) {
                  return l10n.authPasswordsDoNotMatch;
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
                child: state.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.commonContinue,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF601F), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
