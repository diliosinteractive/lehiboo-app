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
  String get settingsSectionAccount => 'Account';

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
  String get settingsAccountDeletionTitle => 'Delete my account';

  @override
  String get settingsAccountDeletionSubtitle =>
      'Request permanent deletion from the web form';

  @override
  String get settingsAccountDeletionDialogTitle => 'Delete your account?';

  @override
  String get settingsAccountDeletionDialogContent =>
      'You will be redirected to a secure web form to confirm this request.';

  @override
  String get settingsAccountDeletionOpenFailed =>
      'Could not open the account deletion form.';

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
  String get commonNext => 'Next';

  @override
  String get commonRestart => 'Restart';

  @override
  String get commonLoading => 'Loading...';

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
  String get commonAdd => 'Add';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonOk => 'OK';

  @override
  String get commonValidate => 'Validate';

  @override
  String get commonErrorTitle => 'Oops!';

  @override
  String get commonGenericError => 'Something went wrong.';

  @override
  String get commonGenericRetryError =>
      'Something went wrong. Please try again.';

  @override
  String get commonConnectionError =>
      'Connection error. Check your internet connection.';

  @override
  String get commonSearchHint => 'Search...';

  @override
  String get routeEventFallbackTitle => 'Event';

  @override
  String get routeRecommendedTitle => 'Recommended for you';

  @override
  String get routeNotFoundTitle => 'Oops! Page not found';

  @override
  String get routeNotFoundBody =>
      'The page you are looking for does not exist.';

  @override
  String get settingsPushPermissionRequired =>
      'Notification permission required';

  @override
  String get settingsUpdateFailed => 'Update failed';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileDefaultUser => 'User';

  @override
  String get profileBookingsTitle => 'My bookings';

  @override
  String get profileBookingsSubtitle => 'View your tickets and bookings';

  @override
  String get profileParticipantsTitle => 'My participants';

  @override
  String get profileParticipantsSubtitle =>
      'Family and close contacts for assigning tickets';

  @override
  String get profileFavoritesTitle => 'My favorites';

  @override
  String get profileFavoritesSubtitle => 'Saved activities';

  @override
  String get profileFollowedOrganizersTitle => 'Followed organizers';

  @override
  String get profileFollowedOrganizersSubtitle =>
      'Manage organizers you follow';

  @override
  String get profileMembershipsTitle => 'My memberships';

  @override
  String get profileMembershipsSubtitle =>
      'Memberships, invitations, private events';

  @override
  String get profileMessagesTitle => 'My messages';

  @override
  String get profileMessagesSubtitle => 'Conversations with organizers';

  @override
  String get profileTripsTitle => 'My outings';

  @override
  String get profileTripsSubtitle => 'Plans and itineraries';

  @override
  String get profileRemindersTitle => 'My reminders';

  @override
  String get profileRemindersSubtitle => 'Reminders for upcoming activities';

  @override
  String get profileQuestionsTitle => 'My questions';

  @override
  String get profileQuestionsSubtitle => 'Your questions about events';

  @override
  String get userQuestionsTitle => 'My questions';

  @override
  String get userQuestionsLoadError => 'Unable to load your questions.';

  @override
  String get userQuestionsEmptyTitle => 'No questions';

  @override
  String get userQuestionsEmptyBody =>
      'You have not asked any questions about an event yet.';

  @override
  String get userQuestionsExploreEvents => 'Discover events';

  @override
  String get userQuestionsDeletedEvent => 'Deleted event';

  @override
  String get userQuestionsOrganizerFallback => 'Organizer';

  @override
  String get userQuestionsRejectedNotice =>
      'This question was rejected by moderation.';

  @override
  String get userQuestionsStatusPending => 'Pending';

  @override
  String get userQuestionsStatusApproved => 'Approved';

  @override
  String get userQuestionsStatusAnswered => 'Answered';

  @override
  String get userQuestionsStatusRejected => 'Rejected';

  @override
  String get profileReviewsTitle => 'My reviews';

  @override
  String get profileReviewsSubtitle => 'Your reviews and organizer replies';

  @override
  String get profileAccountTitle => 'My account';

  @override
  String get profileAccountSubtitle => 'Edit your information';

  @override
  String get profileAlertsTitle => 'My alerts & searches';

  @override
  String get profileAlertsSubtitle => 'Manage your saved searches';

  @override
  String get profileVendorScanTitle => 'Scan tickets';

  @override
  String get profileVendorScanSubtitle => 'Vendor mode - access control';

  @override
  String get profileSettingsSubtitle => 'Language, theme, privacy';

  @override
  String get profileHelpTitle => 'Help & support';

  @override
  String get profileHelpSubtitle => 'FAQ and contact';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileSignInPromptTitle => 'Sign in';

  @override
  String get profileSignInPromptSubtitle =>
      'Access your bookings, favorites, and more';

  @override
  String get profileCompletionFirstName => 'First name';

  @override
  String get profileCompletionLastName => 'Last name';

  @override
  String get profileCompletionPhoto => 'Photo';

  @override
  String get profileCompletionBirthDate => 'Birth date';

  @override
  String get profileCompletionMembershipCity => 'Membership city';

  @override
  String get profileCompletionComplete => 'Profile complete';

  @override
  String profileCompletionProgress(int completed, int total) {
    return 'Profile $completed/$total - earn 50 Hibons';
  }

  @override
  String get profileStatsBookings => 'Bookings';

  @override
  String get profileStatsFavorites => 'Favorites';

  @override
  String get profileStatsReviews => 'Reviews';

  @override
  String get profileLogoutDialogBody => 'Are you sure you want to log out?';

  @override
  String get profileHelpOpenFailed => 'Could not open help';

  @override
  String get profileAvatarUpdated => 'Profile photo updated';

  @override
  String profileAvatarUploadError(String message) {
    return 'Upload error: $message';
  }

  @override
  String get profileLoginRequired => 'Please sign in';

  @override
  String get profilePersonalInfoTitle => 'Personal information';

  @override
  String get profileFirstNameLabel => 'First name';

  @override
  String get profileFirstNameRequired => 'First name is required';

  @override
  String get profileLastNameLabel => 'Last name';

  @override
  String get profileLastNameRequired => 'Last name is required';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profileBirthDateLabel => 'Birth date';

  @override
  String get profileBirthDateUnset => 'Not provided';

  @override
  String get profileCityLabel => 'City';

  @override
  String get profileEmailReadOnlyHelper => 'Email cannot be changed';

  @override
  String get profileChangePasswordCta => 'Change my password';

  @override
  String profileUploadImageError(String message) {
    return 'Image upload error: $message';
  }

  @override
  String get profileUpdateSuccess => 'Profile updated successfully';

  @override
  String profileGenericError(String message) {
    return 'Error: $message';
  }

  @override
  String get profileChangePasswordTitle => 'Change password';

  @override
  String get profileCurrentPasswordLabel => 'Current password';

  @override
  String get profileNewPasswordLabel => 'New password';

  @override
  String get profilePasswordChangeSuccess => 'Password changed successfully';

  @override
  String get profileChangePasswordSubmit => 'Change';

  @override
  String get profileParticipantsPersonalizationNotice =>
      'First name, birth date, city, and relationship help Petit Boo and LeHiboo Experiences suggest more relevant offers and events.';

  @override
  String get profileParticipantsAddShort => 'Add';

  @override
  String get profileParticipantsLoadError => 'Could not load your participants';

  @override
  String get profileParticipantAdded => 'Participant added';

  @override
  String get profileParticipantUpdated => 'Participant updated';

  @override
  String get profileParticipantDeleted => 'Participant deleted';

  @override
  String get profileParticipantsEmptyTitle => 'No participants';

  @override
  String get profileParticipantsEmptyBody =>
      'Add your children, close contacts, or recurring participants so you can quickly choose them at booking.';

  @override
  String get profileParticipantsAddCta => 'Add a participant';

  @override
  String get profileParticipantAddTitle => 'Add a participant';

  @override
  String get profileParticipantEditTitle => 'Edit participant';

  @override
  String get profileParticipantFirstNameLabelRequired => 'First name *';

  @override
  String get profileParticipantFirstNameRequired => 'First name is required';

  @override
  String get profileParticipantLastNameLabelRequired => 'Last name *';

  @override
  String get profileParticipantLastNameRequired => 'Last name is required';

  @override
  String get profileParticipantNicknameLabel => 'Nickname';

  @override
  String get profileParticipantRelationshipLabelRequired => 'Relationship *';

  @override
  String get profileParticipantRelationshipRequired =>
      'Relationship is required';

  @override
  String get profileParticipantBirthDateLabelRequired => 'Birth date *';

  @override
  String get profileParticipantBirthDateRequired => 'Birth date is required';

  @override
  String get profileParticipantBirthDateHint => 'mm/dd/yyyy';

  @override
  String get profileParticipantCityLabelRequired => 'Membership city *';

  @override
  String get profileParticipantCityRequired => 'City is required';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesTabOrganizers => 'Organizers';

  @override
  String get messagesTabSupportLeHiboo => 'LeHiboo support';

  @override
  String get messagesTabClients => 'Clients';

  @override
  String get messagesTabBroadcasts => 'Broadcasts';

  @override
  String get messagesTabSupport => 'Support';

  @override
  String get messagesTabUsers => 'Users';

  @override
  String get messagesTabReports => 'Reports';

  @override
  String get messagesNewMessage => 'New message';

  @override
  String get messagesContactSupport => 'Contact support';

  @override
  String get messagesContactParticipant => 'Contact a participant';

  @override
  String get messagesNewBroadcast => 'New broadcast';

  @override
  String get messagesContactPartner => 'Contact a partner';

  @override
  String get messagesBroadcastTitle => 'Broadcast';

  @override
  String messagesBroadcastCreateStepTitle(int step, int total) {
    return 'New broadcast - Step $step/$total';
  }

  @override
  String get messagesBroadcastStepRecipients => 'Recipients';

  @override
  String get messagesBroadcastStepReview => 'Review';

  @override
  String get messagesBroadcastSentSuccess => 'Broadcast sent successfully.';

  @override
  String get messagesBroadcastSlotLabel => 'Slot';

  @override
  String get messagesBroadcastChooseEvent => 'Choose an event';

  @override
  String get messagesBroadcastSelectEventFirst => 'Select an event first';

  @override
  String get messagesBroadcastLoadingSlots => 'Loading slots...';

  @override
  String get messagesBroadcastCalculatingRecipients =>
      'Calculating recipients...';

  @override
  String get messagesBroadcastRecipientsPreviewError =>
      'Could not calculate recipients.';

  @override
  String messagesBroadcastPotentialRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count potential recipients',
      one: '1 potential recipient',
    );
    return '$_temp0';
  }

  @override
  String get messagesBroadcastNoRecipientsForSelection =>
      'No recipients found for this selection';

  @override
  String get messagesBroadcastAllSlots => 'All slots';

  @override
  String get messagesBroadcastChooseEventTitle => 'Choose an event';

  @override
  String get messagesBroadcastNoEventsFound => 'No event found';

  @override
  String get messagesBroadcastSubjectLabel => 'Subject';

  @override
  String get messagesBroadcastSubjectHint => 'Subject of your message...';

  @override
  String messagesMinimumCharacters(int count) {
    return 'Minimum $count characters';
  }

  @override
  String get messagesBroadcastReviewTitle => 'Review';

  @override
  String get messagesRecipientsLabel => 'Recipients';

  @override
  String messagesBroadcastRecipientsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipients',
      one: '1 recipient',
    );
    return '$_temp0';
  }

  @override
  String get messagesBroadcastProcessing =>
      'Sending is being processed by the server.';

  @override
  String get messagesBroadcastStatusSent => 'Sent';

  @override
  String get messagesBroadcastStatusInProgress => 'In progress';

  @override
  String get messagesBroadcastReadLabel => 'Read';

  @override
  String get messagesBroadcastConversationsLabel => 'Conversations';

  @override
  String get messagesBroadcastTargetedEventsLabel => 'Targeted events';

  @override
  String get messagesBroadcastSending => 'Sending...';

  @override
  String messagesBroadcastSlotFallback(int id) {
    return 'Slot $id';
  }

  @override
  String get messagesSupportTicket => 'Support ticket';

  @override
  String get messagesContactUser => 'Contact a user';

  @override
  String get messagesContactOrganizer => 'Contact an organizer';

  @override
  String get messagesGenericError => 'Something went wrong.';

  @override
  String get messagesFallbackOrganizer => 'Organizer';

  @override
  String get messagesNewConversationSubtitleSupport =>
      'Describe your issue and our team will reply quickly.';

  @override
  String get messagesNewConversationSubtitleRecipient =>
      'Select a recipient and write your message.';

  @override
  String get messagesNewConversationSubtitleDefault =>
      'Write your message below.';

  @override
  String get messagesRecipientLabel => 'Recipient';

  @override
  String get messagesOrganizationLabel => 'Organization';

  @override
  String get messagesParticipantLabel => 'Participant';

  @override
  String get messagesPartnerLabel => 'Partner';

  @override
  String get messagesSearchUserPlaceholder => 'Search for a user...';

  @override
  String get messagesSearchOrganizationPlaceholder =>
      'Search for an organization...';

  @override
  String get messagesSearchParticipantPlaceholder =>
      'Search for a participant...';

  @override
  String get messagesSearchPartnerPlaceholder => 'Search for a partner...';

  @override
  String get messagesNoOrganizerAvailable => 'No organizer available';

  @override
  String get messagesSelectOrganizerPlaceholder => 'Select an organizer...';

  @override
  String get messagesOrganizerPickerHelp =>
      'Browse events to find an organizer to contact.';

  @override
  String get messagesSelectOrganizerRequired => 'Please select an organizer.';

  @override
  String get messagesFieldRequired => 'This field is required.';

  @override
  String get messagesEventLabel => 'Event';

  @override
  String get messagesOptionalLabel => '(optional)';

  @override
  String get messagesSupportSubjectPrompt =>
      'What is the subject of your request?';

  @override
  String get messagesSubjectLabel => 'Subject';

  @override
  String get messagesSubjectHint => 'Subject of your message';

  @override
  String get messagesSubjectRequired => 'Subject is required.';

  @override
  String get messagesMessageLabel => 'Message';

  @override
  String get messagesMessageHint => 'Write your message...';

  @override
  String get messagesMessageRequired => 'Message is required.';

  @override
  String get messagesSend => 'Send';

  @override
  String get messagesChooseOrganizerTitle => 'Choose an organizer';

  @override
  String get messagesSearchByNameHint => 'Search by name...';

  @override
  String messagesNoSearchResults(String query) {
    return 'No results for \"$query\".';
  }

  @override
  String get messagesSearchUserTitle => 'Search for a user';

  @override
  String get messagesUserSearchHint => 'Name, first name, or email...';

  @override
  String get messagesNoUsersAvailable => 'No users available.';

  @override
  String get messagesSearchOrganizationTitle => 'Search for an organization';

  @override
  String get messagesOrganizationSearchHint => 'Organization name...';

  @override
  String get messagesNoOrganizationsAvailable => 'No organizations available.';

  @override
  String get messagesSearchParticipantTitle => 'Search for a participant';

  @override
  String get messagesVendorParticipantSearchHelper =>
      'Only participants who have interacted with your organization.';

  @override
  String get messagesNameOrEmailHint => 'Name or email...';

  @override
  String get messagesNoParticipantsAvailable => 'No participants available.';

  @override
  String get messagesSearchPartnerTitle => 'Search for a partner';

  @override
  String get messagesPartnerSearchHint => 'Partner organization name...';

  @override
  String get messagesNoPartnersAvailable => 'No partners available.';

  @override
  String get messagesSupportSubjectBookingIssue => 'Booking issue';

  @override
  String get messagesSupportSubjectEventQuestion => 'Question about an event';

  @override
  String get messagesSupportSubjectPaymentIssue => 'Payment issue';

  @override
  String get messagesSupportSubjectRefundRequest => 'Refund request';

  @override
  String get messagesSupportSubjectAccountIssue => 'Account issue';

  @override
  String get messagesSupportSubjectContentReport => 'Content report';

  @override
  String get messagesCreateConversation => 'Create conversation';

  @override
  String get messagesNoResults => 'No results';

  @override
  String get messagesSelectUserRequired => 'Please select a user.';

  @override
  String get messagesSelectOrganizationRequired =>
      'Please select an organization.';

  @override
  String get messagesSelectParticipantRequired =>
      'Please select a participant.';

  @override
  String get messagesSelectPartnerRequired => 'Please select a partner.';

  @override
  String get messagesNoAcceptedPartners => 'No accepted partners';

  @override
  String get messagesVendorParticipantAccessDenied =>
      'This participant has no interaction with your organization.';

  @override
  String get messagesVendorPartnerAccessDenied =>
      'This partnership is not accepted.';

  @override
  String get messagesAccessDenied => 'Access denied.';

  @override
  String get messagesNoConversations => 'No conversations';

  @override
  String get messagesNoSupportConversations => 'No support conversations';

  @override
  String get messagesNoClients => 'No clients';

  @override
  String get messagesNoBroadcasts => 'No broadcasts sent';

  @override
  String get messagesNoPartners => 'No partners';

  @override
  String get messagesNoSupportTickets => 'No support tickets';

  @override
  String get messagesNoReports => 'No reports';

  @override
  String messagesLoadError(String error) {
    return 'Error: $error';
  }

  @override
  String get messagesSearchHint => 'Search...';

  @override
  String get messagesFilterReset => 'Reset';

  @override
  String get messagesFilterUnread => 'Unread';

  @override
  String get messagesFilterOpen => 'Open';

  @override
  String get messagesFilterClosed => 'Closed';

  @override
  String get messagesFilterThisWeek => 'This week';

  @override
  String get messagesFilterThisMonth => 'This month';

  @override
  String get messagesFilterOlder => 'Older';

  @override
  String get messagesReasonInappropriate => 'Inappropriate content';

  @override
  String get messagesReasonHarassment => 'Harassment';

  @override
  String get messagesReasonSpam => 'Spam';

  @override
  String get messagesReasonOther => 'Other';

  @override
  String get messagesReportLabel => 'Report';

  @override
  String get messagesReportedLabel => 'Reported';

  @override
  String get messagesReportBadge => 'Report';

  @override
  String get messagesStatusClosed => 'Closed';

  @override
  String get messagesStatusPending => 'Pending';

  @override
  String get messagesStatusOpen => 'Open';

  @override
  String get messagesNotificationOpenAction => 'Open';

  @override
  String get messagesDeletedPreview => 'Deleted message';

  @override
  String get messagesRelativeJustNow => 'Just now';

  @override
  String messagesRelativeDaysShort(int count) {
    return '${count}d';
  }

  @override
  String get messagesComposerHint => 'Your message...';

  @override
  String get messagesComposerClosed => 'This conversation is closed';

  @override
  String get messagesDeletedMessage => 'This message was deleted';

  @override
  String get messagesEditedSuffix => '(edited)';

  @override
  String get messagesEditAction => 'Edit';

  @override
  String get messagesCopyTextAction => 'Copy text';

  @override
  String get messagesDeleteAction => 'Delete';

  @override
  String get messagesReopenTooltip => 'Reopen';

  @override
  String get messagesCloseConversation => 'Close conversation';

  @override
  String get messagesReadonlyBanner =>
      'Read-only mode - conversation linked to a report. You are viewing the exchange between both parties.';

  @override
  String get messagesClosedNotice => 'This conversation is closed.';

  @override
  String get messagesEmptyThread => 'No messages. Be the first to write!';

  @override
  String get messagesCloseConversationBody =>
      'Do you want to close this conversation? You will no longer be able to send messages.';

  @override
  String get messagesReportSheetTitle => 'Report conversation';

  @override
  String get messagesReportSheetSubtitle =>
      'Help us maintain a safe environment by reporting inappropriate content.';

  @override
  String get messagesReportReasonLabel => 'Reason';

  @override
  String get messagesReportCommentLabel => 'Comment';

  @override
  String get messagesReportMinCharsHint => '(min. 10 characters)';

  @override
  String get messagesReportReasonRequired => 'Please select a reason.';

  @override
  String get messagesReportCommentMinError => 'Minimum 10 characters.';

  @override
  String get messagesReportCommentHint => 'Describe the issue...';

  @override
  String get messagesReportSubmit => 'Report';

  @override
  String get messagesReportSuccessTitle => 'Report sent';

  @override
  String get messagesReportSuccessBody =>
      'Your report has been sent to the LeHiboo team.';

  @override
  String get messagesReportSupportCreated =>
      'A support ticket was created for follow-up.';

  @override
  String get messagesSendFailedRetry => 'Failed to send. Try again.';

  @override
  String get messagesViewAction => 'View';

  @override
  String messagesAdminReportFallbackTitle(String reportId) {
    return 'Report $reportId';
  }

  @override
  String get messagesAdminReportDetailTitle => 'Report details';

  @override
  String get messagesAdminReportNotFound => 'Report not found';

  @override
  String get messagesUntitledConversation => 'Untitled conversation';

  @override
  String get messagesAdminReportPartiesSection => 'Involved parties';

  @override
  String get messagesAdminReportReporterLabel => 'Reporter';

  @override
  String get messagesAdminReportReportedLabel => 'Reported';

  @override
  String get messagesUserLabel => 'User';

  @override
  String get messagesAdminReportReasonSection => 'Report reason';

  @override
  String get messagesAdminReportInternalNoteSection =>
      'Internal note (not visible to users)';

  @override
  String get messagesAdminReportNoteHint => 'Add a moderation note...';

  @override
  String get messagesAdminReportNoteSaved => 'Note saved.';

  @override
  String get messagesAdminReportModerationActionsSection =>
      'Moderation actions';

  @override
  String get messagesAdminReportFinalActionsWarning =>
      'These actions are final and cannot be undone.';

  @override
  String get messagesAdminReportDismissAction => 'Dismiss';

  @override
  String get messagesAdminReportMarkReviewedAction => 'Mark reviewed';

  @override
  String get messagesAdminReportDismissConfirmBody =>
      'This report will be marked as dismissed. Do you confirm this action?';

  @override
  String get messagesAdminReportReviewConfirmBody =>
      'This report will be marked as reviewed. Do you confirm this action?';

  @override
  String get messagesAdminReportDismissedSnackbar => 'Report dismissed.';

  @override
  String get messagesAdminReportReviewedSnackbar =>
      'Report marked as reviewed.';

  @override
  String get messagesAdminReportViewConversation => 'View linked conversation';

  @override
  String get messagesAdminReportStatusReviewed => 'Reviewed';

  @override
  String get messagesAdminReportStatusDismissed => 'Dismissed';

  @override
  String get messagesAdminReportStatusSuspended => 'Suspended';

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
  String get petitBooStatusResponding => 'Replying...';

  @override
  String get petitBooStatusAssistantAi => 'AI assistant';

  @override
  String get petitBooHistoryTitle => 'History';

  @override
  String get petitBooNewConversation => 'New conversation';

  @override
  String get petitBooServiceUnavailable =>
      'Petit Boo is temporarily unavailable';

  @override
  String get petitBooGreetingMorning => 'Good morning';

  @override
  String get petitBooGreetingAfternoon => 'Good afternoon';

  @override
  String get petitBooGreetingEvening => 'Good evening';

  @override
  String petitBooGreetingWithName(String greeting, String name) {
    return '$greeting $name!';
  }

  @override
  String petitBooGreetingNoName(String greeting) {
    return '$greeting!';
  }

  @override
  String petitBooSubtitleWithCity(String city) {
    return 'What can I do for you in $city?';
  }

  @override
  String get petitBooSubtitleDefault => 'How can I help you today?';

  @override
  String get petitBooQuickTonight => 'Tonight';

  @override
  String get petitBooQuickTonightPrompt => 'What to do tonight?';

  @override
  String petitBooQuickTonightPromptWithCity(String city) {
    return 'What to do tonight in $city?';
  }

  @override
  String get petitBooQuickWeekend => 'Weekend';

  @override
  String get petitBooQuickWeekendPrompt => 'Events this weekend';

  @override
  String petitBooQuickWeekendPromptWithCity(String city) {
    return 'Events this weekend in $city';
  }

  @override
  String get petitBooQuickTickets => 'My tickets';

  @override
  String get petitBooQuickTicketsPrompt => 'Show my bookings';

  @override
  String get petitBooQuickFavorites => 'Favorites';

  @override
  String get petitBooQuickFavoritesPrompt => 'My favorites';

  @override
  String get petitBooTryAsking => 'Try asking me...';

  @override
  String get petitBooSuggestionTonight => 'What events are on tonight?';

  @override
  String petitBooSuggestionTonightWithCity(String city) {
    return 'What events are on tonight in $city?';
  }

  @override
  String get petitBooSuggestionKids => 'Kids activities this weekend';

  @override
  String petitBooSuggestionKidsWithCity(String city) {
    return 'Kids activities in $city';
  }

  @override
  String get petitBooSuggestionFood => 'Food outings this weekend';

  @override
  String petitBooSuggestionFoodWithCity(String city) {
    return 'Food outings in $city';
  }

  @override
  String get petitBooSuggestionConcerts => 'Concerts and shows coming up';

  @override
  String petitBooSuggestionConcertsWithCity(String city) {
    return 'Concerts and shows in $city';
  }

  @override
  String get petitBooEmptyHistoryTitle => 'No conversations';

  @override
  String get petitBooEmptyHistoryBody =>
      'Start a conversation with Petit Boo\nfor personalized help';

  @override
  String get petitBooErrorTitle => 'Oops!';

  @override
  String get petitBooDeleteConversationTitle => 'Delete this conversation?';

  @override
  String get petitBooDeleteConversationBody => 'This action cannot be undone.';

  @override
  String get petitBooConversationDeleted => 'Conversation deleted';

  @override
  String get petitBooConversationFallbackTitle => 'Conversation';

  @override
  String get petitBooConversationsAuthRequired =>
      'Log in to see your conversations';

  @override
  String get petitBooConversationsLoadFailed => 'Could not load conversations';

  @override
  String get petitBooEngagementWelcome => 'Hi! Can I help? 🌟';

  @override
  String get petitBooEngagementInspiration => 'Looking for inspiration? 💡';

  @override
  String get petitBooEngagementNoResults =>
      'No results? I can search for you! 🕵️‍♂️';

  @override
  String get petitBooEngagementIdle => 'Psst... I know some great spots! 🗺️';

  @override
  String petitBooRelativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String petitBooMessageCountShort(int count) {
    return '$count msg';
  }

  @override
  String get petitBooBrainTitle => 'Petit Boo Memory';

  @override
  String get petitBooMemoryKnownTitle => 'What I know about you';

  @override
  String get petitBooMemoryClearAll => 'Clear all';

  @override
  String get petitBooMemoryEnabled => 'Memory on';

  @override
  String get petitBooMemoryPaused => 'Memory paused';

  @override
  String get petitBooMemoryEnabledDescription =>
      'Petit Boo learns from your conversations to suggest outings that fit you. You can correct or delete this information below.';

  @override
  String get petitBooMemoryPausedDescription =>
      'Petit Boo will not remember anything from your new conversations. Previous information remains stored but is not used.';

  @override
  String get petitBooMemoryEmptyTitle =>
      'I do not have any information about you yet.';

  @override
  String get petitBooMemoryEmptyBody =>
      'Chat with me so I can learn your tastes.';

  @override
  String get petitBooMemoryDisabledBody =>
      'Turn memory back on to view and edit your information.';

  @override
  String get petitBooMemoryEditAction => 'Edit';

  @override
  String get petitBooMemoryForgetAction => 'Forget';

  @override
  String petitBooMemoryEditTitle(String label) {
    return 'Edit $label';
  }

  @override
  String get petitBooMemoryNewValueHint => 'New value';

  @override
  String get petitBooMemoryForgetTitle => 'Forget this information?';

  @override
  String petitBooMemoryForgetBody(String label) {
    return 'Do you really want Petit Boo to forget: $label?';
  }

  @override
  String get petitBooMemoryNoKeep => 'No, keep it';

  @override
  String get petitBooMemoryForgetConfirm => 'Yes, forget';

  @override
  String get petitBooMemoryClearAllTitle => 'Clear everything?';

  @override
  String get petitBooMemoryClearAllBody =>
      'Do you really want to clear all information Petit Boo has learned about you?';

  @override
  String get petitBooMemoryClearAllConfirm => 'Yes, clear all';

  @override
  String get petitBooMemoryLabelFirstName => 'First name';

  @override
  String get petitBooMemoryLabelLastName => 'Last name';

  @override
  String get petitBooMemoryLabelNickname => 'Nickname';

  @override
  String get petitBooMemoryLabelAge => 'Age';

  @override
  String get petitBooMemoryLabelBirthYear => 'Birth year';

  @override
  String get petitBooMemoryLabelAgeGroup => 'Age group';

  @override
  String get petitBooMemoryLabelCity => 'City';

  @override
  String get petitBooMemoryLabelRegion => 'Region';

  @override
  String get petitBooMemoryLabelCountry => 'Country';

  @override
  String get petitBooMemoryLabelLatitude => 'Latitude';

  @override
  String get petitBooMemoryLabelLongitude => 'Longitude';

  @override
  String get petitBooMemoryLabelMaxDistance => 'Max distance (km)';

  @override
  String get petitBooMemoryLabelFavoriteActivities => 'Favorite activities';

  @override
  String get petitBooMemoryLabelDislikedActivities => 'Activities to avoid';

  @override
  String get petitBooMemoryLabelFavoriteCategories => 'Favorite categories';

  @override
  String get petitBooMemoryLabelBudgetPreference => 'Budget';

  @override
  String get petitBooMemoryLabelGroupType => 'Group type';

  @override
  String get petitBooMemoryLabelHasChildren => 'Has children';

  @override
  String get petitBooMemoryLabelChildrenAges => 'Children\'s ages';

  @override
  String get petitBooMemoryLabelDietaryPreferences => 'Dietary preferences';

  @override
  String get petitBooMemoryLabelMobilityConstraints => 'Mobility constraints';

  @override
  String get petitBooMemoryLabelPetFriendlyNeeded => 'Pet-friendly needed';

  @override
  String get petitBooMemoryLabelPreferredTimes => 'Preferred times';

  @override
  String get petitBooMemoryLabelPreferredLanguage => 'Preferred language';

  @override
  String get petitBooMemoryLabelInterests => 'Interests';

  @override
  String get petitBooMemoryLabelLastUpdated => 'Last updated';

  @override
  String get petitBooMemoryUndefined => 'Not set';

  @override
  String get petitBooMemoryYes => 'Yes';

  @override
  String get petitBooMemoryNo => 'No';

  @override
  String get petitBooMemoryAgeGroupYoungAdult => 'Young adult';

  @override
  String get petitBooMemoryAgeGroupAdult => 'Adult';

  @override
  String get petitBooMemoryAgeGroupSenior => 'Senior';

  @override
  String get petitBooMemoryBudgetLow => 'Small budget';

  @override
  String get petitBooMemoryBudgetMedium => 'Medium budget';

  @override
  String get petitBooMemoryBudgetHigh => 'Large budget';

  @override
  String get petitBooMemoryGroupSolo => 'Solo';

  @override
  String get petitBooMemoryGroupCouple => 'Couple';

  @override
  String get petitBooMemoryGroupFamily => 'Family';

  @override
  String get petitBooMemoryGroupFriends => 'With friends';

  @override
  String get petitBooQuotaHeaderTitle => 'Your messages with Petit Boo';

  @override
  String get petitBooQuotaHeaderSubtitle => 'How your quota works';

  @override
  String get petitBooQuotaRemainingLabel => 'remaining';

  @override
  String petitBooQuotaUsage(int used, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      used,
      locale: localeName,
      other: '$used messages used',
      one: '1 message used',
    );
    return '$_temp0 out of $limit';
  }

  @override
  String petitBooQuotaRenewalTitle(String period) {
    return '$period renewal';
  }

  @override
  String petitBooQuotaRenewsAt(String time) {
    return 'Your quota renews $time';
  }

  @override
  String get petitBooQuotaRenewsAutomatically =>
      'Your quota renews automatically';

  @override
  String get petitBooQuotaTipTitle => 'Tip';

  @override
  String get petitBooQuotaTipDescription =>
      'Ask specific questions to get more relevant answers and save messages.';

  @override
  String get petitBooQuotaWhyTitle => 'Why a quota?';

  @override
  String get petitBooQuotaWhyDescription =>
      'Petit Boo uses advanced AI to help you. The quota helps us keep the service reliable for everyone.';

  @override
  String get petitBooQuotaUnderstood => 'Got it';

  @override
  String get petitBooQuotaPeriodDaily => 'Daily';

  @override
  String get petitBooQuotaPeriodWeekly => 'Weekly';

  @override
  String get petitBooQuotaPeriodMonthly => 'Monthly';

  @override
  String get petitBooQuotaPeriodAutomatic => 'Automatic';

  @override
  String get petitBooQuotaResetVerySoon => 'very soon';

  @override
  String petitBooQuotaResetInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'in $_temp0';
  }

  @override
  String get petitBooQuotaResetTomorrow => 'tomorrow';

  @override
  String petitBooQuotaResetInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return 'in $_temp0';
  }

  @override
  String get petitBooQuotaResetInOneHour => 'in 1 hour';

  @override
  String petitBooQuotaResetInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return 'in $_temp0';
  }

  @override
  String get petitBooQuotaResetSoon => 'in a few moments';

  @override
  String get petitBooQuotaResetAutomatically => 'automatically';

  @override
  String get petitBooQuotaDisplayTitle => 'Message quota';

  @override
  String petitBooQuotaDisplayResets(String time) {
    return 'Resets: $time';
  }

  @override
  String get petitBooLimitTitle => 'Oops, all done already?';

  @override
  String get petitBooLimitBody =>
      'Petit Boo needs energy to keep finding gems for you. Recharge with Hibons to unlock the conversation.';

  @override
  String petitBooLimitWalletBalance(int balance) {
    return 'Balance: $balance Hibons';
  }

  @override
  String petitBooLimitContinue(int cost, int messages) {
    String _temp0 = intl.Intl.pluralLogic(
      messages,
      locale: localeName,
      other: '$messages msg',
      one: '1 msg',
    );
    return 'Continue for $cost Hibons (+$_temp0)';
  }

  @override
  String petitBooLimitWatchAdReward(int amount) {
    return 'Watch an ad (+$amount Hibons)';
  }

  @override
  String get petitBooLimitComeBackTomorrow =>
      'Come back tomorrow for new messages.';

  @override
  String get petitBooMaybeLater => 'Maybe later';

  @override
  String get petitBooConversationUnlocked => 'Conversation unlocked.';

  @override
  String get petitBooUnlockFailed => 'Could not unlock the conversation';

  @override
  String get petitBooComingSoon => 'Feature coming soon.';

  @override
  String petitBooErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String petitBooFavoriteAddedWithTitle(String eventTitle) {
    return '\"$eventTitle\" added to favorites';
  }

  @override
  String get petitBooFavoriteAdded => 'Added to favorites';

  @override
  String get petitBooFavoriteRemoved => 'Removed from favorites';

  @override
  String petitBooHibonsEarned(int amount) {
    return '+$amount Hibons earned!';
  }

  @override
  String get petitBooToolFavoritesDescription => 'My favorite events';

  @override
  String get petitBooToolFavoritesTitle => 'Your favorites';

  @override
  String get petitBooToolFavoritesEmpty => 'No favorites';

  @override
  String get petitBooToolSearchEventsDescription => 'Event search';

  @override
  String get petitBooToolSearchEventsTitle => 'Events found';

  @override
  String get petitBooToolSearchEventsEmpty =>
      'No events found with these criteria';

  @override
  String get petitBooToolFreeBadge => 'Free';

  @override
  String get petitBooToolBookingsDescription => 'My bookings';

  @override
  String get petitBooToolBookingsTitle => 'Your bookings';

  @override
  String get petitBooToolBookingsEmpty => 'No bookings';

  @override
  String get petitBooToolTicketsDescription => 'My tickets';

  @override
  String get petitBooToolTicketsTitle => 'Your tickets';

  @override
  String get petitBooToolTicketsEmpty => 'No tickets';

  @override
  String get petitBooToolEventDetailsDescription => 'Event details';

  @override
  String get petitBooToolAlertsDescription => 'My alerts';

  @override
  String get petitBooToolAlertsTitle => 'Your alerts';

  @override
  String get petitBooToolAlertsEmpty => 'No alerts';

  @override
  String get petitBooToolProfileDescription => 'My profile';

  @override
  String get petitBooToolProfileStatBookings => 'Bookings';

  @override
  String get petitBooToolProfileStatParticipations => 'Participations';

  @override
  String get petitBooToolProfileStatFavorites => 'Favorites';

  @override
  String get petitBooToolProfileStatAlerts => 'Alerts';

  @override
  String get petitBooToolNotificationsDescription => 'My notifications';

  @override
  String get petitBooToolNotificationsTitle => 'Your notifications';

  @override
  String get petitBooToolNotificationsEmpty => 'No notifications';

  @override
  String get petitBooToolBrainDescription => 'My memory';

  @override
  String get petitBooToolBrainTitle => 'What I know about you';

  @override
  String get petitBooToolBrainEmpty =>
      'I do not know anything yet. Let us chat.';

  @override
  String get petitBooToolBrainSectionFamily => 'Family';

  @override
  String get petitBooToolBrainSectionLocation => 'Location';

  @override
  String get petitBooToolBrainSectionPreferences => 'Preferences';

  @override
  String get petitBooToolBrainSectionConstraints => 'Constraints';

  @override
  String get petitBooToolUpdateBrainDescription => 'Update my memory';

  @override
  String get petitBooToolAddFavoriteDescription => 'Add to favorites';

  @override
  String get petitBooToolRemoveFavoriteDescription => 'Remove from favorites';

  @override
  String get petitBooToolCreateFavoriteListDescription =>
      'Create a favorites list';

  @override
  String get petitBooToolMoveToListDescription => 'Move to a list';

  @override
  String get petitBooToolFavoriteListsDescription => 'View my favorites lists';

  @override
  String get petitBooToolFavoriteListsTitle => 'My favorites lists';

  @override
  String get petitBooToolUpdateFavoriteListDescription => 'Rename a list';

  @override
  String get petitBooToolDeleteFavoriteListDescription => 'Delete a list';

  @override
  String get petitBooToolPlanTripDescription => 'Plan an itinerary';

  @override
  String get petitBooToolPlanTripTitle => 'Your itinerary';

  @override
  String get petitBooToolSaveTripPlanDescription => 'Save an outing plan';

  @override
  String get petitBooToolTripPlansDescription => 'My outing plans';

  @override
  String get petitBooToolTripPlansTitle => 'Your planned outings';

  @override
  String get petitBooToolTripPlansEmpty => 'No planned outings';

  @override
  String petitBooToolItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String petitBooToolViewItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'View $_temp0';
  }

  @override
  String get petitBooToolEmptyListFallback => 'No items';

  @override
  String get petitBooToolUntitled => 'Untitled';

  @override
  String get petitBooToolStatusActive => 'Active';

  @override
  String get petitBooToolStatusInactive => 'Inactive';

  @override
  String get petitBooToolEventFallbackTitle => 'Event';

  @override
  String petitBooToolEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
    );
    return '$_temp0';
  }

  @override
  String petitBooToolViewEvents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'the $count events',
      one: '1 event',
    );
    return 'View $_temp0';
  }

  @override
  String petitBooEventDateTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get petitBooEventAvailabilityAction => 'View availability';

  @override
  String get petitBooEventPriceFrom => 'From';

  @override
  String petitBooEventPriceTiers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rates',
      one: '1 rate',
    );
    return '$_temp0';
  }

  @override
  String petitBooTripSavedPlansCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved plans',
      one: '1 saved plan',
    );
    return '$_temp0';
  }

  @override
  String petitBooTripStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
    );
    return '$_temp0';
  }

  @override
  String petitBooTripMoreStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count more stops',
      one: '+1 more stop',
    );
    return '$_temp0';
  }

  @override
  String get petitBooTripFallbackStop => 'Stop';

  @override
  String get petitBooTripFallbackListTitle => 'Untitled plan';

  @override
  String get petitBooTripLoadErrorTitle => 'Could not load your outings';

  @override
  String get petitBooTripLoadErrorRetry => 'Try again in a few moments';

  @override
  String get petitBooTripEmptyPrompt => 'Ask me to plan an outing!';

  @override
  String get petitBooTripViewAll => 'View all my outings';

  @override
  String get petitBooTripExpandMap => 'Expand map';

  @override
  String get petitBooTripCollapseMap => 'Collapse';

  @override
  String get petitBooTripTipsTitle => 'Tips';

  @override
  String get petitBooTripSave => 'Save';

  @override
  String get petitBooTripSaved => 'Saved';

  @override
  String get petitBooTripShowMap => 'Show map';

  @override
  String get petitBooTripHideMap => 'Hide map';

  @override
  String get petitBooTripSavePlanPrompt => 'Save this outing plan';

  @override
  String get petitBooTripNoCoordinates => 'No coordinates available';

  @override
  String get petitBooQuotaExceededError =>
      'You have reached your message limit';

  @override
  String get petitBooConnectionError => 'Connection error';

  @override
  String get petitBooAuthRequiredError => 'Sign in to chat with Petit Boo';

  @override
  String get petitBooConversationLoadFailed =>
      'Could not load the conversation';

  @override
  String get petitBooApiErrorFallback => 'Petit Boo error';

  @override
  String get petitBooGenericError => 'An error occurred';

  @override
  String get petitBooBrainManageMemory => 'Manage my memory';

  @override
  String get petitBooBrainRecommendationHint =>
      'Tell me about yourself so I can give you better recommendations.';

  @override
  String get petitBooToolHibonsBalance => 'Hibons balance';

  @override
  String petitBooToolHibonsAmount(int amount) {
    return '$amount Hibons';
  }

  @override
  String get petitBooActionView => 'View';

  @override
  String get petitBooActionMyFavorites => 'My favorites';

  @override
  String get petitBooActionAddedSuccessfully => 'Added successfully';

  @override
  String get petitBooActionRemovedSuccessfully => 'Removed successfully';

  @override
  String get petitBooActionBrainNoted => 'Got it.';

  @override
  String get petitBooActionListCreatedTitle => 'List created';

  @override
  String get petitBooActionNewListCreated => 'New list created';

  @override
  String petitBooActionListCreatedWithName(String name) {
    return 'List \"$name\" created';
  }

  @override
  String get petitBooActionViewList => 'View list';

  @override
  String get petitBooActionMovedTitle => 'Moved';

  @override
  String petitBooActionMovedToList(String eventTitle, String listName) {
    return '\"$eventTitle\" moved to \"$listName\"';
  }

  @override
  String get petitBooActionMovedSuccessfully => 'Moved successfully';

  @override
  String get petitBooActionMovedToListFallback => 'Moved to list';

  @override
  String get petitBooActionMyLists => 'My lists';

  @override
  String get petitBooActionListRenamedTitle => 'List renamed';

  @override
  String petitBooActionListRenamedWithName(String name) {
    return 'List renamed to \"$name\"';
  }

  @override
  String get petitBooActionListDeletedTitle => 'List deleted';

  @override
  String petitBooActionListDeletedWithName(String name) {
    return '\"$name\" deleted';
  }

  @override
  String get petitBooActionDoneTitle => 'Action completed';

  @override
  String get petitBooActionDoneSuccessfully => 'Completed successfully';

  @override
  String get petitBooActionBrainProfileUpdated => 'Profile updated';

  @override
  String get petitBooActionBrainFamilyUpdated => 'Family updated';

  @override
  String get petitBooActionBrainPreferenceSaved => 'Preference saved';

  @override
  String get petitBooActionBrainConstraintSaved => 'Constraint saved';

  @override
  String get petitBooActionBrainMemoryUpdated => 'Memory updated';

  @override
  String petitBooActionBrainNotedValue(String value) {
    return 'Noted: $value';
  }

  @override
  String get petitBooActionBrainRememberFallback => 'I will remember that';

  @override
  String petitBooActionListRenamedFromTo(String oldName, String newName) {
    return '\"$oldName\" → \"$newName\"';
  }

  @override
  String petitBooActionListNewName(String name) {
    return 'New name: \"$name\"';
  }

  @override
  String get petitBooActionListRenamedSuccessfully =>
      'List renamed successfully';

  @override
  String get petitBooActionErrorTitle => 'Failed';

  @override
  String get petitBooActionGenericError => 'Something went wrong';

  @override
  String petitBooFavoriteListsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lists',
      one: '1 list',
    );
    return '$_temp0';
  }

  @override
  String get petitBooFavoriteListsNoName => 'Unnamed';

  @override
  String get petitBooFavoriteListsViewAll => 'View all';

  @override
  String get petitBooFavoriteListsEmptyTitle => 'No lists yet';

  @override
  String get petitBooFavoriteListsEmptyBody => 'Ask me to create one.';

  @override
  String get petitBooFavoriteListEventsEmpty => 'Empty';

  @override
  String petitBooFavoriteListEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
    );
    return '$_temp0';
  }

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
  String get membershipSearchOrganizationHint =>
      'Search for an organization...';

  @override
  String membershipTabActive(int count) {
    return 'Active ($count)';
  }

  @override
  String membershipTabPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String membershipTabRejected(int count) {
    return 'Rejected ($count)';
  }

  @override
  String membershipTabInvitations(int count) {
    return 'Invitations ($count)';
  }

  @override
  String get membershipEmptyActive =>
      'No active memberships yet.\nJoin your favorite organizations so you do not miss anything.';

  @override
  String get membershipEmptyPending => 'You do not have any pending requests.';

  @override
  String get membershipEmptyRejected => 'No rejected requests.';

  @override
  String get membershipEmptyInvitations => 'No invitations for now.';

  @override
  String get membershipDiscoverOrganizations => 'Discover organizations';

  @override
  String get membershipLoadError => 'Could not load your memberships.';

  @override
  String get membershipStatusPending => 'Pending';

  @override
  String get membershipStatusActive => 'Active';

  @override
  String get membershipStatusRejected => 'Rejected';

  @override
  String get membershipStatusInvitation => 'Invitation';

  @override
  String get membershipStatusExpired => 'Expired';

  @override
  String get membershipViewOrganizer => 'View profile';

  @override
  String get membershipPrivateEventsAction => 'Private events';

  @override
  String membershipMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get membershipJoinAction => 'Join';

  @override
  String get membershipPendingAction => 'Pending';

  @override
  String get membershipRetryRequestAction => 'Request again';

  @override
  String get membershipCancelRequestAction => 'Cancel request';

  @override
  String get membershipLeaveAction => 'Leave';

  @override
  String get membershipCancelRequestTitle => 'Cancel request?';

  @override
  String membershipCancelRequestBody(String organizerName) {
    return 'Your request to join $organizerName will be cancelled. You can send another request at any time.';
  }

  @override
  String get membershipLeaveTitle => 'Leave this organization?';

  @override
  String membershipLeaveBody(String organizerName) {
    return 'You will no longer see private events from $organizerName. You can send another request at any time.';
  }

  @override
  String membershipJoinTitle(String organizerName) {
    return 'Join $organizerName\'s private space?';
  }

  @override
  String get membershipJoinBody =>
      'By joining, you get access to exclusive events for members. Your request will be reviewed by the organizer.';

  @override
  String get membersOnlyGateTitle => 'Members-only event';

  @override
  String membersOnlyGateBody(String organizerName) {
    return 'This event is only available to members of $organizerName. Join the organization to unlock its private calendar.';
  }

  @override
  String membersOnlyGateJoin(String organizerName) {
    return 'Join $organizerName';
  }

  @override
  String get privateEventsTitle => 'My private events';

  @override
  String get privateEventsSearchHint => 'Search for an event...';

  @override
  String get privateEventsLoadError => 'Could not load events.';

  @override
  String get privateEventsPrivateBadge => 'Private';

  @override
  String get privateEventsAllOrganizations => 'All organizations';

  @override
  String get privateEventsEmptyTitle => 'No private events yet.';

  @override
  String get privateEventsEmptyBody =>
      'Join organizations to discover their exclusive activities.';

  @override
  String get privateEventsEmptyFiltered => 'No matching private event.';

  @override
  String get membershipInvitationTitle => 'Invitation';

  @override
  String membershipInvitedBy(String name) {
    return 'Invited by $name';
  }

  @override
  String get membershipInvitationExpiredBlurb =>
      'This invitation has expired. Ask the organization to send you a new invitation.';

  @override
  String get membershipInvitationAcceptedBlurb =>
      'This invitation has already been accepted. You can find the organization in your memberships list.';

  @override
  String get membershipInvitationActiveBlurb =>
      'You are invited to join this private space. Accept the invitation to access exclusive events.';

  @override
  String membershipInvitationActiveWithExpiryBlurb(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return 'You are invited to join this private space. Accept the invitation to access exclusive events. This invitation expires in $_temp0.';
  }

  @override
  String membershipInvitationWelcome(String organizationName) {
    return 'Welcome to $organizationName';
  }

  @override
  String get membershipInvitationAcceptFailed =>
      'Could not accept this invitation.';

  @override
  String get membershipInvitationDeclineTitle => 'Decline invitation?';

  @override
  String membershipInvitationDeclineBody(String organizationName) {
    return 'Decline the invitation from $organizationName?';
  }

  @override
  String get membershipInvitationDeclineAction => 'Decline';

  @override
  String get membershipInvitationAcceptAction => 'Accept';

  @override
  String get membershipInvitationDeclined => 'Invitation declined';

  @override
  String get membershipInvitationSignInToAccept => 'Sign in to accept';

  @override
  String get membershipInvitationAlreadyAccepted =>
      'Invitation already accepted.';

  @override
  String get membershipInvitationExpired => 'Invitation expired.';

  @override
  String membershipInvitationExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expires in $count days',
      one: 'Expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String membershipInvitationExpiresInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expires in $count hours',
      one: 'Expires in 1 hour',
    );
    return '$_temp0';
  }

  @override
  String get membershipInvitationNotFoundTitle =>
      'This invitation cannot be found.';

  @override
  String get membershipInvitationNotFoundBody =>
      'The link may have been disabled. Ask the organizer to send you a new invitation.';

  @override
  String get personalizedFeedTitle => 'For you';

  @override
  String get organizerInvalidIdentifier => 'Invalid organizer identifier';

  @override
  String get organizerActivitiesTab => 'Activities';

  @override
  String get organizerReviewsTab => 'Reviews';

  @override
  String get organizerProfileLoadError => 'Could not load this profile.';

  @override
  String get organizerContactAction => 'Contact';

  @override
  String get organizerCoordinatesAction => 'Contact details';

  @override
  String get organizerNoCoordinates =>
      'This organizer has not provided contact details.';

  @override
  String get organizerAboutTitle => 'About';

  @override
  String get organizerEstablishmentTypesTitle => 'Establishment types';

  @override
  String get organizerSocialLinksTitle => 'Social links';

  @override
  String organizerEventsCount(String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'events',
      one: 'event',
    );
    return '$countLabel $_temp0';
  }

  @override
  String organizerFollowersCount(String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'followers',
      one: 'follower',
    );
    return '$countLabel $_temp0';
  }

  @override
  String organizerMembersCount(String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'members',
      one: 'member',
    );
    return '$countLabel $_temp0';
  }

  @override
  String organizerRatingWithReviews(
      String rating, String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'reviews',
      one: 'review',
    );
    return '$rating ($countLabel $_temp0)';
  }

  @override
  String get organizerFollowAction => 'Follow';

  @override
  String get organizerUnfollowAction => 'Unfollow';

  @override
  String get organizerFollowedSearchHint => 'Search for an organizer';

  @override
  String get organizerFollowedEmptySearchTitle => 'No organizer found';

  @override
  String get organizerFollowedEmptySearchBody => 'Try another keyword.';

  @override
  String get organizerFollowedEmptyTitle =>
      'You are not following any organizers';

  @override
  String get organizerFollowedEmptyBody =>
      'Follow an organizer from their page to find them here.';

  @override
  String get organizerFollowedLoadError => 'Could not load the list.';

  @override
  String get organizerActivitiesLoadError => 'Could not load activities.';

  @override
  String get organizerActivitiesEmpty => 'No activities published yet.';

  @override
  String get organizerActivitiesNoUpcoming => 'No upcoming event.';

  @override
  String get organizerActivitiesNoPast => 'No past event.';

  @override
  String organizerActivitiesCurrentTab(int count) {
    return 'Current ($count)';
  }

  @override
  String organizerActivitiesPastTab(int count) {
    return 'Past ($count)';
  }

  @override
  String get organizerReviewsLoadError => 'Could not load reviews.';

  @override
  String organizerReviewsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return 'Based on $_temp0';
  }

  @override
  String organizerVerifiedPurchasesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'including $count verified purchases',
      one: 'including 1 verified purchase',
    );
    return '$_temp0';
  }

  @override
  String get organizerNoReviewsTitle => 'No reviews yet';

  @override
  String get organizerNoReviewsBody =>
      'Be among the first to leave a review on one of their events.';

  @override
  String get organizerReviewUserFallback => 'User';

  @override
  String get organizerReviewFor => 'Review for';

  @override
  String get organizerVerifiedPurchase => 'Verified purchase';

  @override
  String organizerHelpfulCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count helpful',
      one: '1 helpful',
    );
    return '$_temp0';
  }

  @override
  String organizerReplyBy(String author) {
    return 'Reply from $author';
  }

  @override
  String get organizerReplyFallback => 'Organizer reply';

  @override
  String get partnerTypeVenue => 'Venue';

  @override
  String get partnerTypeOrganizer => 'Organizer';

  @override
  String get partnerTypeIndividual => 'Individual';

  @override
  String get partnerSubscriptionBasic => 'Basic';

  @override
  String get partnerSubscriptionEnterprise => 'Enterprise';

  @override
  String get checkinScannerTitle => 'Scan tickets';

  @override
  String get checkinTorchTooltip => 'Flashlight';

  @override
  String get checkinCameraTooltip => 'Camera';

  @override
  String get checkinMoreTooltip => 'More';

  @override
  String get checkinSwitchOrganization => 'Switch organization';

  @override
  String get checkinManualEntryTitle => 'Manual entry';

  @override
  String get checkinGateLabel => 'Gate label';

  @override
  String get checkinGateHint => 'e.g. North, VIP, Entrance 2...';

  @override
  String checkinGateDisplay(String gate) {
    return 'Gate: $gate';
  }

  @override
  String get checkinEntryRecorded => 'Welcome! Entry recorded.';

  @override
  String checkinReEntryRecorded(int count) {
    return 'Re-entry recorded (entry #$count)';
  }

  @override
  String get checkinNetworkRescan =>
      'Unstable network - scan again to confirm.';

  @override
  String get checkinNetworkRetype =>
      'Unstable network - re-enter the code to confirm.';

  @override
  String get checkinCameraPermissionDeniedTitle => 'Camera access denied';

  @override
  String get checkinCameraUnavailableTitle => 'Camera unavailable';

  @override
  String get checkinCameraPermissionDeniedBody =>
      'Allow camera access in system settings, or use manual entry.';

  @override
  String get checkinCameraUnavailableBody =>
      'No camera was detected. Use manual entry.';

  @override
  String get checkinChooseOrganizationFirst =>
      'Choose an organization from the scanner.';

  @override
  String get checkinManualWarning =>
      'Use only with a visual identity check. Manual entry does not verify the QR secret.';

  @override
  String checkinOrganizationLabel(String name) {
    return 'Organization: $name';
  }

  @override
  String get checkinManualCodeHelper => 'Code printed on the ticket';

  @override
  String get checkinVerifyCode => 'Verify code';

  @override
  String get checkinValidTicketTitle => 'Valid ticket';

  @override
  String get checkinReEntryDetectedTitle => 'Re-entry detected';

  @override
  String get checkinConfirmEntry => 'Confirm entry';

  @override
  String get checkinConfirmReEntry => 'Confirm re-entry';

  @override
  String checkinAlreadyEnteredWarning(int count) {
    return 'Already checked in ${count}x - verify before admitting.';
  }

  @override
  String get checkinChooseOrganizationTitle => 'Choose an organization';

  @override
  String get checkinChooseOrganizationBody =>
      'The scanner will send tickets to the selected organization.';

  @override
  String get checkinRoleOwner => 'Owner';

  @override
  String get checkinRoleAdmin => 'Admin';

  @override
  String get checkinRoleStaff => 'Team';

  @override
  String get checkinRoleViewer => 'Member';

  @override
  String get checkinNoVendorOrganizationTitle => 'No vendor organization found';

  @override
  String get checkinNoVendorOrganizationBody =>
      'If you expected to appear here, contact support - your profile may not be linked to an organization yet.';

  @override
  String get checkinRefresh => 'Refresh';

  @override
  String get checkinBlockedTicketCancelledTitle => 'Ticket cancelled';

  @override
  String get checkinBlockedTicketRefundedTitle => 'Ticket refunded';

  @override
  String get checkinBlockedTicketTransferredTitle => 'Ticket transferred';

  @override
  String get checkinBlockedSlotNotStartedTitle => 'Slot not started';

  @override
  String get checkinBlockedWrongEventTitle => 'Wrong event';

  @override
  String get checkinBlockedUnauthorizedTitle => 'Unauthorized';

  @override
  String get checkinBlockedTicketNotFoundTitle => 'Ticket not found';

  @override
  String get checkinBlockedUnknownTitle => 'Error';

  @override
  String get checkinBlockedDoNotAdmit => 'Do not admit.';

  @override
  String get checkinBlockedTicketTransferredBody =>
      'The ticket has been transferred to another holder - scan their QR again.';

  @override
  String get checkinBlockedSlotNotStartedBody =>
      'Entry is not open for this slot yet.';

  @override
  String get checkinBlockedWrongEventBody =>
      'This ticket does not match the filtered event.';

  @override
  String get checkinBlockedUnauthorizedBody =>
      'You are not authorized to scan this ticket for this organization.';

  @override
  String get checkinBlockedTicketNotFoundBody =>
      'QR not recognized - try again or enter the code.';

  @override
  String get checkinBlockedUnknownBody => 'Unexpected error, try again.';

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
  String get authAccountAlreadyVerified =>
      'Your account is already verified. Please sign in.';

  @override
  String get authEmailOrPasswordIncorrect => 'Incorrect email or password';

  @override
  String get authAccountAlreadyExists =>
      'An account already exists with this email';

  @override
  String get authWeakPasswordDetailed =>
      'Password must contain at least 8 characters, an uppercase letter, and a number';

  @override
  String get authVerificationCodeInvalid => 'Invalid verification code';

  @override
  String get authVerificationCodeExpired =>
      'The code has expired. Please request a new one.';

  @override
  String get authTooManyAttempts =>
      'Too many attempts. Try again in 15 minutes.';

  @override
  String get authVerificationCodeSent => 'A verification code has been sent';

  @override
  String get authVerificationCodeVerified => 'Code verified';

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
  String get authFirstNameMinLength =>
      'First name must be at least 2 characters';

  @override
  String get authLastNameMinLength => 'Last name must be at least 2 characters';

  @override
  String get authPasswordMinLengthShort => 'Min. 8 characters';

  @override
  String get authPasswordNeedsUppercaseShort => 'Uppercase required';

  @override
  String get authPasswordNeedsNumberShort => 'Number required';

  @override
  String get authPasswordNeedsSpecialShort => 'Special character required';

  @override
  String get authPasswordNeedsUppercaseNumberSpecial =>
      'Password must contain at least 8 characters, an uppercase letter, a number, and a symbol';

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
  String get authCompanyNameMinLength =>
      'Company name must be at least 2 characters';

  @override
  String get authSiretMustHave14Digits => 'SIRET number must contain 14 digits';

  @override
  String get authAddressMinLength => 'Address must be at least 5 characters';

  @override
  String get authCityMinLength => 'City must be at least 2 characters';

  @override
  String get authPostalCodeLength =>
      'Postal code must be between 3 and 10 characters';

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
  String get authBusinessTermsRequired => 'Please accept the business terms';

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
  String get homePartnerBadge => 'Partner';

  @override
  String get homePartnerSeeAllSelection => 'See the full selection';

  @override
  String get homePersonalizedTitle => 'For you';

  @override
  String get homePersonalizedSubtitle => 'Based on your preferences';

  @override
  String get homeNativeAdSponsored => 'Sponsored';

  @override
  String get homeRecommendedPopularTag => 'Popular';

  @override
  String get homeRecommendedLastSpotsTag => 'Last spots';

  @override
  String get homeSavedSearchAlertFallback => 'Custom alert';

  @override
  String get homeSavedSearchFallback => 'Saved search';

  @override
  String get homeMobileConfigDefaultHeroTitle =>
      'Find your next local adventure';

  @override
  String get homeMobileConfigDefaultHeroSubtitle =>
      'Discover the best events near you';

  @override
  String get homeMobileConfigEventsSectionTitle => 'Find all your events';

  @override
  String get homeMobileConfigEventsSectionDescription =>
      'Explore our selection of local events';

  @override
  String get homeMobileConfigThematiquesSectionTitle => 'Explore by theme';

  @override
  String get homeMobileConfigCitiesSectionTitle => 'Events by city';

  @override
  String get homeMobileConfigExploreButton => 'Explore activities';

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

  @override
  String get searchTitle => 'Search';

  @override
  String get searchFiltersTitle => 'Filters';

  @override
  String get searchClear => 'Clear';

  @override
  String searchClearAllWithCount(int count) {
    return 'Clear all ($count)';
  }

  @override
  String get searchAction => 'Search';

  @override
  String searchActionWithActivity(int count) {
    return 'Search · $count activity';
  }

  @override
  String searchActionWithActivities(int count) {
    return 'Search · $count activities';
  }

  @override
  String get searchSearchActivityTitle => 'Search for an activity';

  @override
  String get searchAroundMe => 'Around me';

  @override
  String get searchAnywhere => 'Anywhere';

  @override
  String get searchAnytime => 'Anytime';

  @override
  String get searchAnyActivityType => 'Any activity type';

  @override
  String get searchSearchSubtitleDefault => 'Title, organizer';

  @override
  String get searchForWhom => 'For whom?';

  @override
  String get searchAllAudiences => 'All audiences';

  @override
  String get searchRefineTitle => 'Refine search';

  @override
  String get searchRefineSubtitleDefault => 'Type, theme, mood';

  @override
  String get searchFilterSingular => '1 filter';

  @override
  String searchFiltersCount(int count) {
    return '$count filters';
  }

  @override
  String get searchCategorySingular => '1 category';

  @override
  String searchCategoriesCount(int count) {
    return '$count categories';
  }

  @override
  String get searchAudienceSingular => '1 audience';

  @override
  String searchAudiencesCount(int count) {
    return '$count audiences';
  }

  @override
  String get searchMyPosition => 'My position';

  @override
  String get searchUseCurrentLocation => 'Use my current location';

  @override
  String searchWithinRadius(int radius) {
    return 'Within $radius km';
  }

  @override
  String get searchRadiusLabel => 'Radius:';

  @override
  String searchRadiusAroundCity(String cityName) {
    return 'Radius around $cityName';
  }

  @override
  String get searchLocationDisabled => 'Enable location';

  @override
  String get searchPermissionDenied => 'Permission denied';

  @override
  String get searchLocationSettingsRequired => 'Enable location in settings';

  @override
  String get searchLocationNotFound => 'Location not found';

  @override
  String searchSavedAlertCreated(String name) {
    return 'Alert \"$name\" created with notifications!';
  }

  @override
  String searchSavedSearchCreated(String name) {
    return 'Search \"$name\" saved!';
  }

  @override
  String get searchAlreadySaved => 'Already saved';

  @override
  String get searchSave => 'Save';

  @override
  String get searchSaveAlert => 'Create alert';

  @override
  String get searchAlreadySavedMultiline => 'Search\nsaved';

  @override
  String get searchSaveSearchMultiline => 'Save\nmy search';

  @override
  String get searchRetry => 'Retry';

  @override
  String searchResult(Object count) {
    return '$count result';
  }

  @override
  String searchResultsCount(Object count) {
    return '$count results';
  }

  @override
  String get searchNoMoreResults => 'That\'s all for now!';

  @override
  String get searchAlertNewActivities => 'Alert me about new activities';

  @override
  String get searchSortBy => 'Sort by';

  @override
  String get searchSortRelevance => 'Relevance';

  @override
  String get searchNoResultsForFilters => 'No results for these filters';

  @override
  String get searchStartTitle => 'Start your search';

  @override
  String get searchNoResultsTitle => 'No activity found';

  @override
  String get searchNoResultsBody =>
      'Try changing your filters or expanding your search area.';

  @override
  String get searchStartBody => 'Use the search bar above to find activities.';

  @override
  String get searchAlertNewEvents => 'Alert me about new events';

  @override
  String get searchClearFilters => 'Clear filters';

  @override
  String searchResultsActivity(int count) {
    return '$count activity';
  }

  @override
  String searchResultsActivities(int count) {
    return '$count activities';
  }

  @override
  String get searchDateToday => 'Today';

  @override
  String get searchDateTomorrow => 'Tomorrow';

  @override
  String get searchDateThisWeek => 'This week';

  @override
  String get searchDateThisWeekend => 'This weekend';

  @override
  String get searchDateThisMonth => 'This month';

  @override
  String get searchDateCustom => 'Custom dates';

  @override
  String get searchPricePaid => 'Paid';

  @override
  String searchPriceRange(int min, int max) {
    return '€$min - €$max';
  }

  @override
  String searchAroundMeWithRadius(int radius) {
    return 'Around me ($radius km)';
  }

  @override
  String searchCityWithRadius(String cityName, int radius) {
    return '$cityName · $radius km';
  }

  @override
  String get searchAvailablePlaces => 'Available spots';

  @override
  String get searchAccessiblePmr => 'Wheelchair accessible';

  @override
  String get searchOnline => 'Online';

  @override
  String get searchInPerson => 'In person';

  @override
  String get searchLocationTypePhysical => 'Physical venue';

  @override
  String get searchLocationTypeOffline => 'Offline';

  @override
  String get searchLocationTypeOnline => 'Online';

  @override
  String get searchLocationTypeHybrid => 'Hybrid';

  @override
  String get searchHintEventOrOrganization => 'Event or organization';

  @override
  String get searchNoSuggestions => 'No suggestions';

  @override
  String get searchSectionThemes => 'Themes';

  @override
  String get searchSectionEventType => 'Event type';

  @override
  String get searchSectionSpecialEvents => 'Highlights';

  @override
  String get searchSectionMood => 'Mood';

  @override
  String get searchSectionDate => 'Date';

  @override
  String get searchSectionCategories => 'Categories';

  @override
  String get searchSectionSort => 'Sort';

  @override
  String get searchSectionLocation => 'Location';

  @override
  String get searchSectionBudget => 'Budget';

  @override
  String get searchSectionFormat => 'Format';

  @override
  String get searchSectionAudience => 'Audience';

  @override
  String get searchSectionLocationType => 'Venue type';

  @override
  String get searchChoosePeriod => 'Choose a period';

  @override
  String get searchChooseCustomDates => 'Choose custom dates';

  @override
  String get searchFreeOnlyTitle => 'Free only';

  @override
  String get searchFreeOnlySubtitle => 'Show free activities only';

  @override
  String get searchPriceRangeTitle => 'Price range';

  @override
  String get searchAll => 'All';

  @override
  String get searchNoThemeAvailable => 'No theme available';

  @override
  String get searchShowLess => 'Show less';

  @override
  String searchShowMoreWithCount(int count) {
    return 'Show more ($count)';
  }

  @override
  String get searchLoadError => 'Unable to load';

  @override
  String get searchHintCity => 'Search for a city';

  @override
  String get searchPopularCities => 'POPULAR CITIES';

  @override
  String get searchResults => 'RESULTS';

  @override
  String searchMinCharacters(int count) {
    return 'Enter at least $count characters';
  }

  @override
  String get searchNoCityFound => 'No city found';

  @override
  String get searchCitiesUnavailable => 'Cities unavailable';

  @override
  String get searchHintCategory => 'Search for a category';

  @override
  String get searchNoCategoryFound => 'No category found';

  @override
  String get searchCategoriesUnavailable => 'Categories unavailable';

  @override
  String get searchFamilyTitle => 'Family';

  @override
  String get searchFamilySubtitle => 'Kid-friendly activities';

  @override
  String get searchAudienceGroup => 'Group';

  @override
  String get searchAudienceSchoolGroup => 'School group';

  @override
  String get searchAudienceProfessional => 'Professional';

  @override
  String get searchAccessibleSubtitle => 'Reduced-mobility accessibility';

  @override
  String get searchOnlineSubtitle => 'Virtual activities';

  @override
  String get searchInPersonSubtitle => 'On-site activities';

  @override
  String get searchAvailabilityTitle => 'Availability';

  @override
  String get searchAvailabilitySubtitle => 'Bookings only';

  @override
  String get searchAvailabilityPanelTitle => 'Availability';

  @override
  String get searchAllActivities => 'All activities';

  @override
  String get searchAvailableOnlyTitle => 'Available spots only';

  @override
  String get searchNoAudienceAvailable => 'No audience available';

  @override
  String get searchAudiencesUnavailable => 'Audiences unavailable';

  @override
  String get searchOptionsUnavailable => 'Options unavailable';

  @override
  String get searchLocationIndoor => 'Indoor';

  @override
  String get searchLocationOutdoor => 'Outdoor';

  @override
  String get searchLocationMixed => 'Mixed';

  @override
  String get searchSortNewest => 'New';

  @override
  String get searchSortDateAsc => 'Date (soonest)';

  @override
  String get searchSortDateDesc => 'Date (latest)';

  @override
  String get searchSortPriceAsc => 'Price low to high';

  @override
  String get searchSortPriceDesc => 'Price high to low';

  @override
  String get searchSortPopularity => 'Popularity';

  @override
  String get searchSortDistance => 'Distance';

  @override
  String get searchSaveSheetTitle => 'Save search';

  @override
  String get searchSaveSheetSubtitle =>
      'Find this search easily and receive alerts for new events.';

  @override
  String get searchDefaultName => 'My search';

  @override
  String get searchAllEvents => 'All events';

  @override
  String searchSummaryPrefix(String summary) {
    return 'Filters: $summary';
  }

  @override
  String get searchNameRequired => 'Please enter a name for the search';

  @override
  String get searchNameAlreadyUsed =>
      'This name is already used. Choose another name.';

  @override
  String get searchNameLabel => 'Search name';

  @override
  String get searchNameHint => 'Example: Concerts in Paris this weekend';

  @override
  String get searchNotificationsTitle => 'Notifications';

  @override
  String get searchPushTitle => 'Push';

  @override
  String get searchPushSubtitle => 'Notifications in the mobile app';

  @override
  String get searchEmailTitle => 'Email';

  @override
  String get searchEmailSubtitle => 'Receive an email for each new event';

  @override
  String get searchSaveButton => 'Save';

  @override
  String get eventExploreTitle => 'Explore events';

  @override
  String get eventSearchHintActivity => 'Search for an activity...';

  @override
  String eventFiltersWithCount(int count) {
    return 'Filters ($count)';
  }

  @override
  String get eventEndOfList => 'That\'s all for now!';

  @override
  String get eventNoEventsTitle => 'No event found';

  @override
  String get eventNoResultsWithFilters => 'No results with the current filters';

  @override
  String get eventNoEventsAvailable =>
      'There are no events available right now';

  @override
  String get eventGenericErrorTitle => 'Something went wrong';

  @override
  String get eventMapLocationError => 'Unable to get your location';

  @override
  String eventMapEventsHere(int count) {
    return '$count events here';
  }

  @override
  String get eventMapSearching => 'Searching...';

  @override
  String get eventMapEmptyHelp => 'It\'s quiet around here!\nNeed a hand?';

  @override
  String get eventLoadError => 'Unable to load the activity.';

  @override
  String eventDateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get eventDatesSoonAvailable =>
      'Dates will be available soon. Contact the organizer for more information.';

  @override
  String get eventAboutTitle => 'About this event';

  @override
  String get eventReadMore => 'Read more';

  @override
  String get eventPricingTitle => 'Pricing';

  @override
  String get eventUndefined => 'Not defined';

  @override
  String get eventNoEntryFee => 'No entry fee';

  @override
  String get eventIndicativePrices =>
      'Indicative prices provided by the organizer';

  @override
  String get eventPriceFromPrefix => 'From ';

  @override
  String get eventPriceDonation => 'Pay what you want';

  @override
  String get eventPriceVariable => 'Variable price';

  @override
  String eventPriceRange(String minPrice, String maxPrice) {
    return 'From $minPrice to $maxPrice';
  }

  @override
  String eventAgeMinimum(int minAge) {
    return '$minAge+ years';
  }

  @override
  String eventAgeMaximum(int maxAge) {
    return 'Up to $maxAge years';
  }

  @override
  String eventAgeRange(int minAge, int maxAge) {
    return '$minAge-$maxAge years';
  }

  @override
  String get eventLocationIndoorOutdoor => 'Indoor/Outdoor';

  @override
  String get eventCharacteristicsTitle => 'Characteristics';

  @override
  String get eventInvalidBookingLink => 'Invalid booking link';

  @override
  String get eventChooseDateFirst => 'Please choose a date first';

  @override
  String get eventSelectAtLeastOneTicket => 'Please select at least one ticket';

  @override
  String get eventBookingChoiceTitle => 'What would you like to do?';

  @override
  String get eventBookingChoiceBody =>
      'Add these tickets to your cart to pay with other events, or finish now.';

  @override
  String get eventTicketsAddedToCart => 'Tickets added to cart';

  @override
  String get eventView => 'View';

  @override
  String get eventAddToCart => 'Add to cart';

  @override
  String get eventBookNow => 'Book now';

  @override
  String eventAllDatesCount(int count) {
    return 'All dates ($count)';
  }

  @override
  String get eventFull => 'Full';

  @override
  String get eventChoose => 'Choose';

  @override
  String get eventTicketing => 'Ticketing';

  @override
  String get eventDiscovery => 'Discovery';

  @override
  String get eventFeatured => 'Featured';

  @override
  String get eventRecommended => 'Recommended';

  @override
  String get eventNew => 'New';

  @override
  String get eventPlaceNotSpecified => 'Place not specified';

  @override
  String get eventCategoryWorkshop => 'Workshop';

  @override
  String get eventCategoryShow => 'Show';

  @override
  String get eventCategoryFestival => 'Festival';

  @override
  String get eventCategoryConcert => 'Concert';

  @override
  String get eventCategoryExhibition => 'Exhibition';

  @override
  String get eventCategorySport => 'Sport';

  @override
  String get eventCategoryCulture => 'Culture';

  @override
  String get eventCategoryMarket => 'Market';

  @override
  String get eventCategoryLeisure => 'Leisure';

  @override
  String get eventCategoryOutdoor => 'Outdoor';

  @override
  String get eventCategoryIndoor => 'Indoor';

  @override
  String get eventCategoryTheater => 'Theater';

  @override
  String get eventCategoryCinema => 'Cinema';

  @override
  String get eventCategoryOther => 'Event';

  @override
  String get eventAudienceAll => 'All audiences';

  @override
  String get eventAudienceFamily => 'Family';

  @override
  String get eventAudienceChildren => 'Children';

  @override
  String get eventAudienceTeenagers => 'Teens';

  @override
  String get eventAudienceAdults => 'Adults';

  @override
  String get eventAudienceSeniors => 'Seniors';

  @override
  String get eventDatesAvailable => 'Available dates';

  @override
  String get eventChooseDate => 'Choose a date';

  @override
  String eventViewAllCount(int count) {
    return 'View all ($count)';
  }

  @override
  String get eventNoDateAvailable => 'No date available';

  @override
  String get eventNoOpenSlots => 'This event has no open slots';

  @override
  String eventSpotsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spots left',
      one: '1 spot left',
    );
    return '$_temp0';
  }

  @override
  String get eventTicketsTitle => 'Tickets';

  @override
  String get eventShowMore => 'Show more';

  @override
  String get eventShowLess => 'Show less';

  @override
  String get eventSoldOut => 'Sold out';

  @override
  String eventTicketLowStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Only $count left!',
      one: 'Only 1 left!',
    );
    return '$_temp0';
  }

  @override
  String eventTicketsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count available',
      one: '1 available',
    );
    return '$_temp0';
  }

  @override
  String get eventTotal => 'total';

  @override
  String eventTicketsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets selected',
      one: '1 ticket selected',
    );
    return '$_temp0';
  }

  @override
  String eventTicketsForDate(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets • $date',
      one: '1 ticket • $date',
    );
    return '$_temp0';
  }

  @override
  String get eventNoSeatsAvailable => 'No seats available';

  @override
  String eventExpectedCapacity(int count) {
    return 'Expected capacity: $count';
  }

  @override
  String get eventViewDates => 'View dates';

  @override
  String get eventReminded => 'Reminder set';

  @override
  String get eventRemindMe => 'Remind me';

  @override
  String get eventViewWebsite => 'View website';

  @override
  String get eventIndicativePrice => 'Indicative price';

  @override
  String eventDateFromTo(String date, String start, String end) {
    return '$date from $start to $end';
  }

  @override
  String eventDateAtStart(String date, String start) {
    return '$date at $start';
  }

  @override
  String get eventServicesAdditionalTitle => 'Additional services (indicative)';

  @override
  String get eventPracticalInfoTitle => 'Practical information';

  @override
  String get eventParkingTitle => 'Parking';

  @override
  String get eventParkingSubtitle => 'Available spaces';

  @override
  String get eventTransportTitle => 'Transport';

  @override
  String get eventTransportSubtitle => 'Bus, metro, tram';

  @override
  String get eventFoodService => 'Food';

  @override
  String get eventFoodOnSite => 'Food on site';

  @override
  String get eventDrinks => 'Drinks';

  @override
  String get eventDrinksAvailable => 'Drinks available';

  @override
  String get eventWifiLabel => 'Wi-Fi';

  @override
  String get eventWifiAvailable => 'Wi-Fi available';

  @override
  String get eventServiceDefaultDescription =>
      'This service is available on site.';

  @override
  String get eventServiceEquipment => 'Equipment provided';

  @override
  String get eventServiceFacilitator => 'Facilitator';

  @override
  String get eventServiceAccommodation => 'Accommodation';

  @override
  String get eventServiceCloakroom => 'Cloakroom';

  @override
  String get eventServiceSecurity => 'Security';

  @override
  String get eventServiceFirstAid => 'First aid';

  @override
  String get eventServiceChildcare => 'Childcare';

  @override
  String get eventServicePhotoBooth => 'Photo booth';

  @override
  String get eventPlace => 'Place';

  @override
  String get eventParkingSheetTitle => 'Parking';

  @override
  String get eventParkingDirections => 'Navigate to parking';

  @override
  String get eventTransportSheetTitle => 'Public transport';

  @override
  String get eventAccessibilityTitle => 'Accessibility';

  @override
  String get eventAccessibilityPmr => 'Wheelchair accessible';

  @override
  String get eventAccessibilityPmrTitle => 'Wheelchair accessibility';

  @override
  String get eventAccessibilitySignLanguage => 'Sign language';

  @override
  String get eventAccessibilityElevator => 'Elevator';

  @override
  String get eventAccessibilityDisabledParking => 'Accessible parking';

  @override
  String get eventAccessibilityDisabledSeats => 'Accessible seats';

  @override
  String get eventAccessibilityGuideDog => 'Guide dog';

  @override
  String get eventAccessibilityHearingLoop => 'Hearing loop';

  @override
  String get eventAccessibilityAudioDescription => 'Audio description';

  @override
  String get eventAccessibilityBraille => 'Braille';

  @override
  String get eventAvailable => 'Available';

  @override
  String get eventQuickActions => 'Quick actions';

  @override
  String get eventDrivingDirections => 'Driving directions';

  @override
  String get eventWalkingDirections => 'Walking directions';

  @override
  String get eventPublicTransportDirections => 'Public transport';

  @override
  String get eventCopyAddress => 'Copy address';

  @override
  String get eventAddressCopied => 'Address copied';

  @override
  String get eventDetailsLabel => 'Details';

  @override
  String get eventLocationTitle => 'Location';

  @override
  String get eventViewOnGoogleMaps => 'View on Google Maps';

  @override
  String get eventNoImage => 'No image';

  @override
  String get eventNoImageAvailable => 'No image available';

  @override
  String get eventViewVideo => 'View video';

  @override
  String eventViewAllPhotosCount(int count) {
    return 'View all photos ($count)';
  }

  @override
  String get eventPrivateNotFound => 'Event not found.';

  @override
  String get eventPasswordRequired => 'Password is required.';

  @override
  String get eventPasswordIncorrect => 'Incorrect password.';

  @override
  String get eventPasswordInvalidFormat => 'Invalid format.';

  @override
  String get eventPasswordNetworkError => 'Network error. Try again.';

  @override
  String eventPasswordRetryIn(int seconds) {
    return 'Try again in ${seconds}s';
  }

  @override
  String get eventPasswordChecking => 'Checking...';

  @override
  String get eventUnlock => 'Unlock';

  @override
  String get eventPrivateTitle => 'This event is private';

  @override
  String get eventPrivateInstructions =>
      'Enter the password shared by the organizer.';

  @override
  String get eventPasswordAttemptsWarning =>
      '3 attempts left before a 1-minute delay.';

  @override
  String get eventPasswordLabel => 'Password';

  @override
  String get eventPasswordHint => 'Enter the password';

  @override
  String get eventMembersOnlyTitle => 'Members only';

  @override
  String get eventMembersOnlyPrefix => 'The event ';

  @override
  String get eventMembersOnlyReservedFor => 'is reserved for members of ';

  @override
  String get eventMembersOnlySuffix => '. Join the community to access it.';

  @override
  String get eventOrganizationFallback => 'this organization';

  @override
  String get eventViewOrganizer => 'View organizer';

  @override
  String get eventEnterPassword => 'Enter password';

  @override
  String get eventPrivateFallbackSubtitle =>
      'This event is private. Enter the password shared by the organizer.';

  @override
  String eventShareWithSender(
      String senderName, String eventTitle, String url) {
    return '$senderName is sharing the event $eventTitle: $url';
  }

  @override
  String eventShareDefault(String eventTitle, String url) {
    return 'Check out the event $eventTitle: $url';
  }

  @override
  String get eventQuestionsTitle => 'Questions';

  @override
  String get eventAsk => 'Ask';

  @override
  String get eventQuestionSent => 'Your question has been sent!';

  @override
  String get eventQuestionAlreadyAsked =>
      'You have already asked a question about this event.';

  @override
  String get eventYourQuestion => 'Your question';

  @override
  String get eventQuestionStatusPending => 'Pending moderation';

  @override
  String get eventQuestionStatusApproved => 'Approved';

  @override
  String get eventQuestionStatusAnswered => 'Answered';

  @override
  String get eventQuestionStatusRejected => 'Rejected';

  @override
  String eventViewAllQuestionsCount(int count) {
    return 'View all questions ($count)';
  }

  @override
  String get eventNoQuestionsTitle => 'No questions yet';

  @override
  String get eventNoQuestionsBody =>
      'Be the first to ask a question about this event.';

  @override
  String get eventAskQuestion => 'Ask a question';

  @override
  String get eventQuestionsLoadError => 'Unable to load questions';

  @override
  String get eventQuestionsEnd => 'You have seen all questions';

  @override
  String get eventVoteUnavailable => 'Unable to vote right now.';

  @override
  String eventQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get eventOfficialAnswer => 'Official answer';

  @override
  String get eventAnonymous => 'Anonymous';

  @override
  String get eventHelpful => 'Helpful';

  @override
  String eventHelpfulCount(int count) {
    return 'Helpful ($count)';
  }

  @override
  String get eventAskQuestionHint => 'Example: What time do doors open?';

  @override
  String get eventQuestionRequired => 'Please enter your question.';

  @override
  String get eventQuestionMinLength =>
      'Your question must contain at least 10 characters.';

  @override
  String get eventQuestionTooLong => 'Your question is too long (1000 max).';

  @override
  String get eventQuestionInvalid => 'Invalid question.';

  @override
  String get eventQuestionInfo =>
      'The organizer will receive your question and reply soon.';

  @override
  String get eventSendQuestion => 'Send my question';

  @override
  String get eventCheckConnectionRetry =>
      'Check your connection, then try again.';

  @override
  String get eventOrganizerInfoSources => 'Info Sources';

  @override
  String get eventOrganizerTitle => 'Organizer';

  @override
  String get eventOrganizerVerified => 'Verified organizer';

  @override
  String get eventOrganizerNotVerified => 'Organizer not verified';

  @override
  String eventOrganizerEventsPublished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events published',
      one: '1 event published',
    );
    return '$_temp0';
  }

  @override
  String eventOrganizerFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '1 follower',
    );
    return '$_temp0';
  }

  @override
  String get eventContact => 'Contact';

  @override
  String get eventViewProfile => 'View profile';

  @override
  String get eventWrittenBy => 'Written by';

  @override
  String get eventLehibooExperiences => 'LEHIBOO EXPERIENCES';

  @override
  String get eventSourceInfo => 'Info source: ';

  @override
  String get eventSimilarEvents => 'Similar events';

  @override
  String eventPeopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people watching',
      one: '1 person watching',
    );
    return '$_temp0';
  }

  @override
  String get bookingCheckoutTitle => 'Finalize my booking';

  @override
  String get bookingSummaryTitle => 'Summary';

  @override
  String get bookingTicketFallback => 'Ticket';

  @override
  String get bookingTotal => 'Total';

  @override
  String get bookingBuyerContactTitle => 'Your contact details';

  @override
  String get bookingContactDetailsTitle => 'Contact details';

  @override
  String get bookingContactDetailsSubtitle =>
      'You will receive your confirmation and tickets at this address.';

  @override
  String get bookingAdditionalInfoOptional =>
      'Additional information (optional)';

  @override
  String get bookingFirstNameLabelRequired => 'First name *';

  @override
  String get bookingLastNameLabelRequired => 'Last name *';

  @override
  String get bookingEmailLabelRequired => 'Email *';

  @override
  String get bookingPhoneLabel => 'Phone';

  @override
  String get bookingAgeLabel => 'Age';

  @override
  String get bookingMembershipCityLabel => 'Membership city';

  @override
  String get bookingFirstNameRequired => 'First name is required';

  @override
  String get bookingLastNameRequired => 'Last name is required';

  @override
  String get bookingEmailRequired => 'Email is required';

  @override
  String get bookingEmailInvalid => 'Invalid email';

  @override
  String get bookingCityMaxLength => 'City must not exceed 255 characters';

  @override
  String get bookingTermsPrefix => 'I accept the ';

  @override
  String get bookingTermsConnector => ' and the ';

  @override
  String get bookingAcceptSalesRequired => 'Please accept the terms of sale';

  @override
  String get bookingEveryTicketNeedsParticipant =>
      'Each ticket must have a participant';

  @override
  String get bookingParticipantsMissingDetails =>
      'Please enter the first name, last name, birth date, city, and relationship for each participant';

  @override
  String get bookingParticipantsMissingCartDetails =>
      'Please enter the first name, birth date, city, and relationship for each participant';

  @override
  String get bookingConfirm => 'Confirm';

  @override
  String get bookingPay => 'Pay';

  @override
  String get bookingContinueToPayment => 'Continue to payment';

  @override
  String get bookingPaymentCancelled => 'Payment cancelled';

  @override
  String bookingTicketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets',
      one: '1 ticket',
    );
    return '$_temp0';
  }

  @override
  String get bookingCartTitle => 'Cart';

  @override
  String get bookingCartHoldExpired =>
      'The cart hold has expired. Add your tickets again to continue.';

  @override
  String get bookingClearCartTitle => 'Clear cart?';

  @override
  String get bookingClearCartBody =>
      'All added tickets will be removed. This action cannot be undone.';

  @override
  String get bookingClear => 'Clear';

  @override
  String bookingCartHoldLabel(String time) {
    return 'Cart $time';
  }

  @override
  String bookingPlacesHoldLabel(String time) {
    return 'Seats $time';
  }

  @override
  String get bookingCartHoldTitle => 'Cart hold';

  @override
  String get bookingCartHoldBody =>
      'Your selection is held for 15 minutes after the last item is added. At payment time, seats are locked for the time needed to finish.';

  @override
  String get bookingUnderstood => 'Got it';

  @override
  String get bookingEmptyCartTitle => 'Your cart is empty';

  @override
  String get bookingEmptyCartBody =>
      'Add tickets from an event page to pay for several bookings at once.';

  @override
  String get bookingExploreEvents => 'Explore events';

  @override
  String get bookingParticipantsTitle => 'Participants';

  @override
  String get bookingParticipantsInstruction =>
      'Choose a saved person or fill in each ticket.';

  @override
  String get bookingParticipantSectionSubtitle =>
      'One form per ticket — fill in each participant';

  @override
  String get bookingParticipantInfoNote =>
      'First name, birth date, city, and relationship help the AI and Le Hiboo experience suggest the most relevant offers and events.';

  @override
  String get bookingChooseSavedParticipant => 'Choose a saved participant';

  @override
  String get bookingAddToNextEmptyTicket => 'Add to the next empty ticket';

  @override
  String get bookingMyParticipants => 'My participants';

  @override
  String bookingSavedParticipantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved',
      one: '1 saved',
    );
    return '$_temp0';
  }

  @override
  String get bookingPrefillTicketsOneClick =>
      'Pre-fill your tickets in one tap';

  @override
  String bookingParticipantsReady(int completed, int total) {
    return '$completed / $total participants ready';
  }

  @override
  String get bookingFillAllWithProfile => 'Fill all tickets with my profile';

  @override
  String get bookingIncompleteProfileTitle => 'Incomplete profile';

  @override
  String get bookingIncompleteProfileBody =>
      'Complete your profile (birth date, city) to pre-fill all required fields.';

  @override
  String get bookingCompleteProfile => 'Complete my profile >';

  @override
  String get bookingPrefillTicket => 'Pre-fill this ticket';

  @override
  String get bookingManualEntry => 'Manual entry';

  @override
  String get bookingBuyerSelf => 'Me (buyer)';

  @override
  String get bookingRelationshipSelf => 'Me';

  @override
  String get bookingRelationshipChild => 'Child';

  @override
  String get bookingRelationshipSpouse => 'Spouse';

  @override
  String get bookingRelationshipFamily => 'Family';

  @override
  String get bookingRelationshipFriend => 'Friend';

  @override
  String get bookingRelationshipOther => 'Other';

  @override
  String get bookingFirstNameShortRequired => 'First name required';

  @override
  String get bookingCityRequired => 'City required';

  @override
  String get bookingRelationRequired => 'Relationship required';

  @override
  String get bookingLastNameLabel => 'Last name';

  @override
  String get bookingRelationLabelRequired => 'Relationship *';

  @override
  String get bookingBirthDateLabelRequired => 'Birth date *';

  @override
  String get bookingBirthDateHelp => 'Birth date';

  @override
  String get bookingBirthDatePlaceholder => 'mm/dd/yyyy';

  @override
  String get bookingContactOptional => 'Optional contact';

  @override
  String get bookingSaveParticipant => 'Add to My participants';

  @override
  String get bookingParticipantComplete => 'Complete';

  @override
  String get bookingParticipantActionRequired => 'Action required';

  @override
  String get bookingRecapTitle => 'Summary';

  @override
  String get bookingTotalTickets => 'Total tickets';

  @override
  String bookingPerTicket(String price) {
    return '$price / ticket';
  }

  @override
  String get bookingRemove => 'Remove';

  @override
  String get bookingOrderConfirmed => 'Order confirmed';

  @override
  String bookingReference(String reference) {
    return 'Reference: $reference';
  }

  @override
  String get bookingCreatedReservations => 'Bookings created';

  @override
  String get bookingTicketsGeneratingOrder =>
      'Your tickets are being generated. You will find them in My bookings.';

  @override
  String get bookingViewMyBookings => 'View my bookings';

  @override
  String get bookingBackHome => 'Back to home';

  @override
  String get bookingReservationFallback => 'Booking';

  @override
  String get bookingMyBookingsTitle => 'My bookings';

  @override
  String get bookingSortTooltip => 'Sort';

  @override
  String get bookingSortByTitle => 'Sort by';

  @override
  String get bookingSortDateAsc => 'Date (nearest)';

  @override
  String get bookingSortDateDesc => 'Date (farthest)';

  @override
  String get bookingSortStatusAsc => 'Status';

  @override
  String get bookingFilterAll => 'All';

  @override
  String get bookingFilterUpcoming => 'Upcoming';

  @override
  String get bookingFilterPast => 'Past';

  @override
  String get bookingFilterCancelled => 'Cancelled';

  @override
  String bookingLoadError(String message) {
    return 'Loading error: $message';
  }

  @override
  String get bookingEmptyAllTitle => 'No bookings';

  @override
  String get bookingEmptyAllBody =>
      'You do not have any bookings yet.\nDiscover our events!';

  @override
  String get bookingEmptyUpcomingTitle => 'No upcoming bookings';

  @override
  String get bookingEmptyUpcomingBody =>
      'You do not have any planned bookings.\nExplore our events!';

  @override
  String get bookingEmptyPastTitle => 'No past bookings';

  @override
  String get bookingEmptyPastBody => 'You have not attended an event yet.';

  @override
  String get bookingEmptyCancelledTitle => 'No cancelled bookings';

  @override
  String get bookingEmptyCancelledBody =>
      'You do not have any cancelled bookings.';

  @override
  String get bookingNotFoundTitle => 'Booking not found';

  @override
  String get bookingNotFoundBody =>
      'This booking does not exist or has been removed.';

  @override
  String get bookingEventFallback => 'Event';

  @override
  String get bookingStandardTicket => 'Standard';

  @override
  String get bookingShareBookingTitle => 'My Le Hiboo booking';

  @override
  String get bookingShareTicketTitle => 'My Le Hiboo ticket';

  @override
  String bookingShareTicketCode(String code) {
    return 'Code: $code';
  }

  @override
  String bookingShareTicketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets',
      one: '1 ticket',
    );
    return '$_temp0';
  }

  @override
  String bookingCalendarReference(String reference) {
    return 'Le Hiboo booking: $reference';
  }

  @override
  String get bookingCalendarAdded => 'Event added to calendar';

  @override
  String get bookingCalendarAddFailed => 'Could not add to calendar';

  @override
  String get bookingCancelDialogTitle => 'Cancel booking';

  @override
  String get bookingCancelDialogBody =>
      'Are you sure you want to cancel this booking? This action cannot be undone.';

  @override
  String bookingCancelDeadline(String deadline) {
    return 'Deadline: $deadline';
  }

  @override
  String get bookingCancelReasonLabel => 'Reason (optional)';

  @override
  String get bookingCancelReasonHint => 'Personal conflict…';

  @override
  String get bookingCancelWarning =>
      'Warning: no refund will be issued after cancellation.';

  @override
  String get bookingCancelKeep => 'No, keep it';

  @override
  String get bookingCancelConfirm => 'Yes, cancel';

  @override
  String get bookingCancelSuccess =>
      'Booking cancelled. No refund will be issued.';

  @override
  String get bookingCancelForbidden =>
      'Cancellation is no longer possible (deadline passed or not authorized by the organizer).';

  @override
  String get bookingCancelNotFound => 'This booking could not be found.';

  @override
  String get bookingCancelValidationTooLong =>
      'The reason is too long (1000 characters max).';

  @override
  String get bookingCancelGenericError =>
      'Could not cancel the booking. Please try again.';

  @override
  String get bookingPreparingPdf => 'Preparing PDF…';

  @override
  String get bookingAndroidDownloadsLocation => 'Downloads/Lehiboo';

  @override
  String get bookingDocumentsTicketsLocation => 'Documents > Lehiboo > tickets';

  @override
  String bookingTicketsSaved(String location) {
    return 'Tickets saved to $location';
  }

  @override
  String bookingTicketSaved(String location) {
    return 'Ticket saved to $location';
  }

  @override
  String get bookingTicketsNotReady =>
      'Your tickets are still being generated. Please try again in a moment.';

  @override
  String get bookingTicketNotReady =>
      'This ticket is still being generated. Please try again in a moment.';

  @override
  String get bookingTicketsNotAuthorized =>
      'You are not authorized to download these tickets.';

  @override
  String get bookingTicketNotDownloadable =>
      'This ticket can no longer be downloaded.';

  @override
  String get bookingDownloadError => 'Download failed. Please try again later.';

  @override
  String get bookingDownloadSingleTicket => 'Download ticket PDF';

  @override
  String get bookingDownloadAllTickets => 'Download all tickets';

  @override
  String get bookingTicketTitle => 'Ticket';

  @override
  String get bookingTicketNotFound => 'Ticket not found';

  @override
  String bookingTicketPosition(int current, int total) {
    return 'Ticket $current/$total';
  }

  @override
  String get bookingTicketSwipeHint => '← Swipe to see other tickets →';

  @override
  String get bookingQrTapFullscreenHint =>
      'Tap the QR code to view it fullscreen';

  @override
  String get bookingQrTapCloseHint => 'Tap anywhere to close';

  @override
  String get bookingParticipantDefault => 'Participant';

  @override
  String bookingParticipantNumber(int index) {
    return 'Participant $index';
  }

  @override
  String bookingAgeYears(int age) {
    return '$age years old';
  }

  @override
  String get bookingAddToCalendar => 'Add to calendar';

  @override
  String get bookingContactOrganizer => 'Contact organizer';

  @override
  String get bookingAdditionalInfoTitle => 'Additional information';

  @override
  String get bookingSectionEvent => 'EVENT';

  @override
  String get bookingViewEvent => 'View event';

  @override
  String get bookingSectionSummary => 'SUMMARY';

  @override
  String get bookingDiscountFallback => 'Discount';

  @override
  String bookingMyTicketsCount(int count) {
    return 'MY TICKETS ($count)';
  }

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusRefunded => 'Refunded';

  @override
  String get bookingTicketStatusActive => 'Active';

  @override
  String get bookingTicketStatusUsed => 'Used';

  @override
  String get bookingTicketStatusCancelled => 'Cancelled';

  @override
  String get bookingTicketStatusExpired => 'Expired';

  @override
  String bookingLegacyReservationForEvent(String eventId) {
    return 'Booking for event $eventId';
  }

  @override
  String bookingLegacyReserveTitle(String eventTitle) {
    return 'Book: $eventTitle';
  }

  @override
  String get bookingLegacyStepSlot => 'Slot';

  @override
  String get bookingLegacyStepInfo => 'Info';

  @override
  String get bookingLegacyStepPayment => 'Payment';

  @override
  String get bookingLegacyChooseSlot => 'Choose a slot';

  @override
  String get bookingLegacyNoSlotTitle => 'No slots';

  @override
  String get bookingLegacyNoSlotBody => 'No slots are available right now.';

  @override
  String get bookingLegacyParticipantsCountTitle => 'Number of participants';

  @override
  String bookingLegacyPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String get bookingLegacyContinue => 'Continue';

  @override
  String get bookingLegacySelectSlotRequired => 'Please select a slot.';

  @override
  String get bookingLegacyRequiredInfo =>
      'Please fill in all required information.';

  @override
  String get bookingLegacyOtherParticipantsLater =>
      'Note: details for the other participants will be requested later.';

  @override
  String get bookingConfirmReservation => 'Confirm booking';

  @override
  String get bookingGoToPayment => 'Go to payment';

  @override
  String get bookingPaymentTitle => 'Payment';

  @override
  String get bookingPaymentCardSimulated => 'Payment card (simulated)';

  @override
  String get bookingCardNumberLabel => 'Card number';

  @override
  String get bookingCardExpiryLabel => 'MM/YY';

  @override
  String get bookingCardCvcLabel => 'CVC';

  @override
  String bookingPayAmount(String amount, String currency) {
    return 'Pay $amount $currency';
  }

  @override
  String get bookingConfirmedTitle => 'Booking confirmed!';

  @override
  String bookingConfirmedBody(String firstName, String eventTitle) {
    return 'Thank you $firstName, your booking for \"$eventTitle\" is confirmed.';
  }

  @override
  String bookingTicketId(String ticketId) {
    return 'Ticket #$ticketId';
  }

  @override
  String get bookingTicketValid => 'Valid';

  @override
  String get bookingSuccessThanks => 'Thank you for your trust';

  @override
  String get bookingReferenceLabel => 'Reference';

  @override
  String get bookingReferenceCopied => 'Reference copied';

  @override
  String get bookingCopyTooltip => 'Copy';

  @override
  String get bookingYourTickets => 'Your tickets';

  @override
  String get bookingTicketsGenerating => 'Generating your tickets...';

  @override
  String get bookingTicketsAvailableInBookings =>
      'Your tickets will be available\nin My bookings';

  @override
  String get bookingConfirmationEmailSent =>
      'A confirmation email with your tickets has been sent.';

  @override
  String get bookingTicketsLoadError => 'Could not load tickets';

  @override
  String get tripPlansListTitle => 'My outings';

  @override
  String tripPlansDeletedSnack(String title) {
    return 'Plan \"$title\" deleted';
  }

  @override
  String get tripPlansUntitledPlan => 'Untitled plan';

  @override
  String get tripPlansEmptyTitle => 'No outings planned';

  @override
  String get tripPlansEmptyBody =>
      'Ask Petit Boo to create an itinerary for your next outing!';

  @override
  String get tripPlansTalkToPetitBoo => 'Talk to Petit Boo';

  @override
  String get tripPlansErrorTitle => 'Something went wrong';

  @override
  String get tripPlansLoadErrorBody => 'Unable to load your outings';

  @override
  String get tripPlanEditTitle => 'Edit';

  @override
  String tripPlanEditErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get tripPlanEditNotFound => 'Plan not found';

  @override
  String get tripPlanEditTitleLabel => 'Title';

  @override
  String get tripPlanEditNameHint => 'Outing name';

  @override
  String get tripPlanEditDateLabel => 'Date';

  @override
  String get tripPlanEditSelectDate => 'Select a date';

  @override
  String get tripPlanEditStopsLabel => 'Stops';

  @override
  String get tripPlanEditReorderHint => 'Drag to reorder';

  @override
  String get tripPlanEditUpdatedSnack => 'Plan updated';

  @override
  String get tripPlanEditDiscardChangesTitle => 'Discard changes?';

  @override
  String get tripPlanEditDiscardChangesBody =>
      'Your changes will not be saved.';

  @override
  String get tripPlanEditDiscard => 'Discard';

  @override
  String tripPlansStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
    );
    return '$_temp0';
  }

  @override
  String tripPlansStopsPlanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops planned',
      one: '1 stop planned',
    );
    return '$_temp0';
  }

  @override
  String get tripPlansStopFallback => 'Stop';

  @override
  String get tripPlansNoCoordinatesAvailable => 'No coordinates available';

  @override
  String get tripPlansDeleteDialogTitle => 'Delete this plan?';

  @override
  String tripPlansDeleteDialogBody(String title) {
    return 'Plan \"$title\" will be permanently deleted.';
  }

  @override
  String tripPlansDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tripPlansDurationHours(int hours) {
    return '${hours}h';
  }

  @override
  String tripPlansDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h$minutes';
  }

  @override
  String get reviewsAllRatingsFilter => 'All';

  @override
  String get reviewsAllTitle => 'All reviews';

  @override
  String get reviewsCannotReviewAlreadyReviewed =>
      'You have already reviewed this event.';

  @override
  String get reviewsCannotReviewEventNotEnded =>
      'You can leave a review once the event is over.';

  @override
  String get reviewsCannotReviewNotParticipated =>
      'Only event participants can leave a review.';

  @override
  String get reviewsCannotReviewOrganizer =>
      'You cannot review your own events.';

  @override
  String get reviewsCannotReviewUnknown =>
      'You cannot leave a review right now.';

  @override
  String reviewsCommentMinLengthError(int minLength) {
    return 'Your review must be at least $minLength characters';
  }

  @override
  String get reviewsCommentRequiredError => 'Please write your review';

  @override
  String get reviewsCommentRequiredLabel => 'Your review *';

  @override
  String get reviewsCreateSuccessPendingModeration =>
      'Review sent. It will be published after approval.';

  @override
  String get reviewsDeleteAction => 'Delete';

  @override
  String get reviewsDeleteConfirmBody =>
      'This action is permanent. You can write a new one later.';

  @override
  String get reviewsDeleteConfirmTitle => 'Delete this review?';

  @override
  String get reviewsDeleteSuccess => 'Review deleted';

  @override
  String get reviewsEditAction => 'Edit';

  @override
  String get reviewsEditModerationNotice =>
      'Any change will put your review back in moderation.';

  @override
  String get reviewsEditMyReviewTitle => 'Edit my review';

  @override
  String get reviewsEmptyBody =>
      'Share your experience and help others choose!';

  @override
  String get reviewsEmptyTitle => 'No reviews yet';

  @override
  String get reviewsEventFallback => 'Event';

  @override
  String get reviewsFeaturedFilter => 'Featured';

  @override
  String get reviewsUserLoadError => 'Unable to load your reviews.';

  @override
  String get reviewsUserLoadMoreError => 'Unable to load more reviews.';

  @override
  String get reviewsMyEmptyBody =>
      'You haven\'t left any reviews yet. Once an event is over, you can share your experience!';

  @override
  String get reviewsMyEmptyTitle => 'No reviews';

  @override
  String get reviewsNoFilteredResults =>
      'No reviews match the selected filters.';

  @override
  String get reviewsNoReviewsTitle => 'No reviews';

  @override
  String get reviewsOrganizerReplied => 'The organizer replied';

  @override
  String get reviewsReportAction => 'Report';

  @override
  String get reviewsReportDetailsOptionalLabel => 'Details (optional)';

  @override
  String get reviewsReportReasonFake => 'Fake review';

  @override
  String get reviewsReportReasonInappropriate => 'Inappropriate content';

  @override
  String get reviewsReportReasonOffensive => 'Offensive language';

  @override
  String get reviewsReportReasonOther => 'Other';

  @override
  String get reviewsReportReasonQuestion => 'Why is this review a problem?';

  @override
  String get reviewsReportReasonSpam => 'Spam';

  @override
  String get reviewsReportSubmitAction => 'Submit report';

  @override
  String get reviewsReportSuccess =>
      'Report sent. Thank you for your vigilance.';

  @override
  String get reviewsReportTitle => 'Report this review';

  @override
  String get reviewsRewriteAction => 'Rewrite';

  @override
  String get reviewsSectionTitle => 'Reviews';

  @override
  String get reviewsSelectRatingRequired => 'Please select a rating';

  @override
  String get reviewsSortMostHelpful => 'Most helpful';

  @override
  String get reviewsSortNewest => 'Newest';

  @override
  String get reviewsSortRating => 'Rating';

  @override
  String get reviewsSortTooltip => 'Sort';

  @override
  String get reviewsStatusApproved => 'Published';

  @override
  String get reviewsStatusPending => 'Pending';

  @override
  String get reviewsStatusRejected => 'Rejected';

  @override
  String get reviewsSubmitAction => 'Submit my review';

  @override
  String get reviewsTitleRequiredError => 'Please add a title';

  @override
  String get reviewsTitleRequiredLabel => 'Title *';

  @override
  String reviewsTotalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews',
    );
    return '$_temp0';
  }

  @override
  String get reviewsUpdateAction => 'Update';

  @override
  String get reviewsUpdateSuccessPendingModeration =>
      'Review updated. It will be moderated again.';

  @override
  String get reviewsVerifiedFilter => 'Verified';

  @override
  String reviewsViewAllAction(int count) {
    return 'See all reviews ($count)';
  }

  @override
  String get reviewsViewMyReviewAction => 'View my review →';

  @override
  String get reviewsWriteAction => 'Write';

  @override
  String get reviewsWriteFirstAction => 'Write the first review';

  @override
  String get reviewsWriteReviewAction => 'Write a review';

  @override
  String get reviewsWriteReviewTitle => 'Leave a review';

  @override
  String get reviewsYourRatingLabel => 'Your rating';

  @override
  String get reviewsYourReviewLabel => 'Your review';

  @override
  String get gamificationActionsCatalogLoadError =>
      'Unable to load the catalog';

  @override
  String get gamificationActionsEmpty => 'No actions available right now';

  @override
  String get gamificationActivitiesBonusTitle => 'Activities & Bonuses';

  @override
  String get gamificationAllFilter => 'All';

  @override
  String get gamificationBadgeLocked => 'Locked';

  @override
  String get gamificationBadgeUnlocked => 'Unlocked';

  @override
  String get gamificationBadgeUnlockedCongrats =>
      'Nice, you unlocked this badge!';

  @override
  String get gamificationBadgesLoadError => 'Unable to load your badges';

  @override
  String get gamificationBoostersUtilitiesTitle => 'Boosters & Utilities';

  @override
  String get gamificationCapReached => 'Reached';

  @override
  String get gamificationChallengesTitle => 'Challenges';

  @override
  String get gamificationClaimDailyReward => 'Claim my reward';

  @override
  String get gamificationComeBackTomorrow => 'Come back tomorrow!';

  @override
  String get gamificationCompleted => 'Completed';

  @override
  String get gamificationCurrentRankPrefix => 'You are';

  @override
  String get gamificationDailyClaimError => 'Error claiming reward';

  @override
  String get gamificationDailyRewardAlreadyClaimed =>
      'You already claimed your reward today!';

  @override
  String get gamificationDailyRewardTitle => 'Daily Reward';

  @override
  String gamificationDayNumber(int dayNumber) {
    return 'D-$dayNumber';
  }

  @override
  String get gamificationEarningsByPillarTitle => 'Breakdown by pillar';

  @override
  String gamificationErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get gamificationGreatCta => 'Great!';

  @override
  String gamificationHibonsAmount(int count) {
    return '$count HIBONs';
  }

  @override
  String get gamificationHibonsAvailable => 'Hibons available';

  @override
  String gamificationHibonsDelta(int delta) {
    return '$delta Hibons';
  }

  @override
  String gamificationHibonsEarned(int count) {
    return '$count Hibons earned';
  }

  @override
  String gamificationHibonsGainedToast(int delta) {
    return '+$delta Hibons earned!';
  }

  @override
  String get gamificationHibonsPacksComingSoonTitle =>
      'Hibon Packs (Coming Soon)';

  @override
  String gamificationHibonsProgress(int current, int total) {
    return '$current / $total HIBONs';
  }

  @override
  String gamificationHibonsRemainingForBadge(int count) {
    return '$count HIBONs left to unlock this badge';
  }

  @override
  String get gamificationHibonsUnit => 'Hibons';

  @override
  String gamificationHibonsUntilNextRank(int count, String rankLabel) {
    return '$count left before $rankLabel';
  }

  @override
  String get gamificationHibouExpressTitle => 'Hibou Express (24h)';

  @override
  String get gamificationHibouExpressDescription =>
      'Unlimited messages with Petit Boo';

  @override
  String get gamificationHistoryTitle => 'History';

  @override
  String get gamificationHowToEarnTitle => 'How to earn Hibons';

  @override
  String get gamificationInAppPurchasesComingSoon =>
      'In-app purchases are coming soon!';

  @override
  String get gamificationInsufficientHibons => 'Not enough Hibons!';

  @override
  String gamificationLifetimeHibonsAccumulated(int count) {
    return '$count HIBONs accumulated';
  }

  @override
  String get gamificationLockedCountLabel => 'To unlock';

  @override
  String get gamificationLuckyWheelTitle => 'Wheel of Fortune';

  @override
  String get gamificationMaxRankReached => 'Max rank reached';

  @override
  String get gamificationMultiplierDescription => 'Earn more Hibons for 1h';

  @override
  String get gamificationMultiplierTitle => 'Multiplier x1.5 (1h)';

  @override
  String get gamificationMyBadgesTitle => 'My Badges';

  @override
  String gamificationNewHibonsBalance(int balance) {
    return 'New balance: $balance Hibons';
  }

  @override
  String get gamificationNoTransactions => 'No transactions';

  @override
  String gamificationPetitBooDailyBonus(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count Petit Boo messages / day',
      one: '+1 Petit Boo message / day',
    );
    return '$_temp0';
  }

  @override
  String get gamificationPillarCommunity => 'Community';

  @override
  String get gamificationPillarDiscovery => 'Discovery';

  @override
  String get gamificationPillarEngagement => 'Engagement';

  @override
  String get gamificationPillarOnboarding => 'Onboarding';

  @override
  String get gamificationPillarParticipation => 'Participation';

  @override
  String get gamificationProgressionTitle => 'Progress';

  @override
  String gamificationProgressThisWeek(int completed, int total) {
    return '$completed/$total this week';
  }

  @override
  String gamificationProgressToday(int completed, int total) {
    return '$completed/$total today';
  }

  @override
  String gamificationPurchaseCompleted(String itemName) {
    return 'Purchase completed: $itemName';
  }

  @override
  String get gamificationRankUpCongratsTitle => 'Congrats!';

  @override
  String gamificationRankUpNowRank(String rankLabel) {
    return 'You are now $rankLabel!';
  }

  @override
  String gamificationRemainingLifetime(int count) {
    return '$count remaining';
  }

  @override
  String get gamificationShopTitle => 'Hibons Shop';

  @override
  String get gamificationStartingRank => 'Starting rank';

  @override
  String get gamificationStreakShieldTitle => 'Streak Shield';

  @override
  String get gamificationStreakShieldDescription =>
      'Protect your streak for 1 day';

  @override
  String get gamificationTopCta => 'Nice!';

  @override
  String get gamificationTotalCountLabel => 'Total';

  @override
  String get gamificationUnlockedCountLabel => 'Unlocked';

  @override
  String get gamificationWheelAlreadyUsedToday =>
      'You already used your chance today.';

  @override
  String get gamificationWheelLoseTitle => 'No luck...';

  @override
  String get gamificationWheelSpinCta => 'Spin';

  @override
  String get gamificationWheelWinTitle => 'Congratulations!';

  @override
  String get alertsListTitle => 'My alerts & searches';

  @override
  String get alertsFilterAll => 'All';

  @override
  String get alertsFilterAlerts => 'Alerts';

  @override
  String get alertsFilterSearches => 'Searches';

  @override
  String get alertsLoadError => 'Could not load your alerts';

  @override
  String get alertsEmptyAllTitle => 'No alerts yet';

  @override
  String get alertsEmptyAllBody =>
      'Save searches to find them here and receive notifications';

  @override
  String get alertsEmptyActiveTitle => 'No active alerts';

  @override
  String get alertsEmptyActiveBody =>
      'Enable notifications on your searches to hear about new events';

  @override
  String get alertsEmptySearchesTitle => 'No saved searches';

  @override
  String get alertsEmptySearchesBody =>
      'Searches without notifications will appear here';

  @override
  String get alertsExploreActivities => 'Explore activities';

  @override
  String get alertsDeleteTitle => 'Delete alert';

  @override
  String get alertsDeleteBody =>
      'Do you really want to delete this saved search?';

  @override
  String alertsDeleted(String name) {
    return 'Alert “$name” deleted';
  }

  @override
  String alertsCreatedOn(String date) {
    return 'Created on $date';
  }

  @override
  String get alertsAllEvents => 'All events';

  @override
  String get alertsUnnamed => 'Unnamed alert';

  @override
  String get favoritesLoadError => 'Loading error';

  @override
  String get favoritesEmptyTitle => 'No favorites';

  @override
  String get favoritesEmptyBody =>
      'Add events to your favorites by tapping the heart so you can find them easily.';

  @override
  String get favoritesEmptyUncategorizedTitle => 'No uncategorized favorites';

  @override
  String get favoritesEmptyUncategorizedBody =>
      'All your favorites are organized in lists.';

  @override
  String get favoritesEmptyListTitle => 'This list is empty';

  @override
  String get favoritesEmptyListBody =>
      'Add favorites to this list from an event detail page.';

  @override
  String get favoritesExploreEvents => 'Explore events';

  @override
  String get favoriteListsTitle => 'My lists';

  @override
  String get favoriteListsLoadError => 'Loading error';

  @override
  String get favoriteListsAllFavorites => 'All favorites';

  @override
  String get favoriteListsAllShort => 'All';

  @override
  String get favoriteListsUncategorized => 'Uncategorized';

  @override
  String get favoriteListsUncategorizedSingular => 'Uncategorized';

  @override
  String get favoriteListsSectionTitle => 'MY LISTS';

  @override
  String get favoriteListNewTitle => 'New list';

  @override
  String get favoriteListOrganizeSubtitle => 'Organize your favorites';

  @override
  String get favoriteListNameLabel => 'List name';

  @override
  String get favoriteListNameHint => 'E.g. Concerts to see';

  @override
  String get favoriteListNameRequired => 'Please enter a name';

  @override
  String get favoriteListNameMinLength =>
      'Name must contain at least 2 characters';

  @override
  String get favoriteListNameMaxLength => 'Name cannot exceed 50 characters';

  @override
  String get favoriteListDescriptionLabel => 'Description (optional)';

  @override
  String get favoriteListDescriptionHint => 'E.g. My favorite music events';

  @override
  String get favoriteListColorLabel => 'Color';

  @override
  String get favoriteListIconLabel => 'Icon';

  @override
  String get favoriteListCreateAction => 'Create';

  @override
  String get favoriteListCreateError => 'Error creating the list';

  @override
  String get favoriteListEditTitle => 'Edit list';

  @override
  String favoriteListFavoritesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favorites',
      one: '1 favorite',
      zero: '0 favorites',
    );
    return '$_temp0';
  }

  @override
  String get favoriteListUpdateError => 'Error updating';

  @override
  String get favoriteListDeleteTitle => 'Delete list?';

  @override
  String favoriteListDeleteBody(String name) {
    return 'The list “$name” will be deleted.';
  }

  @override
  String get favoriteListDeleteMoveBody =>
      'Favorite events will not be deleted; they will be moved to “Uncategorized”.';

  @override
  String favoriteListDeleted(String name) {
    return 'List “$name” deleted';
  }

  @override
  String get favoriteListDeleteError => 'Error deleting';

  @override
  String get favoriteListDeleteThisAction => 'Delete this list';

  @override
  String get favoriteListPickerMoveTitle => 'Move to...';

  @override
  String get favoriteListPickerAddTitle => 'Add to favorites';

  @override
  String get favoriteListPickerUncategorizedSubtitle =>
      'Favorites without a list';

  @override
  String get favoriteListCreateSheetTitle => 'Create a list';

  @override
  String get favoriteListCreateSheetSubtitle => 'New favorites collection';

  @override
  String get favoriteListPickerRemoveTitle => 'Remove from favorites';

  @override
  String get favoriteListPickerRemoveSubtitle => 'Remove from all favorites';

  @override
  String get favoriteAddError => 'Could not add to favorites';

  @override
  String get favoriteRemoveError => 'Could not remove from favorites';

  @override
  String get favoriteUpdateError => 'Could not update favorite';

  @override
  String get favoriteMovedToList => 'Moved to list';

  @override
  String get favoriteMovedToUncategorized => 'Moved to “Uncategorized”';

  @override
  String get favoriteAddedToList => 'Added to list';

  @override
  String get favoriteGenericError => 'Something went wrong.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsFilterUnread => 'Unread';

  @override
  String get notificationsGuestTitle => 'Log in';

  @override
  String get notificationsGuestBody =>
      'Your notifications will appear here after login.';

  @override
  String get notificationsReadSyncError => 'Read status not synced';

  @override
  String get notificationsMarkRead => 'Mark as read';

  @override
  String get notificationsMarkReadError => 'Could not mark as read';

  @override
  String get notificationsMarkedAllRead => 'Notifications marked as read';

  @override
  String get notificationsActionError => 'Action unavailable right now';

  @override
  String get notificationsDeleted => 'Notification deleted';

  @override
  String get notificationsDeleteError => 'Could not delete';

  @override
  String get notificationsDeleteTitle => 'Delete notification';

  @override
  String get notificationsDeleteBody =>
      'Do you really want to delete this notification?';

  @override
  String get notificationsJustNow => 'Just now';

  @override
  String notificationsMinutesAgoShort(int count) {
    return '$count min';
  }

  @override
  String notificationsHoursAgoShort(int count) {
    return '$count h';
  }

  @override
  String notificationsDaysAgoShort(int count) {
    return '$count d';
  }

  @override
  String get notificationsTypeMessage => 'Message';

  @override
  String get notificationsTypeBooking => 'Booking';

  @override
  String get notificationsTypeTicket => 'Ticket';

  @override
  String get notificationsTypeEvent => 'Event';

  @override
  String get notificationsTypeReview => 'Review';

  @override
  String get notificationsTypeQuestion => 'Question';

  @override
  String get notificationsTypeOrganization => 'Organization';

  @override
  String get notificationsTypeInfo => 'Info';

  @override
  String get notificationsEmptyUnreadTitle => 'No unread notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyUnreadBody =>
      'New notifications will appear here.';

  @override
  String get notificationsEmptyBody =>
      'Your messages, bookings, and important updates will appear here.';

  @override
  String get notificationsLoadError => 'Could not load your notifications';

  @override
  String get remindersTitle => 'My reminders';

  @override
  String get remindersUpcoming => 'Upcoming';

  @override
  String get remindersPast => 'Past';

  @override
  String get remindersDeleteTitle => 'Delete reminder?';

  @override
  String remindersDeleteBody(String eventTitle, String date) {
    return 'You will no longer receive notifications for “$eventTitle” on $date.';
  }

  @override
  String get remindersDeleted => 'Reminder deleted';

  @override
  String remindersDateFromTo(String date, String start, String end) {
    return '$date from $start to $end';
  }

  @override
  String remindersDateAtTime(String date, String start) {
    return '$date at $start';
  }

  @override
  String get remindersEmptyTitle => 'No reminders';

  @override
  String get remindersEmptyBody =>
      'Enable reminders on activities you’re interested in to be notified.';

  @override
  String get remindersLoadError => 'Could not load your reminders';

  @override
  String remindersDaysBeforeBadge(int count) {
    return 'D-$count';
  }

  @override
  String get onboardingExploreTitle => 'Get out and experience more';

  @override
  String get onboardingExploreDescription =>
      'Workshops, walks, children’s shows: find the weekend activity without spending your evening searching.';

  @override
  String get onboardingMusicTitle => 'Feel your city’s rhythm';

  @override
  String get onboardingMusicDescription =>
      'Discover concerts, festivals, and parties that move your region. Never miss another music event.';

  @override
  String get onboardingLocalTitle => 'Stay connected to what’s new nearby';

  @override
  String get onboardingLocalDescription =>
      'Markets and places to discover: good addresses close to you.';

  @override
  String get onboardingAssociationTitle => 'Part of an association?';

  @override
  String get onboardingAssociationDescription =>
      'Access private events reserved for your associations: sports, school, culture, leisure. All in one place.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Let’s go';

  @override
  String get thematiquesExploreByTypeTitle => 'Explore by event type';

  @override
  String get thematiquesSeeAll => 'See all';

  @override
  String thematiquesAllTypesCount(int count) {
    return 'All types ($count)';
  }

  @override
  String get thematiquesSearchHint => 'Search an event type...';

  @override
  String thematiquesEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
      zero: '0 events',
    );
    return '$_temp0';
  }

  @override
  String get categoriesAllTitle => 'All categories';

  @override
  String get categoriesSeeAll => 'See all categories';

  @override
  String categoriesAllCount(int count) {
    return 'All categories ($count)';
  }

  @override
  String get categoriesSearchHint => 'Search a category...';

  @override
  String get categoriesEmptySearch => 'No category found';

  @override
  String get blogLatestTitle => 'Latest articles';

  @override
  String get blogEmpty => 'No articles available';

  @override
  String blogReadingTimeMinutes(int minutes) {
    return '$minutes min';
  }
}
