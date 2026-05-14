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
  String get commonRestart => 'Redémarrer';

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
  String get settingsPushPermissionRequired =>
      'Autorisation notifications requise';

  @override
  String get settingsUpdateFailed => 'Mise à jour impossible';

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
  String get authPasswordMinLengthShort => 'Min. 8 caractères';

  @override
  String get authPasswordNeedsUppercaseShort => 'Une majuscule requise';

  @override
  String get authPasswordNeedsNumberShort => 'Un chiffre requis';

  @override
  String get authPasswordNeedsSpecialShort => 'Un caractère spécial requis';

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
}
