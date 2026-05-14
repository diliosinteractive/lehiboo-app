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
  String get commonValidate => 'Validate';

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
  String get messagesViewAction => 'View';

  @override
  String messagesAdminReportFallbackTitle(String reportId) {
    return 'Report $reportId';
  }

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
  String get searchAvailabilitySubtitle => 'Hide full activities';

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
  String get searchPushSubtitle => 'Notifications in the mobile app';

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
}
