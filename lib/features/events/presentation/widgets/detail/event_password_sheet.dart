import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../memberships/domain/exceptions/members_only_exception.dart';
import '../../../../petit_boo/presentation/widgets/animated_toast.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/exceptions/event_password_exceptions.dart';

class EventPasswordSheet extends ConsumerStatefulWidget {
  final String identifier;
  final Future<Event> Function(String password) onSubmit;
  final String? eventTitle;

  const EventPasswordSheet({
    super.key,
    required this.identifier,
    required this.onSubmit,
    this.eventTitle,
  });

  static Future<Event?> show(
    BuildContext context, {
    required String identifier,
    required Future<Event> Function(String password) onSubmit,
    String? eventTitle,
  }) {
    return showModalBottomSheet<Event>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: EventPasswordSheet(
          identifier: identifier,
          onSubmit: onSubmit,
          eventTitle: eventTitle,
        ),
      ),
    );
  }

  @override
  ConsumerState<EventPasswordSheet> createState() => _EventPasswordSheetState();
}

class _EventPasswordSheetState extends ConsumerState<EventPasswordSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  String? _error;
  int _attempts = 0;
  bool _submitting = false;
  int _retryCountdown = 0;
  Timer? _countdownTimer;
  MembersOnlyException? _membersOnlyError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    setState(() => _retryCountdown = seconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_retryCountdown <= 1) {
        timer.cancel();
        setState(() => _retryCountdown = 0);
      } else {
        setState(() => _retryCountdown--);
      }
    });
  }

  Future<void> _submit() async {
    if (_submitting || _retryCountdown > 0) return;

    final pw = _controller.text;
    if (pw.isEmpty) {
      setState(() => _error = 'Le mot de passe est requis.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final event = await widget.onSubmit(pw);
      if (mounted) Navigator.of(context).pop(event);
    } on InvalidEventPasswordException {
      _attempts++;
      _shakeController.forward(from: 0);
      HapticFeedback.heavyImpact();
      _controller.clear();
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'Mot de passe incorrect.';
      });
    } on EventPasswordRateLimitedException catch (e) {
      if (!mounted) return;
      _startCountdown(e.retryAfter.inSeconds);
      setState(() {
        _submitting = false;
        _error = null;
      });
    } on MembersOnlyException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _membersOnlyError = e;
      });
    } on EventNotProtectedException {
      if (mounted) Navigator.of(context).pop(null);
    } on EventValidationException {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'Format invalide.';
      });
    } on EventNotFoundException {
      if (!mounted) return;
      Navigator.of(context).pop(null);
      PetitBooToast.error(context, 'Événement introuvable.');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'Erreur réseau. Réessaie.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: safeBottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (_membersOnlyError != null)
                _buildMembersOnlyBody(_membersOnlyError!)
              else
                _buildPasswordBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordBody() {
    final showWarning = _attempts >= 3 && _retryCountdown == 0;
    final countdownActive = _retryCountdown > 0;
    final buttonLabel = countdownActive
        ? 'Réessaye dans ${_retryCountdown}s'
        : (_submitting ? 'Vérification...' : 'Déverrouiller');
    final buttonEnabled = !_submitting && !countdownActive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cet événement est privé',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Entre le mot de passe communiqué par l\'organisateur.',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.eventTitle != null && widget.eventTitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_outlined, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      widget.eventTitle!,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        if (showWarning)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 18, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Encore 3 essais avant un délai de 1 minute.',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mot de passe',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (_, child) => Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  obscureText: true,
                  enabled: !_submitting && _retryCountdown == 0,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) {
                    if (_error != null) {
                      setState(() => _error = null);
                    }
                  },
                  style: GoogleFonts.montserrat(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Saisis le mot de passe',
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    errorText: _error,
                    errorStyle: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.red.shade600,
                    ),
                    filled: true,
                    fillColor:
                        _error != null ? Colors.red.shade50 : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _error != null
                            ? Colors.red.shade400
                            : Colors.grey.shade300,
                        width: _error != null ? 2 : 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _error != null
                            ? Colors.red.shade400
                            : HbColors.brandPrimary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Annuler',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: buttonEnabled ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          buttonLabel,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersOnlyBody(MembersOnlyException ex) {
    final orgName = ex.organization.name.isNotEmpty
        ? ex.organization.name
        : (ex.organization.organizationName ?? '');
    final orgSlug = ex.organization.slug ?? ex.organization.uuid ?? '';
    final title = widget.eventTitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.group,
                  size: 22,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Réservé aux membres',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'L\'événement '),
                if (title != null && title.isNotEmpty) ...[
                  TextSpan(
                    text: title,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: ' '),
                ],
                const TextSpan(text: 'est réservé aux membres de '),
                TextSpan(
                  text: orgName.isNotEmpty ? orgName : 'cette organisation',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text: '. Rejoins la communauté pour y accéder.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Fermer',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: orgSlug.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop(null);
                          context.push('/organizers/$orgSlug');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Voir l\'organisateur',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
