// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Le Hiboo';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navMap => 'Map';

  @override
  String get navBookings => 'Bookings';

  @override
  String get guestFeatureBookings => 'view my bookings';

  @override
  String get guestFeaturePetitBoo => 'chat with Petit Boo';

  @override
  String get guestFeatureViewMessages => 'view your messages';

  @override
  String get guestFeatureSendMessage => 'send a message';

  @override
  String get guestFeatureViewFavorites => 'view your favorites';

  @override
  String get guestFeatureViewNotifications => 'view your notifications';

  @override
  String get guestFeatureAccessProfile => 'access your profile';

  @override
  String get guestFeatureViewConversation => 'view this conversation';

  @override
  String get guestFeatureManageFavorites => 'manage favorites';

  @override
  String get guestFeatureWriteReview => 'write a review';

  @override
  String get guestFeatureReportReview => 'report a review';

  @override
  String get guestFeatureSaveSearch => 'save a search';

  @override
  String get guestFeatureAskQuestion => 'ask a question';

  @override
  String get guestFeatureVoteQuestion => 'vote for this question';

  @override
  String get guestFeatureJoinOrganizer => 'join this organizer';

  @override
  String get guestFeatureFollowOrganizer => 'follow this organizer';

  @override
  String get guestFeatureContactOrganizer => 'contact an organizer';

  @override
  String get guestFeatureContactThisOrganizer => 'contact this organizer';

  @override
  String get guestFeatureViewCoordinates => 'view contact details';

  @override
  String get guestFeatureEnableReminder => 'turn on a reminder';

  @override
  String get guestFeatureBookActivity => 'book an activity';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsSectionApplication => 'Application';

  @override
  String get settingsSectionLegal => 'Legal information';

  @override
  String get settingsSectionInformation => 'Information';

  @override
  String get settingsPushReward => 'Turn on notifications to earn 30 Hibons';

  @override
  String get settingsPushTitle => 'Push notifications';

  @override
  String get settingsPushSubtitle => 'Receive alerts on your phone';

  @override
  String get settingsNewsletterTitle => 'Newsletter';

  @override
  String get settingsNewsletterSubtitle =>
      'Event recommendations and deals by email';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageDialogTitle => 'Choose language';

  @override
  String settingsLanguageSubtitle(String language) {
    return '$language';
  }

  @override
  String get languageFrench => 'French';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsResetOnboardingTitle => 'Replay introduction';

  @override
  String get settingsResetOnboardingSubtitle => 'Restart the welcome tutorial';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsResetDialogTitle => 'Restart onboarding?';

  @override
  String get settingsResetDialogContent =>
      'Do you really want to replay the welcome screens? This will temporarily take you away from the home screen.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRestart => 'Restart';

  @override
  String get commonToday => 'Today';

  @override
  String get commonTomorrow => 'Tomorrow';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonThisWeekend => 'This weekend';

  @override
  String get commonFree => 'Free';

  @override
  String get commonUndefinedDate => 'Date not set';

  @override
  String get settingsPushPermissionRequired =>
      'Notification permission required';

  @override
  String get settingsUpdateFailed => 'Update failed';

  @override
  String get legalTerms => 'Terms of Use';

  @override
  String get legalSales => 'Terms of Sale';

  @override
  String get legalPrivacy => 'Privacy Policy';

  @override
  String get legalCookies => 'Cookie Policy';

  @override
  String get legalNotices => 'Legal Notice';

  @override
  String legalOpenFailed(String documentLabel) {
    return 'Could not open $documentLabel';
  }

  @override
  String get voiceTooltipHoldToTalk => 'Hold to talk';

  @override
  String voiceMicrophoneError(String message) {
    return 'Microphone error: $message';
  }

  @override
  String get voiceAllowMicrophoneSettings =>
      'Allow microphone access in Settings';

  @override
  String get voiceAllowSpeechSettings => 'Allow speech recognition in Settings';

  @override
  String get voiceMicrophoneUnavailable => 'The microphone is not available';

  @override
  String get voiceNothingHeard => 'I did not hear anything';

  @override
  String get petitBooChatHintListening => 'Listening...';

  @override
  String get petitBooChatHintStreaming => 'Petit Boo is thinking...';

  @override
  String get petitBooChatHintIdle =>
      'Ask your assistant a question or type / for commands...';

  @override
  String get petitBooDisclaimer =>
      'AI can make mistakes. Check important information.';

  @override
  String get bookingTicketSingular => '1 ticket';

  @override
  String bookingTicketPlural(int count) {
    return '$count tickets';
  }

  @override
  String get bookingLifecycleCancelled => 'Cancelled';

  @override
  String get bookingLifecyclePast => 'Past';

  @override
  String get bookingLifecycleUpcoming => 'Upcoming';

  @override
  String broadcastSentOn(String date) {
    return 'Sent on $date';
  }

  @override
  String broadcastCreatedOn(String date) {
    return 'Created on $date';
  }

  @override
  String adminReportReviewedBy(Object name) {
    return 'Reviewed by $name';
  }

  @override
  String adminReportReviewedByOn(Object date, Object name) {
    return 'Reviewed by $name on $date';
  }

  @override
  String get membershipMember => 'Member';

  @override
  String membershipMemberSince(Object date) {
    return 'Member since $date';
  }

  @override
  String get membershipRequestSent => 'Request sent';

  @override
  String membershipRequestSentOn(Object date) {
    return 'Request sent on $date';
  }

  @override
  String get membershipRequestRejected => 'Request not accepted';

  @override
  String membershipRequestRejectedOn(Object date) {
    return 'Request from $date - not accepted';
  }

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'your@email.com';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authEmailRequired => 'Please enter your email';

  @override
  String get authEmailInvalid => 'Please enter a valid email';

  @override
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get authEmailRequiredShort => 'Email is required';

  @override
  String get authEmailInvalidShort => 'Invalid email';

  @override
  String get authPasswordRequiredShort => 'Password is required';

  @override
  String get authLoginTitle => 'Welcome to Le Hiboo!';

  @override
  String get authLoginSubtitle => 'Sign in to discover events near you';

  @override
  String get authForgotPasswordLink => 'Forgot password?';

  @override
  String get authLoginSubmit => 'Sign in';

  @override
  String get authLoginNoAccount => 'Don\'t have an account yet?';

  @override
  String get authCreateAccount => 'Create an account';

  @override
  String get authContinueAsGuest => 'Continue without an account';

  @override
  String get authForgotPasswordTitle => 'Forgot password?';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get authForgotPasswordSubmit => 'Send link';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authForgotPasswordSuccessTitle => 'Email sent!';

  @override
  String get authForgotPasswordSuccessPrefix => 'We sent a reset link to';

  @override
  String get authForgotPasswordSuccessInfo =>
      'Check your inbox and spam folder. The link expires in 1 hour.';

  @override
  String get authForgotPasswordResend => 'Resend email';

  @override
  String get authOtpIncompleteCode => 'Please enter the full code';

  @override
  String get authOtpResent => 'A new code has been sent';

  @override
  String get authOtpTitle => 'Email verification';

  @override
  String get authOtpSubtitle => 'Enter the 6-digit code sent to';

  @override
  String get authOtpVerify => 'Verify';

  @override
  String get authOtpNotReceived => 'Didn\'t receive the code?';

  @override
  String authOtpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authOtpResend => 'Resend';

  @override
  String get authGuestIncorrectCredentials =>
      'Incorrect credentials. Try again.';

  @override
  String get authGuestTitle => 'Sign in';

  @override
  String authGuestSubtitle(String featureName) {
    return 'Sign in to $featureName.';
  }

  @override
  String get authGuestEncouragement =>
      'It only takes 2 minutes and it is free!';

  @override
  String get authRegisterTypeEyebrow => 'ACCOUNT TYPE';

  @override
  String get authRegisterTypeTitle => 'You are...';

  @override
  String get authRegisterTypeSubtitle =>
      'Select your profile to personalize your experience';

  @override
  String get authRegisterTypeCustomerTitle => 'An individual';

  @override
  String get authRegisterTypeCustomerDescription =>
      'I book activities for myself or people close to me.';

  @override
  String get authRegisterTypeBusinessTitle => 'An organization';

  @override
  String get authRegisterTypeBusinessDescription =>
      'Business, association, or public organization - I book for my team.';

  @override
  String get authRegisterTypeComingSoon => 'Coming soon';

  @override
  String get authRegisterCreateMyAccount => 'Create my account';

  @override
  String get authAlreadyHaveAccount => 'Already have an account?';

  @override
  String get authRegisterLegacySubtitle =>
      'Join LeHiboo so you do not miss anything';

  @override
  String get authFirstNameLabel => 'First name';

  @override
  String get authFirstNameHint => 'John';

  @override
  String get authLastNameLabel => 'Last name';

  @override
  String get authLastNameHint => 'Smith';

  @override
  String get authRequired => 'Required';

  @override
  String get authPasswordMinimumHint => 'Minimum 8 characters';

  @override
  String get authPasswordCreateRequired => 'Please enter a password';

  @override
  String get authPasswordMinLength =>
      'Password must contain at least 8 characters';

  @override
  String get authPasswordNeedsUppercase =>
      'Password must contain an uppercase letter';

  @override
  String get authPasswordNeedsNumber => 'Password must contain a number';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authConfirmPasswordHint => 'Retype your password';

  @override
  String get authConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authAcceptTermsRequired => 'Please accept the terms of use';

  @override
  String get authRegisterTermsPrefix => 'I accept the ';

  @override
  String get authRegisterTermsConnector => ' and the ';

  @override
  String get authPermissionReassurance =>
      'You can change this access at any time in Settings.';

  @override
  String get authPermissionLocationTitle => 'Find activities near you';

  @override
  String get authPermissionLocationIntro =>
      'LeHiboo Experiences uses your location to suggest the best nearby events.';

  @override
  String get authPermissionLocationBulletMap => 'See nearby events on the map';

  @override
  String get authPermissionLocationBulletSearch =>
      'Filter search based on your location';

  @override
  String get authPermissionLocationBulletSuggestions =>
      'Receive suggestions tailored to your city';

  @override
  String get authPermissionLocationGranted => 'Location already enabled';

  @override
  String get authPermissionAudioTitle => 'Talk to Petit Boo by voice';

  @override
  String get authPermissionAudioIntro =>
      'Enable the microphone to interact by voice with Petit Boo, our AI assistant for going out.';

  @override
  String get authPermissionAudioBulletQuestions =>
      'Ask questions by voice, without typing';

  @override
  String get authPermissionAudioBulletDictate => 'Dictate your messages faster';

  @override
  String get authPermissionAudioBulletHandsFree => 'Find activities hands-free';

  @override
  String get authPermissionAudioGranted => 'Microphone already enabled';

  @override
  String get authPermissionNotificationsTitle => 'Do not miss the best plans';

  @override
  String get authPermissionNotificationsIntro =>
      'Enable notifications to receive essentials directly on your phone.';

  @override
  String get authPermissionNotificationsBulletTickets =>
      'Your tickets and booking confirmations';

  @override
  String get authPermissionNotificationsBulletAlerts =>
      'Events that match your alerts';

  @override
  String get authPermissionNotificationsBulletFavorites =>
      'News from your favorite places';

  @override
  String get authPermissionNotificationsBulletReminders =>
      'Your reminders and personalized alerts';

  @override
  String get authPermissionNotificationsBulletMessages =>
      'Organizer replies to your messages';

  @override
  String get authPermissionNotificationsGranted =>
      'Notifications already enabled';
}
