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
}
