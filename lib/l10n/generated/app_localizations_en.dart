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

  @override
  String get authEmailAddressInvalid => 'Please enter a valid email address';

  @override
  String get authOtpEmailVerified => 'Email verified!';

  @override
  String get authRegisterMissingVerificationToken =>
      'Verification token is missing. Please start again.';

  @override
  String get authCustomerAccountCreated => 'Account created successfully!';

  @override
  String get authCustomerEmailSubtitle =>
      'Start by verifying your email address';

  @override
  String get authReceiveCode => 'Receive code';

  @override
  String get authCreateBusinessAccount => 'Create a business account';

  @override
  String get authVerificationTitle => 'Verification';

  @override
  String get authEditEmail => 'Edit email';

  @override
  String get authYourInformationTitle => 'Your information';

  @override
  String get authPhoneOptionalLabel => 'Phone (optional)';

  @override
  String get authPhoneHint => '06 12 34 56 78';

  @override
  String get authPhoneInvalid => 'Invalid phone number';

  @override
  String get authBirthDateLabelOptional => 'Date of birth (optional)';

  @override
  String get authBirthDateHelp => 'Date of birth';

  @override
  String get authDateHint => 'MM/DD/YYYY';

  @override
  String get authCityOptionalLabel => 'City (optional)';

  @override
  String get authCityHint => 'London, Paris...';

  @override
  String get authMarketingOptIn =>
      'I want to receive Le Hiboo news and offers by email.';

  @override
  String get authStepEmail => 'Email';

  @override
  String get authStepCode => 'Code';

  @override
  String get authStepInfo => 'Info';

  @override
  String get authProfessionalEmailLabel => 'Business email';

  @override
  String get authProfessionalEmailHint => 'you@company.com';

  @override
  String get authValidationMin2Chars => 'Min. 2 characters';

  @override
  String get authValidationMin5Chars => 'Min. 5 characters';

  @override
  String get authPasswordMinLengthShort => 'Min. 8 characters';

  @override
  String get authPasswordNeedsUppercaseShort => 'Uppercase required';

  @override
  String get authPasswordNeedsNumberShort => 'Number required';

  @override
  String get authPasswordNeedsSpecialShort => 'Special character required';

  @override
  String get authPasswordStrengthWeak => 'Weak';

  @override
  String get authPasswordStrengthFair => 'Fair';

  @override
  String get authPasswordStrengthGood => 'Good';

  @override
  String get authPasswordStrengthStrong => 'Strong';

  @override
  String get authPasswordRequirementMin8 => 'At least 8 characters';

  @override
  String get authPasswordRequirementUppercase => 'One uppercase letter';

  @override
  String get authPasswordRequirementNumber => 'One number';

  @override
  String get authPasswordRequirementSpecial => 'One special character';

  @override
  String get authBusinessTitle => 'Business Account';

  @override
  String get authBusinessCancelTitle => 'Cancel registration?';

  @override
  String get authBusinessCancelContent => 'Your progress will be lost.';

  @override
  String get authBusinessSuccessTitle => 'Registration successful!';

  @override
  String authBusinessSuccessMessageWithOrg(String organizationName) {
    return 'Your business account for \"$organizationName\" was created successfully.';
  }

  @override
  String get authBusinessSuccessMessage =>
      'Your business account was created successfully.';

  @override
  String get authBusinessSuccessAccess =>
      'You can now access all LeHiboo features.';

  @override
  String get authStart => 'Start';

  @override
  String get authBusinessStepInfo => 'Info';

  @override
  String get authBusinessStepVerification => 'Verify';

  @override
  String get authBusinessStepCompany => 'Company';

  @override
  String get authBusinessStepUsage => 'Usage';

  @override
  String get authBusinessStepTerms => 'Terms';

  @override
  String get authPersonalInfoTitle => 'Personal information';

  @override
  String get authPersonalInfoSubtitle =>
      'This information will be used to create your account';

  @override
  String get authOrganizationCompanyLabel => 'Company';

  @override
  String get authOrganizationAssociationLabel => 'Association';

  @override
  String get authOrganizationMunicipalityLabel => 'Public body';

  @override
  String get authOrganizationCompanyDescription => 'Company, SMB, startup...';

  @override
  String get authOrganizationAssociationDescription =>
      'Nonprofit, foundation...';

  @override
  String get authOrganizationMunicipalityDescription =>
      'City hall, department, region...';

  @override
  String get authOrganizationCompanyLower => 'company';

  @override
  String get authOrganizationAssociationLower => 'association';

  @override
  String get authOrganizationMunicipalityLower => 'public body';

  @override
  String get authOrganizationCompanyArticle => 'the company';

  @override
  String get authOrganizationAssociationArticle => 'the association';

  @override
  String get authOrganizationMunicipalityArticle => 'the public body';

  @override
  String get authOrganizationCompanyPossessive => 'your company';

  @override
  String get authOrganizationAssociationPossessive => 'your association';

  @override
  String get authOrganizationMunicipalityPossessive => 'your public body';

  @override
  String authBusinessCompanyInfoTitle(String organizationArticle) {
    return 'Information for $organizationArticle';
  }

  @override
  String authBusinessCompanyInfoSubtitle(String organizationPossessive) {
    return 'This information will identify $organizationPossessive';
  }

  @override
  String get authOrganizationTypeLabel => 'Organization type';

  @override
  String authOrganizationNameLabel(String organizationArticle) {
    return 'Name of $organizationArticle';
  }

  @override
  String get authCompanyNameHint => 'My Company Inc.';

  @override
  String get authOptionalSuffix => '(optional)';

  @override
  String get authSiretInvalid => 'Invalid SIRET';

  @override
  String get authSiretHelp => '14 digits, no spaces';

  @override
  String get authIndustryLabel => 'Industry';

  @override
  String get authSelectHint => 'Select';

  @override
  String get authEmployeeCountLabel => 'Team size';

  @override
  String get authBillingAddressLabel => 'Billing address';

  @override
  String get authBillingAddressHint => '123 Peace Street';

  @override
  String get authPostalCodeLabel => 'Postal code';

  @override
  String get authPostalCodeHint => '75001';

  @override
  String get authCityLabel => 'City';

  @override
  String get authCityFieldHint => 'Paris';

  @override
  String get authCountryLabel => 'Country';

  @override
  String get authCountryHint => 'Country';

  @override
  String get authLoading => 'Loading...';

  @override
  String get authIndustryTechnology => 'Technology';

  @override
  String get authIndustryFinance => 'Finance';

  @override
  String get authIndustryHealth => 'Health';

  @override
  String get authIndustryEducation => 'Education';

  @override
  String get authIndustryCommerce => 'Commerce';

  @override
  String get authIndustryServices => 'Services';

  @override
  String get authIndustryIndustry => 'Industry';

  @override
  String get authIndustryTransport => 'Transport';

  @override
  String get authIndustryRealEstate => 'Real estate';

  @override
  String get authIndustryOther => 'Other';

  @override
  String get authCountryFrance => 'France';

  @override
  String get authCountryBelgium => 'Belgium';

  @override
  String get authCountrySwitzerland => 'Switzerland';

  @override
  String get authCountryLuxembourg => 'Luxembourg';

  @override
  String get authCountryMonaco => 'Monaco';

  @override
  String get authCountryGermany => 'Germany';

  @override
  String get authCountrySpain => 'Spain';

  @override
  String get authCountryItaly => 'Italy';

  @override
  String get authCountryNetherlands => 'Netherlands';

  @override
  String get authCountryUnitedKingdom => 'United Kingdom';

  @override
  String get authCountryOther => 'Other';

  @override
  String get authCompanySearchTitle => 'Quick search';

  @override
  String authCompanySearchHint(String organizationPossessive) {
    return 'Search $organizationPossessive by name...';
  }

  @override
  String authCompanySearchHelper(String organizationPossessive) {
    return 'Search for $organizationPossessive to fill the form automatically';
  }

  @override
  String authSiretLine(String siret) {
    return 'SIRET: $siret';
  }

  @override
  String get authUsageModeTitle => 'Usage mode';

  @override
  String get authUsageModeSubtitle => 'How do you plan to use LeHiboo?';

  @override
  String get authUsageModePersonalLabel => 'Personal use';

  @override
  String get authUsageModePersonalDescription =>
      'I am the only one using the account';

  @override
  String get authUsageModeTeamLabel => 'Team';

  @override
  String get authUsageModeTeamDescription =>
      'Several people will use the account';

  @override
  String get authTeamEmailsLabelOptional => 'Team member emails (optional)';

  @override
  String get authTeamEmailsHint => 'email1@example.com, email2@example.com';

  @override
  String get authTeamEmailsHelper => 'Separate emails with commas';

  @override
  String authInvalidEmailWithValue(String email) {
    return 'Invalid email: $email';
  }

  @override
  String get authDefaultMonthlyBudgetLabelOptional =>
      'Default monthly budget (optional)';

  @override
  String get authAmountInvalid => 'Please enter a valid amount';

  @override
  String get authTermsFinalizationTitle => 'Finalization';

  @override
  String get authTermsFinalizationSubtitle =>
      'Review your information and accept the terms';

  @override
  String get authTermsSummaryTitle => 'Summary';

  @override
  String get authTermsSummaryPersonal => 'Personal information';

  @override
  String get authTermsSummaryOrganization => 'Organization';

  @override
  String get authTermsSummaryUsage => 'Usage';

  @override
  String authTermsBudgetLine(String budget) {
    return 'Budget: $budget EUR/month';
  }

  @override
  String authTermsInvitationsLine(int count) {
    return 'Invitations: $count team members';
  }

  @override
  String get authBusinessTermsLabel => 'terms specific to business accounts';

  @override
  String get authCreateBusinessAccountButton => 'Create my business account';

  @override
  String get authBusinessTermsHelper =>
      'By creating an account, you confirm that the information provided is accurate and that you are authorized to represent this organization.';

  @override
  String get homeTooltipNotifications => 'Notifications';

  @override
  String get homeTooltipCart => 'My cart';

  @override
  String get homeTooltipAccount => 'My account';

  @override
  String get homeViewMore => 'See more';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeNewActivitiesTitle => 'New';

  @override
  String get homeNoNewActivities => 'No new activities found.';

  @override
  String get homeNearbyAvailableTitle => 'Available activities nearby';

  @override
  String get homeWebCtaTitle => 'Find your events with ease';

  @override
  String get homeWebCtaBody =>
      'Our website offers the full experience to discover and book local activities.';

  @override
  String get homeWebCtaButton => 'Visit the website';

  @override
  String get homeFallbackPopularCitiesTitle => 'Where things are happening now';

  @override
  String get homePopularCitiesTitle => 'Popular cities';

  @override
  String homeHeroGreetingMorning(String firstName) {
    return 'Good morning $firstName!';
  }

  @override
  String homeHeroGreetingAfternoon(String firstName) {
    return 'Good afternoon $firstName!';
  }

  @override
  String homeHeroGreetingEvening(String firstName) {
    return 'Good evening $firstName!';
  }

  @override
  String homeHeroGreetingNight(String firstName) {
    return 'Good night $firstName!';
  }

  @override
  String get homeHeroNightTitle => 'Nightlife outings';

  @override
  String homeHeroNightTitleWithCity(String cityName) {
    return 'Nightlife in $cityName';
  }

  @override
  String get homeHeroNightSubtitle => 'Concerts, shows, and evenings out';

  @override
  String get homeHeroWeekendTitle => 'This weekend';

  @override
  String homeHeroWeekendTitleWithCity(String cityName) {
    return 'This weekend in $cityName';
  }

  @override
  String get homeHeroWeekendMorningSubtitle =>
      'The best activities are waiting for you';

  @override
  String get homeHeroMorningTitle => 'Have a great day';

  @override
  String homeHeroMorningTitleWithCity(String cityName) {
    return 'Have a great day in $cityName';
  }

  @override
  String get homeHeroMorningSubtitle => 'Discover today\'s activities';

  @override
  String get homeHeroAfternoonTitle => 'This afternoon';

  @override
  String homeHeroAfternoonTitleWithCity(String cityName) {
    return 'This afternoon in $cityName';
  }

  @override
  String get homeHeroWeekendAfternoonSubtitle =>
      'Make the most of your weekend';

  @override
  String get homeHeroNearbyTitle => 'Activities near you';

  @override
  String homeHeroNearbyTitleWithCity(String cityName) {
    return 'Activities in $cityName';
  }

  @override
  String get homeHeroAfternoonSubtitle => 'Ideas for your afternoon';

  @override
  String get homeHeroEveningTitle => 'Tonight';

  @override
  String homeHeroEveningTitleWithCity(String cityName) {
    return 'Tonight in $cityName';
  }

  @override
  String get homeHeroEveningWeekendSubtitle => 'Weekend outings start now';

  @override
  String get homeHeroEveningWeekdaySubtitle => 'Relax after work';

  @override
  String get homeHeroDiscoverTitle => 'Discover activities';

  @override
  String homeHeroDiscoverTitleWithCity(String cityName) {
    return 'Discover $cityName';
  }

  @override
  String get homeHeroDiscoverSubtitle => 'Find your next outing';

  @override
  String get homeHeroSummerSubtitle => 'Enjoy summer activities';

  @override
  String get homeHeroWinterSubtitle => 'Warm up your evenings';

  @override
  String get homeHeroSpringSubtitle => 'Spring is here, get out there!';

  @override
  String get homeHeroAutumnSubtitle => 'Autumn colors are waiting for you';

  @override
  String get homeSearchTitle => 'Search';

  @override
  String get homeSearchNearby => 'Nearby';

  @override
  String get homeSearchWhere => 'Where?';

  @override
  String get homeSearchWhen => 'When?';

  @override
  String get homeSearchWhat => 'What?';

  @override
  String homeSearchCategoryCount(int count) {
    return '$count cat.';
  }

  @override
  String get homeSearchFamily => 'Family';

  @override
  String get homeExploreByCategoryTitle => 'Explore by category';

  @override
  String homeExploreCategorySemantics(String category) {
    return 'Explore $category';
  }

  @override
  String get homeStoriesFeaturedTitle => 'Featured';

  @override
  String get homeStoriesNewBadge => 'NEW';

  @override
  String get homeStoryViewActivity => 'View activity';

  @override
  String get homeStoryBookingLabel => 'Tickets';

  @override
  String get homeStoryDiscoveryLabel => 'Discovery';

  @override
  String homeDateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String homeTodayAtTime(String time) {
    return 'Today at $time';
  }

  @override
  String homeTomorrowAtTime(String time) {
    return 'Tomorrow at $time';
  }

  @override
  String homeEventByOrganizer(String organizer) {
    return 'By $organizer';
  }

  @override
  String homePriceFrom(String price) {
    return 'From $price';
  }

  @override
  String homePriceFromShort(String price) {
    return 'From $price';
  }

  @override
  String get homePrivateBadge => 'Private';

  @override
  String get homeCountdownNow => 'Now!';

  @override
  String homeCountdownDayHour(int days, int hours) {
    return '$days day ${hours}h';
  }

  @override
  String homeCountdownDaysHours(int days, int hours) {
    return '$days days ${hours}h';
  }

  @override
  String homeRemainingSpot(int count) {
    return '$count spot';
  }

  @override
  String homeRemainingSpots(int count) {
    return '$count spots';
  }

  @override
  String homeUrgencyRemainingSpots(int count) {
    return 'Only $count spots left!';
  }

  @override
  String get homeUrgencyLastHours => 'Last hours to book!';

  @override
  String get homeBook => 'Book';

  @override
  String get homeUrgencyTitle => 'Before it is too late';

  @override
  String get homeUrgencySubtitle => 'These events start soon';

  @override
  String get homeCityNotFound => 'City not found';

  @override
  String homeCityDescriptionFallback(String cityName) {
    return 'Discover activities in $cityName.';
  }

  @override
  String homeCityAvailableEvent(int count) {
    return '$count event available';
  }

  @override
  String homeCityAvailableEvents(int count) {
    return '$count events available';
  }

  @override
  String get homePopularActivities => 'Popular activities';

  @override
  String get homeFilter => 'Filter';

  @override
  String get homeCityNoActivities => 'No activity found in this city';

  @override
  String homeErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get homeOffersTitle => 'Offers and deals';

  @override
  String get homeSpecialOffer => 'Special offer';

  @override
  String get homeQuickToday => 'Today';

  @override
  String get homeQuickWeekend => 'This weekend';

  @override
  String get homeQuickFamily => 'Family';

  @override
  String get homeQuickDistanceUnder2km => '< 2 km';

  @override
  String get homeCategoryAll => 'All';

  @override
  String get homeCategoryShows => 'Shows';

  @override
  String get homeCategoryWorkshops => 'Workshops';

  @override
  String get homeCategorySport => 'Sport';

  @override
  String get homeCategoryCulture => 'Culture';

  @override
  String get homeCategoryMarkets => 'Markets';

  @override
  String get homeCategoryLeisure => 'Leisure';

  @override
  String get homeBrowseByCity => 'Browse by city';
}
