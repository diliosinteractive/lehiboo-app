import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

/// A modal that gates guest-restricted actions behind authentication.
///
/// Login happens **inline** so the user can resume the action that
/// triggered the modal — favoriting an event, posting a review, etc. —
/// without losing any in-flight UI state to a navigation push.
///
/// Returns `true` from [show] when the user is now authenticated and the
/// caller should proceed; `false` when the user dismissed without
/// signing in (or the login required OTP, which we hand off to the
/// dedicated OTP screen).
class GuestRestrictionDialog extends ConsumerStatefulWidget {
  final String featureName;

  const GuestRestrictionDialog({super.key, required this.featureName});

  static Future<bool> show(
    BuildContext context, {
    required String featureName,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => GuestRestrictionDialog(featureName: featureName),
    );
    return result ?? false;
  }

  @override
  ConsumerState<GuestRestrictionDialog> createState() =>
      _GuestRestrictionDialogState();
}

class _GuestRestrictionDialogState
    extends ConsumerState<GuestRestrictionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  // Guard against double-pops when both _submit and the auth-state listener
  // race to dismiss the dialog (e.g. inline login completes and the
  // listener also fires for the same status flip).
  bool _didPop = false;
  // Captured in didChangeDependencies so the listener can pop everything
  // above the dialog (e.g. register / OTP screens the user pushed) and
  // then pop the dialog itself, leaving the original screen on top.
  Route<dynamic>? _ownRoute;

  @override
  void initState() {
    super.initState();
    // Mark that a guest-guard dialog is active. Authentication screens
    // check this flag in their success handlers to skip context.go('/')
    // so they don't blow away the navigation stack the dialog sits on.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(guestGuardActiveProvider.notifier).state = true;
    });

    // Listen for ANY transition to authenticated — covers both the inline
    // login path AND the "Créer un compte" path where the user goes
    // through /register, completes registration, and ends up
    // authenticated. As soon as that happens, pop everything above the
    // dialog and then pop the dialog itself with `true` so the original
    // gated action resumes on the underlying screen.
    ref.listenManual<bool>(isAuthenticatedProvider, (prev, next) {
      if (next && (prev != true) && mounted && !_didPop) {
        _resumeOriginalScreen();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ownRoute ??= ModalRoute.of(context);
  }

  @override
  void dispose() {
    // Always clear the flag — even if we navigated away mid-flow.
    Future.microtask(() {
      ref.read(guestGuardActiveProvider.notifier).state = false;
    });
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _safePop(bool result) {
    if (_didPop || !mounted) return;
    _didPop = true;
    Navigator.of(context).pop(result);
  }

  /// Pops every route above the dialog (register, OTP, etc.) and then
  /// pops the dialog itself with `true`. Leaves the original gated
  /// screen on top so its pending `await GuestGuard.check(...)` resumes
  /// and the original action (e.g. navigation to checkout) fires.
  void _resumeOriginalScreen() {
    if (_didPop || !mounted) return;
    _didPop = true;
    final navigator = Navigator.of(context);
    final ownRoute = _ownRoute;
    if (ownRoute != null) {
      // popUntil stops AT the dialog (does not pop it).
      navigator.popUntil((route) => route == ownRoute);
    }
    // Now pop the dialog itself, completing the GuestGuard.check future.
    navigator.pop(true);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    // Login required OTP — we can't render the OTP flow inline cleanly,
    // so close the dialog and hand off to the dedicated OTP screen. The
    // caller gets `false` and won't auto-resume; the user finishes the
    // OTP flow on its own screen.
    if (result?.requiresOtp == true) {
      // Hand off to the dedicated OTP screen. The auth-state listener
      // will pop the dialog with `true` once OTP verification succeeds
      // and the user actually becomes authenticated.
      context.push('/verify-otp');
      setState(() => _isSubmitting = false);
      return;
    }

    // Auth flip will trigger the listener which calls _resumeOriginalScreen.
    // No need to pop here ourselves — the listener handles it idempotently.
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    if (isAuthenticated) {
      // Belt-and-suspenders in case the listener somehow missed the change.
      _resumeOriginalScreen();
      return;
    }

    setState(() {
      _isSubmitting = false;
      _errorMessage = ref.read(authProvider).errorMessage ??
          'Identifiants incorrects. Réessayez.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildTitle(),
                      const SizedBox(height: 12),
                      _buildSubtitle(),
                      const SizedBox(height: 24),
                      _buildEmailField(),
                      const SizedBox(height: 12),
                      _buildPasswordField(),
                      _buildForgotPasswordLink(),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        _buildError(_errorMessage!),
                      ],
                      const SizedBox(height: 24),
                      _buildSubmitButton(),
                      const SizedBox(height: 16),
                      _buildSecondaryActions(),
                      const SizedBox(height: 6),
                      _buildEncouragement(),
                    ],
                  ),
                ),
              ),
              // Close X — top-right. Same dismissal semantics as the
              // removed "Plus tard": pops the dialog with `false`,
              // signalling "user dismissed without authenticating".
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  tooltip: 'Fermer',
                  icon: const Icon(Icons.close, color: Color(0xFF718096)),
                  onPressed: _isSubmitting ? null : () => _safePop(false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: AssetImage('assets/images/logo_picto_lehiboo.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: const Color(0xFFFF601F).withOpacity(0.1),
        ),
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildTitle() {
    return const Text(
      'Connectez-vous !',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A202C),
        letterSpacing: -0.5,
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).moveY(begin: 10, end: 0);
  }

  Widget _buildSubtitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF718096),
          height: 1.4,
        ),
        children: [
          const TextSpan(text: 'Connectez-vous pour '),
          TextSpan(
            text: widget.featureName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).moveY(begin: 10, end: 0);
  }

  /// Encouragement line moved out of the subtitle and rendered below the
  /// "Créer un compte" button so the layout reads top-to-bottom: gated
  /// feature → login → register CTA → reassurance.
  Widget _buildEncouragement() {
    return const Text(
      "Cela ne prend que 2 minutes et c'est gratuit !",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 13,
        color: Color(0xFFFF601F),
      ),
    ).animate().fadeIn(delay: 450.ms, duration: 400.ms);
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      enabled: !_isSubmitting,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email, AutofillHints.username],
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        label: 'Email',
        icon: Icons.email_outlined,
      ),
      validator: (value) {
        final v = value?.trim() ?? '';
        if (v.isEmpty) return 'Email requis';
        if (!v.contains('@') || !v.contains('.')) return 'Email invalide';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      enabled: !_isSubmitting,
      obscureText: _obscurePassword,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(),
      decoration: _inputDecoration(
        label: 'Mot de passe',
        icon: Icons.lock_outline,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF718096),
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Mot de passe requis';
        return null;
      },
    );
  }

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: Color(0xFFB91C1C)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF601F),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFFF601F).withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _isSubmitting ? null : _onForgotPasswordTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF601F),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Mot de passe oublié ?',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onForgotPasswordTap() {
    if (_isSubmitting || _didPop) return;
    final email = _emailController.text.trim();
    final uri = email.isEmpty
        ? '/forgot-password'
        : '/forgot-password?email=${Uri.encodeComponent(email)}';
    _safePop(false);
    context.push(uri);
  }

  Widget _buildSecondaryActions() {
    // Centered single-CTA. The "Plus tard" escape hatch moved to the
    // close icon at the dialog's top-left so the primary alternative
    // path ("Créer un compte") gets the visual focus.
    return Center(
      child: TextButton(
        // Push register on top of the dialog instead of popping it. When
        // the user finishes registration and becomes authenticated, the
        // auth-state listener in initState pops the dialog with `true`
        // so the original gated action resumes.
        onPressed: _isSubmitting ? null : () => context.push('/register'),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF601F),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: const Text(
          'Créer un compte',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF718096)),
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF601F), width: 1.5),
      ),
    );
  }
}
