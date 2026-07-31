import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/profile_api_datasource.dart';
import '../utils/profile_image_picker_error.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _membershipCityController = TextEditingController();
  DateTime? _birthDate;

  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  File? _selectedImage;
  String? _errorMessage;

  late final String? _ownerAccountId;
  int _sessionGeneration = 0;
  bool _sessionInvalidated = false;
  bool _exitScheduled = false;

  CancelToken? _profileMutationCancelToken;
  CancelToken? _avatarMutationCancelToken;
  CancelToken? _passwordMutationCancelToken;
  TextEditingController? _currentPasswordController;
  TextEditingController? _newPasswordController;
  TextEditingController? _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _ownerAccountId = ref.read(authSessionUserIdProvider);
    _initializeFields();
    ref.listenManual<String?>(authSessionUserIdProvider, (previous, next) {
      if (next != _ownerAccountId) {
        _invalidateSession();
      }
    });
  }

  void _initializeFields() {
    final user = ref.read(authProvider).user;
    if (user != null &&
        _ownerAccountId != null &&
        user.id.trim() == _ownerAccountId) {
      // Try to get firstName/lastName from user fields first
      String firstName = user.firstName ?? '';
      String lastName = user.lastName ?? '';

      // If both are empty but displayName exists, try to parse it
      if (firstName.isEmpty &&
          lastName.isEmpty &&
          user.displayName.isNotEmpty) {
        final parts = user.displayName.trim().split(' ');
        if (parts.isNotEmpty) {
          firstName = parts.first;
          if (parts.length > 1) {
            lastName = parts.skip(1).join(' ');
          }
        }
      }

      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _phoneController.text = user.phone ?? '';
      _membershipCityController.text = user.membershipCity ?? '';
      _birthDate = user.birthDate;
    }
  }

  @override
  void dispose() {
    _sessionGeneration++;
    _cancelOutstandingMutations();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _membershipCityController.dispose();
    super.dispose();
  }

  bool _ownsSession(String? ownerAccountId, int generation) {
    return mounted &&
        !_sessionInvalidated &&
        ownerAccountId != null &&
        ownerAccountId == _ownerAccountId &&
        generation == _sessionGeneration &&
        ref.read(authSessionUserIdProvider) == ownerAccountId;
  }

  bool _isCancellation(Object error) {
    return error is DioException && CancelToken.isCancel(error);
  }

  void _invalidateSession({bool rebuild = true}) {
    if (_sessionInvalidated) return;
    _sessionInvalidated = true;
    _sessionGeneration++;
    _cancelOutstandingMutations();
    _clearSensitiveDraft();
    if (rebuild && mounted) setState(() {});
    _scheduleFailClosedExit();
  }

  void _clearSensitiveDraft() {
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _membershipCityController.clear();
    _currentPasswordController?.clear();
    _newPasswordController?.clear();
    _confirmPasswordController?.clear();
    _birthDate = null;
    _selectedImage = null;
    _errorMessage = null;
    _isLoading = false;
    _isUploadingAvatar = false;
  }

  void _cancelOutstandingMutations() {
    _profileMutationCancelToken?.cancel('Authentication session changed');
    _avatarMutationCancelToken?.cancel('Authentication session changed');
    _passwordMutationCancelToken?.cancel('Authentication session changed');
    _profileMutationCancelToken = null;
    _avatarMutationCancelToken = null;
    _passwordMutationCancelToken = null;
  }

  void _scheduleFailClosedExit() {
    if (_exitScheduled || !mounted) return;
    _exitScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_currentPasswordController != null) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
          return;
        }
        try {
          GoRouter.of(context).go('/');
        } catch (_) {
          // A standalone widget host may not provide GoRouter. The screen is
          // still fail-closed below and contains no previous-account data.
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_ownerAccountId == null ||
        currentAccountId != _ownerAccountId ||
        _sessionInvalidated) {
      if (!_sessionInvalidated) {
        _invalidateSession(rebuild: false);
      }
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.profileAccountTitle)),
        body: Center(child: Text(context.l10n.profileLoginRequired)),
      );
    }

    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null || user.id.trim() != _ownerAccountId) {
      if (!_sessionInvalidated) {
        _invalidateSession(rebuild: false);
      }
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.profileAccountTitle)),
        body: Center(child: Text(context.l10n.profileLoginRequired)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(context.l10n.profileAccountTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar Section
                _buildAvatarSection(user),
                const SizedBox(height: 24),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Form Fields
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.profilePersonalInfoTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textSlate,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        fieldKey: const ValueKey('profile-edit-first-name'),
                        controller: _firstNameController,
                        label: context.l10n.profileFirstNameLabel,
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.profileFirstNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        fieldKey: const ValueKey('profile-edit-last-name'),
                        controller: _lastNameController,
                        label: context.l10n.profileLastNameLabel,
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.profileLastNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        fieldKey: const ValueKey('profile-edit-phone'),
                        controller: _phoneController,
                        label: context.l10n.profilePhoneLabel,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      // Birth date
                      GestureDetector(
                        onTap: () async {
                          final ownerAccountId = _ownerAccountId;
                          final generation = _sessionGeneration;
                          if (!_ownsSession(ownerAccountId, generation)) return;
                          final maxDate = DateTime.now()
                              .subtract(const Duration(days: 15 * 365));
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _birthDate ?? maxDate,
                            firstDate: DateTime(1920),
                            lastDate: maxDate,
                            helpText: context.l10n.profileBirthDateLabel,
                            // locale: const Locale('fr'),
                          );
                          if (!_ownsSession(ownerAccountId, generation)) return;
                          if (picked != null) {
                            setState(() => _birthDate = picked);
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _birthDate != null
                                  ? context
                                      .appDateFormat(
                                        'dd/MM/yyyy',
                                        enPattern: 'MM/dd/yyyy',
                                      )
                                      .format(_birthDate!)
                                  : '',
                            ),
                            decoration: InputDecoration(
                              labelText: context.l10n.profileBirthDateLabel,
                              hintText: context.l10n.profileBirthDateUnset,
                              prefixIcon: const Icon(Icons.cake_outlined,
                                  color: HbColors.brandPrimary),
                              suffixIcon: _birthDate != null
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () =>
                                          setState(() => _birthDate = null),
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: HbColors.brandPrimary, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Membership city
                      _buildTextField(
                        fieldKey:
                            const ValueKey('profile-edit-membership-city'),
                        controller: _membershipCityController,
                        label: context.l10n.profileCityLabel,
                        icon: Icons.location_city_outlined,
                      ),
                      const SizedBox(height: 16),
                      // Email (read-only)
                      _buildTextField(
                        initialValue: user.email,
                        label: context.l10n.authEmailLabel,
                        icon: Icons.email_outlined,
                        enabled: false,
                        helperText: context.l10n.profileEmailReadOnlyHelper,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    key: const ValueKey('profile-edit-save'),
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HbColors.brandPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            context.l10n.commonSave,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Change Password Link
                TextButton.icon(
                  key: const ValueKey('profile-change-password'),
                  onPressed: () => _showChangePasswordDialog(),
                  icon: const Icon(Icons.lock_outline, size: 20),
                  label: Text(context.l10n.profileChangePasswordCta),
                  style: TextButton.styleFrom(
                    foregroundColor: HbColors.brandPrimary,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(user) {
    final avatarUrl = user.avatarUrl;
    final displayName = user.displayName.isNotEmpty
        ? user.displayName
        : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
    final initials = displayName.isNotEmpty
        ? displayName
            .split(' ')
            .take(2)
            .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
            .join()
        : 'U';

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
            ),
            child: _isUploadingAvatar
                ? const Center(
                    child: CircularProgressIndicator(
                      color: HbColors.brandPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : avatarUrl != null && avatarUrl.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: avatarUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: HbColors.brandPrimary,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildDefaultAvatar(initials),
                            ),
                          )
                        : _buildDefaultAvatar(initials),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: HbColors.brandPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: _pickImage,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(String initials) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: HbColors.brandPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    Key? fieldKey,
    TextEditingController? controller,
    String? initialValue,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? helperText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, color: HbColors.brandPrimary),
        filled: true,
        fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: HbColors.brandPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ownerAccountId = _ownerAccountId;
    final generation = _sessionGeneration;
    if (!_ownsSession(ownerAccountId, generation)) return;
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (!_ownsSession(ownerAccountId, generation) || pickedFile == null) {
        return;
      }
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadAvatar(
        ownerAccountId: ownerAccountId!,
        generation: generation,
      );
    } on PlatformException catch (error) {
      if (!_ownsSession(ownerAccountId, generation)) return;
      _setImagePickerError(classifyProfileImagePickerFailure(error));
    } catch (_) {
      if (!_ownsSession(ownerAccountId, generation)) return;
      _setImagePickerError(ProfileImagePickerFailure.pickerUnavailable);
    }
  }

  void _setImagePickerError(ProfileImagePickerFailure failure) {
    setState(() {
      _errorMessage = switch (failure) {
        ProfileImagePickerFailure.permissionDenied =>
          context.l10n.profilePhotoPermissionDenied,
        ProfileImagePickerFailure.pickerUnavailable =>
          context.l10n.profilePhotoPickerFailed,
      };
    });
  }

  Future<void> _uploadAvatar({
    required String ownerAccountId,
    required int generation,
  }) async {
    final selectedImage = _selectedImage;
    if (selectedImage == null || !_ownsSession(ownerAccountId, generation)) {
      return;
    }

    final cancelToken = CancelToken();
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    _avatarMutationCancelToken?.cancel('Superseded avatar upload');
    _avatarMutationCancelToken = cancelToken;

    setState(() {
      _isUploadingAvatar = true;
      _errorMessage = null;
    });

    try {
      final previousAvatarUrl = ref.read(authProvider).user?.avatarUrl;
      final profileDataSource = ref.read(profileApiDataSourceProvider);
      final updatedUser = await profileDataSource.uploadAvatar(
        selectedImage,
        cancelToken: cancelToken,
      );
      if (!_ownsSession(ownerAccountId, generation) ||
          !identical(_avatarMutationCancelToken, cancelToken)) {
        return;
      }

      // Evict the old avatar from CachedNetworkImage's disk + memory caches
      // so we don't keep showing the previous picture if the backend reuses
      // the same URL for the new upload.
      if (previousAvatarUrl != null && previousAvatarUrl.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(previousAvatarUrl);
        if (!_ownsSession(ownerAccountId, generation)) return;
      }
      if (updatedUser.avatarUrl != null && updatedUser.avatarUrl!.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(updatedUser.avatarUrl!);
        if (!_ownsSession(ownerAccountId, generation)) return;
      }

      // Update auth state and persist to secure storage
      ref.read(authProvider.notifier).updateUser(updatedUser);

      if (!mounted) return;
      if (_ownsSession(ownerAccountId, generation)) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.profileAvatarUpdated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (_ownsSession(ownerAccountId, generation) && !_isCancellation(e)) {
        setState(() {
          _errorMessage = ApiResponseHandler.extractError(
            e,
            fallback: l10n.profileAvatarUploadFailed,
          );
        });
      }
    } finally {
      if (identical(_avatarMutationCancelToken, cancelToken)) {
        _avatarMutationCancelToken = null;
      }
      if (_ownsSession(ownerAccountId, generation)) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  Future<void> _handleSave() async {
    final ownerAccountId = _ownerAccountId;
    final generation = _sessionGeneration;
    if (!_ownsSession(ownerAccountId, generation)) return;
    if (!_formKey.currentState!.validate()) return;

    final cancelToken = CancelToken();
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    _profileMutationCancelToken?.cancel('Superseded profile update');
    _profileMutationCancelToken = cancelToken;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profileDataSource = ref.read(profileApiDataSourceProvider);
      final user = ref.read(authProvider).user;
      final updatedUser = await profileDataSource.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        birthDate: _birthDate != null
            ? '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}'
            : null,
        clearBirthDate: _birthDate == null && user?.birthDate != null,
        membershipCity: _membershipCityController.text.trim().isNotEmpty
            ? _membershipCityController.text.trim()
            : null,
        clearMembershipCity: _membershipCityController.text.trim().isEmpty &&
            (user?.membershipCity ?? '').isNotEmpty,
        cancelToken: cancelToken,
      );
      if (!_ownsSession(ownerAccountId, generation) ||
          !identical(_profileMutationCancelToken, cancelToken)) {
        return;
      }

      // Update auth state with new user data
      ref.read(authProvider.notifier).updateUser(updatedUser);

      if (!mounted) return;
      if (_ownsSession(ownerAccountId, generation)) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdateSuccess),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (_ownsSession(ownerAccountId, generation) && !_isCancellation(e)) {
        setState(() {
          _errorMessage = ApiResponseHandler.extractError(
            e,
            fallback: l10n.profileUpdateFailed,
          );
        });
      }
    } finally {
      if (identical(_profileMutationCancelToken, cancelToken)) {
        _profileMutationCancelToken = null;
      }
      if (_ownsSession(ownerAccountId, generation)) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showChangePasswordDialog() {
    final ownerAccountId = _ownerAccountId;
    final generation = _sessionGeneration;
    if (!_ownsSession(ownerAccountId, generation) ||
        _currentPasswordController != null) {
      return;
    }

    final l10n = context.l10n;
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    _currentPasswordController = currentPasswordController;
    _newPasswordController = newPasswordController;
    _confirmPasswordController = confirmPasswordController;
    bool isLoading = false;

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => _DisposeTextControllers(
        controllers: [
          currentPasswordController,
          newPasswordController,
          confirmPasswordController,
        ],
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.profileChangePasswordTitle),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    key: const ValueKey('profile-current-password'),
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.profileCurrentPasswordLabel,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const ValueKey('profile-new-password'),
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.profileNewPasswordLabel,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const ValueKey('profile-confirm-password'),
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.authConfirmPasswordLabel,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.commonCancel,
                    style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                key: const ValueKey('profile-change-password-submit'),
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!_ownsSession(ownerAccountId, generation)) {
                          if (context.mounted) Navigator.pop(context);
                          return;
                        }
                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.authPasswordsDoNotMatch),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final currentPassword = currentPasswordController.text;
                        final newPassword = newPasswordController.text;
                        final confirmPassword = confirmPasswordController.text;
                        final cancelToken = CancelToken();
                        _passwordMutationCancelToken?.cancel(
                          'Superseded password update',
                        );
                        _passwordMutationCancelToken = cancelToken;
                        setDialogState(() => isLoading = true);

                        try {
                          final profileDataSource =
                              ref.read(profileApiDataSourceProvider);
                          await profileDataSource.updatePassword(
                            currentPassword: currentPassword,
                            newPassword: newPassword,
                            confirmPassword: confirmPassword,
                            cancelToken: cancelToken,
                          );

                          if (!mounted) return;
                          if (_ownsSession(ownerAccountId, generation) &&
                              identical(
                                _passwordMutationCancelToken,
                                cancelToken,
                              ) &&
                              context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(l10n.profilePasswordChangeSuccess),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (_ownsSession(ownerAccountId, generation) &&
                              !_isCancellation(e) &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(ApiResponseHandler.extractError(
                                  e,
                                  fallback: l10n.profilePasswordChangeFailed,
                                )),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } finally {
                          if (identical(
                            _passwordMutationCancelToken,
                            cancelToken,
                          )) {
                            _passwordMutationCancelToken = null;
                          }
                          if (_ownsSession(ownerAccountId, generation) &&
                              context.mounted) {
                            setDialogState(() => isLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(l10n.profileChangePasswordSubmit),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      if (identical(_currentPasswordController, currentPasswordController)) {
        _currentPasswordController = null;
      }
      if (identical(_newPasswordController, newPasswordController)) {
        _newPasswordController = null;
      }
      if (identical(_confirmPasswordController, confirmPasswordController)) {
        _confirmPasswordController = null;
      }
    }));
  }
}

class _DisposeTextControllers extends StatefulWidget {
  const _DisposeTextControllers({
    required this.controllers,
    required this.child,
  });

  final List<TextEditingController> controllers;
  final Widget child;

  @override
  State<_DisposeTextControllers> createState() =>
      _DisposeTextControllersState();
}

class _DisposeTextControllersState extends State<_DisposeTextControllers> {
  @override
  void dispose() {
    for (final controller in widget.controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
