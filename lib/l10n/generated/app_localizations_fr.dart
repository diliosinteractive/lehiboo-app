// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Le Hiboo';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navMap => 'Carte';

  @override
  String get navBookings => 'Réservations';

  @override
  String get guestFeatureBookings => 'consulter mes réservations';

  @override
  String get guestFeaturePetitBoo => 'discuter avec Petit Boo';

  @override
  String get guestFeatureViewMessages => 'voir vos messages';

  @override
  String get guestFeatureSendMessage => 'envoyer un message';

  @override
  String get guestFeatureViewFavorites => 'voir vos favoris';

  @override
  String get guestFeatureViewNotifications => 'voir vos notifications';

  @override
  String get guestFeatureAccessProfile => 'accéder à votre profil';

  @override
  String get guestFeatureViewConversation => 'voir cette conversation';

  @override
  String get guestFeatureManageFavorites => 'gérer les favoris';

  @override
  String get guestFeatureWriteReview => 'laisser un avis';

  @override
  String get guestFeatureReportReview => 'signaler un avis';

  @override
  String get guestFeatureSaveSearch => 'sauvegarder une recherche';

  @override
  String get guestFeatureAskQuestion => 'poser une question';

  @override
  String get guestFeatureVoteQuestion => 'voter pour cette question';

  @override
  String get guestFeatureJoinOrganizer => 'rejoindre cet organisateur';

  @override
  String get guestFeatureFollowOrganizer => 'suivre cet organisateur';

  @override
  String get guestFeatureContactOrganizer => 'contacter un organisateur';

  @override
  String get guestFeatureContactThisOrganizer => 'contacter cet organisateur';

  @override
  String get guestFeatureViewCoordinates => 'voir les coordonnées';

  @override
  String get guestFeatureEnableReminder => 'activer un rappel';

  @override
  String get guestFeatureBookActivity => 'réserver une activité';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionPreferences => 'Préférences';

  @override
  String get settingsSectionApplication => 'Application';

  @override
  String get settingsSectionAccount => 'Compte';

  @override
  String get settingsSectionLegal => 'Informations légales';

  @override
  String get settingsSectionInformation => 'Informations';

  @override
  String get settingsPushReward =>
      'Active les notifications pour gagner 30 Hibons';

  @override
  String get settingsPushTitle => 'Notifications push';

  @override
  String get settingsPushSubtitle => 'Recevoir les alertes sur ton téléphone';

  @override
  String get settingsNewsletterTitle => 'Newsletter';

  @override
  String get settingsNewsletterSubtitle =>
      'Recommandations événements et bons plans par email';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageDialogTitle => 'Choisir la langue';

  @override
  String settingsLanguageSubtitle(String language) {
    return '$language';
  }

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get settingsResetOnboardingTitle => 'Revoir l\'introduction';

  @override
  String get settingsResetOnboardingSubtitle =>
      'Redémarrer le tutoriel d\'accueil';

  @override
  String get settingsAccountDeletionTitle => 'Supprimer mon compte';

  @override
  String get settingsAccountDeletionSubtitle =>
      'Demander la suppression définitive via le formulaire web';

  @override
  String get settingsAccountDeletionDialogTitle => 'Supprimer votre compte ?';

  @override
  String get settingsAccountDeletionDialogContent =>
      'Vous allez être redirigé vers un formulaire web sécurisé pour confirmer cette demande.';

  @override
  String get settingsAccountDeletionOpenFailed =>
      'Impossible d\'ouvrir le formulaire de suppression du compte.';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsResetDialogTitle => 'Redémarrer l\'onboarding ?';

  @override
  String get settingsResetDialogContent =>
      'Voulez-vous vraiment revoir les écrans de bienvenue ? Cela vous déconnectera temporairement de l\'accueil.';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonRestart => 'Redémarrer';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonToday => 'Aujourd\'hui';

  @override
  String get commonTomorrow => 'Demain';

  @override
  String get commonYesterday => 'Hier';

  @override
  String get commonThisWeekend => 'Ce week-end';

  @override
  String get commonFree => 'Gratuit';

  @override
  String get commonUndefinedDate => 'Date non définie';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonOk => 'OK';

  @override
  String get commonValidate => 'Valider';

  @override
  String get commonErrorTitle => 'Oups !';

  @override
  String get commonGenericError => 'Une erreur est survenue.';

  @override
  String get commonGenericRetryError =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get commonConnectionError =>
      'Erreur de connexion. Vérifiez votre connexion internet.';

  @override
  String get commonSearchHint => 'Rechercher...';

  @override
  String get routeEventFallbackTitle => 'Événement';

  @override
  String get routeRecommendedTitle => 'Recommandés pour vous';

  @override
  String get routeNotFoundTitle => 'Oups ! Page non trouvée';

  @override
  String get routeNotFoundBody => 'La page que vous recherchez n\'existe pas.';

  @override
  String get settingsPushPermissionRequired =>
      'Autorisation notifications requise';

  @override
  String get settingsUpdateFailed => 'Mise à jour impossible';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDefaultUser => 'Utilisateur';

  @override
  String get profileBookingsTitle => 'Mes réservations';

  @override
  String get profileBookingsSubtitle => 'Voir vos billets et réservations';

  @override
  String get profileParticipantsTitle => 'Mes participants';

  @override
  String get profileParticipantsSubtitle =>
      'Famille et proches pour attribuer les billets';

  @override
  String get profileFavoritesTitle => 'Mes favoris';

  @override
  String get profileFavoritesSubtitle => 'Activités sauvegardées';

  @override
  String get profileFollowedOrganizersTitle => 'Organisateurs suivis';

  @override
  String get profileFollowedOrganizersSubtitle =>
      'Gérer les organisateurs que vous suivez';

  @override
  String get profileMembershipsTitle => 'Mes adhésions';

  @override
  String get profileMembershipsSubtitle =>
      'Adhésions, invitations, événements privés';

  @override
  String get profileMessagesTitle => 'Mes messages';

  @override
  String get profileMessagesSubtitle => 'Conversations avec les organisateurs';

  @override
  String get profileTripsTitle => 'Mes sorties';

  @override
  String get profileTripsSubtitle => 'Plans et itinéraires';

  @override
  String get profileRemindersTitle => 'Mes rappels';

  @override
  String get profileRemindersSubtitle => 'Rappels d\'activités à venir';

  @override
  String get profileQuestionsTitle => 'Mes questions';

  @override
  String get profileQuestionsSubtitle => 'Vos questions sur les événements';

  @override
  String get userQuestionsTitle => 'Mes questions';

  @override
  String get userQuestionsLoadError => 'Impossible de charger vos questions.';

  @override
  String get userQuestionsEmptyTitle => 'Aucune question';

  @override
  String get userQuestionsEmptyBody =>
      'Vous n\'avez encore posé aucune question sur un événement.';

  @override
  String get userQuestionsExploreEvents => 'Découvrir des événements';

  @override
  String get userQuestionsDeletedEvent => 'Événement supprimé';

  @override
  String get userQuestionsOrganizerFallback => 'Organisateur';

  @override
  String get userQuestionsRejectedNotice =>
      'Cette question a été rejetée par la modération.';

  @override
  String get userQuestionsStatusPending => 'En attente';

  @override
  String get userQuestionsStatusApproved => 'Approuvée';

  @override
  String get userQuestionsStatusAnswered => 'Répondue';

  @override
  String get userQuestionsStatusRejected => 'Rejetée';

  @override
  String get profileReviewsTitle => 'Mes avis';

  @override
  String get profileReviewsSubtitle => 'Vos avis et réponses des organisateurs';

  @override
  String get profileAccountTitle => 'Mon compte';

  @override
  String get profileAccountSubtitle => 'Modifier vos informations';

  @override
  String get profileAlertsTitle => 'Mes alertes & recherches';

  @override
  String get profileAlertsSubtitle => 'Gérer vos recherches enregistrées';

  @override
  String get profileVendorScanTitle => 'Scanner les billets';

  @override
  String get profileVendorScanSubtitle => 'Mode vendeur - contrôle d\'accès';

  @override
  String get profileSettingsSubtitle => 'Langue, thème, confidentialité';

  @override
  String get profileHelpTitle => 'Aide & support';

  @override
  String get profileHelpSubtitle => 'FAQ et contact';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get profileSignInPromptTitle => 'Connectez-vous';

  @override
  String get profileSignInPromptSubtitle =>
      'Accédez à vos réservations, favoris et plus encore';

  @override
  String get profileCompletionFirstName => 'Prénom';

  @override
  String get profileCompletionLastName => 'Nom';

  @override
  String get profileCompletionPhoto => 'Photo';

  @override
  String get profileCompletionBirthDate => 'Date de naissance';

  @override
  String get profileCompletionMembershipCity => 'Ville d\'adhésion';

  @override
  String get profileCompletionComplete => 'Profil complet';

  @override
  String profileCompletionProgress(int completed, int total) {
    return 'Profil $completed/$total - gagne 50 Hibons';
  }

  @override
  String get profileStatsBookings => 'Réservations';

  @override
  String get profileStatsFavorites => 'Favoris';

  @override
  String get profileStatsReviews => 'Avis';

  @override
  String get profileLogoutDialogBody =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileHelpOpenFailed => 'Impossible d\'ouvrir l\'aide';

  @override
  String get profileAvatarUpdated => 'Photo de profil mise à jour';

  @override
  String profileAvatarUploadError(String message) {
    return 'Erreur lors de l\'upload : $message';
  }

  @override
  String get profileLoginRequired => 'Veuillez vous connecter';

  @override
  String get profilePersonalInfoTitle => 'Informations personnelles';

  @override
  String get profileFirstNameLabel => 'Prénom';

  @override
  String get profileFirstNameRequired => 'Le prénom est requis';

  @override
  String get profileLastNameLabel => 'Nom';

  @override
  String get profileLastNameRequired => 'Le nom est requis';

  @override
  String get profilePhoneLabel => 'Téléphone';

  @override
  String get profileBirthDateLabel => 'Date de naissance';

  @override
  String get profileBirthDateUnset => 'Non renseigné';

  @override
  String get profileCityLabel => 'Ville';

  @override
  String get profileEmailReadOnlyHelper => 'L\'email ne peut pas être modifié';

  @override
  String get profileChangePasswordCta => 'Changer mon mot de passe';

  @override
  String profileUploadImageError(String message) {
    return 'Erreur lors de l\'upload de l\'image : $message';
  }

  @override
  String get profileUpdateSuccess => 'Profil mis à jour avec succès';

  @override
  String profileGenericError(String message) {
    return 'Erreur : $message';
  }

  @override
  String get profileChangePasswordTitle => 'Changer le mot de passe';

  @override
  String get profileCurrentPasswordLabel => 'Mot de passe actuel';

  @override
  String get profileNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get profilePasswordChangeSuccess => 'Mot de passe changé avec succès';

  @override
  String get profileChangePasswordSubmit => 'Changer';

  @override
  String get profileParticipantsPersonalizationNotice =>
      'Le prénom, la date de naissance, la ville et la relation aident Petit Boo et LeHiboo Expériences à vous proposer des offres et des événements plus pertinents.';

  @override
  String get profileParticipantsAddShort => 'Ajouter';

  @override
  String get profileParticipantsLoadError =>
      'Impossible de charger vos participants';

  @override
  String get profileParticipantAdded => 'Participant ajouté';

  @override
  String get profileParticipantUpdated => 'Participant modifié';

  @override
  String get profileParticipantDeleted => 'Participant supprimé';

  @override
  String get profileParticipantsEmptyTitle => 'Aucun participant';

  @override
  String get profileParticipantsEmptyBody =>
      'Ajoutez vos enfants, proches ou participants récurrents pour les choisir rapidement au moment de réserver.';

  @override
  String get profileParticipantsAddCta => 'Ajouter un participant';

  @override
  String get profileParticipantAddTitle => 'Ajouter un participant';

  @override
  String get profileParticipantEditTitle => 'Modifier le participant';

  @override
  String get profileParticipantFirstNameLabelRequired => 'Prénom *';

  @override
  String get profileParticipantFirstNameRequired => 'Prénom requis';

  @override
  String get profileParticipantLastNameLabelRequired => 'Nom *';

  @override
  String get profileParticipantLastNameRequired => 'Nom requis';

  @override
  String get profileParticipantNicknameLabel => 'Surnom';

  @override
  String get profileParticipantRelationshipLabelRequired => 'Relation *';

  @override
  String get profileParticipantRelationshipRequired => 'Relation requise';

  @override
  String get profileParticipantBirthDateLabelRequired => 'Date de naissance *';

  @override
  String get profileParticipantBirthDateRequired => 'Date de naissance requise';

  @override
  String get profileParticipantBirthDateHint => 'jj/mm/aaaa';

  @override
  String get profileParticipantCityLabelRequired => 'Ville d\'appartenance *';

  @override
  String get profileParticipantCityRequired => 'Ville requise';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesTabOrganizers => 'Organisateurs';

  @override
  String get messagesTabSupportLeHiboo => 'Support LeHiboo';

  @override
  String get messagesTabClients => 'Clients';

  @override
  String get messagesTabBroadcasts => 'Diffusions';

  @override
  String get messagesTabSupport => 'Support';

  @override
  String get messagesTabUsers => 'Utilisateurs';

  @override
  String get messagesTabReports => 'Signalements';

  @override
  String get messagesNewMessage => 'Nouveau message';

  @override
  String get messagesContactSupport => 'Contacter le support';

  @override
  String get messagesContactParticipant => 'Contacter un participant';

  @override
  String get messagesNewBroadcast => 'Nouvelle diffusion';

  @override
  String get messagesContactPartner => 'Contacter un partenaire';

  @override
  String get messagesBroadcastTitle => 'Diffusion';

  @override
  String messagesBroadcastCreateStepTitle(int step, int total) {
    return 'Nouvelle diffusion - Étape $step/$total';
  }

  @override
  String get messagesBroadcastStepRecipients => 'Destinataires';

  @override
  String get messagesBroadcastStepReview => 'Récapitulatif';

  @override
  String get messagesBroadcastSentSuccess => 'Diffusion envoyée avec succès.';

  @override
  String get messagesBroadcastSlotLabel => 'Créneau';

  @override
  String get messagesBroadcastChooseEvent => 'Choisir un événement';

  @override
  String get messagesBroadcastSelectEventFirst =>
      'Sélectionnez d\'abord un événement';

  @override
  String get messagesBroadcastLoadingSlots => 'Chargement des créneaux...';

  @override
  String get messagesBroadcastCalculatingRecipients =>
      'Calcul des destinataires...';

  @override
  String get messagesBroadcastRecipientsPreviewError =>
      'Impossible de calculer les destinataires.';

  @override
  String messagesBroadcastPotentialRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinataires potentiels',
      one: '1 destinataire potentiel',
    );
    return '$_temp0';
  }

  @override
  String get messagesBroadcastNoRecipientsForSelection =>
      'Aucun destinataire trouvé pour cette sélection';

  @override
  String get messagesBroadcastAllSlots => 'Tous les créneaux';

  @override
  String get messagesBroadcastChooseEventTitle => 'Choisir un événement';

  @override
  String get messagesBroadcastNoEventsFound => 'Aucun événement trouvé';

  @override
  String get messagesBroadcastSubjectLabel => 'Sujet';

  @override
  String get messagesBroadcastSubjectHint => 'Objet de votre message...';

  @override
  String messagesMinimumCharacters(int count) {
    return 'Minimum $count caractères';
  }

  @override
  String get messagesBroadcastReviewTitle => 'Récapitulatif';

  @override
  String get messagesRecipientsLabel => 'Destinataires';

  @override
  String messagesBroadcastRecipientsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinataires',
      one: '1 destinataire',
    );
    return '$_temp0';
  }

  @override
  String get messagesBroadcastProcessing =>
      'L\'envoi est en cours de traitement par le serveur.';

  @override
  String get messagesBroadcastStatusSent => 'Envoyée';

  @override
  String get messagesBroadcastStatusInProgress => 'En cours';

  @override
  String get messagesBroadcastReadLabel => 'Lus';

  @override
  String get messagesBroadcastConversationsLabel => 'Conversations';

  @override
  String get messagesBroadcastTargetedEventsLabel => 'Événements ciblés';

  @override
  String get messagesBroadcastSending => 'En cours d\'envoi...';

  @override
  String messagesBroadcastSlotFallback(int id) {
    return 'Créneau $id';
  }

  @override
  String get messagesSupportTicket => 'Ticket support';

  @override
  String get messagesContactUser => 'Contacter un utilisateur';

  @override
  String get messagesContactOrganizer => 'Contacter un organisateur';

  @override
  String get messagesGenericError => 'Une erreur est survenue.';

  @override
  String get messagesFallbackOrganizer => 'Organisateur';

  @override
  String get messagesNewConversationSubtitleSupport =>
      'Décrivez votre problème et notre équipe vous répondra rapidement.';

  @override
  String get messagesNewConversationSubtitleRecipient =>
      'Sélectionnez un destinataire et composez votre message.';

  @override
  String get messagesNewConversationSubtitleDefault =>
      'Composez votre message ci-dessous.';

  @override
  String get messagesRecipientLabel => 'Destinataire';

  @override
  String get messagesOrganizationLabel => 'Organisation';

  @override
  String get messagesParticipantLabel => 'Participant';

  @override
  String get messagesPartnerLabel => 'Partenaire';

  @override
  String get messagesSearchUserPlaceholder => 'Rechercher un utilisateur…';

  @override
  String get messagesSearchOrganizationPlaceholder =>
      'Rechercher une organisation…';

  @override
  String get messagesSearchParticipantPlaceholder =>
      'Rechercher un participant…';

  @override
  String get messagesSearchPartnerPlaceholder => 'Rechercher un partenaire…';

  @override
  String get messagesNoOrganizerAvailable => 'Aucun organisateur disponible';

  @override
  String get messagesSelectOrganizerPlaceholder =>
      'Sélectionner un organisateur…';

  @override
  String get messagesOrganizerPickerHelp =>
      'Parcourez les événements pour trouver un organisateur à contacter.';

  @override
  String get messagesSelectOrganizerRequired =>
      'Veuillez sélectionner un organisateur.';

  @override
  String get messagesFieldRequired => 'Ce champ est requis.';

  @override
  String get messagesEventLabel => 'Événement';

  @override
  String get messagesOptionalLabel => '(optionnel)';

  @override
  String get messagesSupportSubjectPrompt =>
      'Quel est le sujet de votre demande ?';

  @override
  String get messagesSubjectLabel => 'Objet';

  @override
  String get messagesSubjectHint => 'L\'objet de votre message';

  @override
  String get messagesSubjectRequired => 'Le sujet est obligatoire.';

  @override
  String get messagesMessageLabel => 'Message';

  @override
  String get messagesMessageHint => 'Écrivez votre message…';

  @override
  String get messagesMessageRequired => 'Le message est obligatoire.';

  @override
  String get messagesSend => 'Envoyer';

  @override
  String get messagesChooseOrganizerTitle => 'Choisir un organisateur';

  @override
  String get messagesSearchByNameHint => 'Rechercher par nom…';

  @override
  String messagesNoSearchResults(String query) {
    return 'Aucun résultat pour \"$query\".';
  }

  @override
  String get messagesSearchUserTitle => 'Rechercher un utilisateur';

  @override
  String get messagesUserSearchHint => 'Nom, prénom ou e-mail…';

  @override
  String get messagesNoUsersAvailable => 'Aucun utilisateur disponible.';

  @override
  String get messagesSearchOrganizationTitle => 'Rechercher une organisation';

  @override
  String get messagesOrganizationSearchHint => 'Nom de l\'organisation…';

  @override
  String get messagesNoOrganizationsAvailable =>
      'Aucune organisation disponible.';

  @override
  String get messagesSearchParticipantTitle => 'Rechercher un participant';

  @override
  String get messagesVendorParticipantSearchHelper =>
      'Seuls les participants ayant interagi avec votre organisation.';

  @override
  String get messagesNameOrEmailHint => 'Nom ou e-mail…';

  @override
  String get messagesNoParticipantsAvailable => 'Aucun participant disponible.';

  @override
  String get messagesSearchPartnerTitle => 'Rechercher un partenaire';

  @override
  String get messagesPartnerSearchHint => 'Nom de l\'organisation partenaire…';

  @override
  String get messagesNoPartnersAvailable => 'Aucun partenaire disponible.';

  @override
  String get messagesSupportSubjectBookingIssue => 'Problème de réservation';

  @override
  String get messagesSupportSubjectEventQuestion => 'Question sur un événement';

  @override
  String get messagesSupportSubjectPaymentIssue => 'Problème de paiement';

  @override
  String get messagesSupportSubjectRefundRequest => 'Demande de remboursement';

  @override
  String get messagesSupportSubjectAccountIssue => 'Problème de compte';

  @override
  String get messagesSupportSubjectContentReport => 'Signalement d\'un contenu';

  @override
  String get messagesCreateConversation => 'Créer la conversation';

  @override
  String get messagesNoResults => 'Aucun résultat';

  @override
  String get messagesSelectUserRequired =>
      'Veuillez sélectionner un utilisateur.';

  @override
  String get messagesSelectOrganizationRequired =>
      'Veuillez sélectionner une organisation.';

  @override
  String get messagesSelectParticipantRequired =>
      'Veuillez sélectionner un participant.';

  @override
  String get messagesSelectPartnerRequired =>
      'Veuillez sélectionner un partenaire.';

  @override
  String get messagesNoAcceptedPartners => 'Aucun partenaire accepté';

  @override
  String get messagesVendorParticipantAccessDenied =>
      'Ce participant n\'a pas d\'interaction avec votre organisation.';

  @override
  String get messagesVendorPartnerAccessDenied =>
      'Ce partenariat n\'est pas accepté.';

  @override
  String get messagesAccessDenied => 'Accès refusé.';

  @override
  String get messagesNoConversations => 'Aucune conversation';

  @override
  String get messagesNoSupportConversations =>
      'Aucune conversation avec le support';

  @override
  String get messagesNoClients => 'Aucun client';

  @override
  String get messagesNoBroadcasts => 'Aucune diffusion envoyée';

  @override
  String get messagesNoPartners => 'Aucun partenaire';

  @override
  String get messagesNoSupportTickets => 'Aucun ticket support';

  @override
  String get messagesNoReports => 'Aucun signalement';

  @override
  String messagesLoadError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get messagesSearchHint => 'Rechercher…';

  @override
  String get messagesFilterReset => 'Réinitialiser';

  @override
  String get messagesFilterUnread => 'Non lus';

  @override
  String get messagesFilterOpen => 'Ouverts';

  @override
  String get messagesFilterClosed => 'Fermés';

  @override
  String get messagesFilterThisWeek => 'Cette semaine';

  @override
  String get messagesFilterThisMonth => 'Ce mois';

  @override
  String get messagesFilterOlder => 'Plus ancien';

  @override
  String get messagesReasonInappropriate => 'Contenu inapproprié';

  @override
  String get messagesReasonHarassment => 'Harcèlement';

  @override
  String get messagesReasonSpam => 'Spam';

  @override
  String get messagesReasonOther => 'Autre';

  @override
  String get messagesReportLabel => 'Signaler';

  @override
  String get messagesReportedLabel => 'Signalé';

  @override
  String get messagesReportBadge => 'Signalement';

  @override
  String get messagesStatusClosed => 'Fermé';

  @override
  String get messagesStatusPending => 'En attente';

  @override
  String get messagesStatusOpen => 'Ouvert';

  @override
  String get messagesNotificationOpenAction => 'Ouvrir';

  @override
  String get messagesDeletedPreview => 'Message supprimé';

  @override
  String get messagesRelativeJustNow => 'À l\'instant';

  @override
  String messagesRelativeDaysShort(int count) {
    return '${count}j';
  }

  @override
  String get messagesComposerHint => 'Votre message…';

  @override
  String get messagesComposerClosed => 'Cette conversation est fermée';

  @override
  String get messagesDeletedMessage => 'Ce message a été supprimé';

  @override
  String get messagesEditedSuffix => '(modifié)';

  @override
  String get messagesEditAction => 'Modifier';

  @override
  String get messagesCopyTextAction => 'Copier le texte';

  @override
  String get messagesDeleteAction => 'Supprimer';

  @override
  String get messagesReopenTooltip => 'Rouvrir';

  @override
  String get messagesCloseConversation => 'Fermer la conversation';

  @override
  String get messagesReadonlyBanner =>
      'Mode lecture seule - conversation liée à un signalement. Vous observez les échanges entre les deux parties.';

  @override
  String get messagesClosedNotice => 'Cette conversation est fermée.';

  @override
  String get messagesEmptyThread =>
      'Aucun message. Soyez le premier à écrire !';

  @override
  String get messagesCloseConversationBody =>
      'Voulez-vous fermer cette conversation ? Vous ne pourrez plus envoyer de messages.';

  @override
  String get messagesReportSheetTitle => 'Signaler la conversation';

  @override
  String get messagesReportSheetSubtitle =>
      'Aidez-nous à maintenir un environnement sûr en signalant les contenus inappropriés.';

  @override
  String get messagesReportReasonLabel => 'Raison';

  @override
  String get messagesReportCommentLabel => 'Commentaire';

  @override
  String get messagesReportMinCharsHint => '(min. 10 caractères)';

  @override
  String get messagesReportReasonRequired =>
      'Veuillez sélectionner une raison.';

  @override
  String get messagesReportCommentMinError => 'Minimum 10 caractères.';

  @override
  String get messagesReportCommentHint => 'Décrivez le problème…';

  @override
  String get messagesReportSubmit => 'Signaler';

  @override
  String get messagesReportSuccessTitle => 'Signalement transmis';

  @override
  String get messagesReportSuccessBody =>
      'Votre signalement a bien été transmis à l\'équipe LeHiboo.';

  @override
  String get messagesReportSupportCreated =>
      'Un ticket support a été créé pour le suivi.';

  @override
  String get messagesSendFailedRetry => 'Échec de l\'envoi. Réessayez.';

  @override
  String get messagesViewAction => 'Voir';

  @override
  String messagesAdminReportFallbackTitle(String reportId) {
    return 'Signalement $reportId';
  }

  @override
  String get messagesAdminReportDetailTitle => 'Détail du signalement';

  @override
  String get messagesAdminReportNotFound => 'Signalement introuvable';

  @override
  String get messagesUntitledConversation => 'Conversation sans titre';

  @override
  String get messagesAdminReportPartiesSection => 'Parties impliquées';

  @override
  String get messagesAdminReportReporterLabel => 'Rapporteur';

  @override
  String get messagesAdminReportReportedLabel => 'Signalé';

  @override
  String get messagesUserLabel => 'Utilisateur';

  @override
  String get messagesAdminReportReasonSection => 'Motif du signalement';

  @override
  String get messagesAdminReportInternalNoteSection =>
      'Note interne (non visible par les usagers)';

  @override
  String get messagesAdminReportNoteHint => 'Ajouter une note de modération…';

  @override
  String get messagesAdminReportNoteSaved => 'Note enregistrée.';

  @override
  String get messagesAdminReportModerationActionsSection =>
      'Actions de modération';

  @override
  String get messagesAdminReportFinalActionsWarning =>
      'Ces actions sont définitives et ne peuvent pas être annulées.';

  @override
  String get messagesAdminReportDismissAction => 'Ignorer';

  @override
  String get messagesAdminReportMarkReviewedAction => 'Marquer traité';

  @override
  String get messagesAdminReportDismissConfirmBody =>
      'Ce signalement sera marqué comme ignoré. Confirmez-vous cette action ?';

  @override
  String get messagesAdminReportReviewConfirmBody =>
      'Ce signalement sera marqué comme traité. Confirmez-vous cette action ?';

  @override
  String get messagesAdminReportDismissedSnackbar => 'Signalement ignoré.';

  @override
  String get messagesAdminReportReviewedSnackbar =>
      'Signalement marqué comme traité.';

  @override
  String get messagesAdminReportViewConversation => 'Voir la conversation liée';

  @override
  String get messagesAdminReportStatusReviewed => 'Traité';

  @override
  String get messagesAdminReportStatusDismissed => 'Ignoré';

  @override
  String get messagesAdminReportStatusSuspended => 'Suspendu';

  @override
  String get legalTerms => 'Conditions Générales d\'Utilisation';

  @override
  String get legalSales => 'Conditions Générales de Vente';

  @override
  String get legalPrivacy => 'Politique de confidentialité';

  @override
  String get legalCookies => 'Politique cookies';

  @override
  String get legalNotices => 'Mentions légales';

  @override
  String legalOpenFailed(String documentLabel) {
    return 'Ouverture impossible : $documentLabel';
  }

  @override
  String get voiceTooltipHoldToTalk => 'Maintiens pour parler';

  @override
  String voiceMicrophoneError(String message) {
    return 'Erreur micro : $message';
  }

  @override
  String get voiceAllowMicrophoneSettings => 'Autorise le micro dans Réglages';

  @override
  String get voiceAllowSpeechSettings =>
      'Autorise la reconnaissance vocale dans Réglages';

  @override
  String get voiceMicrophoneUnavailable => 'Le micro n\'est pas disponible';

  @override
  String get voiceNothingHeard => 'Je n\'ai rien entendu';

  @override
  String get petitBooChatHintListening => 'Je vous écoute...';

  @override
  String get petitBooChatHintStreaming => 'Petit Boo réfléchit...';

  @override
  String get petitBooChatHintIdle =>
      'Posez une question à votre assistant ou tapez / pour les commandes...';

  @override
  String get petitBooDisclaimer =>
      'L\'IA peut commettre des erreurs. Vérifiez les informations importantes.';

  @override
  String get petitBooStatusResponding => 'Répond...';

  @override
  String get petitBooStatusAssistantAi => 'Assistant IA';

  @override
  String get petitBooHistoryTitle => 'Historique';

  @override
  String get petitBooNewConversation => 'Nouvelle conversation';

  @override
  String get petitBooServiceUnavailable =>
      'Petit Boo est temporairement indisponible';

  @override
  String get petitBooGreetingMorning => 'Bonjour';

  @override
  String get petitBooGreetingAfternoon => 'Bon après-midi';

  @override
  String get petitBooGreetingEvening => 'Bonsoir';

  @override
  String petitBooGreetingWithName(String greeting, String name) {
    return '$greeting $name !';
  }

  @override
  String petitBooGreetingNoName(String greeting) {
    return '$greeting !';
  }

  @override
  String petitBooSubtitleWithCity(String city) {
    return 'Que puis-je faire pour vous à $city ?';
  }

  @override
  String get petitBooSubtitleDefault =>
      'Comment puis-je vous aider aujourd\'hui ?';

  @override
  String get petitBooQuickTonight => 'Ce soir';

  @override
  String get petitBooQuickTonightPrompt => 'Que faire ce soir ?';

  @override
  String petitBooQuickTonightPromptWithCity(String city) {
    return 'Que faire ce soir à $city ?';
  }

  @override
  String get petitBooQuickWeekend => 'Week-end';

  @override
  String get petitBooQuickWeekendPrompt => 'Événements ce week-end';

  @override
  String petitBooQuickWeekendPromptWithCity(String city) {
    return 'Événements ce week-end à $city';
  }

  @override
  String get petitBooQuickTickets => 'Mes billets';

  @override
  String get petitBooQuickTicketsPrompt => 'Affiche mes réservations';

  @override
  String get petitBooQuickFavorites => 'Favoris';

  @override
  String get petitBooQuickFavoritesPrompt => 'Mes favoris';

  @override
  String get petitBooTryAsking => 'Essayez de me demander...';

  @override
  String get petitBooSuggestionTonight => 'Quels événements ce soir ?';

  @override
  String petitBooSuggestionTonightWithCity(String city) {
    return 'Quels événements ce soir à $city ?';
  }

  @override
  String get petitBooSuggestionKids => 'Activités pour enfants ce week-end';

  @override
  String petitBooSuggestionKidsWithCity(String city) {
    return 'Activités pour enfants à $city';
  }

  @override
  String get petitBooSuggestionFood => 'Sorties gastronomiques ce week-end';

  @override
  String petitBooSuggestionFoodWithCity(String city) {
    return 'Sorties gastronomiques à $city';
  }

  @override
  String get petitBooSuggestionConcerts => 'Concerts et spectacles à venir';

  @override
  String petitBooSuggestionConcertsWithCity(String city) {
    return 'Concerts et spectacles à $city';
  }

  @override
  String get petitBooEmptyHistoryTitle => 'Aucune conversation';

  @override
  String get petitBooEmptyHistoryBody =>
      'Démarrez une conversation avec Petit Boo\npour obtenir de l\'aide personnalisée';

  @override
  String get petitBooErrorTitle => 'Oups !';

  @override
  String get petitBooDeleteConversationTitle =>
      'Supprimer cette conversation ?';

  @override
  String get petitBooDeleteConversationBody => 'Cette action est irréversible.';

  @override
  String get petitBooConversationDeleted => 'Conversation supprimée';

  @override
  String get petitBooConversationFallbackTitle => 'Conversation';

  @override
  String get petitBooConversationsAuthRequired =>
      'Connectez-vous pour voir vos conversations';

  @override
  String get petitBooConversationsLoadFailed =>
      'Impossible de charger les conversations';

  @override
  String get petitBooEngagementWelcome => 'Bonjour ! Je peux vous aider ? 🌟';

  @override
  String get petitBooEngagementInspiration =>
      'Vous cherchez l\'inspiration ? 💡';

  @override
  String get petitBooEngagementNoResults =>
      'Oups, rien trouvé ? Je peux chercher pour vous ! 🕵️‍♂️';

  @override
  String get petitBooEngagementIdle =>
      'Psst... Je connais des coins sympas ! 🗺️';

  @override
  String petitBooRelativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String petitBooMessageCountShort(int count) {
    return '$count msg';
  }

  @override
  String get petitBooBrainTitle => 'Mémoire de Petit Boo';

  @override
  String get petitBooMemoryKnownTitle => 'Ce que je sais sur vous';

  @override
  String get petitBooMemoryClearAll => 'Tout effacer';

  @override
  String get petitBooMemoryEnabled => 'Mémoire activée';

  @override
  String get petitBooMemoryPaused => 'Mémoire en pause';

  @override
  String get petitBooMemoryEnabledDescription =>
      'Petit Boo apprend de vos échanges pour vous proposer des sorties qui vous ressemblent. Vous pouvez corriger ou supprimer ces infos ci-dessous.';

  @override
  String get petitBooMemoryPausedDescription =>
      'Petit Boo ne retient plus rien de vos nouvelles conversations. Les anciennes informations restent stockées mais ne sont pas utilisées.';

  @override
  String get petitBooMemoryEmptyTitle =>
      'Je n\'ai pas encore d\'infos sur vous.';

  @override
  String get petitBooMemoryEmptyBody =>
      'Discutez avec moi pour que j\'apprenne vos goûts.';

  @override
  String get petitBooMemoryDisabledBody =>
      'Réactivez la mémoire pour voir et modifier vos informations.';

  @override
  String get petitBooMemoryEditAction => 'Modifier';

  @override
  String get petitBooMemoryForgetAction => 'Oublier';

  @override
  String petitBooMemoryEditTitle(String label) {
    return 'Modifier $label';
  }

  @override
  String get petitBooMemoryNewValueHint => 'Nouvelle valeur';

  @override
  String get petitBooMemoryForgetTitle => 'Oublier cette info ?';

  @override
  String petitBooMemoryForgetBody(String label) {
    return 'Voulez-vous vraiment que Petit Boo oublie : $label ?';
  }

  @override
  String get petitBooMemoryNoKeep => 'Non, garder';

  @override
  String get petitBooMemoryForgetConfirm => 'Oui, oublier';

  @override
  String get petitBooMemoryClearAllTitle => 'Tout effacer ?';

  @override
  String get petitBooMemoryClearAllBody =>
      'Voulez-vous vraiment effacer toutes les informations que Petit Boo a apprises sur vous ?';

  @override
  String get petitBooMemoryClearAllConfirm => 'Oui, tout effacer';

  @override
  String get petitBooMemoryLabelFirstName => 'Prénom';

  @override
  String get petitBooMemoryLabelLastName => 'Nom';

  @override
  String get petitBooMemoryLabelNickname => 'Surnom';

  @override
  String get petitBooMemoryLabelAge => 'Âge';

  @override
  String get petitBooMemoryLabelBirthYear => 'Année de naissance';

  @override
  String get petitBooMemoryLabelAgeGroup => 'Tranche d\'âge';

  @override
  String get petitBooMemoryLabelCity => 'Ville';

  @override
  String get petitBooMemoryLabelRegion => 'Région';

  @override
  String get petitBooMemoryLabelCountry => 'Pays';

  @override
  String get petitBooMemoryLabelLatitude => 'Latitude';

  @override
  String get petitBooMemoryLabelLongitude => 'Longitude';

  @override
  String get petitBooMemoryLabelMaxDistance => 'Distance max (km)';

  @override
  String get petitBooMemoryLabelFavoriteActivities => 'Activités préférées';

  @override
  String get petitBooMemoryLabelDislikedActivities => 'Activités à éviter';

  @override
  String get petitBooMemoryLabelFavoriteCategories => 'Catégories préférées';

  @override
  String get petitBooMemoryLabelBudgetPreference => 'Budget';

  @override
  String get petitBooMemoryLabelGroupType => 'Type de groupe';

  @override
  String get petitBooMemoryLabelHasChildren => 'A des enfants';

  @override
  String get petitBooMemoryLabelChildrenAges => 'Âge des enfants';

  @override
  String get petitBooMemoryLabelDietaryPreferences => 'Régime alimentaire';

  @override
  String get petitBooMemoryLabelMobilityConstraints =>
      'Contraintes de mobilité';

  @override
  String get petitBooMemoryLabelPetFriendlyNeeded => 'Animaux acceptés';

  @override
  String get petitBooMemoryLabelPreferredTimes => 'Moments préférés';

  @override
  String get petitBooMemoryLabelPreferredLanguage => 'Langue préférée';

  @override
  String get petitBooMemoryLabelInterests => 'Centres d\'intérêt';

  @override
  String get petitBooMemoryLabelLastUpdated => 'Dernière mise à jour';

  @override
  String get petitBooMemoryUndefined => 'Non défini';

  @override
  String get petitBooMemoryYes => 'Oui';

  @override
  String get petitBooMemoryNo => 'Non';

  @override
  String get petitBooMemoryAgeGroupYoungAdult => 'Jeune adulte';

  @override
  String get petitBooMemoryAgeGroupAdult => 'Adulte';

  @override
  String get petitBooMemoryAgeGroupSenior => 'Senior';

  @override
  String get petitBooMemoryBudgetLow => 'Petit budget';

  @override
  String get petitBooMemoryBudgetMedium => 'Budget moyen';

  @override
  String get petitBooMemoryBudgetHigh => 'Gros budget';

  @override
  String get petitBooMemoryGroupSolo => 'Seul(e)';

  @override
  String get petitBooMemoryGroupCouple => 'En couple';

  @override
  String get petitBooMemoryGroupFamily => 'En famille';

  @override
  String get petitBooMemoryGroupFriends => 'Entre amis';

  @override
  String get petitBooQuotaHeaderTitle => 'Vos messages avec Petit Boo';

  @override
  String get petitBooQuotaHeaderSubtitle => 'Comment fonctionne votre quota';

  @override
  String get petitBooQuotaRemainingLabel => 'restants';

  @override
  String petitBooQuotaUsage(int used, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      used,
      locale: localeName,
      other: '$used messages utilisés',
      one: '1 message utilisé',
    );
    return '$_temp0 sur $limit';
  }

  @override
  String petitBooQuotaRenewalTitle(String period) {
    return 'Renouvellement $period';
  }

  @override
  String petitBooQuotaRenewsAt(String time) {
    return 'Votre quota se renouvelle $time';
  }

  @override
  String get petitBooQuotaRenewsAutomatically =>
      'Votre quota se renouvelle automatiquement';

  @override
  String get petitBooQuotaTipTitle => 'Astuce';

  @override
  String get petitBooQuotaTipDescription =>
      'Posez des questions précises pour obtenir des réponses plus pertinentes et économiser vos messages.';

  @override
  String get petitBooQuotaWhyTitle => 'Pourquoi un quota ?';

  @override
  String get petitBooQuotaWhyDescription =>
      'Petit Boo utilise une IA avancée pour vous aider. Le quota nous permet de garantir un service de qualité pour tous.';

  @override
  String get petitBooQuotaUnderstood => 'J\'ai compris';

  @override
  String get petitBooQuotaPeriodDaily => 'quotidien';

  @override
  String get petitBooQuotaPeriodWeekly => 'hebdomadaire';

  @override
  String get petitBooQuotaPeriodMonthly => 'mensuel';

  @override
  String get petitBooQuotaPeriodAutomatic => 'automatique';

  @override
  String get petitBooQuotaResetVerySoon => 'très bientôt';

  @override
  String petitBooQuotaResetInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return 'dans $_temp0';
  }

  @override
  String get petitBooQuotaResetTomorrow => 'demain';

  @override
  String petitBooQuotaResetInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return 'dans $_temp0';
  }

  @override
  String get petitBooQuotaResetInOneHour => 'dans 1 heure';

  @override
  String petitBooQuotaResetInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return 'dans $_temp0';
  }

  @override
  String get petitBooQuotaResetSoon => 'dans quelques instants';

  @override
  String get petitBooQuotaResetAutomatically => 'automatiquement';

  @override
  String get petitBooQuotaDisplayTitle => 'Quota de messages';

  @override
  String petitBooQuotaDisplayResets(String time) {
    return 'Renouvellement : $time';
  }

  @override
  String get petitBooLimitTitle => 'Oups, c\'est déjà fini ?';

  @override
  String get petitBooLimitBody =>
      'Petit Boo a besoin d\'énergie pour continuer à chercher des pépites pour vous. Rechargez son stock de Hibons pour débloquer la conversation.';

  @override
  String petitBooLimitWalletBalance(int balance) {
    return 'Solde : $balance Hibons';
  }

  @override
  String petitBooLimitContinue(int cost, int messages) {
    String _temp0 = intl.Intl.pluralLogic(
      messages,
      locale: localeName,
      other: '$messages msg',
      one: '1 msg',
    );
    return 'Continuer pour $cost Hibons (+$_temp0)';
  }

  @override
  String petitBooLimitWatchAdReward(int amount) {
    return 'Regarder une pub (+$amount Hibons)';
  }

  @override
  String get petitBooLimitComeBackTomorrow =>
      'Revenez demain pour de nouveaux messages.';

  @override
  String get petitBooMaybeLater => 'Peut-être plus tard';

  @override
  String get petitBooConversationUnlocked => 'Conversation débloquée.';

  @override
  String get petitBooUnlockFailed => 'Impossible de débloquer la conversation';

  @override
  String get petitBooComingSoon => 'Fonctionnalité bientôt disponible.';

  @override
  String petitBooErrorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String petitBooFavoriteAddedWithTitle(String eventTitle) {
    return '\"$eventTitle\" ajouté aux favoris';
  }

  @override
  String get petitBooFavoriteAdded => 'Ajouté aux favoris';

  @override
  String get petitBooFavoriteRemoved => 'Retiré des favoris';

  @override
  String petitBooHibonsEarned(int amount) {
    return '+$amount Hibons gagnés !';
  }

  @override
  String get petitBooToolFavoritesDescription => 'Mes événements favoris';

  @override
  String get petitBooToolFavoritesTitle => 'Tes favoris';

  @override
  String get petitBooToolFavoritesEmpty => 'Aucun favori';

  @override
  String get petitBooToolSearchEventsDescription => 'Recherche d\'événements';

  @override
  String get petitBooToolSearchEventsTitle => 'Événements trouvés';

  @override
  String get petitBooToolSearchEventsEmpty =>
      'Aucun événement trouvé avec ces critères';

  @override
  String get petitBooToolFreeBadge => 'Gratuit';

  @override
  String get petitBooToolBookingsDescription => 'Mes réservations';

  @override
  String get petitBooToolBookingsTitle => 'Tes réservations';

  @override
  String get petitBooToolBookingsEmpty => 'Aucune réservation';

  @override
  String get petitBooToolTicketsDescription => 'Mes billets';

  @override
  String get petitBooToolTicketsTitle => 'Tes billets';

  @override
  String get petitBooToolTicketsEmpty => 'Aucun billet';

  @override
  String get petitBooToolEventDetailsDescription => 'Détails d\'un événement';

  @override
  String get petitBooToolAlertsDescription => 'Mes alertes';

  @override
  String get petitBooToolAlertsTitle => 'Tes alertes';

  @override
  String get petitBooToolAlertsEmpty => 'Aucune alerte';

  @override
  String get petitBooToolProfileDescription => 'Mon profil';

  @override
  String get petitBooToolProfileStatBookings => 'Réservations';

  @override
  String get petitBooToolProfileStatParticipations => 'Participations';

  @override
  String get petitBooToolProfileStatFavorites => 'Favoris';

  @override
  String get petitBooToolProfileStatAlerts => 'Alertes';

  @override
  String get petitBooToolNotificationsDescription => 'Mes notifications';

  @override
  String get petitBooToolNotificationsTitle => 'Tes notifications';

  @override
  String get petitBooToolNotificationsEmpty => 'Aucune notification';

  @override
  String get petitBooToolBrainDescription => 'Ma mémoire';

  @override
  String get petitBooToolBrainTitle => 'Ce que je sais de toi';

  @override
  String get petitBooToolBrainEmpty => 'Je ne sais encore rien. Discutons.';

  @override
  String get petitBooToolBrainSectionFamily => 'Famille';

  @override
  String get petitBooToolBrainSectionLocation => 'Localisation';

  @override
  String get petitBooToolBrainSectionPreferences => 'Préférences';

  @override
  String get petitBooToolBrainSectionConstraints => 'Contraintes';

  @override
  String get petitBooToolUpdateBrainDescription => 'Mettre à jour ma mémoire';

  @override
  String get petitBooToolAddFavoriteDescription => 'Ajouter aux favoris';

  @override
  String get petitBooToolRemoveFavoriteDescription => 'Retirer des favoris';

  @override
  String get petitBooToolCreateFavoriteListDescription =>
      'Créer une liste de favoris';

  @override
  String get petitBooToolMoveToListDescription => 'Déplacer vers une liste';

  @override
  String get petitBooToolFavoriteListsDescription =>
      'Voir mes listes de favoris';

  @override
  String get petitBooToolFavoriteListsTitle => 'Mes listes de favoris';

  @override
  String get petitBooToolUpdateFavoriteListDescription => 'Renommer une liste';

  @override
  String get petitBooToolDeleteFavoriteListDescription => 'Supprimer une liste';

  @override
  String get petitBooToolPlanTripDescription => 'Planifier un itinéraire';

  @override
  String get petitBooToolPlanTripTitle => 'Ton itinéraire';

  @override
  String get petitBooToolSaveTripPlanDescription =>
      'Sauvegarder un plan de sortie';

  @override
  String get petitBooToolTripPlansDescription => 'Mes plans de sortie';

  @override
  String get petitBooToolTripPlansTitle => 'Tes sorties planifiées';

  @override
  String get petitBooToolTripPlansEmpty => 'Aucune sortie planifiée';

  @override
  String petitBooToolItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String petitBooToolViewItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les $count éléments',
      one: '1 élément',
    );
    return 'Voir $_temp0';
  }

  @override
  String get petitBooToolEmptyListFallback => 'Aucun élément';

  @override
  String get petitBooToolUntitled => 'Sans titre';

  @override
  String get petitBooToolStatusActive => 'Active';

  @override
  String get petitBooToolStatusInactive => 'Inactive';

  @override
  String get petitBooToolEventFallbackTitle => 'Événement';

  @override
  String petitBooToolEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count événements',
      one: '1 événement',
    );
    return '$_temp0';
  }

  @override
  String petitBooToolViewEvents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les $count événements',
      one: '1 événement',
    );
    return 'Voir $_temp0';
  }

  @override
  String petitBooEventDateTime(String date, String time) {
    return '$date à $time';
  }

  @override
  String get petitBooEventAvailabilityAction => 'Voir les disponibilités';

  @override
  String get petitBooEventPriceFrom => 'À partir de';

  @override
  String petitBooEventPriceTiers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarifs',
      one: '1 tarif',
    );
    return '$_temp0';
  }

  @override
  String petitBooTripSavedPlansCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plans sauvegardés',
      one: '1 plan sauvegardé',
    );
    return '$_temp0';
  }

  @override
  String petitBooTripStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étapes',
      one: '1 étape',
    );
    return '$_temp0';
  }

  @override
  String petitBooTripMoreStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count autres étapes',
      one: '+1 autre étape',
    );
    return '$_temp0';
  }

  @override
  String get petitBooTripFallbackStop => 'Étape';

  @override
  String get petitBooTripFallbackListTitle => 'Plan sans titre';

  @override
  String get petitBooTripLoadErrorTitle => 'Impossible de charger tes sorties';

  @override
  String get petitBooTripLoadErrorRetry => 'Réessaie dans quelques instants';

  @override
  String get petitBooTripEmptyPrompt => 'Demande-moi de planifier une sortie !';

  @override
  String get petitBooTripViewAll => 'Voir toutes mes sorties';

  @override
  String get petitBooTripExpandMap => 'Agrandir la carte';

  @override
  String get petitBooTripCollapseMap => 'Réduire';

  @override
  String get petitBooTripTipsTitle => 'Conseils';

  @override
  String get petitBooTripSave => 'Sauvegarder';

  @override
  String get petitBooTripSaved => 'Sauvegardé';

  @override
  String get petitBooTripShowMap => 'Voir carte';

  @override
  String get petitBooTripHideMap => 'Masquer carte';

  @override
  String get petitBooTripSavePlanPrompt => 'Sauvegarde ce plan de sortie';

  @override
  String get petitBooTripNoCoordinates => 'Aucune coordonnée disponible';

  @override
  String get petitBooQuotaExceededError =>
      'Vous avez atteint votre limite de messages';

  @override
  String get petitBooConnectionError => 'Erreur de connexion';

  @override
  String get petitBooAuthRequiredError =>
      'Connectez-vous pour discuter avec Petit Boo';

  @override
  String get petitBooConversationLoadFailed =>
      'Impossible de charger la conversation';

  @override
  String get petitBooApiErrorFallback => 'Erreur Petit Boo';

  @override
  String get petitBooGenericError => 'Une erreur est survenue';

  @override
  String get petitBooBrainManageMemory => 'Gérer ma mémoire';

  @override
  String get petitBooBrainRecommendationHint =>
      'Parle-moi de toi pour que je puisse te faire de meilleures recommandations.';

  @override
  String get petitBooToolHibonsBalance => 'Solde Hibons';

  @override
  String petitBooToolHibonsAmount(int amount) {
    return '$amount Hibons';
  }

  @override
  String get petitBooActionView => 'Voir';

  @override
  String get petitBooActionMyFavorites => 'Mes favoris';

  @override
  String get petitBooActionAddedSuccessfully => 'Ajouté avec succès';

  @override
  String get petitBooActionRemovedSuccessfully => 'Retiré avec succès';

  @override
  String get petitBooActionBrainNoted => 'C\'est noté !';

  @override
  String get petitBooActionListCreatedTitle => 'Liste créée';

  @override
  String get petitBooActionNewListCreated => 'Nouvelle liste créée';

  @override
  String petitBooActionListCreatedWithName(String name) {
    return 'Liste \"$name\" créée';
  }

  @override
  String get petitBooActionViewList => 'Voir la liste';

  @override
  String get petitBooActionMovedTitle => 'Déplacé';

  @override
  String petitBooActionMovedToList(String eventTitle, String listName) {
    return '\"$eventTitle\" déplacé vers \"$listName\"';
  }

  @override
  String get petitBooActionMovedSuccessfully => 'Déplacé avec succès';

  @override
  String get petitBooActionMovedToListFallback => 'Déplacé vers la liste';

  @override
  String get petitBooActionMyLists => 'Mes listes';

  @override
  String get petitBooActionListRenamedTitle => 'Liste renommée';

  @override
  String petitBooActionListRenamedWithName(String name) {
    return 'Liste renommée en \"$name\"';
  }

  @override
  String get petitBooActionListDeletedTitle => 'Liste supprimée';

  @override
  String petitBooActionListDeletedWithName(String name) {
    return '\"$name\" supprimée';
  }

  @override
  String get petitBooActionDoneTitle => 'Action effectuée';

  @override
  String get petitBooActionDoneSuccessfully => 'Effectué avec succès';

  @override
  String get petitBooActionBrainProfileUpdated => 'Profil mis à jour';

  @override
  String get petitBooActionBrainFamilyUpdated => 'Famille mise à jour';

  @override
  String get petitBooActionBrainPreferenceSaved => 'Préférence notée';

  @override
  String get petitBooActionBrainConstraintSaved => 'Contrainte notée';

  @override
  String get petitBooActionBrainMemoryUpdated => 'Mémoire mise à jour';

  @override
  String petitBooActionBrainNotedValue(String value) {
    return 'Noté : $value';
  }

  @override
  String get petitBooActionBrainRememberFallback => 'Je me souviendrai de ça';

  @override
  String petitBooActionListRenamedFromTo(String oldName, String newName) {
    return '\"$oldName\" → \"$newName\"';
  }

  @override
  String petitBooActionListNewName(String name) {
    return 'Nouveau nom : \"$name\"';
  }

  @override
  String get petitBooActionListRenamedSuccessfully =>
      'Liste renommée avec succès';

  @override
  String get petitBooActionErrorTitle => 'Échec';

  @override
  String get petitBooActionGenericError => 'Une erreur est survenue';

  @override
  String petitBooFavoriteListsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listes',
      one: '1 liste',
    );
    return '$_temp0';
  }

  @override
  String get petitBooFavoriteListsNoName => 'Sans nom';

  @override
  String get petitBooFavoriteListsViewAll => 'Voir tout';

  @override
  String get petitBooFavoriteListsEmptyTitle => 'Aucune liste pour le moment';

  @override
  String get petitBooFavoriteListsEmptyBody => 'Demande-moi d\'en créer une.';

  @override
  String get petitBooFavoriteListEventsEmpty => 'Vide';

  @override
  String petitBooFavoriteListEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count événements',
      one: '1 événement',
    );
    return '$_temp0';
  }

  @override
  String get bookingTicketSingular => '1 billet';

  @override
  String bookingTicketPlural(int count) {
    return '$count billets';
  }

  @override
  String get bookingLifecycleCancelled => 'Annulé';

  @override
  String get bookingLifecyclePast => 'Passé';

  @override
  String get bookingLifecycleUpcoming => 'À venir';

  @override
  String broadcastSentOn(String date) {
    return 'Envoyée le $date';
  }

  @override
  String broadcastCreatedOn(String date) {
    return 'Créée le $date';
  }

  @override
  String adminReportReviewedBy(Object name) {
    return 'Traité par $name';
  }

  @override
  String adminReportReviewedByOn(Object date, Object name) {
    return 'Traité par $name le $date';
  }

  @override
  String get membershipMember => 'Membre';

  @override
  String membershipMemberSince(Object date) {
    return 'Membre depuis le $date';
  }

  @override
  String get membershipRequestSent => 'Demande envoyée';

  @override
  String membershipRequestSentOn(Object date) {
    return 'Demande envoyée le $date';
  }

  @override
  String get membershipRequestRejected => 'Demande non acceptée';

  @override
  String membershipRequestRejectedOn(Object date) {
    return 'Demande du $date - non acceptée';
  }

  @override
  String get membershipSearchOrganizationHint => 'Rechercher une organisation…';

  @override
  String membershipTabActive(int count) {
    return 'Actives ($count)';
  }

  @override
  String membershipTabPending(int count) {
    return 'En attente ($count)';
  }

  @override
  String membershipTabRejected(int count) {
    return 'Refusées ($count)';
  }

  @override
  String membershipTabInvitations(int count) {
    return 'Invitations ($count)';
  }

  @override
  String get membershipEmptyActive =>
      'Aucune adhésion active.\nRejoignez vos organisations préférées pour ne rien manquer.';

  @override
  String get membershipEmptyPending =>
      'Vous n\'avez pas de demande en attente.';

  @override
  String get membershipEmptyRejected => 'Aucune demande refusée.';

  @override
  String get membershipEmptyInvitations => 'Aucune invitation pour le moment.';

  @override
  String get membershipDiscoverOrganizations => 'Découvrir les organisations';

  @override
  String get membershipLoadError => 'Impossible de charger vos adhésions.';

  @override
  String get membershipStatusPending => 'En attente';

  @override
  String get membershipStatusActive => 'Actif';

  @override
  String get membershipStatusRejected => 'Refusée';

  @override
  String get membershipStatusInvitation => 'Invitation';

  @override
  String get membershipStatusExpired => 'Expirée';

  @override
  String get membershipViewOrganizer => 'Voir la fiche';

  @override
  String get membershipPrivateEventsAction => 'Événements privés';

  @override
  String membershipMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get membershipJoinAction => 'Rejoindre';

  @override
  String get membershipPendingAction => 'En attente';

  @override
  String get membershipRetryRequestAction => 'Refaire la demande';

  @override
  String get membershipCancelRequestAction => 'Annuler la demande';

  @override
  String get membershipLeaveAction => 'Quitter';

  @override
  String get membershipCancelRequestTitle => 'Annuler la demande ?';

  @override
  String membershipCancelRequestBody(String organizerName) {
    return 'Votre demande de rejoindre $organizerName sera annulée. Vous pourrez en refaire une à tout moment.';
  }

  @override
  String get membershipLeaveTitle => 'Quitter l\'organisation ?';

  @override
  String membershipLeaveBody(String organizerName) {
    return 'Vous ne verrez plus les événements privés de $organizerName. Vous pourrez refaire une demande à tout moment.';
  }

  @override
  String membershipJoinTitle(String organizerName) {
    return 'Rejoindre l\'espace privé de $organizerName ?';
  }

  @override
  String get membershipJoinBody =>
      'En rejoignant, vous accédez aux événements exclusifs proposés aux membres. Votre demande sera examinée par l\'organisateur.';

  @override
  String get membersOnlyGateTitle => 'Événement réservé aux membres';

  @override
  String membersOnlyGateBody(String organizerName) {
    return 'Cet événement est uniquement accessible aux membres de $organizerName. Rejoignez l\'organisation pour débloquer son agenda privé.';
  }

  @override
  String membersOnlyGateJoin(String organizerName) {
    return 'Rejoindre $organizerName';
  }

  @override
  String get privateEventsTitle => 'Mes événements privés';

  @override
  String get privateEventsSearchHint => 'Rechercher un événement…';

  @override
  String get privateEventsLoadError => 'Impossible de charger les événements.';

  @override
  String get privateEventsPrivateBadge => 'Privé';

  @override
  String get privateEventsAllOrganizations => 'Toutes les organisations';

  @override
  String get privateEventsEmptyTitle =>
      'Aucun événement privé pour l\'instant.';

  @override
  String get privateEventsEmptyBody =>
      'Rejoignez des organisations pour découvrir leurs activités exclusives.';

  @override
  String get privateEventsEmptyFiltered =>
      'Aucun événement privé correspondant.';

  @override
  String get membershipInvitationTitle => 'Invitation';

  @override
  String membershipInvitedBy(String name) {
    return 'Invité par $name';
  }

  @override
  String get membershipInvitationExpiredBlurb =>
      'Cette invitation a expiré. Demandez à l\'organisation de vous renvoyer une invitation.';

  @override
  String get membershipInvitationAcceptedBlurb =>
      'Cette invitation a déjà été acceptée. Retrouvez l\'organisation dans votre liste d\'adhésions.';

  @override
  String get membershipInvitationActiveBlurb =>
      'Vous êtes invité(e) à rejoindre cet espace privé. Acceptez l\'invitation pour accéder aux événements exclusifs.';

  @override
  String membershipInvitationActiveWithExpiryBlurb(int hours) {
    return 'Vous êtes invité(e) à rejoindre cet espace privé. Acceptez l\'invitation pour accéder aux événements exclusifs. Cette invitation expire dans $hours h.';
  }

  @override
  String membershipInvitationWelcome(String organizationName) {
    return 'Bienvenue dans $organizationName';
  }

  @override
  String get membershipInvitationAcceptFailed =>
      'Impossible d\'accepter cette invitation.';

  @override
  String get membershipInvitationDeclineTitle => 'Décliner l\'invitation ?';

  @override
  String membershipInvitationDeclineBody(String organizationName) {
    return 'Refuser l\'invitation de $organizationName ?';
  }

  @override
  String get membershipInvitationDeclineAction => 'Décliner';

  @override
  String get membershipInvitationAcceptAction => 'Accepter';

  @override
  String get membershipInvitationDeclined => 'Invitation déclinée';

  @override
  String get membershipInvitationSignInToAccept => 'Se connecter pour accepter';

  @override
  String get membershipInvitationAlreadyAccepted => 'Invitation déjà acceptée.';

  @override
  String get membershipInvitationExpired => 'Invitation expirée.';

  @override
  String membershipInvitationExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expire dans $count jours',
      one: 'Expire dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String membershipInvitationExpiresInHours(int count) {
    return 'Expire dans $count h';
  }

  @override
  String get membershipInvitationNotFoundTitle =>
      'Cette invitation est introuvable.';

  @override
  String get membershipInvitationNotFoundBody =>
      'Le lien a peut-être été désactivé. Demandez à l\'organisateur de vous renvoyer une invitation.';

  @override
  String get personalizedFeedTitle => 'Pour vous';

  @override
  String get organizerInvalidIdentifier => 'Identifiant organisateur invalide';

  @override
  String get organizerActivitiesTab => 'Activités';

  @override
  String get organizerReviewsTab => 'Avis';

  @override
  String get organizerProfileLoadError => 'Impossible de charger ce profil.';

  @override
  String get organizerContactAction => 'Contacter';

  @override
  String get organizerCoordinatesAction => 'Coordonnées';

  @override
  String get organizerNoCoordinates =>
      'Cet organisateur n\'a pas renseigné de coordonnées.';

  @override
  String get organizerAboutTitle => 'À propos';

  @override
  String get organizerEstablishmentTypesTitle => 'Types d\'établissement';

  @override
  String get organizerSocialLinksTitle => 'Réseaux sociaux';

  @override
  String organizerEventsCount(String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'événements',
      one: 'événement',
    );
    return '$countLabel $_temp0';
  }

  @override
  String organizerFollowersCount(String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'abonnés',
      one: 'abonné',
    );
    return '$countLabel $_temp0';
  }

  @override
  String organizerMembersCount(String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'membres',
      one: 'membre',
    );
    return '$countLabel $_temp0';
  }

  @override
  String organizerRatingWithReviews(
      String rating, String countLabel, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'avis',
      one: 'avis',
    );
    return '$rating ($countLabel $_temp0)';
  }

  @override
  String get organizerFollowAction => 'Suivre';

  @override
  String get organizerUnfollowAction => 'Ne plus suivre';

  @override
  String get organizerFollowedSearchHint => 'Rechercher un organisateur';

  @override
  String get organizerFollowedEmptySearchTitle => 'Aucun organisateur trouvé';

  @override
  String get organizerFollowedEmptySearchBody => 'Essayez un autre mot-clé.';

  @override
  String get organizerFollowedEmptyTitle => 'Vous ne suivez aucun organisateur';

  @override
  String get organizerFollowedEmptyBody =>
      'Suivez un organisateur depuis sa page pour le retrouver ici.';

  @override
  String get organizerFollowedLoadError => 'Impossible de charger la liste.';

  @override
  String get organizerActivitiesLoadError =>
      'Impossible de charger les activités.';

  @override
  String get organizerActivitiesEmpty =>
      'Aucune activité publiée pour le moment.';

  @override
  String get organizerActivitiesNoUpcoming => 'Pas d\'événement à venir.';

  @override
  String get organizerActivitiesNoPast => 'Pas d\'événement passé.';

  @override
  String organizerActivitiesCurrentTab(int count) {
    return 'En cours ($count)';
  }

  @override
  String organizerActivitiesPastTab(int count) {
    return 'Passés ($count)';
  }

  @override
  String get organizerReviewsLoadError => 'Impossible de charger les avis.';

  @override
  String organizerReviewsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '1 avis',
    );
    return 'Sur $_temp0';
  }

  @override
  String organizerVerifiedPurchasesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dont $count achats vérifiés',
      one: 'dont 1 achat vérifié',
    );
    return '$_temp0';
  }

  @override
  String get organizerNoReviewsTitle => 'Aucun avis pour le moment';

  @override
  String get organizerNoReviewsBody =>
      'Soyez parmi les premiers à laisser un avis sur l\'un de ses événements.';

  @override
  String get organizerReviewUserFallback => 'Utilisateur';

  @override
  String get organizerReviewFor => 'Avis pour';

  @override
  String get organizerVerifiedPurchase => 'Achat vérifié';

  @override
  String organizerHelpfulCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utiles',
      one: '1 utile',
    );
    return '$_temp0';
  }

  @override
  String organizerReplyBy(String author) {
    return 'Réponse de $author';
  }

  @override
  String get organizerReplyFallback => 'Réponse de l\'organisateur';

  @override
  String get partnerTypeVenue => 'Salle/Lieu';

  @override
  String get partnerTypeOrganizer => 'Organisateur';

  @override
  String get partnerTypeIndividual => 'Particulier';

  @override
  String get partnerSubscriptionBasic => 'Basique';

  @override
  String get partnerSubscriptionEnterprise => 'Enterprise';

  @override
  String get checkinScannerTitle => 'Scanner les billets';

  @override
  String get checkinTorchTooltip => 'Lampe';

  @override
  String get checkinCameraTooltip => 'Caméra';

  @override
  String get checkinMoreTooltip => 'Plus';

  @override
  String get checkinSwitchOrganization => 'Changer d\'organisation';

  @override
  String get checkinManualEntryTitle => 'Saisie manuelle';

  @override
  String get checkinGateLabel => 'Étiquette de gate';

  @override
  String get checkinGateHint => 'ex: Nord, VIP, Entrée 2…';

  @override
  String checkinGateDisplay(String gate) {
    return 'Gate : $gate';
  }

  @override
  String get checkinEntryRecorded => 'Bienvenue ! Entrée enregistrée.';

  @override
  String checkinReEntryRecorded(int count) {
    return 'Ré-entrée enregistrée (entrée n°$count)';
  }

  @override
  String get checkinNetworkRescan =>
      'Réseau instable — re-scannez pour confirmer.';

  @override
  String get checkinNetworkRetype =>
      'Réseau instable — re-saisissez pour confirmer.';

  @override
  String get checkinCameraPermissionDeniedTitle => 'Accès caméra refusé';

  @override
  String get checkinCameraUnavailableTitle => 'Caméra indisponible';

  @override
  String get checkinCameraPermissionDeniedBody =>
      'Autorisez la caméra dans les paramètres système, ou utilisez la saisie manuelle.';

  @override
  String get checkinCameraUnavailableBody =>
      'Aucune caméra n\'a été détectée. Utilisez la saisie manuelle.';

  @override
  String get checkinChooseOrganizationFirst =>
      'Choisissez une organisation depuis le scanner.';

  @override
  String get checkinManualWarning =>
      'À utiliser uniquement avec une vérification d\'identité visuelle. La saisie manuelle ne contrôle pas le secret du QR.';

  @override
  String checkinOrganizationLabel(String name) {
    return 'Organisation : $name';
  }

  @override
  String get checkinManualCodeHelper => 'Code imprimé sur le billet';

  @override
  String get checkinVerifyCode => 'Vérifier le code';

  @override
  String get checkinValidTicketTitle => 'Billet valide';

  @override
  String get checkinReEntryDetectedTitle => 'Ré-entrée détectée';

  @override
  String get checkinConfirmEntry => 'Confirmer l\'entrée';

  @override
  String get checkinConfirmReEntry => 'Confirmer la ré-entrée';

  @override
  String checkinAlreadyEnteredWarning(int count) {
    return 'Déjà entré $count× — vérifiez avant d\'admettre.';
  }

  @override
  String get checkinChooseOrganizationTitle => 'Choisir une organisation';

  @override
  String get checkinChooseOrganizationBody =>
      'Le scanner enverra les billets à l\'organisation sélectionnée.';

  @override
  String get checkinRoleOwner => 'Propriétaire';

  @override
  String get checkinRoleAdmin => 'Administrateur';

  @override
  String get checkinRoleStaff => 'Équipe';

  @override
  String get checkinRoleViewer => 'Membre';

  @override
  String get checkinNoVendorOrganizationTitle =>
      'Aucune organisation vendeur trouvée';

  @override
  String get checkinNoVendorOrganizationBody =>
      'Si vous attendiez d\'apparaître ici, contactez le support — votre profil n\'est peut-être pas encore lié à une organisation.';

  @override
  String get checkinRefresh => 'Actualiser';

  @override
  String get checkinBlockedTicketCancelledTitle => 'Billet annulé';

  @override
  String get checkinBlockedTicketRefundedTitle => 'Billet remboursé';

  @override
  String get checkinBlockedTicketTransferredTitle => 'Billet transféré';

  @override
  String get checkinBlockedSlotNotStartedTitle => 'Créneau non commencé';

  @override
  String get checkinBlockedWrongEventTitle => 'Mauvais événement';

  @override
  String get checkinBlockedUnauthorizedTitle => 'Non autorisé';

  @override
  String get checkinBlockedTicketNotFoundTitle => 'Billet introuvable';

  @override
  String get checkinBlockedUnknownTitle => 'Erreur';

  @override
  String get checkinBlockedDoNotAdmit => 'Ne pas laisser entrer.';

  @override
  String get checkinBlockedTicketTransferredBody =>
      'Le billet a été transféré à un autre porteur — re-scannez son QR.';

  @override
  String get checkinBlockedSlotNotStartedBody =>
      'L\'entrée n\'est pas encore ouverte pour ce créneau.';

  @override
  String get checkinBlockedWrongEventBody =>
      'Ce billet ne correspond pas à l\'événement filtré.';

  @override
  String get checkinBlockedUnauthorizedBody =>
      'Vous n\'êtes pas autorisé à scanner ce billet pour cette organisation.';

  @override
  String get checkinBlockedTicketNotFoundBody =>
      'QR non reconnu — réessayez ou saisissez le code.';

  @override
  String get checkinBlockedUnknownBody => 'Erreur inattendue, réessayez.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'votre@email.com';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authEmailRequired => 'Veuillez entrer votre email';

  @override
  String get authEmailInvalid => 'Veuillez entrer un email valide';

  @override
  String get authPasswordRequired => 'Veuillez entrer votre mot de passe';

  @override
  String get authEmailRequiredShort => 'Email requis';

  @override
  String get authEmailInvalidShort => 'Email invalide';

  @override
  String get authPasswordRequiredShort => 'Mot de passe requis';

  @override
  String get authLoginTitle => 'Bienvenue sur Le Hiboo !';

  @override
  String get authLoginSubtitle =>
      'Connectez-vous pour découvrir les événements près de chez vous';

  @override
  String get authForgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get authLoginSubmit => 'Se connecter';

  @override
  String get authLoginNoAccount => 'Pas encore de compte ?';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authContinueAsGuest => 'Continuer sans compte';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get authForgotPasswordSubmit => 'Envoyer le lien';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authForgotPasswordSuccessTitle => 'Email envoyé !';

  @override
  String get authForgotPasswordSuccessPrefix =>
      'Nous avons envoyé un lien de réinitialisation à';

  @override
  String get authForgotPasswordSuccessInfo =>
      'Vérifiez votre boîte de réception et vos spams. Le lien expire dans 1 heure.';

  @override
  String get authForgotPasswordResend => 'Renvoyer l\'email';

  @override
  String get authOtpIncompleteCode => 'Veuillez entrer le code complet';

  @override
  String get authOtpResent => 'Un nouveau code a été envoyé';

  @override
  String get authOtpTitle => 'Vérification email';

  @override
  String get authOtpSubtitle => 'Entrez le code à 6 chiffres envoyé à';

  @override
  String get authOtpVerify => 'Vérifier';

  @override
  String get authOtpNotReceived => 'Vous n\'avez pas reçu le code ?';

  @override
  String authOtpResendIn(int seconds) {
    return 'Renvoyer dans ${seconds}s';
  }

  @override
  String get authOtpResend => 'Renvoyer';

  @override
  String get authGuestIncorrectCredentials =>
      'Identifiants incorrects. Réessayez.';

  @override
  String get authAccountAlreadyVerified =>
      'Votre compte est déjà vérifié. Veuillez vous connecter.';

  @override
  String get authEmailOrPasswordIncorrect => 'Email ou mot de passe incorrect';

  @override
  String get authAccountAlreadyExists => 'Un compte existe déjà avec cet email';

  @override
  String get authWeakPasswordDetailed =>
      'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre';

  @override
  String get authVerificationCodeInvalid => 'Code de vérification invalide';

  @override
  String get authVerificationCodeExpired =>
      'Le code a expiré. Veuillez en demander un nouveau.';

  @override
  String get authTooManyAttempts =>
      'Trop de tentatives. Réessayez dans 15 minutes.';

  @override
  String get authVerificationCodeSent => 'Un code de vérification a été envoyé';

  @override
  String get authVerificationCodeVerified => 'Code vérifié';

  @override
  String get authGuestTitle => 'Connectez-vous !';

  @override
  String authGuestSubtitle(String featureName) {
    return 'Connectez-vous pour $featureName.';
  }

  @override
  String get authGuestEncouragement =>
      'Cela ne prend que 2 minutes et c\'est gratuit !';

  @override
  String get authRegisterTypeEyebrow => 'TYPE DE COMPTE';

  @override
  String get authRegisterTypeTitle => 'Vous êtes...';

  @override
  String get authRegisterTypeSubtitle =>
      'Sélectionnez votre profil pour personnaliser votre expérience';

  @override
  String get authRegisterTypeCustomerTitle => 'Un particulier';

  @override
  String get authRegisterTypeCustomerDescription =>
      'Je réserve des activités pour moi ou mes proches.';

  @override
  String get authRegisterTypeBusinessTitle => 'Une organisation';

  @override
  String get authRegisterTypeBusinessDescription =>
      'Entreprise, association ou collectivité - je réserve pour mon équipe.';

  @override
  String get authRegisterTypeComingSoon => 'Bientôt disponible';

  @override
  String get authRegisterCreateMyAccount => 'Créer mon compte';

  @override
  String get authAlreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get authRegisterLegacySubtitle =>
      'Rejoignez LeHiboo pour ne rien manquer';

  @override
  String get authFirstNameLabel => 'Prénom';

  @override
  String get authFirstNameHint => 'Jean';

  @override
  String get authLastNameLabel => 'Nom';

  @override
  String get authLastNameHint => 'Dupont';

  @override
  String get authRequired => 'Requis';

  @override
  String get authPasswordMinimumHint => 'Minimum 8 caractères';

  @override
  String get authPasswordCreateRequired => 'Veuillez entrer un mot de passe';

  @override
  String get authPasswordMinLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get authPasswordNeedsUppercase =>
      'Le mot de passe doit contenir une majuscule';

  @override
  String get authPasswordNeedsNumber =>
      'Le mot de passe doit contenir un chiffre';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authConfirmPasswordHint => 'Retapez votre mot de passe';

  @override
  String get authConfirmPasswordRequired =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get authPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authAcceptTermsRequired =>
      'Veuillez accepter les conditions d\'utilisation';

  @override
  String get authRegisterTermsPrefix => 'J\'accepte les ';

  @override
  String get authRegisterTermsConnector => ' et la ';

  @override
  String get authPermissionReassurance =>
      'Vous pouvez changer cet accès à tout moment dans les réglages.';

  @override
  String get authPermissionLocationTitle => 'Trouvez des sorties près de vous';

  @override
  String get authPermissionLocationIntro =>
      'LeHiboo Experiences utilise votre position pour vous suggérer les meilleurs événements à proximité.';

  @override
  String get authPermissionLocationBulletMap =>
      'Voir les événements à proximité sur la carte';

  @override
  String get authPermissionLocationBulletSearch =>
      'Filtrer la recherche selon votre position';

  @override
  String get authPermissionLocationBulletSuggestions =>
      'Recevoir des suggestions adaptées à votre ville';

  @override
  String get authPermissionLocationGranted => 'Localisation déjà activée';

  @override
  String get authPermissionAudioTitle => 'Discutez en vocal avec Petit Boo';

  @override
  String get authPermissionAudioIntro =>
      'Activez le micro pour interagir à la voix avec Petit Boo, notre assistant IA dédié aux sorties.';

  @override
  String get authPermissionAudioBulletQuestions =>
      'Posez vos questions à la voix, sans clavier';

  @override
  String get authPermissionAudioBulletDictate =>
      'Dictez vos messages plus rapidement';

  @override
  String get authPermissionAudioBulletHandsFree =>
      'Trouvez des sorties les mains libres';

  @override
  String get authPermissionAudioGranted => 'Micro déjà activé';

  @override
  String get authPermissionNotificationsTitle => 'Ne ratez rien des bons plans';

  @override
  String get authPermissionNotificationsIntro =>
      'Activez les notifications pour recevoir l\'essentiel directement sur votre téléphone.';

  @override
  String get authPermissionNotificationsBulletTickets =>
      'Vos billets et confirmations de réservation';

  @override
  String get authPermissionNotificationsBulletAlerts =>
      'Les événements qui matchent vos alertes';

  @override
  String get authPermissionNotificationsBulletFavorites =>
      'Les nouveautés de vos lieux favoris';

  @override
  String get authPermissionNotificationsBulletReminders =>
      'Vos rappels et alertes personnalisées';

  @override
  String get authPermissionNotificationsBulletMessages =>
      'Les réponses des organisateurs à vos messages';

  @override
  String get authPermissionNotificationsGranted =>
      'Notifications déjà activées';

  @override
  String get authEmailAddressInvalid =>
      'Veuillez entrer une adresse email valide';

  @override
  String get authOtpEmailVerified => 'Email vérifié !';

  @override
  String get authRegisterMissingVerificationToken =>
      'Erreur : token de vérification manquant. Veuillez recommencer.';

  @override
  String get authCustomerAccountCreated => 'Compte créé avec succès !';

  @override
  String get authCustomerEmailSubtitle =>
      'Commencez par vérifier votre adresse email';

  @override
  String get authReceiveCode => 'Recevoir le code';

  @override
  String get authCreateBusinessAccount => 'Créer un compte professionnel';

  @override
  String get authVerificationTitle => 'Vérification';

  @override
  String get authEditEmail => 'Modifier l\'email';

  @override
  String get authYourInformationTitle => 'Vos informations';

  @override
  String get authPhoneOptionalLabel => 'Téléphone (optionnel)';

  @override
  String get authPhoneHint => '06 12 34 56 78';

  @override
  String get authPhoneInvalid => 'Numéro de téléphone invalide';

  @override
  String get authBirthDateLabelOptional => 'Date de naissance (optionnel)';

  @override
  String get authBirthDateHelp => 'Date de naissance';

  @override
  String get authDateHint => 'JJ/MM/AAAA';

  @override
  String get authCityOptionalLabel => 'Ville (optionnel)';

  @override
  String get authCityHint => 'Lyon, Paris...';

  @override
  String get authMarketingOptIn =>
      'Je souhaite recevoir les actualités et offres du Hiboo par e-mail.';

  @override
  String get authStepEmail => 'Email';

  @override
  String get authStepCode => 'Code';

  @override
  String get authStepInfo => 'Infos';

  @override
  String get authProfessionalEmailLabel => 'Email professionnel';

  @override
  String get authProfessionalEmailHint => 'votre@entreprise.com';

  @override
  String get authValidationMin2Chars => 'Min. 2 caractères';

  @override
  String get authValidationMin5Chars => 'Min. 5 caractères';

  @override
  String get authFirstNameMinLength =>
      'Le prénom doit contenir au moins 2 caractères';

  @override
  String get authLastNameMinLength =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get authPasswordMinLengthShort => 'Min. 8 caractères';

  @override
  String get authPasswordNeedsUppercaseShort => 'Une majuscule requise';

  @override
  String get authPasswordNeedsNumberShort => 'Un chiffre requis';

  @override
  String get authPasswordNeedsSpecialShort => 'Un caractère spécial requis';

  @override
  String get authPasswordNeedsUppercaseNumberSpecial =>
      'Le mot de passe doit contenir au moins 8 caractères, une majuscule, un chiffre et un symbole';

  @override
  String get authPasswordStrengthWeak => 'Faible';

  @override
  String get authPasswordStrengthFair => 'Moyen';

  @override
  String get authPasswordStrengthGood => 'Bon';

  @override
  String get authPasswordStrengthStrong => 'Fort';

  @override
  String get authPasswordRequirementMin8 => 'Au moins 8 caractères';

  @override
  String get authPasswordRequirementUppercase => 'Une lettre majuscule';

  @override
  String get authPasswordRequirementNumber => 'Un chiffre';

  @override
  String get authPasswordRequirementSpecial => 'Un caractère spécial';

  @override
  String get authBusinessTitle => 'Compte Professionnel';

  @override
  String get authBusinessCancelTitle => 'Annuler l\'inscription ?';

  @override
  String get authBusinessCancelContent => 'Votre progression sera perdue.';

  @override
  String get authBusinessSuccessTitle => 'Inscription réussie !';

  @override
  String authBusinessSuccessMessageWithOrg(String organizationName) {
    return 'Votre compte professionnel pour \"$organizationName\" a été créé avec succès.';
  }

  @override
  String get authBusinessSuccessMessage =>
      'Votre compte professionnel a été créé avec succès.';

  @override
  String get authBusinessSuccessAccess =>
      'Vous pouvez maintenant accéder à toutes les fonctionnalités de LeHiboo.';

  @override
  String get authStart => 'Commencer';

  @override
  String get authBusinessStepInfo => 'Infos';

  @override
  String get authBusinessStepVerification => 'Vérif.';

  @override
  String get authBusinessStepCompany => 'Entreprise';

  @override
  String get authBusinessStepUsage => 'Usage';

  @override
  String get authBusinessStepTerms => 'Termes';

  @override
  String get authPersonalInfoTitle => 'Informations personnelles';

  @override
  String get authPersonalInfoSubtitle =>
      'Ces informations seront utilisées pour créer votre compte';

  @override
  String get authOrganizationCompanyLabel => 'Entreprise';

  @override
  String get authOrganizationAssociationLabel => 'Association';

  @override
  String get authOrganizationMunicipalityLabel => 'Collectivité';

  @override
  String get authOrganizationCompanyDescription =>
      'Société, TPE, PME, startup...';

  @override
  String get authOrganizationAssociationDescription => 'Loi 1901, fondation...';

  @override
  String get authOrganizationMunicipalityDescription =>
      'Mairie, département, région...';

  @override
  String get authOrganizationCompanyLower => 'entreprise';

  @override
  String get authOrganizationAssociationLower => 'association';

  @override
  String get authOrganizationMunicipalityLower => 'collectivité';

  @override
  String get authOrganizationCompanyArticle => 'l\'entreprise';

  @override
  String get authOrganizationAssociationArticle => 'l\'association';

  @override
  String get authOrganizationMunicipalityArticle => 'la collectivité';

  @override
  String get authOrganizationCompanyPossessive => 'votre entreprise';

  @override
  String get authOrganizationAssociationPossessive => 'votre association';

  @override
  String get authOrganizationMunicipalityPossessive => 'votre collectivité';

  @override
  String authBusinessCompanyInfoTitle(String organizationArticle) {
    return 'Informations de $organizationArticle';
  }

  @override
  String authBusinessCompanyInfoSubtitle(String organizationPossessive) {
    return 'Ces informations permettront d\'identifier $organizationPossessive';
  }

  @override
  String get authOrganizationTypeLabel => 'Type d\'organisation';

  @override
  String authOrganizationNameLabel(String organizationArticle) {
    return 'Nom de $organizationArticle';
  }

  @override
  String get authCompanyNameHint => 'Ma Société SAS';

  @override
  String get authOptionalSuffix => '(optionnel)';

  @override
  String get authSiretInvalid => 'SIRET invalide';

  @override
  String get authSiretHelp => '14 chiffres, sans espaces';

  @override
  String get authCompanyNameMinLength =>
      'Le nom de l\'entreprise doit contenir au moins 2 caractères';

  @override
  String get authSiretMustHave14Digits =>
      'Le numéro SIRET doit contenir 14 chiffres';

  @override
  String get authAddressMinLength =>
      'L\'adresse doit contenir au moins 5 caractères';

  @override
  String get authCityMinLength =>
      'La ville doit contenir au moins 2 caractères';

  @override
  String get authPostalCodeLength =>
      'Le code postal doit contenir entre 3 et 10 caractères';

  @override
  String get authIndustryLabel => 'Secteur d\'activité';

  @override
  String get authSelectHint => 'Sélectionner';

  @override
  String get authEmployeeCountLabel => 'Effectif';

  @override
  String get authBillingAddressLabel => 'Adresse de facturation';

  @override
  String get authBillingAddressHint => '123 rue de la Paix';

  @override
  String get authPostalCodeLabel => 'Code postal';

  @override
  String get authPostalCodeHint => '75001';

  @override
  String get authCityLabel => 'Ville';

  @override
  String get authCityFieldHint => 'Paris';

  @override
  String get authCountryLabel => 'Pays';

  @override
  String get authCountryHint => 'Pays';

  @override
  String get authLoading => 'Chargement...';

  @override
  String get authIndustryTechnology => 'Technologie';

  @override
  String get authIndustryFinance => 'Finance';

  @override
  String get authIndustryHealth => 'Santé';

  @override
  String get authIndustryEducation => 'Éducation';

  @override
  String get authIndustryCommerce => 'Commerce';

  @override
  String get authIndustryServices => 'Services';

  @override
  String get authIndustryIndustry => 'Industrie';

  @override
  String get authIndustryTransport => 'Transport';

  @override
  String get authIndustryRealEstate => 'Immobilier';

  @override
  String get authIndustryOther => 'Autre';

  @override
  String get authCountryFrance => 'France';

  @override
  String get authCountryBelgium => 'Belgique';

  @override
  String get authCountrySwitzerland => 'Suisse';

  @override
  String get authCountryLuxembourg => 'Luxembourg';

  @override
  String get authCountryMonaco => 'Monaco';

  @override
  String get authCountryGermany => 'Allemagne';

  @override
  String get authCountrySpain => 'Espagne';

  @override
  String get authCountryItaly => 'Italie';

  @override
  String get authCountryNetherlands => 'Pays-Bas';

  @override
  String get authCountryUnitedKingdom => 'Royaume-Uni';

  @override
  String get authCountryOther => 'Autre';

  @override
  String get authCompanySearchTitle => 'Recherche rapide';

  @override
  String authCompanySearchHint(String organizationPossessive) {
    return 'Rechercher $organizationPossessive par nom...';
  }

  @override
  String authCompanySearchHelper(String organizationPossessive) {
    return 'Recherchez $organizationPossessive pour remplir automatiquement le formulaire';
  }

  @override
  String authSiretLine(String siret) {
    return 'SIRET : $siret';
  }

  @override
  String get authUsageModeTitle => 'Mode d\'utilisation';

  @override
  String get authUsageModeSubtitle => 'Comment comptez-vous utiliser LeHiboo ?';

  @override
  String get authUsageModePersonalLabel => 'Utilisation personnelle';

  @override
  String get authUsageModePersonalDescription =>
      'Je suis le seul à utiliser le compte';

  @override
  String get authUsageModeTeamLabel => 'Équipe';

  @override
  String get authUsageModeTeamDescription =>
      'Plusieurs personnes utiliseront le compte';

  @override
  String get authTeamEmailsLabelOptional =>
      'Emails des collaborateurs (optionnel)';

  @override
  String get authTeamEmailsHint => 'email1@exemple.com, email2@exemple.com';

  @override
  String get authTeamEmailsHelper => 'Séparez les emails par des virgules';

  @override
  String authInvalidEmailWithValue(String email) {
    return 'Email invalide : $email';
  }

  @override
  String get authDefaultMonthlyBudgetLabelOptional =>
      'Budget mensuel par défaut (optionnel)';

  @override
  String get authAmountInvalid => 'Veuillez entrer un montant valide';

  @override
  String get authTermsFinalizationTitle => 'Finalisation';

  @override
  String get authTermsFinalizationSubtitle =>
      'Vérifiez vos informations et acceptez les conditions';

  @override
  String get authTermsSummaryTitle => 'Récapitulatif';

  @override
  String get authTermsSummaryPersonal => 'Informations personnelles';

  @override
  String get authTermsSummaryOrganization => 'Organisation';

  @override
  String get authTermsSummaryUsage => 'Utilisation';

  @override
  String authTermsBudgetLine(String budget) {
    return 'Budget : $budget EUR/mois';
  }

  @override
  String authTermsInvitationsLine(int count) {
    return 'Invitations : $count collaborateurs';
  }

  @override
  String get authBusinessTermsLabel =>
      'conditions spécifiques aux comptes professionnels';

  @override
  String get authBusinessTermsRequired =>
      'Veuillez accepter les conditions business';

  @override
  String get authCreateBusinessAccountButton => 'Créer mon compte business';

  @override
  String get authBusinessTermsHelper =>
      'En créant un compte, vous confirmez que les informations fournies sont exactes et que vous êtes autorisé à représenter cette organisation.';

  @override
  String get homeTooltipNotifications => 'Notifications';

  @override
  String get homeTooltipCart => 'Mon panier';

  @override
  String get homeTooltipAccount => 'Mon compte';

  @override
  String get homeViewMore => 'Voir plus';

  @override
  String get homeViewAll => 'Voir tout';

  @override
  String get homePartnerBadge => 'Partenaire';

  @override
  String get homePartnerSeeAllSelection => 'Voir toute la sélection';

  @override
  String get homePersonalizedTitle => 'Pour vous';

  @override
  String get homePersonalizedSubtitle => 'Basé sur vos préférences';

  @override
  String get homeNativeAdSponsored => 'Sponsorisé';

  @override
  String get homeRecommendedPopularTag => 'Populaire';

  @override
  String get homeRecommendedLastSpotsTag => 'Dernières places';

  @override
  String get homeSavedSearchAlertFallback => 'Alerte personnalisée';

  @override
  String get homeSavedSearchFallback => 'Recherche sauvegardée';

  @override
  String get homeMobileConfigDefaultHeroTitle =>
      'Trouvez votre prochaine aventure locale';

  @override
  String get homeMobileConfigDefaultHeroSubtitle =>
      'Découvrez les meilleurs événements près de chez vous';

  @override
  String get homeMobileConfigEventsSectionTitle =>
      'Retrouvez tous vos événements';

  @override
  String get homeMobileConfigEventsSectionDescription =>
      'Explorez notre sélection d\'événements locaux';

  @override
  String get homeMobileConfigThematiquesSectionTitle =>
      'Explorez par thématique';

  @override
  String get homeMobileConfigCitiesSectionTitle => 'Événements par ville';

  @override
  String get homeMobileConfigExploreButton => 'Explorer les activités';

  @override
  String get homeNewActivitiesTitle => 'Nouveautés';

  @override
  String get homeNoNewActivities => 'Aucune nouveauté trouvée.';

  @override
  String get homeNearbyAvailableTitle => 'Activités disponibles à proximité';

  @override
  String get homeWebCtaTitle => 'Retrouvez vos événements en toute simplicité';

  @override
  String get homeWebCtaBody =>
      'Notre site web offre une expérience complète pour découvrir et réserver vos activités locales.';

  @override
  String get homeWebCtaButton => 'Découvrir le site';

  @override
  String get homeFallbackPopularCitiesTitle => 'Où ça bouge en ce moment';

  @override
  String get homePopularCitiesTitle => 'Villes populaires';

  @override
  String homeHeroGreetingMorning(String firstName) {
    return 'Bonjour $firstName !';
  }

  @override
  String homeHeroGreetingAfternoon(String firstName) {
    return 'Bon après-midi $firstName !';
  }

  @override
  String homeHeroGreetingEvening(String firstName) {
    return 'Bonsoir $firstName !';
  }

  @override
  String homeHeroGreetingNight(String firstName) {
    return 'Bonne nuit $firstName !';
  }

  @override
  String get homeHeroNightTitle => 'Sorties nocturnes';

  @override
  String homeHeroNightTitleWithCity(String cityName) {
    return 'Sorties nocturnes à $cityName';
  }

  @override
  String get homeHeroNightSubtitle => 'Concerts, spectacles et soirées';

  @override
  String get homeHeroWeekendTitle => 'Ce week-end';

  @override
  String homeHeroWeekendTitleWithCity(String cityName) {
    return 'Ce week-end à $cityName';
  }

  @override
  String get homeHeroWeekendMorningSubtitle =>
      'Les meilleures activités vous attendent';

  @override
  String get homeHeroMorningTitle => 'Bonne journée';

  @override
  String homeHeroMorningTitleWithCity(String cityName) {
    return 'Bonne journée à $cityName';
  }

  @override
  String get homeHeroMorningSubtitle => 'Découvrez les activités du jour';

  @override
  String get homeHeroAfternoonTitle => 'Cet après-midi';

  @override
  String homeHeroAfternoonTitleWithCity(String cityName) {
    return 'Cet après-midi à $cityName';
  }

  @override
  String get homeHeroWeekendAfternoonSubtitle => 'Profitez de votre week-end';

  @override
  String get homeHeroNearbyTitle => 'Activités près de vous';

  @override
  String homeHeroNearbyTitleWithCity(String cityName) {
    return 'Activités à $cityName';
  }

  @override
  String get homeHeroAfternoonSubtitle => 'Pour occuper votre après-midi';

  @override
  String get homeHeroEveningTitle => 'Ce soir';

  @override
  String homeHeroEveningTitleWithCity(String cityName) {
    return 'Ce soir à $cityName';
  }

  @override
  String get homeHeroEveningWeekendSubtitle =>
      'Les sorties du week-end commencent';

  @override
  String get homeHeroEveningWeekdaySubtitle => 'Après le travail, on se détend';

  @override
  String get homeHeroDiscoverTitle => 'Découvrez les activités';

  @override
  String homeHeroDiscoverTitleWithCity(String cityName) {
    return 'Découvrez $cityName';
  }

  @override
  String get homeHeroDiscoverSubtitle => 'Trouvez votre prochaine sortie';

  @override
  String get homeHeroSummerSubtitle => 'Profitez des activités estivales';

  @override
  String get homeHeroWinterSubtitle => 'Réchauffez vos soirées';

  @override
  String get homeHeroSpringSubtitle => 'Le printemps est là, sortez !';

  @override
  String get homeHeroAutumnSubtitle =>
      'Les couleurs de l\'automne vous attendent';

  @override
  String get homeSearchTitle => 'Rechercher';

  @override
  String get homeSearchNearby => 'À proximité';

  @override
  String get homeSearchWhere => 'Où ?';

  @override
  String get homeSearchWhen => 'Quand ?';

  @override
  String get homeSearchWhat => 'Quoi ?';

  @override
  String homeSearchCategoryCount(int count) {
    return '$count cat.';
  }

  @override
  String get homeSearchFamily => 'Famille';

  @override
  String get homeExploreByCategoryTitle => 'Explorer par catégorie';

  @override
  String homeExploreCategorySemantics(String category) {
    return 'Explorer $category';
  }

  @override
  String get homeStoriesFeaturedTitle => 'À la une';

  @override
  String get homeStoriesNewBadge => 'NEW';

  @override
  String get homeStoryViewActivity => 'Voir l\'activité';

  @override
  String get homeStoryBookingLabel => 'Billetterie';

  @override
  String get homeStoryDiscoveryLabel => 'Découverte';

  @override
  String homeDateAtTime(String date, String time) {
    return '$date à $time';
  }

  @override
  String homeTodayAtTime(String time) {
    return 'Aujourd\'hui à $time';
  }

  @override
  String homeTomorrowAtTime(String time) {
    return 'Demain à $time';
  }

  @override
  String homeEventByOrganizer(String organizer) {
    return 'Par $organizer';
  }

  @override
  String homePriceFrom(String price) {
    return 'À partir de $price';
  }

  @override
  String homePriceFromShort(String price) {
    return 'Dès $price';
  }

  @override
  String get homePrivateBadge => 'Privé';

  @override
  String get homeCountdownNow => 'Maintenant !';

  @override
  String homeCountdownDayHour(int days, int hours) {
    return '$days jour ${hours}h';
  }

  @override
  String homeCountdownDaysHours(int days, int hours) {
    return '$days jours ${hours}h';
  }

  @override
  String homeRemainingSpot(int count) {
    return '$count place';
  }

  @override
  String homeRemainingSpots(int count) {
    return '$count places';
  }

  @override
  String homeUrgencyRemainingSpots(int count) {
    return 'Plus que $count places !';
  }

  @override
  String get homeUrgencyLastHours => 'Dernières heures pour réserver !';

  @override
  String get homeBook => 'Réserver';

  @override
  String get homeUrgencyTitle => 'Avant qu\'il soit trop tard';

  @override
  String get homeUrgencySubtitle => 'Ces événements commencent bientôt';

  @override
  String get homeCityNotFound => 'Ville non trouvée';

  @override
  String homeCityDescriptionFallback(String cityName) {
    return 'Découvrez les activités à $cityName.';
  }

  @override
  String homeCityAvailableEvent(int count) {
    return '$count événement disponible';
  }

  @override
  String homeCityAvailableEvents(int count) {
    return '$count événements disponibles';
  }

  @override
  String get homePopularActivities => 'Activités populaires';

  @override
  String get homeFilter => 'Filtrer';

  @override
  String get homeCityNoActivities => 'Aucune activité trouvée dans cette ville';

  @override
  String homeErrorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get homeOffersTitle => 'Offres et bons plans';

  @override
  String get homeSpecialOffer => 'Offre spéciale';

  @override
  String get homeQuickToday => 'Aujourd\'hui';

  @override
  String get homeQuickWeekend => 'Ce week-end';

  @override
  String get homeQuickFamily => 'Famille';

  @override
  String get homeQuickDistanceUnder2km => '< 2 km';

  @override
  String get homeCategoryAll => 'Tous';

  @override
  String get homeCategoryShows => 'Spectacles';

  @override
  String get homeCategoryWorkshops => 'Ateliers';

  @override
  String get homeCategorySport => 'Sport';

  @override
  String get homeCategoryCulture => 'Culture';

  @override
  String get homeCategoryMarkets => 'Marchés';

  @override
  String get homeCategoryLeisure => 'Loisirs';

  @override
  String get homeBrowseByCity => 'Parcourir par ville';

  @override
  String get searchTitle => 'Recherche';

  @override
  String get searchFiltersTitle => 'Filtres';

  @override
  String get searchClear => 'Effacer';

  @override
  String searchClearAllWithCount(int count) {
    return 'Tout effacer ($count)';
  }

  @override
  String get searchAction => 'Rechercher';

  @override
  String searchActionWithActivity(int count) {
    return 'Rechercher · $count activité';
  }

  @override
  String searchActionWithActivities(int count) {
    return 'Rechercher · $count activités';
  }

  @override
  String get searchSearchActivityTitle => 'Rechercher une activité';

  @override
  String get searchAroundMe => 'Autour de moi';

  @override
  String get searchAnywhere => 'N\'importe où';

  @override
  String get searchAnytime => 'N\'importe quand';

  @override
  String get searchAnyActivityType => 'Tout type d\'activité';

  @override
  String get searchSearchSubtitleDefault => 'Titre, organisateur';

  @override
  String get searchForWhom => 'Pour qui ?';

  @override
  String get searchAllAudiences => 'Tous les publics';

  @override
  String get searchRefineTitle => 'Affiner la recherche';

  @override
  String get searchRefineSubtitleDefault => 'Type, thématique, ambiance';

  @override
  String get searchFilterSingular => '1 filtre';

  @override
  String searchFiltersCount(int count) {
    return '$count filtres';
  }

  @override
  String get searchCategorySingular => '1 catégorie';

  @override
  String searchCategoriesCount(int count) {
    return '$count catégories';
  }

  @override
  String get searchAudienceSingular => '1 public';

  @override
  String searchAudiencesCount(int count) {
    return '$count publics';
  }

  @override
  String get searchMyPosition => 'Ma position';

  @override
  String get searchUseCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String searchWithinRadius(int radius) {
    return 'Dans un rayon de $radius km';
  }

  @override
  String get searchRadiusLabel => 'Rayon :';

  @override
  String searchRadiusAroundCity(String cityName) {
    return 'Rayon autour de $cityName';
  }

  @override
  String get searchLocationDisabled => 'Activez la localisation';

  @override
  String get searchPermissionDenied => 'Permission refusée';

  @override
  String get searchLocationSettingsRequired =>
      'Activez la localisation dans les paramètres';

  @override
  String get searchLocationNotFound => 'Position introuvable';

  @override
  String searchSavedAlertCreated(String name) {
    return 'Alerte \"$name\" créée avec notifications !';
  }

  @override
  String searchSavedSearchCreated(String name) {
    return 'Recherche \"$name\" enregistrée !';
  }

  @override
  String get searchAlreadySaved => 'Déjà enregistrée';

  @override
  String get searchSave => 'Enregistrer';

  @override
  String get searchSaveAlert => 'Créer une alerte';

  @override
  String get searchAlreadySavedMultiline => 'Recherche\nenregistrée';

  @override
  String get searchSaveSearchMultiline => 'Sauvegarder\nma recherche';

  @override
  String get searchRetry => 'Réessayer';

  @override
  String searchResult(Object count) {
    return '$count résultat';
  }

  @override
  String searchResultsCount(Object count) {
    return '$count résultats';
  }

  @override
  String get searchNoMoreResults => 'C\'est tout pour le moment !';

  @override
  String get searchAlertNewActivities => 'M\'alerter des nouveautés';

  @override
  String get searchSortBy => 'Trier par';

  @override
  String get searchSortRelevance => 'Pertinence';

  @override
  String get searchNoResultsForFilters => 'Aucun résultat pour ces filtres';

  @override
  String get searchStartTitle => 'Commencez votre recherche';

  @override
  String get searchNoResultsTitle => 'Aucune activité trouvée';

  @override
  String get searchNoResultsBody =>
      'Essayez de modifier vos filtres ou d\'élargir votre zone de recherche.';

  @override
  String get searchStartBody =>
      'Utilisez la barre de recherche ci-dessus pour trouver des activités.';

  @override
  String get searchAlertNewEvents => 'M\'alerter des nouveaux événements';

  @override
  String get searchClearFilters => 'Effacer les filtres';

  @override
  String searchResultsActivity(int count) {
    return '$count activité';
  }

  @override
  String searchResultsActivities(int count) {
    return '$count activités';
  }

  @override
  String get searchDateToday => 'Aujourd\'hui';

  @override
  String get searchDateTomorrow => 'Demain';

  @override
  String get searchDateThisWeek => 'Cette semaine';

  @override
  String get searchDateThisWeekend => 'Ce week-end';

  @override
  String get searchDateThisMonth => 'Ce mois-ci';

  @override
  String get searchDateCustom => 'Dates personnalisées';

  @override
  String get searchPricePaid => 'Payant';

  @override
  String searchPriceRange(int min, int max) {
    return '$min€ - $max€';
  }

  @override
  String searchAroundMeWithRadius(int radius) {
    return 'Autour de moi ($radius km)';
  }

  @override
  String searchCityWithRadius(String cityName, int radius) {
    return '$cityName · $radius km';
  }

  @override
  String get searchAvailablePlaces => 'Places disponibles';

  @override
  String get searchAccessiblePmr => 'Accessible PMR';

  @override
  String get searchOnline => 'En ligne';

  @override
  String get searchInPerson => 'En présentiel';

  @override
  String get searchLocationTypePhysical => 'Lieu physique';

  @override
  String get searchLocationTypeOffline => 'Hors ligne';

  @override
  String get searchLocationTypeOnline => 'En ligne';

  @override
  String get searchLocationTypeHybrid => 'Hybride';

  @override
  String get searchHintEventOrOrganization => 'Événement ou organisation';

  @override
  String get searchNoSuggestions => 'Aucune suggestion';

  @override
  String get searchSectionThemes => 'Thématiques';

  @override
  String get searchSectionEventType => 'Type d\'événement';

  @override
  String get searchSectionSpecialEvents => 'Temps forts';

  @override
  String get searchSectionMood => 'Ambiance';

  @override
  String get searchSectionDate => 'Date';

  @override
  String get searchSectionCategories => 'Catégories';

  @override
  String get searchSectionSort => 'Tri';

  @override
  String get searchSectionLocation => 'Localisation';

  @override
  String get searchSectionBudget => 'Budget';

  @override
  String get searchSectionFormat => 'Format';

  @override
  String get searchSectionAudience => 'Public';

  @override
  String get searchSectionLocationType => 'Type de lieu';

  @override
  String get searchChoosePeriod => 'Choisissez une période';

  @override
  String get searchChooseCustomDates => 'Choisir des dates personnalisées';

  @override
  String get searchFreeOnlyTitle => 'Gratuit uniquement';

  @override
  String get searchFreeOnlySubtitle =>
      'Afficher seulement les activités gratuites';

  @override
  String get searchPriceRangeTitle => 'Fourchette de prix';

  @override
  String get searchAll => 'Tous';

  @override
  String get searchNoThemeAvailable => 'Aucune thématique disponible';

  @override
  String get searchShowLess => 'Voir moins';

  @override
  String searchShowMoreWithCount(int count) {
    return 'Voir plus ($count)';
  }

  @override
  String get searchLoadError => 'Chargement impossible';

  @override
  String get searchHintCity => 'Rechercher une ville';

  @override
  String get searchPopularCities => 'VILLES POPULAIRES';

  @override
  String get searchResults => 'RÉSULTATS';

  @override
  String searchMinCharacters(int count) {
    return 'Saisissez au moins $count caractères';
  }

  @override
  String get searchNoCityFound => 'Aucune ville trouvée';

  @override
  String get searchCitiesUnavailable => 'Villes indisponibles';

  @override
  String get searchHintCategory => 'Rechercher une catégorie';

  @override
  String get searchNoCategoryFound => 'Aucune catégorie trouvée';

  @override
  String get searchCategoriesUnavailable => 'Catégories indisponibles';

  @override
  String get searchFamilyTitle => 'Famille';

  @override
  String get searchFamilySubtitle => 'Activités adaptées aux enfants';

  @override
  String get searchAudienceGroup => 'En groupe';

  @override
  String get searchAudienceSchoolGroup => 'Groupe scolaire';

  @override
  String get searchAudienceProfessional => 'Professionnel';

  @override
  String get searchAccessibleSubtitle => 'Accessibilité mobilité réduite';

  @override
  String get searchOnlineSubtitle => 'Activités virtuelles';

  @override
  String get searchInPersonSubtitle => 'Activités sur place';

  @override
  String get searchAvailabilityTitle => 'Disponibilités';

  @override
  String get searchAvailabilitySubtitle => 'Billetterie uniquement';

  @override
  String get searchAvailabilityPanelTitle => 'Disponibilité';

  @override
  String get searchAllActivities => 'Toutes les activités';

  @override
  String get searchAvailableOnlyTitle => 'Places disponibles uniquement';

  @override
  String get searchNoAudienceAvailable => 'Aucun public disponible';

  @override
  String get searchAudiencesUnavailable => 'Publics indisponibles';

  @override
  String get searchOptionsUnavailable => 'Options indisponibles';

  @override
  String get searchLocationIndoor => 'En intérieur';

  @override
  String get searchLocationOutdoor => 'En extérieur';

  @override
  String get searchLocationMixed => 'Mixte';

  @override
  String get searchSortNewest => 'Nouveautés';

  @override
  String get searchSortDateAsc => 'Date (proche)';

  @override
  String get searchSortDateDesc => 'Date (plus tard)';

  @override
  String get searchSortPriceAsc => 'Prix croissant';

  @override
  String get searchSortPriceDesc => 'Prix décroissant';

  @override
  String get searchSortPopularity => 'Popularité';

  @override
  String get searchSortDistance => 'Distance';

  @override
  String get searchSaveSheetTitle => 'Sauvegarder la recherche';

  @override
  String get searchSaveSheetSubtitle =>
      'Retrouvez facilement cette recherche et recevez des alertes pour les nouveaux événements.';

  @override
  String get searchDefaultName => 'Ma recherche';

  @override
  String get searchAllEvents => 'Tous les événements';

  @override
  String searchSummaryPrefix(String summary) {
    return 'Filtres : $summary';
  }

  @override
  String get searchNameRequired => 'Veuillez entrer un nom pour la recherche';

  @override
  String get searchNameAlreadyUsed =>
      'Ce nom est déjà utilisé. Choisissez un autre nom.';

  @override
  String get searchNameLabel => 'Nom de la recherche';

  @override
  String get searchNameHint => 'Ex : Concerts à Paris ce week-end';

  @override
  String get searchNotificationsTitle => 'Notifications';

  @override
  String get searchPushTitle => 'Push';

  @override
  String get searchPushSubtitle => 'Notifications sur l\'app mobile';

  @override
  String get searchEmailTitle => 'Email';

  @override
  String get searchEmailSubtitle =>
      'Recevez un email pour chaque nouvel événement';

  @override
  String get searchSaveButton => 'Sauvegarder';

  @override
  String get eventExploreTitle => 'Explorer les événements';

  @override
  String get eventSearchHintActivity => 'Rechercher une activité...';

  @override
  String eventFiltersWithCount(int count) {
    return 'Filtres ($count)';
  }

  @override
  String get eventEndOfList => 'C\'est tout pour le moment !';

  @override
  String get eventNoEventsTitle => 'Aucun événement trouvé';

  @override
  String get eventNoResultsWithFilters =>
      'Aucun résultat avec les filtres actuels';

  @override
  String get eventNoEventsAvailable =>
      'Il n\'y a pas d\'événements disponibles pour le moment';

  @override
  String get eventGenericErrorTitle => 'Une erreur est survenue';

  @override
  String get eventMapLocationError => 'Impossible de récupérer votre position';

  @override
  String eventMapEventsHere(int count) {
    return '$count événements ici';
  }

  @override
  String get eventMapSearching => 'Recherche en cours...';

  @override
  String get eventMapEmptyHelp =>
      'Oups, c\'est calme par ici !\nBesoin d\'un coup de pouce ?';

  @override
  String get eventLoadError => 'Impossible de charger l\'activité.';

  @override
  String eventDateAtTime(String date, String time) {
    return '$date à $time';
  }

  @override
  String get eventDatesSoonAvailable =>
      'Dates bientôt disponibles. Contactez l\'organisateur pour plus d\'infos.';

  @override
  String get eventAboutTitle => 'À propos de l\'événement';

  @override
  String get eventReadMore => 'Lire la suite';

  @override
  String get eventPricingTitle => 'Tarification';

  @override
  String get eventUndefined => 'Non définie';

  @override
  String get eventNoEntryFee => 'Aucun frais d\'entrée';

  @override
  String get eventIndicativePrices =>
      'Prix indicatifs communiqués par l\'organisateur';

  @override
  String get eventPriceFromPrefix => 'À partir de ';

  @override
  String get eventPriceDonation => 'Participation libre';

  @override
  String get eventPriceVariable => 'Prix variable';

  @override
  String eventPriceRange(String minPrice, String maxPrice) {
    return 'De $minPrice à $maxPrice';
  }

  @override
  String eventAgeMinimum(int minAge) {
    return '$minAge ans et +';
  }

  @override
  String eventAgeMaximum(int maxAge) {
    return 'Jusqu\'à $maxAge ans';
  }

  @override
  String eventAgeRange(int minAge, int maxAge) {
    return '$minAge-$maxAge ans';
  }

  @override
  String get eventLocationIndoorOutdoor => 'Intérieur/Extérieur';

  @override
  String get eventCharacteristicsTitle => 'Caractéristiques';

  @override
  String get eventInvalidBookingLink => 'Lien de réservation invalide';

  @override
  String get eventChooseDateFirst => 'Veuillez d\'abord choisir une date';

  @override
  String get eventSelectAtLeastOneTicket =>
      'Veuillez sélectionner au moins un billet';

  @override
  String get eventBookingChoiceTitle => 'Que voulez-vous faire ?';

  @override
  String get eventBookingChoiceBody =>
      'Ajoutez ces billets au panier pour les payer avec d\'autres événements, ou finalisez maintenant.';

  @override
  String get eventTicketsAddedToCart => 'Billets ajoutés au panier';

  @override
  String get eventView => 'Voir';

  @override
  String get eventAddToCart => 'Ajouter au panier';

  @override
  String get eventBookNow => 'Réserver maintenant';

  @override
  String eventAllDatesCount(int count) {
    return 'Toutes les dates ($count)';
  }

  @override
  String get eventFull => 'Complet';

  @override
  String get eventChoose => 'Choisir';

  @override
  String get eventTicketing => 'Billetterie';

  @override
  String get eventDiscovery => 'Découverte';

  @override
  String get eventFeatured => 'En vedette';

  @override
  String get eventRecommended => 'Recommandé';

  @override
  String get eventNew => 'Nouveau';

  @override
  String get eventPlaceNotSpecified => 'Lieu non précisé';

  @override
  String get eventCategoryWorkshop => 'Atelier';

  @override
  String get eventCategoryShow => 'Spectacle';

  @override
  String get eventCategoryFestival => 'Festival';

  @override
  String get eventCategoryConcert => 'Concert';

  @override
  String get eventCategoryExhibition => 'Exposition';

  @override
  String get eventCategorySport => 'Sport';

  @override
  String get eventCategoryCulture => 'Culture';

  @override
  String get eventCategoryMarket => 'Marché';

  @override
  String get eventCategoryLeisure => 'Loisirs';

  @override
  String get eventCategoryOutdoor => 'Plein air';

  @override
  String get eventCategoryIndoor => 'Intérieur';

  @override
  String get eventCategoryTheater => 'Théâtre';

  @override
  String get eventCategoryCinema => 'Cinéma';

  @override
  String get eventCategoryOther => 'Événement';

  @override
  String get eventAudienceAll => 'Tout public';

  @override
  String get eventAudienceFamily => 'Famille';

  @override
  String get eventAudienceChildren => 'Enfants';

  @override
  String get eventAudienceTeenagers => 'Ados';

  @override
  String get eventAudienceAdults => 'Adultes';

  @override
  String get eventAudienceSeniors => 'Seniors';

  @override
  String get eventDatesAvailable => 'Dates disponibles';

  @override
  String get eventChooseDate => 'Choisissez une date';

  @override
  String eventViewAllCount(int count) {
    return 'Voir tout ($count)';
  }

  @override
  String get eventNoDateAvailable => 'Aucune date disponible';

  @override
  String get eventNoOpenSlots => 'Cet événement n\'a pas de créneaux ouverts';

  @override
  String eventSpotsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places restantes',
      one: '1 place restante',
    );
    return '$_temp0';
  }

  @override
  String get eventTicketsTitle => 'Billets';

  @override
  String get eventShowMore => 'Voir plus';

  @override
  String get eventShowLess => 'Voir moins';

  @override
  String get eventSoldOut => 'Épuisé';

  @override
  String eventTicketLowStock(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plus que $count !',
      one: 'Plus qu\'1 !',
    );
    return '$_temp0';
  }

  @override
  String eventTicketsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count disponibles',
      one: '1 disponible',
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
      other: '$count billets sélectionnés',
      one: '1 billet sélectionné',
    );
    return '$_temp0';
  }

  @override
  String eventTicketsForDate(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count billets • $date',
      one: '1 billet • $date',
    );
    return '$_temp0';
  }

  @override
  String get eventNoSeatsAvailable => 'Plus de places disponibles';

  @override
  String eventExpectedCapacity(int count) {
    return 'Capacité prévue : $count';
  }

  @override
  String get eventViewDates => 'Voir les dates';

  @override
  String get eventReminded => 'Rappelé';

  @override
  String get eventRemindMe => 'Me rappeler';

  @override
  String get eventViewWebsite => 'Voir le site';

  @override
  String get eventIndicativePrice => 'Prix indicatif';

  @override
  String eventDateFromTo(String date, String start, String end) {
    return '$date de $start à $end';
  }

  @override
  String eventDateAtStart(String date, String start) {
    return '$date à $start';
  }

  @override
  String get eventServicesAdditionalTitle =>
      'Services additionnels (indicatif)';

  @override
  String get eventPracticalInfoTitle => 'Infos pratiques';

  @override
  String get eventParkingTitle => 'Parking';

  @override
  String get eventParkingSubtitle => 'Places disponibles';

  @override
  String get eventTransportTitle => 'Transports';

  @override
  String get eventTransportSubtitle => 'Bus, métro, tram';

  @override
  String get eventFoodService => 'Restauration';

  @override
  String get eventFoodOnSite => 'Restauration sur place';

  @override
  String get eventDrinks => 'Boissons';

  @override
  String get eventDrinksAvailable => 'Boissons disponibles';

  @override
  String get eventWifiLabel => 'Wi-Fi';

  @override
  String get eventWifiAvailable => 'Wi-Fi disponible';

  @override
  String get eventServiceDefaultDescription =>
      'Ce service est disponible sur place.';

  @override
  String get eventServiceEquipment => 'Matériel fourni';

  @override
  String get eventServiceFacilitator => 'Animateur';

  @override
  String get eventServiceAccommodation => 'Hébergement';

  @override
  String get eventServiceCloakroom => 'Vestiaire';

  @override
  String get eventServiceSecurity => 'Sécurité';

  @override
  String get eventServiceFirstAid => 'Premiers secours';

  @override
  String get eventServiceChildcare => 'Garderie';

  @override
  String get eventServicePhotoBooth => 'Photobooth';

  @override
  String get eventPlace => 'Lieu';

  @override
  String get eventParkingSheetTitle => 'Stationnement';

  @override
  String get eventParkingDirections => 'Naviguer vers le parking';

  @override
  String get eventTransportSheetTitle => 'Transports en commun';

  @override
  String get eventAccessibilityTitle => 'Accessibilité';

  @override
  String get eventAccessibilityPmr => 'Accessible PMR';

  @override
  String get eventAccessibilityPmrTitle => 'Accessibilité PMR';

  @override
  String get eventAccessibilitySignLanguage => 'Langue des signes';

  @override
  String get eventAccessibilityElevator => 'Ascenseur';

  @override
  String get eventAccessibilityDisabledParking => 'Parking handicapé';

  @override
  String get eventAccessibilityDisabledSeats => 'Places handicapé';

  @override
  String get eventAccessibilityGuideDog => 'Chien guide';

  @override
  String get eventAccessibilityHearingLoop => 'Boucle magnétique';

  @override
  String get eventAccessibilityAudioDescription => 'Audiodescription';

  @override
  String get eventAccessibilityBraille => 'Braille';

  @override
  String get eventAvailable => 'Disponible';

  @override
  String get eventQuickActions => 'Actions rapides';

  @override
  String get eventDrivingDirections => 'Itinéraire en voiture';

  @override
  String get eventWalkingDirections => 'Y aller à pied';

  @override
  String get eventPublicTransportDirections => 'Transports en commun';

  @override
  String get eventCopyAddress => 'Copier l\'adresse';

  @override
  String get eventAddressCopied => 'Adresse copiée';

  @override
  String get eventDetailsLabel => 'Détails';

  @override
  String get eventLocationTitle => 'Localisation';

  @override
  String get eventViewOnGoogleMaps => 'Voir sur Google Maps';

  @override
  String get eventNoImage => 'Aucune image';

  @override
  String get eventNoImageAvailable => 'Aucune image disponible';

  @override
  String get eventViewVideo => 'Voir la vidéo';

  @override
  String eventViewAllPhotosCount(int count) {
    return 'Voir toutes les photos ($count)';
  }

  @override
  String get eventPrivateNotFound => 'Événement introuvable.';

  @override
  String get eventPasswordRequired => 'Le mot de passe est requis.';

  @override
  String get eventPasswordIncorrect => 'Mot de passe incorrect.';

  @override
  String get eventPasswordInvalidFormat => 'Format invalide.';

  @override
  String get eventPasswordNetworkError => 'Erreur réseau. Réessaie.';

  @override
  String eventPasswordRetryIn(int seconds) {
    return 'Réessaye dans ${seconds}s';
  }

  @override
  String get eventPasswordChecking => 'Vérification...';

  @override
  String get eventUnlock => 'Déverrouiller';

  @override
  String get eventPrivateTitle => 'Cet événement est privé';

  @override
  String get eventPrivateInstructions =>
      'Entre le mot de passe communiqué par l\'organisateur.';

  @override
  String get eventPasswordAttemptsWarning =>
      'Encore 3 essais avant un délai de 1 minute.';

  @override
  String get eventPasswordLabel => 'Mot de passe';

  @override
  String get eventPasswordHint => 'Saisis le mot de passe';

  @override
  String get eventMembersOnlyTitle => 'Réservé aux membres';

  @override
  String get eventMembersOnlyPrefix => 'L\'événement ';

  @override
  String get eventMembersOnlyReservedFor => 'est réservé aux membres de ';

  @override
  String get eventMembersOnlySuffix =>
      '. Rejoins la communauté pour y accéder.';

  @override
  String get eventOrganizationFallback => 'cette organisation';

  @override
  String get eventViewOrganizer => 'Voir l\'organisateur';

  @override
  String get eventEnterPassword => 'Entrer le mot de passe';

  @override
  String get eventPrivateFallbackSubtitle =>
      'Cet événement est privé. Entre le mot de passe communiqué par l\'organisateur.';

  @override
  String eventShareWithSender(
      String senderName, String eventTitle, String url) {
    return '$senderName vous partage l\'événement $eventTitle : $url';
  }

  @override
  String eventShareDefault(String eventTitle, String url) {
    return 'Découvre l\'événement $eventTitle : $url';
  }

  @override
  String get eventQuestionsTitle => 'Questions';

  @override
  String get eventAsk => 'Poser';

  @override
  String get eventQuestionSent => 'Votre question a été envoyée !';

  @override
  String get eventQuestionAlreadyAsked =>
      'Vous avez déjà posé une question sur cet événement.';

  @override
  String get eventYourQuestion => 'Votre question';

  @override
  String get eventQuestionStatusPending => 'En attente de modération';

  @override
  String get eventQuestionStatusApproved => 'Approuvée';

  @override
  String get eventQuestionStatusAnswered => 'Répondue';

  @override
  String get eventQuestionStatusRejected => 'Refusée';

  @override
  String eventViewAllQuestionsCount(int count) {
    return 'Voir toutes les questions ($count)';
  }

  @override
  String get eventNoQuestionsTitle => 'Aucune question pour le moment';

  @override
  String get eventNoQuestionsBody =>
      'Soyez le premier à poser une question sur cet événement.';

  @override
  String get eventAskQuestion => 'Poser une question';

  @override
  String get eventQuestionsLoadError => 'Impossible de charger les questions';

  @override
  String get eventQuestionsEnd => 'Vous avez vu toutes les questions';

  @override
  String get eventVoteUnavailable => 'Impossible de voter pour le moment.';

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
  String get eventOfficialAnswer => 'Réponse officielle';

  @override
  String get eventAnonymous => 'Anonyme';

  @override
  String get eventHelpful => 'Utile';

  @override
  String eventHelpfulCount(int count) {
    return 'Utile ($count)';
  }

  @override
  String get eventAskQuestionHint => 'Ex: À quelle heure ouvrent les portes ?';

  @override
  String get eventQuestionRequired => 'Veuillez saisir votre question.';

  @override
  String get eventQuestionMinLength =>
      'Votre question doit contenir au moins 10 caractères.';

  @override
  String get eventQuestionTooLong =>
      'Votre question est trop longue (1000 max).';

  @override
  String get eventQuestionInvalid => 'Question invalide.';

  @override
  String get eventQuestionInfo =>
      'L\'organisateur recevra votre question et vous répondra bientôt.';

  @override
  String get eventSendQuestion => 'Envoyer ma question';

  @override
  String get eventCheckConnectionRetry =>
      'Vérifiez votre connexion puis réessayez.';

  @override
  String get eventOrganizerInfoSources => 'Sources Infos';

  @override
  String get eventOrganizerTitle => 'Organisateur';

  @override
  String get eventOrganizerVerified => 'Organisateur vérifié';

  @override
  String get eventOrganizerNotVerified => 'Organisateur non vérifié';

  @override
  String eventOrganizerEventsPublished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count événements publiés',
      one: '1 événement publié',
    );
    return '$_temp0';
  }

  @override
  String eventOrganizerFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count abonnés',
      one: '1 abonné',
    );
    return '$_temp0';
  }

  @override
  String get eventContact => 'Contacter';

  @override
  String get eventViewProfile => 'Voir le profil';

  @override
  String get eventWrittenBy => 'Rédigé par';

  @override
  String get eventLehibooExperiences => 'LEHIBOO EXPÉRIENCES';

  @override
  String get eventSourceInfo => 'Source infos : ';

  @override
  String get eventSimilarEvents => 'Événements similaires';

  @override
  String eventPeopleWatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes regardent',
      one: '1 personne regarde',
    );
    return '$_temp0';
  }

  @override
  String get bookingCheckoutTitle => 'Finaliser ma réservation';

  @override
  String get bookingSummaryTitle => 'Récapitulatif';

  @override
  String get bookingTicketFallback => 'Billet';

  @override
  String get bookingTotal => 'Total';

  @override
  String get bookingBuyerContactTitle => 'Vos coordonnées';

  @override
  String get bookingContactDetailsTitle => 'Coordonnées';

  @override
  String get bookingContactDetailsSubtitle =>
      'Vous recevrez votre confirmation et vos billets à cette adresse.';

  @override
  String get bookingAdditionalInfoOptional =>
      'Informations complémentaires (optionnel)';

  @override
  String get bookingFirstNameLabelRequired => 'Prénom *';

  @override
  String get bookingLastNameLabelRequired => 'Nom *';

  @override
  String get bookingEmailLabelRequired => 'Email *';

  @override
  String get bookingPhoneLabel => 'Téléphone';

  @override
  String get bookingAgeLabel => 'Âge';

  @override
  String get bookingMembershipCityLabel => 'Ville d\'appartenance';

  @override
  String get bookingFirstNameRequired => 'Le prénom est requis';

  @override
  String get bookingLastNameRequired => 'Le nom est requis';

  @override
  String get bookingEmailRequired => 'L\'email est requis';

  @override
  String get bookingEmailInvalid => 'Email invalide';

  @override
  String get bookingCityMaxLength =>
      'La ville ne doit pas dépasser 255 caractères';

  @override
  String get bookingTermsPrefix => 'J\'accepte les ';

  @override
  String get bookingTermsConnector => ' et la ';

  @override
  String get bookingAcceptSalesRequired =>
      'Veuillez accepter les conditions générales de vente';

  @override
  String get bookingEveryTicketNeedsParticipant =>
      'Chaque billet doit avoir un participant renseigné';

  @override
  String get bookingParticipantsMissingDetails =>
      'Veuillez renseigner le prénom, le nom, la date de naissance, la ville et la relation de chaque participant';

  @override
  String get bookingParticipantsMissingCartDetails =>
      'Veuillez renseigner le prénom, la date de naissance, la ville et la relation de chaque participant';

  @override
  String get bookingConfirm => 'Confirmer';

  @override
  String get bookingPay => 'Payer';

  @override
  String get bookingContinueToPayment => 'Continuer vers le paiement';

  @override
  String get bookingPaymentCancelled => 'Paiement annulé';

  @override
  String bookingTicketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count billets',
      one: '1 billet',
    );
    return '$_temp0';
  }

  @override
  String get bookingCartTitle => 'Panier';

  @override
  String get bookingCartHoldExpired =>
      'Le délai du panier est dépassé. Ajoutez à nouveau vos billets pour continuer.';

  @override
  String get bookingClearCartTitle => 'Vider le panier ?';

  @override
  String get bookingClearCartBody =>
      'Tous les billets ajoutés seront supprimés. Cette action est irréversible.';

  @override
  String get bookingClear => 'Vider';

  @override
  String bookingCartHoldLabel(String time) {
    return 'Panier $time';
  }

  @override
  String bookingPlacesHoldLabel(String time) {
    return 'Places $time';
  }

  @override
  String get bookingCartHoldTitle => 'Conservation du panier';

  @override
  String get bookingCartHoldBody =>
      'Votre sélection est conservée 15 minutes après le dernier ajout. Au moment du paiement, les places sont bloquées le temps nécessaire à la finalisation.';

  @override
  String get bookingUnderstood => 'Compris';

  @override
  String get bookingEmptyCartTitle => 'Votre panier est vide';

  @override
  String get bookingEmptyCartBody =>
      'Ajoutez des billets depuis une fiche événement pour payer plusieurs réservations en une fois.';

  @override
  String get bookingExploreEvents => 'Explorer les événements';

  @override
  String get bookingParticipantsTitle => 'Participants';

  @override
  String get bookingParticipantsInstruction =>
      'Choisissez une personne enregistrée ou renseignez chaque billet.';

  @override
  String get bookingParticipantSectionSubtitle =>
      'Un formulaire par billet — renseignez chaque participant';

  @override
  String get bookingParticipantInfoNote =>
      'Le prénom, la date de naissance, la ville et la relation aident l\'IA et l\'expérience Le Hiboo à proposer les offres et événements les plus pertinents.';

  @override
  String get bookingChooseSavedParticipant =>
      'Choisir un participant enregistré';

  @override
  String get bookingAddToNextEmptyTicket => 'Ajouter au prochain billet vide';

  @override
  String get bookingMyParticipants => 'Mes participants';

  @override
  String bookingSavedParticipantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrés',
      one: '1 enregistré',
    );
    return '$_temp0';
  }

  @override
  String get bookingPrefillTicketsOneClick =>
      'Pré-remplissez vos billets en un clic';

  @override
  String bookingParticipantsReady(int completed, int total) {
    return '$completed / $total participants prêts';
  }

  @override
  String get bookingFillAllWithProfile =>
      'Remplir tous les billets avec mon profil';

  @override
  String get bookingIncompleteProfileTitle => 'Profil incomplet';

  @override
  String get bookingIncompleteProfileBody =>
      'Complétez votre profil (date de naissance, ville) pour pré-remplir tous les champs requis.';

  @override
  String get bookingCompleteProfile => 'Compléter mon profil >';

  @override
  String get bookingPrefillTicket => 'Pré-remplir ce billet';

  @override
  String get bookingManualEntry => 'Saisie manuelle';

  @override
  String get bookingBuyerSelf => 'Moi (acheteur)';

  @override
  String get bookingRelationshipSelf => 'Moi';

  @override
  String get bookingRelationshipChild => 'Enfant';

  @override
  String get bookingRelationshipSpouse => 'Conjoint';

  @override
  String get bookingRelationshipFamily => 'Famille';

  @override
  String get bookingRelationshipFriend => 'Ami';

  @override
  String get bookingRelationshipOther => 'Autre';

  @override
  String get bookingFirstNameShortRequired => 'Prénom requis';

  @override
  String get bookingCityRequired => 'Ville requise';

  @override
  String get bookingRelationRequired => 'Relation requise';

  @override
  String get bookingLastNameLabel => 'Nom';

  @override
  String get bookingRelationLabelRequired => 'Relation *';

  @override
  String get bookingBirthDateLabelRequired => 'Date de naissance *';

  @override
  String get bookingBirthDateHelp => 'Date de naissance';

  @override
  String get bookingBirthDatePlaceholder => 'jj/mm/aaaa';

  @override
  String get bookingContactOptional => 'Contact optionnel';

  @override
  String get bookingSaveParticipant => 'Ajouter à Mes participants';

  @override
  String get bookingParticipantComplete => 'Complet';

  @override
  String get bookingParticipantActionRequired => 'Action requise';

  @override
  String get bookingRecapTitle => 'Récapitulatif';

  @override
  String get bookingTotalTickets => 'Total billets';

  @override
  String bookingPerTicket(String price) {
    return '$price / billet';
  }

  @override
  String get bookingRemove => 'Retirer';

  @override
  String get bookingOrderConfirmed => 'Commande confirmée';

  @override
  String bookingReference(String reference) {
    return 'Référence : $reference';
  }

  @override
  String get bookingCreatedReservations => 'Réservations créées';

  @override
  String get bookingTicketsGeneratingOrder =>
      'Vos billets sont en cours de génération. Vous les retrouverez dans Mes réservations.';

  @override
  String get bookingViewMyBookings => 'Voir mes réservations';

  @override
  String get bookingBackHome => 'Retour à l\'accueil';

  @override
  String get bookingReservationFallback => 'Réservation';

  @override
  String get bookingMyBookingsTitle => 'Mes réservations';

  @override
  String get bookingSortTooltip => 'Trier';

  @override
  String get bookingSortByTitle => 'Trier par';

  @override
  String get bookingSortDateAsc => 'Date (plus proche)';

  @override
  String get bookingSortDateDesc => 'Date (plus lointaine)';

  @override
  String get bookingSortStatusAsc => 'Statut';

  @override
  String get bookingFilterAll => 'Tous';

  @override
  String get bookingFilterUpcoming => 'À venir';

  @override
  String get bookingFilterPast => 'Passés';

  @override
  String get bookingFilterCancelled => 'Annulés';

  @override
  String bookingLoadError(String message) {
    return 'Erreur de chargement : $message';
  }

  @override
  String get bookingEmptyAllTitle => 'Aucune réservation';

  @override
  String get bookingEmptyAllBody =>
      'Vous n\'avez pas encore de réservation.\nDécouvrez nos événements !';

  @override
  String get bookingEmptyUpcomingTitle => 'Aucune réservation à venir';

  @override
  String get bookingEmptyUpcomingBody =>
      'Vous n\'avez pas de réservation prévue.\nExplorez nos événements !';

  @override
  String get bookingEmptyPastTitle => 'Aucune réservation passée';

  @override
  String get bookingEmptyPastBody =>
      'Vous n\'avez pas encore participé à un événement.';

  @override
  String get bookingEmptyCancelledTitle => 'Aucune réservation annulée';

  @override
  String get bookingEmptyCancelledBody =>
      'Vous n\'avez aucune réservation annulée.';

  @override
  String get bookingNotFoundTitle => 'Réservation introuvable';

  @override
  String get bookingNotFoundBody =>
      'Cette réservation n\'existe pas ou a été supprimée.';

  @override
  String get bookingEventFallback => 'Événement';

  @override
  String get bookingStandardTicket => 'Standard';

  @override
  String get bookingShareBookingTitle => 'Ma réservation Le Hiboo';

  @override
  String get bookingShareTicketTitle => 'Mon billet Le Hiboo';

  @override
  String bookingShareTicketCode(String code) {
    return 'Code : $code';
  }

  @override
  String bookingShareTicketsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count billets',
      one: '1 billet',
    );
    return '$_temp0';
  }

  @override
  String bookingCalendarReference(String reference) {
    return 'Réservation Le Hiboo : $reference';
  }

  @override
  String get bookingCalendarAdded => 'Événement ajouté au calendrier';

  @override
  String get bookingCalendarAddFailed => 'Impossible d\'ajouter au calendrier';

  @override
  String get bookingCancelDialogTitle => 'Annuler la réservation';

  @override
  String get bookingCancelDialogBody =>
      'Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.';

  @override
  String bookingCancelDeadline(String deadline) {
    return 'Date limite : $deadline';
  }

  @override
  String get bookingCancelReasonLabel => 'Raison (optionnel)';

  @override
  String get bookingCancelReasonHint => 'Empêchement personnel…';

  @override
  String get bookingCancelWarning =>
      'Attention : aucun remboursement ne sera effectué après l\'annulation.';

  @override
  String get bookingCancelKeep => 'Non, garder';

  @override
  String get bookingCancelConfirm => 'Oui, annuler';

  @override
  String get bookingCancelSuccess =>
      'Réservation annulée. Aucun remboursement ne sera effectué.';

  @override
  String get bookingCancelForbidden =>
      'L\'annulation n\'est plus possible (délai dépassé ou non autorisé par l\'organisateur).';

  @override
  String get bookingCancelNotFound => 'Cette réservation est introuvable.';

  @override
  String get bookingCancelValidationTooLong =>
      'La raison saisie est trop longue (1000 caractères max).';

  @override
  String get bookingCancelGenericError =>
      'Impossible d\'annuler la réservation. Réessayez.';

  @override
  String get bookingPreparingPdf => 'Préparation du PDF…';

  @override
  String get bookingAndroidDownloadsLocation => 'Téléchargements/Lehiboo';

  @override
  String get bookingDocumentsTicketsLocation => 'Documents > Lehiboo > tickets';

  @override
  String bookingTicketsSaved(String location) {
    return 'Billets enregistrés dans $location';
  }

  @override
  String bookingTicketSaved(String location) {
    return 'Billet enregistré dans $location';
  }

  @override
  String get bookingTicketsNotReady =>
      'Vos billets sont en cours de génération, réessayez dans un instant.';

  @override
  String get bookingTicketNotReady =>
      'Ce billet est en cours de génération, réessayez dans un instant.';

  @override
  String get bookingTicketsNotAuthorized =>
      'Vous n\'êtes pas autorisé à télécharger ces billets.';

  @override
  String get bookingTicketNotDownloadable =>
      'Ce billet n\'est plus téléchargeable.';

  @override
  String get bookingDownloadError =>
      'Téléchargement impossible. Réessayez plus tard.';

  @override
  String get bookingDownloadSingleTicket => 'Télécharger le billet PDF';

  @override
  String get bookingDownloadAllTickets => 'Télécharger tous les billets';

  @override
  String get bookingTicketTitle => 'Billet';

  @override
  String get bookingTicketNotFound => 'Billet non trouvé';

  @override
  String bookingTicketPosition(int current, int total) {
    return 'Billet $current/$total';
  }

  @override
  String get bookingTicketSwipeHint => '← Swipe pour voir les autres billets →';

  @override
  String get bookingQrTapFullscreenHint =>
      'Appuyez sur le QR code pour l\'afficher en plein écran';

  @override
  String get bookingQrTapCloseHint => 'Appuyez n\'importe où pour fermer';

  @override
  String get bookingParticipantDefault => 'Participant';

  @override
  String bookingParticipantNumber(int index) {
    return 'Participant $index';
  }

  @override
  String bookingAgeYears(int age) {
    return '$age ans';
  }

  @override
  String get bookingAddToCalendar => 'Ajouter au calendrier';

  @override
  String get bookingContactOrganizer => 'Contacter l\'organisateur';

  @override
  String get bookingAdditionalInfoTitle => 'Informations complémentaires';

  @override
  String get bookingSectionEvent => 'ÉVÉNEMENT';

  @override
  String get bookingViewEvent => 'Voir l\'événement';

  @override
  String get bookingSectionSummary => 'RÉSUMÉ';

  @override
  String get bookingDiscountFallback => 'Réduction';

  @override
  String bookingMyTicketsCount(int count) {
    return 'MES BILLETS ($count)';
  }

  @override
  String get bookingStatusPending => 'En attente';

  @override
  String get bookingStatusConfirmed => 'Confirmé';

  @override
  String get bookingStatusCancelled => 'Annulé';

  @override
  String get bookingStatusCompleted => 'Terminé';

  @override
  String get bookingStatusRefunded => 'Remboursé';

  @override
  String get bookingTicketStatusActive => 'Actif';

  @override
  String get bookingTicketStatusUsed => 'Utilisé';

  @override
  String get bookingTicketStatusCancelled => 'Annulé';

  @override
  String get bookingTicketStatusExpired => 'Expiré';

  @override
  String bookingLegacyReservationForEvent(String eventId) {
    return 'Réservation pour l\'événement $eventId';
  }

  @override
  String bookingLegacyReserveTitle(String eventTitle) {
    return 'Réserver : $eventTitle';
  }

  @override
  String get bookingLegacyStepSlot => 'Créneau';

  @override
  String get bookingLegacyStepInfo => 'Infos';

  @override
  String get bookingLegacyStepPayment => 'Paiement';

  @override
  String get bookingLegacyChooseSlot => 'Choisir un créneau';

  @override
  String get bookingLegacyNoSlotTitle => 'Aucun créneau';

  @override
  String get bookingLegacyNoSlotBody =>
      'Aucun créneau disponible pour le moment.';

  @override
  String get bookingLegacyParticipantsCountTitle => 'Nombre de participants';

  @override
  String bookingLegacyPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes',
      one: '1 personne',
    );
    return '$_temp0';
  }

  @override
  String get bookingLegacyContinue => 'Continuer';

  @override
  String get bookingLegacySelectSlotRequired =>
      'Veuillez sélectionner un créneau.';

  @override
  String get bookingLegacyRequiredInfo =>
      'Veuillez remplir toutes les informations obligatoires.';

  @override
  String get bookingLegacyOtherParticipantsLater =>
      'Note : Les détails des autres participants seront demandés ultérieurement.';

  @override
  String get bookingConfirmReservation => 'Confirmer la réservation';

  @override
  String get bookingGoToPayment => 'Aller au paiement';

  @override
  String get bookingPaymentTitle => 'Paiement';

  @override
  String get bookingPaymentCardSimulated => 'Carte bancaire (simulée)';

  @override
  String get bookingCardNumberLabel => 'Numéro de carte';

  @override
  String get bookingCardExpiryLabel => 'MM/AA';

  @override
  String get bookingCardCvcLabel => 'CVC';

  @override
  String bookingPayAmount(String amount, String currency) {
    return 'Payer $amount $currency';
  }

  @override
  String get bookingConfirmedTitle => 'Réservation confirmée !';

  @override
  String bookingConfirmedBody(String firstName, String eventTitle) {
    return 'Merci $firstName, votre réservation pour \"$eventTitle\" est validée.';
  }

  @override
  String bookingTicketId(String ticketId) {
    return 'Billet #$ticketId';
  }

  @override
  String get bookingTicketValid => 'Valide';

  @override
  String get bookingSuccessThanks => 'Merci pour votre confiance';

  @override
  String get bookingReferenceLabel => 'Référence';

  @override
  String get bookingReferenceCopied => 'Référence copiée';

  @override
  String get bookingCopyTooltip => 'Copier';

  @override
  String get bookingYourTickets => 'Vos billets';

  @override
  String get bookingTicketsGenerating => 'Génération de vos billets...';

  @override
  String get bookingTicketsAvailableInBookings =>
      'Vos billets seront disponibles\ndans votre espace \"Mes réservations\"';

  @override
  String get bookingConfirmationEmailSent =>
      'Un email de confirmation avec vos billets vous a été envoyé.';

  @override
  String get bookingTicketsLoadError => 'Impossible de charger les billets';

  @override
  String get tripPlansListTitle => 'Mes sorties';

  @override
  String tripPlansDeletedSnack(String title) {
    return 'Plan \"$title\" supprimé';
  }

  @override
  String get tripPlansUntitledPlan => 'Plan sans titre';

  @override
  String get tripPlansEmptyTitle => 'Aucune sortie planifiée';

  @override
  String get tripPlansEmptyBody =>
      'Demande à Petit Boo de te créer un itinéraire pour ta prochaine sortie !';

  @override
  String get tripPlansTalkToPetitBoo => 'Parler à Petit Boo';

  @override
  String get tripPlansErrorTitle => 'Une erreur est survenue';

  @override
  String get tripPlansLoadErrorBody => 'Impossible de charger vos sorties';

  @override
  String get tripPlanEditTitle => 'Modifier';

  @override
  String tripPlanEditErrorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get tripPlanEditNotFound => 'Plan non trouvé';

  @override
  String get tripPlanEditTitleLabel => 'Titre';

  @override
  String get tripPlanEditNameHint => 'Nom de la sortie';

  @override
  String get tripPlanEditDateLabel => 'Date';

  @override
  String get tripPlanEditSelectDate => 'Sélectionner une date';

  @override
  String get tripPlanEditStopsLabel => 'Étapes';

  @override
  String get tripPlanEditReorderHint => 'Glisser pour réorganiser';

  @override
  String get tripPlanEditUpdatedSnack => 'Plan mis à jour';

  @override
  String get tripPlanEditDiscardChangesTitle =>
      'Abandonner les modifications ?';

  @override
  String get tripPlanEditDiscardChangesBody =>
      'Vos modifications ne seront pas sauvegardées.';

  @override
  String get tripPlanEditDiscard => 'Abandonner';

  @override
  String tripPlansStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étapes',
      one: '1 étape',
    );
    return '$_temp0';
  }

  @override
  String tripPlansStopsPlanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étapes prévues',
      one: '1 étape prévue',
    );
    return '$_temp0';
  }

  @override
  String get tripPlansStopFallback => 'Étape';

  @override
  String get tripPlansNoCoordinatesAvailable => 'Aucune coordonnée disponible';

  @override
  String get tripPlansDeleteDialogTitle => 'Supprimer ce plan ?';

  @override
  String tripPlansDeleteDialogBody(String title) {
    return 'Le plan \"$title\" sera définitivement supprimé.';
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
  String get reviewsAllRatingsFilter => 'Tous';

  @override
  String get reviewsAllTitle => 'Tous les avis';

  @override
  String get reviewsCannotReviewAlreadyReviewed =>
      'Vous avez déjà laissé un avis sur cet événement.';

  @override
  String get reviewsCannotReviewEventNotEnded =>
      'Vous pourrez laisser un avis une fois l\'événement passé.';

  @override
  String get reviewsCannotReviewNotParticipated =>
      'Seuls les participants à l\'événement peuvent laisser un avis.';

  @override
  String get reviewsCannotReviewOrganizer =>
      'Vous ne pouvez pas noter vos propres événements.';

  @override
  String get reviewsCannotReviewUnknown =>
      'Vous ne pouvez pas laisser d\'avis pour le moment.';

  @override
  String reviewsCommentMinLengthError(int minLength) {
    return 'Votre avis doit faire au moins $minLength caractères';
  }

  @override
  String get reviewsCommentRequiredError => 'Veuillez écrire votre avis';

  @override
  String get reviewsCommentRequiredLabel => 'Votre avis *';

  @override
  String get reviewsCreateSuccessPendingModeration =>
      'Avis envoyé. Il sera publié après validation.';

  @override
  String get reviewsDeleteAction => 'Supprimer';

  @override
  String get reviewsDeleteConfirmBody =>
      'Cette action est définitive. Vous pourrez en écrire un nouveau plus tard.';

  @override
  String get reviewsDeleteConfirmTitle => 'Supprimer cet avis ?';

  @override
  String get reviewsDeleteSuccess => 'Avis supprimé';

  @override
  String get reviewsEditAction => 'Modifier';

  @override
  String get reviewsEditModerationNotice =>
      'Toute modification remettra votre avis en attente de modération.';

  @override
  String get reviewsEditMyReviewTitle => 'Modifier mon avis';

  @override
  String get reviewsEmptyBody =>
      'Partagez votre expérience et aidez les autres à choisir !';

  @override
  String get reviewsEmptyTitle => 'Pas encore d\'avis';

  @override
  String get reviewsEventFallback => 'Événement';

  @override
  String get reviewsFeaturedFilter => 'Mis en avant';

  @override
  String get reviewsUserLoadError => 'Impossible de charger vos avis.';

  @override
  String get reviewsUserLoadMoreError => 'Impossible de charger la suite.';

  @override
  String get reviewsMyEmptyBody =>
      'Vous n\'avez encore laissé aucun avis. Une fois un événement terminé, vous pourrez partager votre expérience !';

  @override
  String get reviewsMyEmptyTitle => 'Aucun avis';

  @override
  String get reviewsNoFilteredResults =>
      'Aucun avis ne correspond aux filtres sélectionnés.';

  @override
  String get reviewsNoReviewsTitle => 'Aucun avis';

  @override
  String get reviewsOrganizerReplied => 'L\'organisateur a répondu';

  @override
  String get reviewsReportAction => 'Signaler';

  @override
  String get reviewsReportDetailsOptionalLabel => 'Précisions (optionnel)';

  @override
  String get reviewsReportReasonFake => 'Faux avis';

  @override
  String get reviewsReportReasonInappropriate => 'Contenu inapproprié';

  @override
  String get reviewsReportReasonOffensive => 'Propos offensants';

  @override
  String get reviewsReportReasonOther => 'Autre';

  @override
  String get reviewsReportReasonQuestion =>
      'Pourquoi cet avis pose-t-il problème ?';

  @override
  String get reviewsReportReasonSpam => 'Spam';

  @override
  String get reviewsReportSubmitAction => 'Envoyer le signalement';

  @override
  String get reviewsReportSuccess =>
      'Signalement envoyé. Merci de votre vigilance.';

  @override
  String get reviewsReportTitle => 'Signaler cet avis';

  @override
  String get reviewsRewriteAction => 'Réécrire';

  @override
  String get reviewsSectionTitle => 'Avis';

  @override
  String get reviewsSelectRatingRequired => 'Veuillez sélectionner une note';

  @override
  String get reviewsSortMostHelpful => 'Plus utiles';

  @override
  String get reviewsSortNewest => 'Plus récents';

  @override
  String get reviewsSortRating => 'Note';

  @override
  String get reviewsSortTooltip => 'Trier';

  @override
  String get reviewsStatusApproved => 'Publié';

  @override
  String get reviewsStatusPending => 'En attente';

  @override
  String get reviewsStatusRejected => 'Refusé';

  @override
  String get reviewsSubmitAction => 'Envoyer mon avis';

  @override
  String get reviewsTitleRequiredError => 'Veuillez ajouter un titre';

  @override
  String get reviewsTitleRequiredLabel => 'Titre *';

  @override
  String reviewsTotalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '1 avis',
      zero: 'Aucun avis',
    );
    return '$_temp0';
  }

  @override
  String get reviewsUpdateAction => 'Mettre à jour';

  @override
  String get reviewsUpdateSuccessPendingModeration =>
      'Avis mis à jour. Il sera de nouveau modéré.';

  @override
  String get reviewsVerifiedFilter => 'Vérifiés';

  @override
  String reviewsViewAllAction(int count) {
    return 'Voir tous les avis ($count)';
  }

  @override
  String get reviewsViewMyReviewAction => 'Voir mon avis →';

  @override
  String get reviewsWriteAction => 'Écrire';

  @override
  String get reviewsWriteFirstAction => 'Écrire le premier avis';

  @override
  String get reviewsWriteReviewAction => 'Écrire un avis';

  @override
  String get reviewsWriteReviewTitle => 'Laisser un avis';

  @override
  String get reviewsYourRatingLabel => 'Votre note';

  @override
  String get reviewsYourReviewLabel => 'Votre avis';

  @override
  String get gamificationActionsCatalogLoadError =>
      'Impossible de charger le catalogue';

  @override
  String get gamificationActionsEmpty =>
      'Aucune action disponible pour le moment';

  @override
  String get gamificationActivitiesBonusTitle => 'Activités & Bonus';

  @override
  String get gamificationAllFilter => 'Tous';

  @override
  String get gamificationBadgeLocked => 'À débloquer';

  @override
  String get gamificationBadgeUnlocked => 'Débloqué';

  @override
  String get gamificationBadgeUnlockedCongrats =>
      'Bravo, tu as débloqué ce badge !';

  @override
  String get gamificationBadgesLoadError => 'Impossible de charger tes badges';

  @override
  String get gamificationBoostersUtilitiesTitle => 'Boosters & Utilitaires';

  @override
  String get gamificationCapReached => 'Atteint';

  @override
  String get gamificationChallengesTitle => 'Challenges';

  @override
  String get gamificationClaimDailyReward => 'Réclamer ma récompense';

  @override
  String get gamificationComeBackTomorrow => 'Reviens demain !';

  @override
  String get gamificationCompleted => 'Effectué';

  @override
  String get gamificationCurrentRankPrefix => 'Tu es';

  @override
  String get gamificationDailyClaimError => 'Erreur lors de la réclamation';

  @override
  String get gamificationDailyRewardAlreadyClaimed =>
      'Tu as déjà réclamé ta récompense aujourd\'hui !';

  @override
  String get gamificationDailyRewardTitle => 'Récompense quotidienne';

  @override
  String gamificationDayNumber(int dayNumber) {
    return 'J-$dayNumber';
  }

  @override
  String get gamificationEarningsByPillarTitle => 'Répartition par pilier';

  @override
  String gamificationErrorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get gamificationGreatCta => 'Super !';

  @override
  String gamificationHibonsAmount(int count) {
    return '$count HIBONs';
  }

  @override
  String get gamificationHibonsAvailable => 'Hibons disponibles';

  @override
  String gamificationHibonsDelta(int delta) {
    return '$delta Hibons';
  }

  @override
  String gamificationHibonsEarned(int count) {
    return '$count Hibons gagnés';
  }

  @override
  String gamificationHibonsGainedToast(int delta) {
    return '+$delta Hibons gagnés !';
  }

  @override
  String get gamificationHibonsPacksComingSoonTitle =>
      'Packs de Hibons (bientôt)';

  @override
  String gamificationHibonsProgress(int current, int total) {
    return '$current / $total HIBONs';
  }

  @override
  String gamificationHibonsRemainingForBadge(int count) {
    return 'Encore $count HIBONs pour débloquer ce badge';
  }

  @override
  String get gamificationHibonsUnit => 'Hibons';

  @override
  String gamificationHibonsUntilNextRank(int count, String rankLabel) {
    return 'Plus que $count avant $rankLabel';
  }

  @override
  String get gamificationHibouExpressTitle => 'Hibou Express (24 h)';

  @override
  String get gamificationHibouExpressDescription =>
      'Messages illimités avec Petit Boo';

  @override
  String get gamificationHistoryTitle => 'Historique';

  @override
  String get gamificationHowToEarnTitle => 'Comment gagner des Hibons';

  @override
  String get gamificationInAppPurchasesComingSoon =>
      'Les achats In-App arrivent bientôt !';

  @override
  String get gamificationInsufficientHibons => 'Hibons insuffisants !';

  @override
  String gamificationLifetimeHibonsAccumulated(int count) {
    return '$count HIBONs cumulés';
  }

  @override
  String get gamificationLockedCountLabel => 'À débloquer';

  @override
  String get gamificationLuckyWheelTitle => 'Roue de la Fortune';

  @override
  String get gamificationMaxRankReached => 'Rang maximal atteint';

  @override
  String get gamificationMultiplierDescription =>
      'Gagnez plus de Hibons pendant 1h';

  @override
  String get gamificationMultiplierTitle => 'Multiplicateur x1.5 (1h)';

  @override
  String get gamificationMyBadgesTitle => 'Mes badges';

  @override
  String gamificationNewHibonsBalance(int balance) {
    return 'Nouveau solde : $balance Hibons';
  }

  @override
  String get gamificationNoTransactions => 'Aucune transaction';

  @override
  String gamificationPetitBooDailyBonus(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count messages Petit Boo / jour',
      one: '+1 message Petit Boo / jour',
    );
    return '$_temp0';
  }

  @override
  String get gamificationPillarCommunity => 'Communauté';

  @override
  String get gamificationPillarDiscovery => 'Découverte';

  @override
  String get gamificationPillarEngagement => 'Engagement';

  @override
  String get gamificationPillarOnboarding => 'Onboarding';

  @override
  String get gamificationPillarParticipation => 'Participation';

  @override
  String get gamificationProgressionTitle => 'Progression';

  @override
  String gamificationProgressThisWeek(int completed, int total) {
    return '$completed/$total cette semaine';
  }

  @override
  String gamificationProgressToday(int completed, int total) {
    return '$completed/$total aujourd\'hui';
  }

  @override
  String gamificationPurchaseCompleted(String itemName) {
    return 'Achat effectué : $itemName';
  }

  @override
  String get gamificationRankUpCongratsTitle => 'Bravo !';

  @override
  String gamificationRankUpNowRank(String rankLabel) {
    return 'Tu es maintenant $rankLabel !';
  }

  @override
  String gamificationRemainingLifetime(int count) {
    return '$count restant';
  }

  @override
  String get gamificationShopTitle => 'Boutique Hibons';

  @override
  String get gamificationStartingRank => 'Rang de départ';

  @override
  String get gamificationStreakShieldTitle => 'Bouclier de série';

  @override
  String get gamificationStreakShieldDescription =>
      'Protégez votre série pour 1 jour';

  @override
  String get gamificationTopCta => 'Top !';

  @override
  String get gamificationTotalCountLabel => 'Total';

  @override
  String get gamificationUnlockedCountLabel => 'Débloqués';

  @override
  String get gamificationWheelAlreadyUsedToday =>
      'Tu as déjà utilisé ta chance aujourd\'hui.';

  @override
  String get gamificationWheelLoseTitle => 'Pas de chance...';

  @override
  String get gamificationWheelSpinCta => 'Lancer';

  @override
  String get gamificationWheelWinTitle => 'Félicitations !';

  @override
  String get alertsListTitle => 'Mes alertes et recherches';

  @override
  String get alertsFilterAll => 'Toutes';

  @override
  String get alertsFilterAlerts => 'Alertes';

  @override
  String get alertsFilterSearches => 'Recherches';

  @override
  String get alertsLoadError => 'Impossible de charger vos alertes';

  @override
  String get alertsEmptyAllTitle => 'Aucune alerte pour le moment';

  @override
  String get alertsEmptyAllBody =>
      'Enregistrez vos recherches pour les retrouver ici et recevoir des notifications';

  @override
  String get alertsEmptyActiveTitle => 'Aucune alerte active';

  @override
  String get alertsEmptyActiveBody =>
      'Activez les notifications sur vos recherches pour être alerté des nouveaux événements';

  @override
  String get alertsEmptySearchesTitle => 'Aucune recherche enregistrée';

  @override
  String get alertsEmptySearchesBody =>
      'Vos recherches sans notification apparaîtront ici';

  @override
  String get alertsExploreActivities => 'Explorer les activités';

  @override
  String get alertsDeleteTitle => 'Supprimer l\'alerte';

  @override
  String get alertsDeleteBody =>
      'Voulez-vous vraiment supprimer cette recherche enregistrée ?';

  @override
  String alertsDeleted(String name) {
    return 'Alerte « $name » supprimée';
  }

  @override
  String alertsCreatedOn(String date) {
    return 'Créée le $date';
  }

  @override
  String get alertsAllEvents => 'Tous les événements';

  @override
  String get alertsUnnamed => 'Alerte sans nom';

  @override
  String get favoritesLoadError => 'Erreur de chargement';

  @override
  String get favoritesEmptyTitle => 'Aucun favori';

  @override
  String get favoritesEmptyBody =>
      'Ajoutez des événements à vos favoris en cliquant sur le cœur pour les retrouver facilement.';

  @override
  String get favoritesEmptyUncategorizedTitle => 'Aucun favori non classé';

  @override
  String get favoritesEmptyUncategorizedBody =>
      'Tous vos favoris sont organisés dans des listes.';

  @override
  String get favoritesEmptyListTitle => 'Cette liste est vide';

  @override
  String get favoritesEmptyListBody =>
      'Ajoutez des favoris à cette liste depuis le détail d\'un événement.';

  @override
  String get favoritesExploreEvents => 'Explorer les événements';

  @override
  String get favoriteListsTitle => 'Mes listes';

  @override
  String get favoriteListsLoadError => 'Erreur de chargement';

  @override
  String get favoriteListsAllFavorites => 'Tous les favoris';

  @override
  String get favoriteListsAllShort => 'Tous';

  @override
  String get favoriteListsUncategorized => 'Non classés';

  @override
  String get favoriteListsUncategorizedSingular => 'Non classé';

  @override
  String get favoriteListsSectionTitle => 'MES LISTES';

  @override
  String get favoriteListNewTitle => 'Nouvelle liste';

  @override
  String get favoriteListOrganizeSubtitle => 'Organisez vos favoris';

  @override
  String get favoriteListNameLabel => 'Nom de la liste';

  @override
  String get favoriteListNameHint => 'Ex. : Concerts à voir';

  @override
  String get favoriteListNameRequired => 'Veuillez entrer un nom';

  @override
  String get favoriteListNameMinLength =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get favoriteListNameMaxLength =>
      'Le nom ne peut pas dépasser 50 caractères';

  @override
  String get favoriteListDescriptionLabel => 'Description (optionnelle)';

  @override
  String get favoriteListDescriptionHint =>
      'Ex. : Mes événements musicaux préférés';

  @override
  String get favoriteListColorLabel => 'Couleur';

  @override
  String get favoriteListIconLabel => 'Icône';

  @override
  String get favoriteListCreateAction => 'Créer';

  @override
  String get favoriteListCreateError =>
      'Erreur lors de la création de la liste';

  @override
  String get favoriteListEditTitle => 'Modifier la liste';

  @override
  String favoriteListFavoritesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favoris',
      one: '1 favori',
      zero: '0 favori',
    );
    return '$_temp0';
  }

  @override
  String get favoriteListUpdateError => 'Erreur lors de la mise à jour';

  @override
  String get favoriteListDeleteTitle => 'Supprimer la liste ?';

  @override
  String favoriteListDeleteBody(String name) {
    return 'La liste « $name » sera supprimée.';
  }

  @override
  String get favoriteListDeleteMoveBody =>
      'Les événements favoris ne seront pas supprimés, ils seront déplacés dans « Non classés ».';

  @override
  String favoriteListDeleted(String name) {
    return 'Liste « $name » supprimée';
  }

  @override
  String get favoriteListDeleteError => 'Erreur lors de la suppression';

  @override
  String get favoriteListDeleteThisAction => 'Supprimer cette liste';

  @override
  String get favoriteListPickerMoveTitle => 'Déplacer vers...';

  @override
  String get favoriteListPickerAddTitle => 'Ajouter aux favoris';

  @override
  String get favoriteListPickerUncategorizedSubtitle => 'Favoris sans liste';

  @override
  String get favoriteListCreateSheetTitle => 'Créer une liste';

  @override
  String get favoriteListCreateSheetSubtitle =>
      'Nouvelle collection de favoris';

  @override
  String get favoriteListPickerRemoveTitle => 'Retirer des favoris';

  @override
  String get favoriteListPickerRemoveSubtitle =>
      'Supprimer de tous les favoris';

  @override
  String get favoriteAddError => 'Impossible d\'ajouter aux favoris';

  @override
  String get favoriteRemoveError => 'Impossible de retirer des favoris';

  @override
  String get favoriteUpdateError => 'Impossible de modifier le favori';

  @override
  String get favoriteMovedToList => 'Déplacé vers la liste';

  @override
  String get favoriteMovedToUncategorized => 'Déplacé vers « Non classés »';

  @override
  String get favoriteAddedToList => 'Ajouté à la liste';

  @override
  String get favoriteGenericError => 'Une erreur est survenue.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Tout marquer comme lu';

  @override
  String get notificationsFilterAll => 'Toutes';

  @override
  String get notificationsFilterUnread => 'Non lues';

  @override
  String get notificationsGuestTitle => 'Connectez-vous';

  @override
  String get notificationsGuestBody =>
      'Vos notifications apparaîtront ici après connexion.';

  @override
  String get notificationsReadSyncError => 'Lecture non synchronisée';

  @override
  String get notificationsMarkRead => 'Marquer comme lu';

  @override
  String get notificationsMarkReadError => 'Impossible de marquer comme lu';

  @override
  String get notificationsMarkedAllRead => 'Notifications marquées comme lues';

  @override
  String get notificationsActionError => 'Action impossible pour le moment';

  @override
  String get notificationsDeleted => 'Notification supprimée';

  @override
  String get notificationsDeleteError => 'Suppression impossible';

  @override
  String get notificationsDeleteTitle => 'Supprimer la notification';

  @override
  String get notificationsDeleteBody =>
      'Voulez-vous vraiment supprimer cette notification ?';

  @override
  String get notificationsJustNow => 'À l\'instant';

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
    return '$count j';
  }

  @override
  String get notificationsTypeMessage => 'Message';

  @override
  String get notificationsTypeBooking => 'Réservation';

  @override
  String get notificationsTypeTicket => 'Billet';

  @override
  String get notificationsTypeEvent => 'Événement';

  @override
  String get notificationsTypeReview => 'Avis';

  @override
  String get notificationsTypeQuestion => 'Question';

  @override
  String get notificationsTypeOrganization => 'Organisation';

  @override
  String get notificationsTypeInfo => 'Info';

  @override
  String get notificationsEmptyUnreadTitle => 'Aucune notification non lue';

  @override
  String get notificationsEmptyTitle => 'Aucune notification pour le moment';

  @override
  String get notificationsEmptyUnreadBody =>
      'Les nouvelles notifications apparaîtront ici.';

  @override
  String get notificationsEmptyBody =>
      'Vos messages, réservations et mises à jour importantes apparaîtront ici.';

  @override
  String get notificationsLoadError =>
      'Impossible de charger vos notifications';

  @override
  String get remindersTitle => 'Mes rappels';

  @override
  String get remindersUpcoming => 'À venir';

  @override
  String get remindersPast => 'Passés';

  @override
  String get remindersDeleteTitle => 'Supprimer le rappel ?';

  @override
  String remindersDeleteBody(String eventTitle, String date) {
    return 'Vous ne recevrez plus de notifications pour « $eventTitle » le $date.';
  }

  @override
  String get remindersDeleted => 'Rappel supprimé';

  @override
  String remindersDateFromTo(String date, String start, String end) {
    return '$date de $start à $end';
  }

  @override
  String remindersDateAtTime(String date, String start) {
    return '$date à $start';
  }

  @override
  String get remindersEmptyTitle => 'Aucun rappel';

  @override
  String get remindersEmptyBody =>
      'Activez des rappels sur les activités qui vous intéressent pour être notifié.';

  @override
  String get remindersLoadError => 'Impossible de charger vos rappels';

  @override
  String remindersDaysBeforeBadge(int count) {
    return 'J-$count';
  }

  @override
  String get onboardingExploreTitle => 'Sortez et expérimentez';

  @override
  String get onboardingExploreDescription =>
      'Ateliers, balades, spectacles enfants : trouvez l\'activité du week-end sans y passer votre soirée.';

  @override
  String get onboardingMusicTitle => 'Vibrez au rythme de votre ville';

  @override
  String get onboardingMusicDescription =>
      'Découvrez les concerts, festivals et soirées qui font bouger votre région. Ne ratez plus aucun événement musical.';

  @override
  String get onboardingLocalTitle => 'Restez connecté aux nouveautés du coin';

  @override
  String get onboardingLocalDescription =>
      'Marchés, lieux à découvrir : les bonnes adresses à deux pas de chez vous.';

  @override
  String get onboardingAssociationTitle => 'Membre d\'une asso ?';

  @override
  String get onboardingAssociationDescription =>
      'Accédez aux événements privés réservés à vos associations : sport, école, culture, loisirs. Tout au même endroit.';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingGetStarted => 'C\'est parti';

  @override
  String get thematiquesExploreByTypeTitle => 'Explorer par type d\'événement';

  @override
  String get thematiquesSeeAll => 'Voir tout';

  @override
  String thematiquesAllTypesCount(int count) {
    return 'Tous les types ($count)';
  }

  @override
  String get thematiquesSearchHint => 'Rechercher un type d\'événement...';

  @override
  String thematiquesEventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count événements',
      one: '1 événement',
      zero: '0 événement',
    );
    return '$_temp0';
  }

  @override
  String get categoriesAllTitle => 'Toutes les catégories';

  @override
  String get categoriesSeeAll => 'Voir toutes les catégories';

  @override
  String categoriesAllCount(int count) {
    return 'Toutes les catégories ($count)';
  }

  @override
  String get categoriesSearchHint => 'Rechercher une catégorie...';

  @override
  String get categoriesEmptySearch => 'Aucune catégorie trouvée';

  @override
  String get blogLatestTitle => 'Derniers articles';

  @override
  String get blogEmpty => 'Aucun article disponible';

  @override
  String blogReadingTimeMinutes(int minutes) {
    return '$minutes min';
  }
}
