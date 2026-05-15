import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../shared/legal/legal_links.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../providers/auth_provider.dart';
import '../widgets/password_strength_indicator.dart';
import '../../../../core/utils/api_response_handler.dart';

/// Customer (simple) registration screen with 3 steps:
/// 1. Email input + OTP send
/// 2. OTP verification
/// 3. Complete registration form
class CustomerRegisterScreen extends ConsumerStatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  ConsumerState<CustomerRegisterScreen> createState() =>
      _CustomerRegisterScreenState();
}

enum _RegistrationStep { email, otp, form }

class _CustomerRegisterScreenState
    extends ConsumerState<CustomerRegisterScreen> {
  _RegistrationStep _currentStep = _RegistrationStep.email;

  // Controllers for email step
  final _emailController = TextEditingController();

  // Controllers for OTP step
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // Controllers for form step
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _membershipCityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _birthDate;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _acceptMarketing = false;
  bool _isLoading = false;

  // OTP state
  String? _verifiedEmailToken;
  int _otpCooldownSeconds = 0;
  Timer? _cooldownTimer;

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _emailController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var n in _otpFocusNodes) {
      n.dispose();
    }
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _membershipCityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _otpCooldownSeconds = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpCooldownSeconds > 0) {
        setState(() => _otpCooldownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError(context.l10n.authEmailAddressInvalid);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryImplProvider);
      final result = await authRepository.sendOtpCode(
        email: email,
        type: 'email_verification',
      );

      if (!mounted) return;

      if (result.success) {
        _showSuccess(result.message);
        _startCooldown();
        setState(() => _currentStep = _RegistrationStep.otp);
        // Focus first OTP field
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _otpFocusNodes[0].requestFocus();
        });
      }
    } catch (e) {
      if (mounted) {
        _showError(ApiResponseHandler.extractError(e));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_otpCooldownSeconds > 0) return;

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryImplProvider);
      final result = await authRepository.sendOtpCode(
        email: _emailController.text.trim(),
        type: 'email_verification',
      );

      if (!mounted) return;

      if (result.success) {
        _showSuccess(context.l10n.authOtpResent);
        _startCooldown();
        _clearOtpFields();
      }
    } catch (e) {
      if (mounted) {
        _showError(ApiResponseHandler.extractError(e));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) {
      _showError(context.l10n.authOtpIncompleteCode);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryImplProvider);
      final result = await authRepository.verifyOtpCode(
        email: _emailController.text.trim(),
        code: _otpCode,
        type: 'email_verification',
      );

      if (!mounted) return;

      if (result.verified && result.verifiedEmailToken != null) {
        _verifiedEmailToken = result.verifiedEmailToken;
        _showSuccess(context.l10n.authOtpEmailVerified);
        setState(() => _currentStep = _RegistrationStep.form);
      } else {
        _showError(result.message);
        _clearOtpFields();
      }
    } catch (e) {
      if (mounted) {
        _showError(ApiResponseHandler.extractError(e));
        _clearOtpFields();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearOtpFields() {
    for (var c in _otpControllers) {
      c.clear();
    }
    _otpFocusNodes[0].requestFocus();
  }

  void _onOtpDigitChanged(int index, String value) {
    // Handle paste of full code
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = value[i];
      }
      FocusScope.of(context).unfocus();
      _verifyOtp();
      return;
    }

    // Handle single digit entry
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }

    // Auto-submit when all digits are entered
    if (_otpCode.length == 6) {
      _verifyOtp();
    }
  }

  void _onOtpKeyPressed(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _otpControllers[index].text.isEmpty &&
        index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      _showError(context.l10n.authAcceptTermsRequired);
      return;
    }

    if (_verifiedEmailToken == null) {
      _showError(context.l10n.authRegisterMissingVerificationToken);
      setState(() => _currentStep = _RegistrationStep.email);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryImplProvider);
      final result = await authRepository.registerCustomer(
        verifiedEmailToken: _verifiedEmailToken!,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        birthDate: _birthDate != null
            ? '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}'
            : null,
        membershipCity: _membershipCityController.text.trim().isNotEmpty
            ? _membershipCityController.text.trim()
            : null,
        acceptTerms: _acceptTerms,
        acceptMarketing: _acceptMarketing,
      );

      if (!mounted) return;

      if (result.authResult != null) {
        // Direct authentication (no verification needed).
        _showSuccess(context.l10n.authCustomerAccountCreated);
        // If the registration was triggered from a GuestRestrictionDialog,
        // skip the navigation reset — the dialog's auth-state listener
        // will pop our pushed screens and the dialog itself, returning
        // the user to the original screen so the gated action resumes.
        // Otherwise route to the post-signup notifications screen. Location
        // permission is now part of first-launch onboarding (shown once
        // before the user ever reaches the login page), so we skip it here.
        //
        // Navigation BEFORE setAuthenticatedUser is intentional: the auth
        // state change fires _AuthRouterRefresh which rebuilds the router
        // and pops pushed routes, which would dispose this State and kill
        // any deferred navigation. Replacing the stack with `go()` first
        // means the subsequent refresh has nothing to pop.
        if (!ref.read(guestGuardActiveProvider)) {
          context.go('/post-signup/notifications');
        }
        // Listener cascade (Hibons sync, push init, messages realtime, …)
        // may throw — particularly CircularDependencyError when a Hibons
        // provider re-reads itself mid-build through the response
        // interceptor. Don't bubble that to the user — they just succeeded.
        try {
          ref
              .read(authProvider.notifier)
              .setAuthenticatedUser(result.authResult!.user);
        } catch (e, st) {
          debugPrint(
              '🚨 setAuthenticatedUser cascade error: ${e.runtimeType}: $e\n$st');
        }
        return;
      } else if (result.pendingVerification) {
        // This shouldn't happen with the new flow, but handle it just in case
        _showSuccess(result.message);
        context.push(
          '/verify-otp',
          extra: {
            'userId': result.userId ?? '',
            'email': result.email,
            'type': 'register',
          },
        );
      }
    } catch (e, st) {
      // Loud diagnostic — narrows down which line of the try block threw
      // and what runtime type the error is (helps distinguish Dart Errors,
      // DioExceptions, etc.).
      debugPrint('🚨 _handleRegister catch: ${e.runtimeType}: $e\n$st');
      if (mounted) {
        final errorMessage = ApiResponseHandler.extractError(e);
        _showError(errorMessage);

        // If token expired, go back to email step
        if (errorMessage.contains('expire') || errorMessage.contains('token')) {
          _verifiedEmailToken = null;
          setState(() => _currentStep = _RegistrationStep.email);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _goBack() {
    switch (_currentStep) {
      case _RegistrationStep.email:
        context.pop();
        break;
      case _RegistrationStep.otp:
        setState(() => _currentStep = _RegistrationStep.email);
        break;
      case _RegistrationStep.form:
        // Don't allow going back from form to OTP (token is already used)
        // Go back to email instead
        _verifiedEmailToken = null;
        _clearOtpFields();
        setState(() => _currentStep = _RegistrationStep.email);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HbColors.textSlate),
          onPressed: _goBack,
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case _RegistrationStep.email:
        return _buildEmailStep();
      case _RegistrationStep.otp:
        return _buildOtpStep();
      case _RegistrationStep.form:
        return _buildFormStep();
    }
  }

  Widget _buildEmailStep() {
    final l10n = context.l10n;

    return SingleChildScrollView(
      key: const ValueKey('email'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.email_outlined,
                size: 40,
                color: HbColors.brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            l10n.authCreateAccount,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.authCustomerEmailSubtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Step indicator
          _buildStepIndicator(1),
          const SizedBox(height: 32),

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _sendOtp(),
            decoration: _inputDecoration(
              label: l10n.authEmailLabel,
              hint: l10n.authEmailHint,
              icon: Icons.email_outlined,
            ),
          ),
          const SizedBox(height: 24),

          // Continue button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      l10n.authReceiveCode,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          const SizedBox(height: 32),

          // Business account link
          Center(
            child: TextButton(
              onPressed: () => context.pushReplacement('/register/business'),
              child: Text(
                l10n.authCreateBusinessAccount,
                style: const TextStyle(
                  color: HbColors.brandPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.authAlreadyHaveAccount} ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.authLoginSubmit,
                  style: const TextStyle(
                    color: HbColors.brandPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final l10n = context.l10n;

    return SingleChildScrollView(
      key: const ValueKey('otp'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sms_outlined,
                size: 40,
                color: HbColors.brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            l10n.authVerificationTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.authOtpSubtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text.trim(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: HbColors.textSlate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Step indicator
          _buildStepIndicator(2),
          const SizedBox(height: 32),

          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 48,
                height: 56,
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onOtpKeyPressed(index, event),
                  child: TextFormField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    enabled: !_isLoading,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textSlate,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                          color: HbColors.brandPrimary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: (value) => _onOtpDigitChanged(index, value),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),

          // Verify Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      l10n.authOtpVerify,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Resend Code
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.authOtpNotReceived,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 4),
              if (_otpCooldownSeconds > 0)
                Text(
                  l10n.authOtpResendIn(_otpCooldownSeconds),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                TextButton(
                  onPressed: _isLoading ? null : _resendOtp,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l10n.authOtpResend,
                    style: const TextStyle(
                      color: HbColors.brandPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Back button
          Center(
            child: TextButton.icon(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(l10n.authEditEmail),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormStep() {
    final l10n = context.l10n;

    return SingleChildScrollView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_add,
                  size: 40,
                  color: HbColors.brandPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              l10n.authYourInformationTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: HbColors.textSlate,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  _emailController.text.trim(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Step indicator
            _buildStepIndicator(3),
            const SizedBox(height: 32),

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
                      if (value == null || value.isEmpty) {
                        return l10n.authRequired;
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
                      if (value == null || value.isEmpty) {
                        return l10n.authRequired;
                      }
                      return null;
                    },
                  ),
                ),
              ],
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
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authPasswordCreateRequired;
                }
                if (value.length < 8) {
                  return l10n.authPasswordMinLength;
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return l10n.authPasswordNeedsUppercase;
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return l10n.authPasswordNeedsNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CompactPasswordStrengthIndicator(
              password: _passwordController.text,
            ),
            const SizedBox(height: 16),

            // Confirm password field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleRegister(),
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
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
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
            const SizedBox(height: 20),

            // Marketing-consent checkbox (opt-in, optional).
            // Sent to backend as the `newsletter` field on /auth/register.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _acceptMarketing,
                    onChanged: (value) {
                      setState(() => _acceptMarketing = value ?? false);
                    },
                    activeColor: HbColors.brandPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.authMarketingOptIn,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Terms checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() => _acceptTerms = value ?? false);
                    },
                    activeColor: HbColors.brandPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      children: [
                        TextSpan(text: l10n.authRegisterTermsPrefix),
                        TextSpan(
                          text: l10n.legalTerms,
                          style: const TextStyle(
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => LegalLinks.open(
                                  context,
                                  LegalDocument.terms,
                                ),
                        ),
                        TextSpan(text: l10n.authRegisterTermsConnector),
                        TextSpan(
                          text: l10n.legalPrivacy,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Register button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
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
                        l10n.authRegisterCreateMyAccount,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepDot(1, currentStep >= 1, l10n.authStepEmail),
        _buildStepLine(currentStep >= 2),
        _buildStepDot(2, currentStep >= 2, l10n.authStepCode),
        _buildStepLine(currentStep >= 3),
        _buildStepDot(3, currentStep >= 3, l10n.authStepInfo),
      ],
    );
  }

  Widget _buildStepDot(int step, bool isActive, String label) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? HbColors.brandPrimary : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive && step < _currentStep.index + 1
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '$step',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? HbColors.brandPrimary : Colors.grey[500],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? HbColors.brandPrimary : Colors.grey[300],
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
        borderSide: const BorderSide(color: HbColors.brandPrimary, width: 2),
      ),
    );
  }
}
