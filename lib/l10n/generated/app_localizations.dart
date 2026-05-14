import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Application title.
  ///
  /// In fr, this message translates to:
  /// **'Le Hiboo'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get navExplore;

  /// No description provided for @navMap.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get navMap;

  /// No description provided for @navBookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get navBookings;

  /// No description provided for @guestFeatureBookings.
  ///
  /// In fr, this message translates to:
  /// **'consulter mes réservations'**
  String get guestFeatureBookings;

  /// No description provided for @guestFeaturePetitBoo.
  ///
  /// In fr, this message translates to:
  /// **'discuter avec Petit Boo'**
  String get guestFeaturePetitBoo;

  /// No description provided for @guestFeatureViewMessages.
  ///
  /// In fr, this message translates to:
  /// **'voir vos messages'**
  String get guestFeatureViewMessages;

  /// No description provided for @guestFeatureSendMessage.
  ///
  /// In fr, this message translates to:
  /// **'envoyer un message'**
  String get guestFeatureSendMessage;

  /// No description provided for @guestFeatureViewFavorites.
  ///
  /// In fr, this message translates to:
  /// **'voir vos favoris'**
  String get guestFeatureViewFavorites;

  /// No description provided for @guestFeatureViewNotifications.
  ///
  /// In fr, this message translates to:
  /// **'voir vos notifications'**
  String get guestFeatureViewNotifications;

  /// No description provided for @guestFeatureAccessProfile.
  ///
  /// In fr, this message translates to:
  /// **'accéder à votre profil'**
  String get guestFeatureAccessProfile;

  /// No description provided for @guestFeatureViewConversation.
  ///
  /// In fr, this message translates to:
  /// **'voir cette conversation'**
  String get guestFeatureViewConversation;

  /// No description provided for @guestFeatureManageFavorites.
  ///
  /// In fr, this message translates to:
  /// **'gérer les favoris'**
  String get guestFeatureManageFavorites;

  /// No description provided for @guestFeatureWriteReview.
  ///
  /// In fr, this message translates to:
  /// **'laisser un avis'**
  String get guestFeatureWriteReview;

  /// No description provided for @guestFeatureReportReview.
  ///
  /// In fr, this message translates to:
  /// **'signaler un avis'**
  String get guestFeatureReportReview;

  /// No description provided for @guestFeatureSaveSearch.
  ///
  /// In fr, this message translates to:
  /// **'sauvegarder une recherche'**
  String get guestFeatureSaveSearch;

  /// No description provided for @guestFeatureAskQuestion.
  ///
  /// In fr, this message translates to:
  /// **'poser une question'**
  String get guestFeatureAskQuestion;

  /// No description provided for @guestFeatureVoteQuestion.
  ///
  /// In fr, this message translates to:
  /// **'voter pour cette question'**
  String get guestFeatureVoteQuestion;

  /// No description provided for @guestFeatureJoinOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'rejoindre cet organisateur'**
  String get guestFeatureJoinOrganizer;

  /// No description provided for @guestFeatureFollowOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'suivre cet organisateur'**
  String get guestFeatureFollowOrganizer;

  /// No description provided for @guestFeatureContactOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'contacter un organisateur'**
  String get guestFeatureContactOrganizer;

  /// No description provided for @guestFeatureContactThisOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'contacter cet organisateur'**
  String get guestFeatureContactThisOrganizer;

  /// No description provided for @guestFeatureViewCoordinates.
  ///
  /// In fr, this message translates to:
  /// **'voir les coordonnées'**
  String get guestFeatureViewCoordinates;

  /// No description provided for @guestFeatureEnableReminder.
  ///
  /// In fr, this message translates to:
  /// **'activer un rappel'**
  String get guestFeatureEnableReminder;

  /// No description provided for @guestFeatureBookActivity.
  ///
  /// In fr, this message translates to:
  /// **'réserver une activité'**
  String get guestFeatureBookActivity;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsSectionApplication.
  ///
  /// In fr, this message translates to:
  /// **'Application'**
  String get settingsSectionApplication;

  /// No description provided for @settingsSectionLegal.
  ///
  /// In fr, this message translates to:
  /// **'Informations légales'**
  String get settingsSectionLegal;

  /// No description provided for @settingsSectionInformation.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get settingsSectionInformation;

  /// No description provided for @settingsPushReward.
  ///
  /// In fr, this message translates to:
  /// **'Active les notifications pour gagner 30 Hibons'**
  String get settingsPushReward;

  /// No description provided for @settingsPushTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications push'**
  String get settingsPushTitle;

  /// No description provided for @settingsPushSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir les alertes sur ton téléphone'**
  String get settingsPushSubtitle;

  /// No description provided for @settingsNewsletterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Newsletter'**
  String get settingsNewsletterTitle;

  /// No description provided for @settingsNewsletterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recommandations événements et bons plans par email'**
  String get settingsNewsletterSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la langue'**
  String get settingsLanguageDialogTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{language}'**
  String settingsLanguageSubtitle(String language);

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get languageEnglish;

  /// No description provided for @settingsResetOnboardingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Revoir l\'introduction'**
  String get settingsResetOnboardingTitle;

  /// No description provided for @settingsResetOnboardingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Redémarrer le tutoriel d\'accueil'**
  String get settingsResetOnboardingSubtitle;

  /// No description provided for @settingsVersionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsVersionTitle;

  /// No description provided for @settingsResetDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Redémarrer l\'onboarding ?'**
  String get settingsResetDialogTitle;

  /// No description provided for @settingsResetDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment revoir les écrans de bienvenue ? Cela vous déconnectera temporairement de l\'accueil.'**
  String get settingsResetDialogContent;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// No description provided for @commonRestart.
  ///
  /// In fr, this message translates to:
  /// **'Redémarrer'**
  String get commonRestart;

  /// No description provided for @commonToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get commonToday;

  /// No description provided for @commonTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain'**
  String get commonTomorrow;

  /// No description provided for @commonYesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get commonYesterday;

  /// No description provided for @commonThisWeekend.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end'**
  String get commonThisWeekend;

  /// No description provided for @commonFree.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get commonFree;

  /// No description provided for @commonUndefinedDate.
  ///
  /// In fr, this message translates to:
  /// **'Date non définie'**
  String get commonUndefinedDate;

  /// No description provided for @settingsPushPermissionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Autorisation notifications requise'**
  String get settingsPushPermissionRequired;

  /// No description provided for @settingsUpdateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour impossible'**
  String get settingsUpdateFailed;

  /// No description provided for @legalTerms.
  ///
  /// In fr, this message translates to:
  /// **'Conditions Générales d\'Utilisation'**
  String get legalTerms;

  /// No description provided for @legalSales.
  ///
  /// In fr, this message translates to:
  /// **'Conditions Générales de Vente'**
  String get legalSales;

  /// No description provided for @legalPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get legalPrivacy;

  /// No description provided for @legalCookies.
  ///
  /// In fr, this message translates to:
  /// **'Politique cookies'**
  String get legalCookies;

  /// No description provided for @legalNotices.
  ///
  /// In fr, this message translates to:
  /// **'Mentions légales'**
  String get legalNotices;

  /// No description provided for @legalOpenFailed.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture impossible : {documentLabel}'**
  String legalOpenFailed(String documentLabel);

  /// No description provided for @voiceTooltipHoldToTalk.
  ///
  /// In fr, this message translates to:
  /// **'Maintiens pour parler'**
  String get voiceTooltipHoldToTalk;

  /// No description provided for @voiceMicrophoneError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur micro : {message}'**
  String voiceMicrophoneError(String message);

  /// No description provided for @voiceAllowMicrophoneSettings.
  ///
  /// In fr, this message translates to:
  /// **'Autorise le micro dans Réglages'**
  String get voiceAllowMicrophoneSettings;

  /// No description provided for @voiceAllowSpeechSettings.
  ///
  /// In fr, this message translates to:
  /// **'Autorise la reconnaissance vocale dans Réglages'**
  String get voiceAllowSpeechSettings;

  /// No description provided for @voiceMicrophoneUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le micro n\'est pas disponible'**
  String get voiceMicrophoneUnavailable;

  /// No description provided for @voiceNothingHeard.
  ///
  /// In fr, this message translates to:
  /// **'Je n\'ai rien entendu'**
  String get voiceNothingHeard;

  /// No description provided for @petitBooChatHintListening.
  ///
  /// In fr, this message translates to:
  /// **'Je vous écoute...'**
  String get petitBooChatHintListening;

  /// No description provided for @petitBooChatHintStreaming.
  ///
  /// In fr, this message translates to:
  /// **'Petit Boo réfléchit...'**
  String get petitBooChatHintStreaming;

  /// No description provided for @petitBooChatHintIdle.
  ///
  /// In fr, this message translates to:
  /// **'Posez une question à votre assistant ou tapez / pour les commandes...'**
  String get petitBooChatHintIdle;

  /// No description provided for @petitBooDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'L\'IA peut commettre des erreurs. Vérifiez les informations importantes.'**
  String get petitBooDisclaimer;

  /// No description provided for @bookingTicketSingular.
  ///
  /// In fr, this message translates to:
  /// **'1 billet'**
  String get bookingTicketSingular;

  /// No description provided for @bookingTicketPlural.
  ///
  /// In fr, this message translates to:
  /// **'{count} billets'**
  String bookingTicketPlural(int count);

  /// No description provided for @bookingLifecycleCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get bookingLifecycleCancelled;

  /// No description provided for @bookingLifecyclePast.
  ///
  /// In fr, this message translates to:
  /// **'Passé'**
  String get bookingLifecyclePast;

  /// No description provided for @bookingLifecycleUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get bookingLifecycleUpcoming;

  /// No description provided for @broadcastSentOn.
  ///
  /// In fr, this message translates to:
  /// **'Envoyée le {date}'**
  String broadcastSentOn(String date);

  /// No description provided for @broadcastCreatedOn.
  ///
  /// In fr, this message translates to:
  /// **'Créée le {date}'**
  String broadcastCreatedOn(String date);

  /// No description provided for @adminReportReviewedBy.
  ///
  /// In fr, this message translates to:
  /// **'Traité par {name}'**
  String adminReportReviewedBy(Object name);

  /// No description provided for @adminReportReviewedByOn.
  ///
  /// In fr, this message translates to:
  /// **'Traité par {name} le {date}'**
  String adminReportReviewedByOn(Object date, Object name);

  /// No description provided for @membershipMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get membershipMember;

  /// No description provided for @membershipMemberSince.
  ///
  /// In fr, this message translates to:
  /// **'Membre depuis le {date}'**
  String membershipMemberSince(Object date);

  /// No description provided for @membershipRequestSent.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée'**
  String get membershipRequestSent;

  /// No description provided for @membershipRequestSentOn.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée le {date}'**
  String membershipRequestSentOn(Object date);

  /// No description provided for @membershipRequestRejected.
  ///
  /// In fr, this message translates to:
  /// **'Demande non acceptée'**
  String get membershipRequestRejected;

  /// No description provided for @membershipRequestRejectedOn.
  ///
  /// In fr, this message translates to:
  /// **'Demande du {date} - non acceptée'**
  String membershipRequestRejectedOn(Object date);

  /// No description provided for @authEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'votre@email.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'••••••••'**
  String get authPasswordHint;

  /// No description provided for @authEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre email'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un email valide'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get authPasswordRequired;

  /// No description provided for @authEmailRequiredShort.
  ///
  /// In fr, this message translates to:
  /// **'Email requis'**
  String get authEmailRequiredShort;

  /// No description provided for @authEmailInvalidShort.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get authEmailInvalidShort;

  /// No description provided for @authPasswordRequiredShort.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe requis'**
  String get authPasswordRequiredShort;

  /// No description provided for @authLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Le Hiboo !'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour découvrir les événements près de chez vous'**
  String get authLoginSubtitle;

  /// No description provided for @authForgotPasswordLink.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPasswordLink;

  /// No description provided for @authLoginSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginSubmit;

  /// No description provided for @authLoginNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authLoginNoAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authCreateAccount;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In fr, this message translates to:
  /// **'Continuer sans compte'**
  String get authContinueAsGuest;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authForgotPasswordSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get authForgotPasswordSubmit;

  /// No description provided for @authBackToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get authBackToLogin;

  /// No description provided for @authForgotPasswordSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Email envoyé !'**
  String get authForgotPasswordSuccessTitle;

  /// No description provided for @authForgotPasswordSuccessPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Nous avons envoyé un lien de réinitialisation à'**
  String get authForgotPasswordSuccessPrefix;

  /// No description provided for @authForgotPasswordSuccessInfo.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre boîte de réception et vos spams. Le lien expire dans 1 heure.'**
  String get authForgotPasswordSuccessInfo;

  /// No description provided for @authForgotPasswordResend.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer l\'email'**
  String get authForgotPasswordResend;

  /// No description provided for @authOtpIncompleteCode.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer le code complet'**
  String get authOtpIncompleteCode;

  /// No description provided for @authOtpResent.
  ///
  /// In fr, this message translates to:
  /// **'Un nouveau code a été envoyé'**
  String get authOtpResent;

  /// No description provided for @authOtpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification email'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code à 6 chiffres envoyé à'**
  String get authOtpSubtitle;

  /// No description provided for @authOtpVerify.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get authOtpVerify;

  /// No description provided for @authOtpNotReceived.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas reçu le code ?'**
  String get authOtpNotReceived;

  /// No description provided for @authOtpResendIn.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer dans {seconds}s'**
  String authOtpResendIn(int seconds);

  /// No description provided for @authOtpResend.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer'**
  String get authOtpResend;

  /// No description provided for @authGuestIncorrectCredentials.
  ///
  /// In fr, this message translates to:
  /// **'Identifiants incorrects. Réessayez.'**
  String get authGuestIncorrectCredentials;

  /// No description provided for @authGuestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous !'**
  String get authGuestTitle;

  /// No description provided for @authGuestSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour {featureName}.'**
  String authGuestSubtitle(String featureName);

  /// No description provided for @authGuestEncouragement.
  ///
  /// In fr, this message translates to:
  /// **'Cela ne prend que 2 minutes et c\'est gratuit !'**
  String get authGuestEncouragement;

  /// No description provided for @authRegisterTypeEyebrow.
  ///
  /// In fr, this message translates to:
  /// **'TYPE DE COMPTE'**
  String get authRegisterTypeEyebrow;

  /// No description provided for @authRegisterTypeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes...'**
  String get authRegisterTypeTitle;

  /// No description provided for @authRegisterTypeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez votre profil pour personnaliser votre expérience'**
  String get authRegisterTypeSubtitle;

  /// No description provided for @authRegisterTypeCustomerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un particulier'**
  String get authRegisterTypeCustomerTitle;

  /// No description provided for @authRegisterTypeCustomerDescription.
  ///
  /// In fr, this message translates to:
  /// **'Je réserve des activités pour moi ou mes proches.'**
  String get authRegisterTypeCustomerDescription;

  /// No description provided for @authRegisterTypeBusinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une organisation'**
  String get authRegisterTypeBusinessTitle;

  /// No description provided for @authRegisterTypeBusinessDescription.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise, association ou collectivité - je réserve pour mon équipe.'**
  String get authRegisterTypeBusinessDescription;

  /// No description provided for @authRegisterTypeComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get authRegisterTypeComingSoon;

  /// No description provided for @authRegisterCreateMyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get authRegisterCreateMyAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authRegisterLegacySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez LeHiboo pour ne rien manquer'**
  String get authRegisterLegacySubtitle;

  /// No description provided for @authFirstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get authFirstNameLabel;

  /// No description provided for @authFirstNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Jean'**
  String get authFirstNameHint;

  /// No description provided for @authLastNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get authLastNameLabel;

  /// No description provided for @authLastNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Dupont'**
  String get authLastNameHint;

  /// No description provided for @authRequired.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get authRequired;

  /// No description provided for @authPasswordMinimumHint.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 8 caractères'**
  String get authPasswordMinimumHint;

  /// No description provided for @authPasswordCreateRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un mot de passe'**
  String get authPasswordCreateRequired;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères'**
  String get authPasswordMinLength;

  /// No description provided for @authPasswordNeedsUppercase.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir une majuscule'**
  String get authPasswordNeedsUppercase;

  /// No description provided for @authPasswordNeedsNumber.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir un chiffre'**
  String get authPasswordNeedsNumber;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Retapez votre mot de passe'**
  String get authConfirmPasswordHint;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez confirmer votre mot de passe'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authAcceptTermsRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez accepter les conditions d\'utilisation'**
  String get authAcceptTermsRequired;

  /// No description provided for @authRegisterTermsPrefix.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les '**
  String get authRegisterTermsPrefix;

  /// No description provided for @authRegisterTermsConnector.
  ///
  /// In fr, this message translates to:
  /// **' et la '**
  String get authRegisterTermsConnector;

  /// No description provided for @authPermissionReassurance.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez changer cet accès à tout moment dans les réglages.'**
  String get authPermissionReassurance;

  /// No description provided for @authPermissionLocationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez des sorties près de vous'**
  String get authPermissionLocationTitle;

  /// No description provided for @authPermissionLocationIntro.
  ///
  /// In fr, this message translates to:
  /// **'LeHiboo Experiences utilise votre position pour vous suggérer les meilleurs événements à proximité.'**
  String get authPermissionLocationIntro;

  /// No description provided for @authPermissionLocationBulletMap.
  ///
  /// In fr, this message translates to:
  /// **'Voir les événements à proximité sur la carte'**
  String get authPermissionLocationBulletMap;

  /// No description provided for @authPermissionLocationBulletSearch.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer la recherche selon votre position'**
  String get authPermissionLocationBulletSearch;

  /// No description provided for @authPermissionLocationBulletSuggestions.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir des suggestions adaptées à votre ville'**
  String get authPermissionLocationBulletSuggestions;

  /// No description provided for @authPermissionLocationGranted.
  ///
  /// In fr, this message translates to:
  /// **'Localisation déjà activée'**
  String get authPermissionLocationGranted;

  /// No description provided for @authPermissionAudioTitle.
  ///
  /// In fr, this message translates to:
  /// **'Discutez en vocal avec Petit Boo'**
  String get authPermissionAudioTitle;

  /// No description provided for @authPermissionAudioIntro.
  ///
  /// In fr, this message translates to:
  /// **'Activez le micro pour interagir à la voix avec Petit Boo, notre assistant IA dédié aux sorties.'**
  String get authPermissionAudioIntro;

  /// No description provided for @authPermissionAudioBulletQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Posez vos questions à la voix, sans clavier'**
  String get authPermissionAudioBulletQuestions;

  /// No description provided for @authPermissionAudioBulletDictate.
  ///
  /// In fr, this message translates to:
  /// **'Dictez vos messages plus rapidement'**
  String get authPermissionAudioBulletDictate;

  /// No description provided for @authPermissionAudioBulletHandsFree.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez des sorties les mains libres'**
  String get authPermissionAudioBulletHandsFree;

  /// No description provided for @authPermissionAudioGranted.
  ///
  /// In fr, this message translates to:
  /// **'Micro déjà activé'**
  String get authPermissionAudioGranted;

  /// No description provided for @authPermissionNotificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ne ratez rien des bons plans'**
  String get authPermissionNotificationsTitle;

  /// No description provided for @authPermissionNotificationsIntro.
  ///
  /// In fr, this message translates to:
  /// **'Activez les notifications pour recevoir l\'essentiel directement sur votre téléphone.'**
  String get authPermissionNotificationsIntro;

  /// No description provided for @authPermissionNotificationsBulletTickets.
  ///
  /// In fr, this message translates to:
  /// **'Vos billets et confirmations de réservation'**
  String get authPermissionNotificationsBulletTickets;

  /// No description provided for @authPermissionNotificationsBulletAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Les événements qui matchent vos alertes'**
  String get authPermissionNotificationsBulletAlerts;

  /// No description provided for @authPermissionNotificationsBulletFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Les nouveautés de vos lieux favoris'**
  String get authPermissionNotificationsBulletFavorites;

  /// No description provided for @authPermissionNotificationsBulletReminders.
  ///
  /// In fr, this message translates to:
  /// **'Vos rappels et alertes personnalisées'**
  String get authPermissionNotificationsBulletReminders;

  /// No description provided for @authPermissionNotificationsBulletMessages.
  ///
  /// In fr, this message translates to:
  /// **'Les réponses des organisateurs à vos messages'**
  String get authPermissionNotificationsBulletMessages;

  /// No description provided for @authPermissionNotificationsGranted.
  ///
  /// In fr, this message translates to:
  /// **'Notifications déjà activées'**
  String get authPermissionNotificationsGranted;

  /// No description provided for @authEmailAddressInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une adresse email valide'**
  String get authEmailAddressInvalid;

  /// No description provided for @authOtpEmailVerified.
  ///
  /// In fr, this message translates to:
  /// **'Email vérifié !'**
  String get authOtpEmailVerified;

  /// No description provided for @authRegisterMissingVerificationToken.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : token de vérification manquant. Veuillez recommencer.'**
  String get authRegisterMissingVerificationToken;

  /// No description provided for @authCustomerAccountCreated.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé avec succès !'**
  String get authCustomerAccountCreated;

  /// No description provided for @authCustomerEmailSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Commencez par vérifier votre adresse email'**
  String get authCustomerEmailSubtitle;

  /// No description provided for @authReceiveCode.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir le code'**
  String get authReceiveCode;

  /// No description provided for @authCreateBusinessAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte professionnel'**
  String get authCreateBusinessAccount;

  /// No description provided for @authVerificationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification'**
  String get authVerificationTitle;

  /// No description provided for @authEditEmail.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'email'**
  String get authEditEmail;

  /// No description provided for @authYourInformationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos informations'**
  String get authYourInformationTitle;

  /// No description provided for @authPhoneOptionalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone (optionnel)'**
  String get authPhoneOptionalLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'06 12 34 56 78'**
  String get authPhoneHint;

  /// No description provided for @authPhoneInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone invalide'**
  String get authPhoneInvalid;

  /// No description provided for @authBirthDateLabelOptional.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance (optionnel)'**
  String get authBirthDateLabelOptional;

  /// No description provided for @authBirthDateHelp.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get authBirthDateHelp;

  /// No description provided for @authDateHint.
  ///
  /// In fr, this message translates to:
  /// **'JJ/MM/AAAA'**
  String get authDateHint;

  /// No description provided for @authCityOptionalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ville (optionnel)'**
  String get authCityOptionalLabel;

  /// No description provided for @authCityHint.
  ///
  /// In fr, this message translates to:
  /// **'Lyon, Paris...'**
  String get authCityHint;

  /// No description provided for @authMarketingOptIn.
  ///
  /// In fr, this message translates to:
  /// **'Je souhaite recevoir les actualités et offres du Hiboo par e-mail.'**
  String get authMarketingOptIn;

  /// No description provided for @authStepEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get authStepEmail;

  /// No description provided for @authStepCode.
  ///
  /// In fr, this message translates to:
  /// **'Code'**
  String get authStepCode;

  /// No description provided for @authStepInfo.
  ///
  /// In fr, this message translates to:
  /// **'Infos'**
  String get authStepInfo;

  /// No description provided for @authProfessionalEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email professionnel'**
  String get authProfessionalEmailLabel;

  /// No description provided for @authProfessionalEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'votre@entreprise.com'**
  String get authProfessionalEmailHint;

  /// No description provided for @authValidationMin2Chars.
  ///
  /// In fr, this message translates to:
  /// **'Min. 2 caractères'**
  String get authValidationMin2Chars;

  /// No description provided for @authValidationMin5Chars.
  ///
  /// In fr, this message translates to:
  /// **'Min. 5 caractères'**
  String get authValidationMin5Chars;

  /// No description provided for @authPasswordMinLengthShort.
  ///
  /// In fr, this message translates to:
  /// **'Min. 8 caractères'**
  String get authPasswordMinLengthShort;

  /// No description provided for @authPasswordNeedsUppercaseShort.
  ///
  /// In fr, this message translates to:
  /// **'Une majuscule requise'**
  String get authPasswordNeedsUppercaseShort;

  /// No description provided for @authPasswordNeedsNumberShort.
  ///
  /// In fr, this message translates to:
  /// **'Un chiffre requis'**
  String get authPasswordNeedsNumberShort;

  /// No description provided for @authPasswordNeedsSpecialShort.
  ///
  /// In fr, this message translates to:
  /// **'Un caractère spécial requis'**
  String get authPasswordNeedsSpecialShort;

  /// No description provided for @authPasswordStrengthWeak.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get authPasswordStrengthWeak;

  /// No description provided for @authPasswordStrengthFair.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get authPasswordStrengthFair;

  /// No description provided for @authPasswordStrengthGood.
  ///
  /// In fr, this message translates to:
  /// **'Bon'**
  String get authPasswordStrengthGood;

  /// No description provided for @authPasswordStrengthStrong.
  ///
  /// In fr, this message translates to:
  /// **'Fort'**
  String get authPasswordStrengthStrong;

  /// No description provided for @authPasswordRequirementMin8.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères'**
  String get authPasswordRequirementMin8;

  /// No description provided for @authPasswordRequirementUppercase.
  ///
  /// In fr, this message translates to:
  /// **'Une lettre majuscule'**
  String get authPasswordRequirementUppercase;

  /// No description provided for @authPasswordRequirementNumber.
  ///
  /// In fr, this message translates to:
  /// **'Un chiffre'**
  String get authPasswordRequirementNumber;

  /// No description provided for @authPasswordRequirementSpecial.
  ///
  /// In fr, this message translates to:
  /// **'Un caractère spécial'**
  String get authPasswordRequirementSpecial;

  /// No description provided for @authBusinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte Professionnel'**
  String get authBusinessTitle;

  /// No description provided for @authBusinessCancelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler l\'inscription ?'**
  String get authBusinessCancelTitle;

  /// No description provided for @authBusinessCancelContent.
  ///
  /// In fr, this message translates to:
  /// **'Votre progression sera perdue.'**
  String get authBusinessCancelContent;

  /// No description provided for @authBusinessSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription réussie !'**
  String get authBusinessSuccessTitle;

  /// No description provided for @authBusinessSuccessMessageWithOrg.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte professionnel pour \"{organizationName}\" a été créé avec succès.'**
  String authBusinessSuccessMessageWithOrg(String organizationName);

  /// No description provided for @authBusinessSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte professionnel a été créé avec succès.'**
  String get authBusinessSuccessMessage;

  /// No description provided for @authBusinessSuccessAccess.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez maintenant accéder à toutes les fonctionnalités de LeHiboo.'**
  String get authBusinessSuccessAccess;

  /// No description provided for @authStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get authStart;

  /// No description provided for @authBusinessStepInfo.
  ///
  /// In fr, this message translates to:
  /// **'Infos'**
  String get authBusinessStepInfo;

  /// No description provided for @authBusinessStepVerification.
  ///
  /// In fr, this message translates to:
  /// **'Vérif.'**
  String get authBusinessStepVerification;

  /// No description provided for @authBusinessStepCompany.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get authBusinessStepCompany;

  /// No description provided for @authBusinessStepUsage.
  ///
  /// In fr, this message translates to:
  /// **'Usage'**
  String get authBusinessStepUsage;

  /// No description provided for @authBusinessStepTerms.
  ///
  /// In fr, this message translates to:
  /// **'Termes'**
  String get authBusinessStepTerms;

  /// No description provided for @authPersonalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get authPersonalInfoTitle;

  /// No description provided for @authPersonalInfoSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ces informations seront utilisées pour créer votre compte'**
  String get authPersonalInfoSubtitle;

  /// No description provided for @authOrganizationCompanyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get authOrganizationCompanyLabel;

  /// No description provided for @authOrganizationAssociationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Association'**
  String get authOrganizationAssociationLabel;

  /// No description provided for @authOrganizationMunicipalityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Collectivité'**
  String get authOrganizationMunicipalityLabel;

  /// No description provided for @authOrganizationCompanyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Société, TPE, PME, startup...'**
  String get authOrganizationCompanyDescription;

  /// No description provided for @authOrganizationAssociationDescription.
  ///
  /// In fr, this message translates to:
  /// **'Loi 1901, fondation...'**
  String get authOrganizationAssociationDescription;

  /// No description provided for @authOrganizationMunicipalityDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mairie, département, région...'**
  String get authOrganizationMunicipalityDescription;

  /// No description provided for @authOrganizationCompanyLower.
  ///
  /// In fr, this message translates to:
  /// **'entreprise'**
  String get authOrganizationCompanyLower;

  /// No description provided for @authOrganizationAssociationLower.
  ///
  /// In fr, this message translates to:
  /// **'association'**
  String get authOrganizationAssociationLower;

  /// No description provided for @authOrganizationMunicipalityLower.
  ///
  /// In fr, this message translates to:
  /// **'collectivité'**
  String get authOrganizationMunicipalityLower;

  /// No description provided for @authOrganizationCompanyArticle.
  ///
  /// In fr, this message translates to:
  /// **'l\'entreprise'**
  String get authOrganizationCompanyArticle;

  /// No description provided for @authOrganizationAssociationArticle.
  ///
  /// In fr, this message translates to:
  /// **'l\'association'**
  String get authOrganizationAssociationArticle;

  /// No description provided for @authOrganizationMunicipalityArticle.
  ///
  /// In fr, this message translates to:
  /// **'la collectivité'**
  String get authOrganizationMunicipalityArticle;

  /// No description provided for @authOrganizationCompanyPossessive.
  ///
  /// In fr, this message translates to:
  /// **'votre entreprise'**
  String get authOrganizationCompanyPossessive;

  /// No description provided for @authOrganizationAssociationPossessive.
  ///
  /// In fr, this message translates to:
  /// **'votre association'**
  String get authOrganizationAssociationPossessive;

  /// No description provided for @authOrganizationMunicipalityPossessive.
  ///
  /// In fr, this message translates to:
  /// **'votre collectivité'**
  String get authOrganizationMunicipalityPossessive;

  /// No description provided for @authBusinessCompanyInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations de {organizationArticle}'**
  String authBusinessCompanyInfoTitle(String organizationArticle);

  /// No description provided for @authBusinessCompanyInfoSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ces informations permettront d\'identifier {organizationPossessive}'**
  String authBusinessCompanyInfoSubtitle(String organizationPossessive);

  /// No description provided for @authOrganizationTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'organisation'**
  String get authOrganizationTypeLabel;

  /// No description provided for @authOrganizationNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de {organizationArticle}'**
  String authOrganizationNameLabel(String organizationArticle);

  /// No description provided for @authCompanyNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ma Société SAS'**
  String get authCompanyNameHint;

  /// No description provided for @authOptionalSuffix.
  ///
  /// In fr, this message translates to:
  /// **'(optionnel)'**
  String get authOptionalSuffix;

  /// No description provided for @authSiretInvalid.
  ///
  /// In fr, this message translates to:
  /// **'SIRET invalide'**
  String get authSiretInvalid;

  /// No description provided for @authSiretHelp.
  ///
  /// In fr, this message translates to:
  /// **'14 chiffres, sans espaces'**
  String get authSiretHelp;

  /// No description provided for @authIndustryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Secteur d\'activité'**
  String get authIndustryLabel;

  /// No description provided for @authSelectHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner'**
  String get authSelectHint;

  /// No description provided for @authEmployeeCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Effectif'**
  String get authEmployeeCountLabel;

  /// No description provided for @authBillingAddressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse de facturation'**
  String get authBillingAddressLabel;

  /// No description provided for @authBillingAddressHint.
  ///
  /// In fr, this message translates to:
  /// **'123 rue de la Paix'**
  String get authBillingAddressHint;

  /// No description provided for @authPostalCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code postal'**
  String get authPostalCodeLabel;

  /// No description provided for @authPostalCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'75001'**
  String get authPostalCodeHint;

  /// No description provided for @authCityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get authCityLabel;

  /// No description provided for @authCityFieldHint.
  ///
  /// In fr, this message translates to:
  /// **'Paris'**
  String get authCityFieldHint;

  /// No description provided for @authCountryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get authCountryLabel;

  /// No description provided for @authCountryHint.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get authCountryHint;

  /// No description provided for @authLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get authLoading;

  /// No description provided for @authIndustryTechnology.
  ///
  /// In fr, this message translates to:
  /// **'Technologie'**
  String get authIndustryTechnology;

  /// No description provided for @authIndustryFinance.
  ///
  /// In fr, this message translates to:
  /// **'Finance'**
  String get authIndustryFinance;

  /// No description provided for @authIndustryHealth.
  ///
  /// In fr, this message translates to:
  /// **'Santé'**
  String get authIndustryHealth;

  /// No description provided for @authIndustryEducation.
  ///
  /// In fr, this message translates to:
  /// **'Éducation'**
  String get authIndustryEducation;

  /// No description provided for @authIndustryCommerce.
  ///
  /// In fr, this message translates to:
  /// **'Commerce'**
  String get authIndustryCommerce;

  /// No description provided for @authIndustryServices.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get authIndustryServices;

  /// No description provided for @authIndustryIndustry.
  ///
  /// In fr, this message translates to:
  /// **'Industrie'**
  String get authIndustryIndustry;

  /// No description provided for @authIndustryTransport.
  ///
  /// In fr, this message translates to:
  /// **'Transport'**
  String get authIndustryTransport;

  /// No description provided for @authIndustryRealEstate.
  ///
  /// In fr, this message translates to:
  /// **'Immobilier'**
  String get authIndustryRealEstate;

  /// No description provided for @authIndustryOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get authIndustryOther;

  /// No description provided for @authCountryFrance.
  ///
  /// In fr, this message translates to:
  /// **'France'**
  String get authCountryFrance;

  /// No description provided for @authCountryBelgium.
  ///
  /// In fr, this message translates to:
  /// **'Belgique'**
  String get authCountryBelgium;

  /// No description provided for @authCountrySwitzerland.
  ///
  /// In fr, this message translates to:
  /// **'Suisse'**
  String get authCountrySwitzerland;

  /// No description provided for @authCountryLuxembourg.
  ///
  /// In fr, this message translates to:
  /// **'Luxembourg'**
  String get authCountryLuxembourg;

  /// No description provided for @authCountryMonaco.
  ///
  /// In fr, this message translates to:
  /// **'Monaco'**
  String get authCountryMonaco;

  /// No description provided for @authCountryGermany.
  ///
  /// In fr, this message translates to:
  /// **'Allemagne'**
  String get authCountryGermany;

  /// No description provided for @authCountrySpain.
  ///
  /// In fr, this message translates to:
  /// **'Espagne'**
  String get authCountrySpain;

  /// No description provided for @authCountryItaly.
  ///
  /// In fr, this message translates to:
  /// **'Italie'**
  String get authCountryItaly;

  /// No description provided for @authCountryNetherlands.
  ///
  /// In fr, this message translates to:
  /// **'Pays-Bas'**
  String get authCountryNetherlands;

  /// No description provided for @authCountryUnitedKingdom.
  ///
  /// In fr, this message translates to:
  /// **'Royaume-Uni'**
  String get authCountryUnitedKingdom;

  /// No description provided for @authCountryOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get authCountryOther;

  /// No description provided for @authCompanySearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche rapide'**
  String get authCompanySearchTitle;

  /// No description provided for @authCompanySearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher {organizationPossessive} par nom...'**
  String authCompanySearchHint(String organizationPossessive);

  /// No description provided for @authCompanySearchHelper.
  ///
  /// In fr, this message translates to:
  /// **'Recherchez {organizationPossessive} pour remplir automatiquement le formulaire'**
  String authCompanySearchHelper(String organizationPossessive);

  /// No description provided for @authSiretLine.
  ///
  /// In fr, this message translates to:
  /// **'SIRET : {siret}'**
  String authSiretLine(String siret);

  /// No description provided for @authUsageModeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode d\'utilisation'**
  String get authUsageModeTitle;

  /// No description provided for @authUsageModeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment comptez-vous utiliser LeHiboo ?'**
  String get authUsageModeSubtitle;

  /// No description provided for @authUsageModePersonalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Utilisation personnelle'**
  String get authUsageModePersonalLabel;

  /// No description provided for @authUsageModePersonalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Je suis le seul à utiliser le compte'**
  String get authUsageModePersonalDescription;

  /// No description provided for @authUsageModeTeamLabel.
  ///
  /// In fr, this message translates to:
  /// **'Équipe'**
  String get authUsageModeTeamLabel;

  /// No description provided for @authUsageModeTeamDescription.
  ///
  /// In fr, this message translates to:
  /// **'Plusieurs personnes utiliseront le compte'**
  String get authUsageModeTeamDescription;

  /// No description provided for @authTeamEmailsLabelOptional.
  ///
  /// In fr, this message translates to:
  /// **'Emails des collaborateurs (optionnel)'**
  String get authTeamEmailsLabelOptional;

  /// No description provided for @authTeamEmailsHint.
  ///
  /// In fr, this message translates to:
  /// **'email1@exemple.com, email2@exemple.com'**
  String get authTeamEmailsHint;

  /// No description provided for @authTeamEmailsHelper.
  ///
  /// In fr, this message translates to:
  /// **'Séparez les emails par des virgules'**
  String get authTeamEmailsHelper;

  /// No description provided for @authInvalidEmailWithValue.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide : {email}'**
  String authInvalidEmailWithValue(String email);

  /// No description provided for @authDefaultMonthlyBudgetLabelOptional.
  ///
  /// In fr, this message translates to:
  /// **'Budget mensuel par défaut (optionnel)'**
  String get authDefaultMonthlyBudgetLabelOptional;

  /// No description provided for @authAmountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un montant valide'**
  String get authAmountInvalid;

  /// No description provided for @authTermsFinalizationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Finalisation'**
  String get authTermsFinalizationTitle;

  /// No description provided for @authTermsFinalizationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez vos informations et acceptez les conditions'**
  String get authTermsFinalizationSubtitle;

  /// No description provided for @authTermsSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get authTermsSummaryTitle;

  /// No description provided for @authTermsSummaryPersonal.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get authTermsSummaryPersonal;

  /// No description provided for @authTermsSummaryOrganization.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get authTermsSummaryOrganization;

  /// No description provided for @authTermsSummaryUsage.
  ///
  /// In fr, this message translates to:
  /// **'Utilisation'**
  String get authTermsSummaryUsage;

  /// No description provided for @authTermsBudgetLine.
  ///
  /// In fr, this message translates to:
  /// **'Budget : {budget} EUR/mois'**
  String authTermsBudgetLine(String budget);

  /// No description provided for @authTermsInvitationsLine.
  ///
  /// In fr, this message translates to:
  /// **'Invitations : {count} collaborateurs'**
  String authTermsInvitationsLine(int count);

  /// No description provided for @authBusinessTermsLabel.
  ///
  /// In fr, this message translates to:
  /// **'conditions spécifiques aux comptes professionnels'**
  String get authBusinessTermsLabel;

  /// No description provided for @authCreateBusinessAccountButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte business'**
  String get authCreateBusinessAccountButton;

  /// No description provided for @authBusinessTermsHelper.
  ///
  /// In fr, this message translates to:
  /// **'En créant un compte, vous confirmez que les informations fournies sont exactes et que vous êtes autorisé à représenter cette organisation.'**
  String get authBusinessTermsHelper;

  /// No description provided for @homeTooltipNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get homeTooltipNotifications;

  /// No description provided for @homeTooltipCart.
  ///
  /// In fr, this message translates to:
  /// **'Mon panier'**
  String get homeTooltipCart;

  /// No description provided for @homeTooltipAccount.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get homeTooltipAccount;

  /// No description provided for @homeViewMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus'**
  String get homeViewMore;

  /// No description provided for @homeViewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get homeViewAll;

  /// No description provided for @homeNewActivitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés'**
  String get homeNewActivitiesTitle;

  /// No description provided for @homeNoNewActivities.
  ///
  /// In fr, this message translates to:
  /// **'Aucune nouveauté trouvée.'**
  String get homeNoNewActivities;

  /// No description provided for @homeNearbyAvailableTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités disponibles à proximité'**
  String get homeNearbyAvailableTitle;

  /// No description provided for @homeWebCtaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez vos événements en toute simplicité'**
  String get homeWebCtaTitle;

  /// No description provided for @homeWebCtaBody.
  ///
  /// In fr, this message translates to:
  /// **'Notre site web offre une expérience complète pour découvrir et réserver vos activités locales.'**
  String get homeWebCtaBody;

  /// No description provided for @homeWebCtaButton.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir le site'**
  String get homeWebCtaButton;

  /// No description provided for @homeFallbackPopularCitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Où ça bouge en ce moment'**
  String get homeFallbackPopularCitiesTitle;

  /// No description provided for @homePopularCitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Villes populaires'**
  String get homePopularCitiesTitle;

  /// No description provided for @homeHeroGreetingMorning.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {firstName} !'**
  String homeHeroGreetingMorning(String firstName);

  /// No description provided for @homeHeroGreetingAfternoon.
  ///
  /// In fr, this message translates to:
  /// **'Bon après-midi {firstName} !'**
  String homeHeroGreetingAfternoon(String firstName);

  /// No description provided for @homeHeroGreetingEvening.
  ///
  /// In fr, this message translates to:
  /// **'Bonsoir {firstName} !'**
  String homeHeroGreetingEvening(String firstName);

  /// No description provided for @homeHeroGreetingNight.
  ///
  /// In fr, this message translates to:
  /// **'Bonne nuit {firstName} !'**
  String homeHeroGreetingNight(String firstName);

  /// No description provided for @homeHeroNightTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sorties nocturnes'**
  String get homeHeroNightTitle;

  /// No description provided for @homeHeroNightTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Sorties nocturnes à {cityName}'**
  String homeHeroNightTitleWithCity(String cityName);

  /// No description provided for @homeHeroNightSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Concerts, spectacles et soirées'**
  String get homeHeroNightSubtitle;

  /// No description provided for @homeHeroWeekendTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end'**
  String get homeHeroWeekendTitle;

  /// No description provided for @homeHeroWeekendTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end à {cityName}'**
  String homeHeroWeekendTitleWithCity(String cityName);

  /// No description provided for @homeHeroWeekendMorningSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les meilleures activités vous attendent'**
  String get homeHeroWeekendMorningSubtitle;

  /// No description provided for @homeHeroMorningTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bonne journée'**
  String get homeHeroMorningTitle;

  /// No description provided for @homeHeroMorningTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Bonne journée à {cityName}'**
  String homeHeroMorningTitleWithCity(String cityName);

  /// No description provided for @homeHeroMorningSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez les activités du jour'**
  String get homeHeroMorningSubtitle;

  /// No description provided for @homeHeroAfternoonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cet après-midi'**
  String get homeHeroAfternoonTitle;

  /// No description provided for @homeHeroAfternoonTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Cet après-midi à {cityName}'**
  String homeHeroAfternoonTitleWithCity(String cityName);

  /// No description provided for @homeHeroWeekendAfternoonSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Profitez de votre week-end'**
  String get homeHeroWeekendAfternoonSubtitle;

  /// No description provided for @homeHeroNearbyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités près de vous'**
  String get homeHeroNearbyTitle;

  /// No description provided for @homeHeroNearbyTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Activités à {cityName}'**
  String homeHeroNearbyTitleWithCity(String cityName);

  /// No description provided for @homeHeroAfternoonSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour occuper votre après-midi'**
  String get homeHeroAfternoonSubtitle;

  /// No description provided for @homeHeroEveningTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce soir'**
  String get homeHeroEveningTitle;

  /// No description provided for @homeHeroEveningTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Ce soir à {cityName}'**
  String homeHeroEveningTitleWithCity(String cityName);

  /// No description provided for @homeHeroEveningWeekendSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les sorties du week-end commencent'**
  String get homeHeroEveningWeekendSubtitle;

  /// No description provided for @homeHeroEveningWeekdaySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Après le travail, on se détend'**
  String get homeHeroEveningWeekdaySubtitle;

  /// No description provided for @homeHeroDiscoverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez les activités'**
  String get homeHeroDiscoverTitle;

  /// No description provided for @homeHeroDiscoverTitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez {cityName}'**
  String homeHeroDiscoverTitleWithCity(String cityName);

  /// No description provided for @homeHeroDiscoverSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez votre prochaine sortie'**
  String get homeHeroDiscoverSubtitle;

  /// No description provided for @homeHeroSummerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Profitez des activités estivales'**
  String get homeHeroSummerSubtitle;

  /// No description provided for @homeHeroWinterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Réchauffez vos soirées'**
  String get homeHeroWinterSubtitle;

  /// No description provided for @homeHeroSpringSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le printemps est là, sortez !'**
  String get homeHeroSpringSubtitle;

  /// No description provided for @homeHeroAutumnSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les couleurs de l\'automne vous attendent'**
  String get homeHeroAutumnSubtitle;

  /// No description provided for @homeSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get homeSearchTitle;

  /// No description provided for @homeSearchNearby.
  ///
  /// In fr, this message translates to:
  /// **'À proximité'**
  String get homeSearchNearby;

  /// No description provided for @homeSearchWhere.
  ///
  /// In fr, this message translates to:
  /// **'Où ?'**
  String get homeSearchWhere;

  /// No description provided for @homeSearchWhen.
  ///
  /// In fr, this message translates to:
  /// **'Quand ?'**
  String get homeSearchWhen;

  /// No description provided for @homeSearchWhat.
  ///
  /// In fr, this message translates to:
  /// **'Quoi ?'**
  String get homeSearchWhat;

  /// No description provided for @homeSearchCategoryCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} cat.'**
  String homeSearchCategoryCount(int count);

  /// No description provided for @homeSearchFamily.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get homeSearchFamily;

  /// No description provided for @homeExploreByCategoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorer par catégorie'**
  String get homeExploreByCategoryTitle;

  /// No description provided for @homeExploreCategorySemantics.
  ///
  /// In fr, this message translates to:
  /// **'Explorer {category}'**
  String homeExploreCategorySemantics(String category);

  /// No description provided for @homeStoriesFeaturedTitle.
  ///
  /// In fr, this message translates to:
  /// **'À la une'**
  String get homeStoriesFeaturedTitle;

  /// No description provided for @homeStoriesNewBadge.
  ///
  /// In fr, this message translates to:
  /// **'NEW'**
  String get homeStoriesNewBadge;

  /// No description provided for @homeStoryViewActivity.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'activité'**
  String get homeStoryViewActivity;

  /// No description provided for @homeStoryBookingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Billetterie'**
  String get homeStoryBookingLabel;

  /// No description provided for @homeStoryDiscoveryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Découverte'**
  String get homeStoryDiscoveryLabel;

  /// No description provided for @homeDateAtTime.
  ///
  /// In fr, this message translates to:
  /// **'{date} à {time}'**
  String homeDateAtTime(String date, String time);

  /// No description provided for @homeTodayAtTime.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui à {time}'**
  String homeTodayAtTime(String time);

  /// No description provided for @homeTomorrowAtTime.
  ///
  /// In fr, this message translates to:
  /// **'Demain à {time}'**
  String homeTomorrowAtTime(String time);

  /// No description provided for @homeEventByOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Par {organizer}'**
  String homeEventByOrganizer(String organizer);

  /// No description provided for @homePriceFrom.
  ///
  /// In fr, this message translates to:
  /// **'À partir de {price}'**
  String homePriceFrom(String price);

  /// No description provided for @homePriceFromShort.
  ///
  /// In fr, this message translates to:
  /// **'Dès {price}'**
  String homePriceFromShort(String price);

  /// No description provided for @homePrivateBadge.
  ///
  /// In fr, this message translates to:
  /// **'Privé'**
  String get homePrivateBadge;

  /// No description provided for @homeCountdownNow.
  ///
  /// In fr, this message translates to:
  /// **'Maintenant !'**
  String get homeCountdownNow;

  /// No description provided for @homeCountdownDayHour.
  ///
  /// In fr, this message translates to:
  /// **'{days} jour {hours}h'**
  String homeCountdownDayHour(int days, int hours);

  /// No description provided for @homeCountdownDaysHours.
  ///
  /// In fr, this message translates to:
  /// **'{days} jours {hours}h'**
  String homeCountdownDaysHours(int days, int hours);

  /// No description provided for @homeRemainingSpot.
  ///
  /// In fr, this message translates to:
  /// **'{count} place'**
  String homeRemainingSpot(int count);

  /// No description provided for @homeRemainingSpots.
  ///
  /// In fr, this message translates to:
  /// **'{count} places'**
  String homeRemainingSpots(int count);

  /// No description provided for @homeUrgencyRemainingSpots.
  ///
  /// In fr, this message translates to:
  /// **'Plus que {count} places !'**
  String homeUrgencyRemainingSpots(int count);

  /// No description provided for @homeUrgencyLastHours.
  ///
  /// In fr, this message translates to:
  /// **'Dernières heures pour réserver !'**
  String get homeUrgencyLastHours;

  /// No description provided for @homeBook.
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get homeBook;

  /// No description provided for @homeUrgencyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avant qu\'il soit trop tard'**
  String get homeUrgencyTitle;

  /// No description provided for @homeUrgencySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ces événements commencent bientôt'**
  String get homeUrgencySubtitle;

  /// No description provided for @homeCityNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Ville non trouvée'**
  String get homeCityNotFound;

  /// No description provided for @homeCityDescriptionFallback.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez les activités à {cityName}.'**
  String homeCityDescriptionFallback(String cityName);

  /// No description provided for @homeCityAvailableEvent.
  ///
  /// In fr, this message translates to:
  /// **'{count} événement disponible'**
  String homeCityAvailableEvent(int count);

  /// No description provided for @homeCityAvailableEvents.
  ///
  /// In fr, this message translates to:
  /// **'{count} événements disponibles'**
  String homeCityAvailableEvents(int count);

  /// No description provided for @homePopularActivities.
  ///
  /// In fr, this message translates to:
  /// **'Activités populaires'**
  String get homePopularActivities;

  /// No description provided for @homeFilter.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer'**
  String get homeFilter;

  /// No description provided for @homeCityNoActivities.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité trouvée dans cette ville'**
  String get homeCityNoActivities;

  /// No description provided for @homeErrorWithMessage.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {message}'**
  String homeErrorWithMessage(String message);

  /// No description provided for @homeOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offres et bons plans'**
  String get homeOffersTitle;

  /// No description provided for @homeSpecialOffer.
  ///
  /// In fr, this message translates to:
  /// **'Offre spéciale'**
  String get homeSpecialOffer;

  /// No description provided for @homeQuickToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get homeQuickToday;

  /// No description provided for @homeQuickWeekend.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end'**
  String get homeQuickWeekend;

  /// No description provided for @homeQuickFamily.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get homeQuickFamily;

  /// No description provided for @homeQuickDistanceUnder2km.
  ///
  /// In fr, this message translates to:
  /// **'< 2 km'**
  String get homeQuickDistanceUnder2km;

  /// No description provided for @homeCategoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get homeCategoryAll;

  /// No description provided for @homeCategoryShows.
  ///
  /// In fr, this message translates to:
  /// **'Spectacles'**
  String get homeCategoryShows;

  /// No description provided for @homeCategoryWorkshops.
  ///
  /// In fr, this message translates to:
  /// **'Ateliers'**
  String get homeCategoryWorkshops;

  /// No description provided for @homeCategorySport.
  ///
  /// In fr, this message translates to:
  /// **'Sport'**
  String get homeCategorySport;

  /// No description provided for @homeCategoryCulture.
  ///
  /// In fr, this message translates to:
  /// **'Culture'**
  String get homeCategoryCulture;

  /// No description provided for @homeCategoryMarkets.
  ///
  /// In fr, this message translates to:
  /// **'Marchés'**
  String get homeCategoryMarkets;

  /// No description provided for @homeCategoryLeisure.
  ///
  /// In fr, this message translates to:
  /// **'Loisirs'**
  String get homeCategoryLeisure;

  /// No description provided for @homeBrowseByCity.
  ///
  /// In fr, this message translates to:
  /// **'Parcourir par ville'**
  String get homeBrowseByCity;

  /// No description provided for @searchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get searchTitle;

  /// No description provided for @searchFiltersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get searchFiltersTitle;

  /// No description provided for @searchClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get searchClear;

  /// No description provided for @searchClearAllWithCount.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer ({count})'**
  String searchClearAllWithCount(int count);

  /// No description provided for @searchAction.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get searchAction;

  /// No description provided for @searchActionWithActivity.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher · {count} activité'**
  String searchActionWithActivity(int count);

  /// No description provided for @searchActionWithActivities.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher · {count} activités'**
  String searchActionWithActivities(int count);

  /// No description provided for @searchSearchActivityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une activité'**
  String get searchSearchActivityTitle;

  /// No description provided for @searchAroundMe.
  ///
  /// In fr, this message translates to:
  /// **'Autour de moi'**
  String get searchAroundMe;

  /// No description provided for @searchAnywhere.
  ///
  /// In fr, this message translates to:
  /// **'N\'importe où'**
  String get searchAnywhere;

  /// No description provided for @searchAnytime.
  ///
  /// In fr, this message translates to:
  /// **'N\'importe quand'**
  String get searchAnytime;

  /// No description provided for @searchAnyActivityType.
  ///
  /// In fr, this message translates to:
  /// **'Tout type d\'activité'**
  String get searchAnyActivityType;

  /// No description provided for @searchSearchSubtitleDefault.
  ///
  /// In fr, this message translates to:
  /// **'Titre, organisateur'**
  String get searchSearchSubtitleDefault;

  /// No description provided for @searchForWhom.
  ///
  /// In fr, this message translates to:
  /// **'Pour qui ?'**
  String get searchForWhom;

  /// No description provided for @searchAllAudiences.
  ///
  /// In fr, this message translates to:
  /// **'Tous les publics'**
  String get searchAllAudiences;

  /// No description provided for @searchRefineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Affiner la recherche'**
  String get searchRefineTitle;

  /// No description provided for @searchRefineSubtitleDefault.
  ///
  /// In fr, this message translates to:
  /// **'Type, thématique, ambiance'**
  String get searchRefineSubtitleDefault;

  /// No description provided for @searchFilterSingular.
  ///
  /// In fr, this message translates to:
  /// **'1 filtre'**
  String get searchFilterSingular;

  /// No description provided for @searchFiltersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} filtres'**
  String searchFiltersCount(int count);

  /// No description provided for @searchCategorySingular.
  ///
  /// In fr, this message translates to:
  /// **'1 catégorie'**
  String get searchCategorySingular;

  /// No description provided for @searchCategoriesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} catégories'**
  String searchCategoriesCount(int count);

  /// No description provided for @searchAudienceSingular.
  ///
  /// In fr, this message translates to:
  /// **'1 public'**
  String get searchAudienceSingular;

  /// No description provided for @searchAudiencesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} publics'**
  String searchAudiencesCount(int count);

  /// No description provided for @searchMyPosition.
  ///
  /// In fr, this message translates to:
  /// **'Ma position'**
  String get searchMyPosition;

  /// No description provided for @searchUseCurrentLocation.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser ma position actuelle'**
  String get searchUseCurrentLocation;

  /// No description provided for @searchWithinRadius.
  ///
  /// In fr, this message translates to:
  /// **'Dans un rayon de {radius} km'**
  String searchWithinRadius(int radius);

  /// No description provided for @searchRadiusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rayon :'**
  String get searchRadiusLabel;

  /// No description provided for @searchRadiusAroundCity.
  ///
  /// In fr, this message translates to:
  /// **'Rayon autour de {cityName}'**
  String searchRadiusAroundCity(String cityName);

  /// No description provided for @searchLocationDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Activez la localisation'**
  String get searchLocationDisabled;

  /// No description provided for @searchPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Permission refusée'**
  String get searchPermissionDenied;

  /// No description provided for @searchLocationSettingsRequired.
  ///
  /// In fr, this message translates to:
  /// **'Activez la localisation dans les paramètres'**
  String get searchLocationSettingsRequired;

  /// No description provided for @searchLocationNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Position introuvable'**
  String get searchLocationNotFound;

  /// No description provided for @searchSavedAlertCreated.
  ///
  /// In fr, this message translates to:
  /// **'Alerte \"{name}\" créée avec notifications !'**
  String searchSavedAlertCreated(String name);

  /// No description provided for @searchSavedSearchCreated.
  ///
  /// In fr, this message translates to:
  /// **'Recherche \"{name}\" enregistrée !'**
  String searchSavedSearchCreated(String name);

  /// No description provided for @searchAlreadySaved.
  ///
  /// In fr, this message translates to:
  /// **'Déjà enregistrée'**
  String get searchAlreadySaved;

  /// No description provided for @searchSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get searchSave;

  /// No description provided for @searchSaveAlert.
  ///
  /// In fr, this message translates to:
  /// **'Créer une alerte'**
  String get searchSaveAlert;

  /// No description provided for @searchAlreadySavedMultiline.
  ///
  /// In fr, this message translates to:
  /// **'Recherche\nenregistrée'**
  String get searchAlreadySavedMultiline;

  /// No description provided for @searchSaveSearchMultiline.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder\nma recherche'**
  String get searchSaveSearchMultiline;

  /// No description provided for @searchRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get searchRetry;

  /// No description provided for @searchResult.
  ///
  /// In fr, this message translates to:
  /// **'{count} résultat'**
  String searchResult(Object count);

  /// No description provided for @searchResultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} résultats'**
  String searchResultsCount(Object count);

  /// No description provided for @searchNoMoreResults.
  ///
  /// In fr, this message translates to:
  /// **'C\'est tout pour le moment !'**
  String get searchNoMoreResults;

  /// No description provided for @searchAlertNewActivities.
  ///
  /// In fr, this message translates to:
  /// **'M\'alerter des nouveautés'**
  String get searchAlertNewActivities;

  /// No description provided for @searchSortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get searchSortBy;

  /// No description provided for @searchSortRelevance.
  ///
  /// In fr, this message translates to:
  /// **'Pertinence'**
  String get searchSortRelevance;

  /// No description provided for @searchNoResultsForFilters.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour ces filtres'**
  String get searchNoResultsForFilters;

  /// No description provided for @searchStartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Commencez votre recherche'**
  String get searchStartTitle;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité trouvée'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsBody.
  ///
  /// In fr, this message translates to:
  /// **'Essayez de modifier vos filtres ou d\'élargir votre zone de recherche.'**
  String get searchNoResultsBody;

  /// No description provided for @searchStartBody.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez la barre de recherche ci-dessus pour trouver des activités.'**
  String get searchStartBody;

  /// No description provided for @searchAlertNewEvents.
  ///
  /// In fr, this message translates to:
  /// **'M\'alerter des nouveaux événements'**
  String get searchAlertNewEvents;

  /// No description provided for @searchClearFilters.
  ///
  /// In fr, this message translates to:
  /// **'Effacer les filtres'**
  String get searchClearFilters;

  /// No description provided for @searchResultsActivity.
  ///
  /// In fr, this message translates to:
  /// **'{count} activité'**
  String searchResultsActivity(int count);

  /// No description provided for @searchResultsActivities.
  ///
  /// In fr, this message translates to:
  /// **'{count} activités'**
  String searchResultsActivities(int count);

  /// No description provided for @searchDateToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get searchDateToday;

  /// No description provided for @searchDateTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain'**
  String get searchDateTomorrow;

  /// No description provided for @searchDateThisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get searchDateThisWeek;

  /// No description provided for @searchDateThisWeekend.
  ///
  /// In fr, this message translates to:
  /// **'Ce week-end'**
  String get searchDateThisWeekend;

  /// No description provided for @searchDateThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci'**
  String get searchDateThisMonth;

  /// No description provided for @searchDateCustom.
  ///
  /// In fr, this message translates to:
  /// **'Dates personnalisées'**
  String get searchDateCustom;

  /// No description provided for @searchPricePaid.
  ///
  /// In fr, this message translates to:
  /// **'Payant'**
  String get searchPricePaid;

  /// No description provided for @searchPriceRange.
  ///
  /// In fr, this message translates to:
  /// **'{min}€ - {max}€'**
  String searchPriceRange(int min, int max);

  /// No description provided for @searchAroundMeWithRadius.
  ///
  /// In fr, this message translates to:
  /// **'Autour de moi ({radius} km)'**
  String searchAroundMeWithRadius(int radius);

  /// No description provided for @searchCityWithRadius.
  ///
  /// In fr, this message translates to:
  /// **'{cityName} · {radius} km'**
  String searchCityWithRadius(String cityName, int radius);

  /// No description provided for @searchAvailablePlaces.
  ///
  /// In fr, this message translates to:
  /// **'Places disponibles'**
  String get searchAvailablePlaces;

  /// No description provided for @searchAccessiblePmr.
  ///
  /// In fr, this message translates to:
  /// **'Accessible PMR'**
  String get searchAccessiblePmr;

  /// No description provided for @searchOnline.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get searchOnline;

  /// No description provided for @searchInPerson.
  ///
  /// In fr, this message translates to:
  /// **'En présentiel'**
  String get searchInPerson;

  /// No description provided for @searchLocationTypePhysical.
  ///
  /// In fr, this message translates to:
  /// **'Lieu physique'**
  String get searchLocationTypePhysical;

  /// No description provided for @searchLocationTypeOffline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get searchLocationTypeOffline;

  /// No description provided for @searchLocationTypeOnline.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get searchLocationTypeOnline;

  /// No description provided for @searchLocationTypeHybrid.
  ///
  /// In fr, this message translates to:
  /// **'Hybride'**
  String get searchLocationTypeHybrid;

  /// No description provided for @searchHintEventOrOrganization.
  ///
  /// In fr, this message translates to:
  /// **'Événement ou organisation'**
  String get searchHintEventOrOrganization;

  /// No description provided for @searchNoSuggestions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune suggestion'**
  String get searchNoSuggestions;

  /// No description provided for @searchSectionThemes.
  ///
  /// In fr, this message translates to:
  /// **'Thématiques'**
  String get searchSectionThemes;

  /// No description provided for @searchSectionEventType.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'événement'**
  String get searchSectionEventType;

  /// No description provided for @searchSectionSpecialEvents.
  ///
  /// In fr, this message translates to:
  /// **'Temps forts'**
  String get searchSectionSpecialEvents;

  /// No description provided for @searchSectionMood.
  ///
  /// In fr, this message translates to:
  /// **'Ambiance'**
  String get searchSectionMood;

  /// No description provided for @searchSectionDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get searchSectionDate;

  /// No description provided for @searchSectionCategories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get searchSectionCategories;

  /// No description provided for @searchSectionSort.
  ///
  /// In fr, this message translates to:
  /// **'Tri'**
  String get searchSectionSort;

  /// No description provided for @searchSectionLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get searchSectionLocation;

  /// No description provided for @searchSectionBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget'**
  String get searchSectionBudget;

  /// No description provided for @searchSectionFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format'**
  String get searchSectionFormat;

  /// No description provided for @searchSectionAudience.
  ///
  /// In fr, this message translates to:
  /// **'Public'**
  String get searchSectionAudience;

  /// No description provided for @searchSectionLocationType.
  ///
  /// In fr, this message translates to:
  /// **'Type de lieu'**
  String get searchSectionLocationType;

  /// No description provided for @searchChoosePeriod.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une période'**
  String get searchChoosePeriod;

  /// No description provided for @searchChooseCustomDates.
  ///
  /// In fr, this message translates to:
  /// **'Choisir des dates personnalisées'**
  String get searchChooseCustomDates;

  /// No description provided for @searchFreeOnlyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit uniquement'**
  String get searchFreeOnlyTitle;

  /// No description provided for @searchFreeOnlySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Afficher seulement les activités gratuites'**
  String get searchFreeOnlySubtitle;

  /// No description provided for @searchPriceRangeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fourchette de prix'**
  String get searchPriceRangeTitle;

  /// No description provided for @searchAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get searchAll;

  /// No description provided for @searchNoThemeAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune thématique disponible'**
  String get searchNoThemeAvailable;

  /// No description provided for @searchShowLess.
  ///
  /// In fr, this message translates to:
  /// **'Voir moins'**
  String get searchShowLess;

  /// No description provided for @searchShowMoreWithCount.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus ({count})'**
  String searchShowMoreWithCount(int count);

  /// No description provided for @searchLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Chargement impossible'**
  String get searchLoadError;

  /// No description provided for @searchHintCity.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une ville'**
  String get searchHintCity;

  /// No description provided for @searchPopularCities.
  ///
  /// In fr, this message translates to:
  /// **'VILLES POPULAIRES'**
  String get searchPopularCities;

  /// No description provided for @searchResults.
  ///
  /// In fr, this message translates to:
  /// **'RÉSULTATS'**
  String get searchResults;

  /// No description provided for @searchMinCharacters.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez au moins {count} caractères'**
  String searchMinCharacters(int count);

  /// No description provided for @searchNoCityFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune ville trouvée'**
  String get searchNoCityFound;

  /// No description provided for @searchCitiesUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Villes indisponibles'**
  String get searchCitiesUnavailable;

  /// No description provided for @searchHintCategory.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une catégorie'**
  String get searchHintCategory;

  /// No description provided for @searchNoCategoryFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie trouvée'**
  String get searchNoCategoryFound;

  /// No description provided for @searchCategoriesUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Catégories indisponibles'**
  String get searchCategoriesUnavailable;

  /// No description provided for @searchFamilyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get searchFamilyTitle;

  /// No description provided for @searchFamilySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités adaptées aux enfants'**
  String get searchFamilySubtitle;

  /// No description provided for @searchAudienceGroup.
  ///
  /// In fr, this message translates to:
  /// **'En groupe'**
  String get searchAudienceGroup;

  /// No description provided for @searchAudienceSchoolGroup.
  ///
  /// In fr, this message translates to:
  /// **'Groupe scolaire'**
  String get searchAudienceSchoolGroup;

  /// No description provided for @searchAudienceProfessional.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel'**
  String get searchAudienceProfessional;

  /// No description provided for @searchAccessibleSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité mobilité réduite'**
  String get searchAccessibleSubtitle;

  /// No description provided for @searchOnlineSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités virtuelles'**
  String get searchOnlineSubtitle;

  /// No description provided for @searchInPersonSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités sur place'**
  String get searchInPersonSubtitle;

  /// No description provided for @searchAvailabilityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilités'**
  String get searchAvailabilityTitle;

  /// No description provided for @searchAvailabilitySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Masquer les activités complètes'**
  String get searchAvailabilitySubtitle;

  /// No description provided for @searchAvailabilityPanelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilité'**
  String get searchAvailabilityPanelTitle;

  /// No description provided for @searchAllActivities.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les activités'**
  String get searchAllActivities;

  /// No description provided for @searchAvailableOnlyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Places disponibles uniquement'**
  String get searchAvailableOnlyTitle;

  /// No description provided for @searchNoAudienceAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun public disponible'**
  String get searchNoAudienceAvailable;

  /// No description provided for @searchAudiencesUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Publics indisponibles'**
  String get searchAudiencesUnavailable;

  /// No description provided for @searchOptionsUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Options indisponibles'**
  String get searchOptionsUnavailable;

  /// No description provided for @searchLocationIndoor.
  ///
  /// In fr, this message translates to:
  /// **'En intérieur'**
  String get searchLocationIndoor;

  /// No description provided for @searchLocationOutdoor.
  ///
  /// In fr, this message translates to:
  /// **'En extérieur'**
  String get searchLocationOutdoor;

  /// No description provided for @searchLocationMixed.
  ///
  /// In fr, this message translates to:
  /// **'Mixte'**
  String get searchLocationMixed;

  /// No description provided for @searchSortNewest.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés'**
  String get searchSortNewest;

  /// No description provided for @searchSortDateAsc.
  ///
  /// In fr, this message translates to:
  /// **'Date (proche)'**
  String get searchSortDateAsc;

  /// No description provided for @searchSortDateDesc.
  ///
  /// In fr, this message translates to:
  /// **'Date (plus tard)'**
  String get searchSortDateDesc;

  /// No description provided for @searchSortPriceAsc.
  ///
  /// In fr, this message translates to:
  /// **'Prix croissant'**
  String get searchSortPriceAsc;

  /// No description provided for @searchSortPriceDesc.
  ///
  /// In fr, this message translates to:
  /// **'Prix décroissant'**
  String get searchSortPriceDesc;

  /// No description provided for @searchSortPopularity.
  ///
  /// In fr, this message translates to:
  /// **'Popularité'**
  String get searchSortPopularity;

  /// No description provided for @searchSortDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get searchSortDistance;

  /// No description provided for @searchSaveSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder la recherche'**
  String get searchSaveSheetTitle;

  /// No description provided for @searchSaveSheetSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez facilement cette recherche et recevez des alertes pour les nouveaux événements.'**
  String get searchSaveSheetSubtitle;

  /// No description provided for @searchDefaultName.
  ///
  /// In fr, this message translates to:
  /// **'Ma recherche'**
  String get searchDefaultName;

  /// No description provided for @searchAllEvents.
  ///
  /// In fr, this message translates to:
  /// **'Tous les événements'**
  String get searchAllEvents;

  /// No description provided for @searchSummaryPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Filtres : {summary}'**
  String searchSummaryPrefix(String summary);

  /// No description provided for @searchNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un nom pour la recherche'**
  String get searchNameRequired;

  /// No description provided for @searchNameAlreadyUsed.
  ///
  /// In fr, this message translates to:
  /// **'Ce nom est déjà utilisé. Choisissez un autre nom.'**
  String get searchNameAlreadyUsed;

  /// No description provided for @searchNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la recherche'**
  String get searchNameLabel;

  /// No description provided for @searchNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : Concerts à Paris ce week-end'**
  String get searchNameHint;

  /// No description provided for @searchNotificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get searchNotificationsTitle;

  /// No description provided for @searchPushSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications sur l\'app mobile'**
  String get searchPushSubtitle;

  /// No description provided for @searchEmailSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevez un email pour chaque nouvel événement'**
  String get searchEmailSubtitle;

  /// No description provided for @searchSaveButton.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get searchSaveButton;

  /// No description provided for @eventExploreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les événements'**
  String get eventExploreTitle;

  /// No description provided for @eventSearchHintActivity.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une activité...'**
  String get eventSearchHintActivity;

  /// No description provided for @eventFiltersWithCount.
  ///
  /// In fr, this message translates to:
  /// **'Filtres ({count})'**
  String eventFiltersWithCount(int count);

  /// No description provided for @eventEndOfList.
  ///
  /// In fr, this message translates to:
  /// **'C\'est tout pour le moment !'**
  String get eventEndOfList;

  /// No description provided for @eventNoEventsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement trouvé'**
  String get eventNoEventsTitle;

  /// No description provided for @eventNoResultsWithFilters.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat avec les filtres actuels'**
  String get eventNoResultsWithFilters;

  /// No description provided for @eventNoEventsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Il n\'y a pas d\'événements disponibles pour le moment'**
  String get eventNoEventsAvailable;

  /// No description provided for @eventGenericErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get eventGenericErrorTitle;

  /// No description provided for @eventMapLocationError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de récupérer votre position'**
  String get eventMapLocationError;

  /// No description provided for @eventMapEventsHere.
  ///
  /// In fr, this message translates to:
  /// **'{count} événements ici'**
  String eventMapEventsHere(int count);

  /// No description provided for @eventMapSearching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche en cours...'**
  String get eventMapSearching;

  /// No description provided for @eventMapEmptyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Oups, c\'est calme par ici !\nBesoin d\'un coup de pouce ?'**
  String get eventMapEmptyHelp;

  /// No description provided for @eventLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger l\'activité.'**
  String get eventLoadError;

  /// No description provided for @eventDateAtTime.
  ///
  /// In fr, this message translates to:
  /// **'{date} à {time}'**
  String eventDateAtTime(String date, String time);

  /// No description provided for @eventDatesSoonAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Dates bientôt disponibles. Contactez l\'organisateur pour plus d\'infos.'**
  String get eventDatesSoonAvailable;

  /// No description provided for @eventAboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos de l\'événement'**
  String get eventAboutTitle;

  /// No description provided for @eventReadMore.
  ///
  /// In fr, this message translates to:
  /// **'Lire la suite'**
  String get eventReadMore;

  /// No description provided for @eventPricingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tarification'**
  String get eventPricingTitle;

  /// No description provided for @eventUndefined.
  ///
  /// In fr, this message translates to:
  /// **'Non définie'**
  String get eventUndefined;

  /// No description provided for @eventNoEntryFee.
  ///
  /// In fr, this message translates to:
  /// **'Aucun frais d\'entrée'**
  String get eventNoEntryFee;

  /// No description provided for @eventIndicativePrices.
  ///
  /// In fr, this message translates to:
  /// **'Prix indicatifs communiqués par l\'organisateur'**
  String get eventIndicativePrices;

  /// No description provided for @eventPriceFromPrefix.
  ///
  /// In fr, this message translates to:
  /// **'À partir de '**
  String get eventPriceFromPrefix;

  /// No description provided for @eventCharacteristicsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques'**
  String get eventCharacteristicsTitle;

  /// No description provided for @eventInvalidBookingLink.
  ///
  /// In fr, this message translates to:
  /// **'Lien de réservation invalide'**
  String get eventInvalidBookingLink;

  /// No description provided for @eventChooseDateFirst.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez d\'abord choisir une date'**
  String get eventChooseDateFirst;

  /// No description provided for @eventSelectAtLeastOneTicket.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner au moins un billet'**
  String get eventSelectAtLeastOneTicket;

  /// No description provided for @eventBookingChoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Que voulez-vous faire ?'**
  String get eventBookingChoiceTitle;

  /// No description provided for @eventBookingChoiceBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez ces billets au panier pour les payer avec d\'autres événements, ou finalisez maintenant.'**
  String get eventBookingChoiceBody;

  /// No description provided for @eventTicketsAddedToCart.
  ///
  /// In fr, this message translates to:
  /// **'Billets ajoutés au panier'**
  String get eventTicketsAddedToCart;

  /// No description provided for @eventView.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get eventView;

  /// No description provided for @eventAddToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au panier'**
  String get eventAddToCart;

  /// No description provided for @eventBookNow.
  ///
  /// In fr, this message translates to:
  /// **'Réserver maintenant'**
  String get eventBookNow;

  /// No description provided for @eventAllDatesCount.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les dates ({count})'**
  String eventAllDatesCount(int count);

  /// No description provided for @eventFull.
  ///
  /// In fr, this message translates to:
  /// **'Complet'**
  String get eventFull;

  /// No description provided for @eventChoose.
  ///
  /// In fr, this message translates to:
  /// **'Choisir'**
  String get eventChoose;

  /// No description provided for @eventTicketing.
  ///
  /// In fr, this message translates to:
  /// **'Billetterie'**
  String get eventTicketing;

  /// No description provided for @eventDiscovery.
  ///
  /// In fr, this message translates to:
  /// **'Découverte'**
  String get eventDiscovery;

  /// No description provided for @eventFeatured.
  ///
  /// In fr, this message translates to:
  /// **'En vedette'**
  String get eventFeatured;

  /// No description provided for @eventRecommended.
  ///
  /// In fr, this message translates to:
  /// **'Recommandé'**
  String get eventRecommended;

  /// No description provided for @eventNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get eventNew;

  /// No description provided for @eventPlaceNotSpecified.
  ///
  /// In fr, this message translates to:
  /// **'Lieu non précisé'**
  String get eventPlaceNotSpecified;

  /// No description provided for @eventCategoryWorkshop.
  ///
  /// In fr, this message translates to:
  /// **'Atelier'**
  String get eventCategoryWorkshop;

  /// No description provided for @eventCategoryShow.
  ///
  /// In fr, this message translates to:
  /// **'Spectacle'**
  String get eventCategoryShow;

  /// No description provided for @eventCategoryFestival.
  ///
  /// In fr, this message translates to:
  /// **'Festival'**
  String get eventCategoryFestival;

  /// No description provided for @eventCategoryConcert.
  ///
  /// In fr, this message translates to:
  /// **'Concert'**
  String get eventCategoryConcert;

  /// No description provided for @eventCategoryExhibition.
  ///
  /// In fr, this message translates to:
  /// **'Exposition'**
  String get eventCategoryExhibition;

  /// No description provided for @eventCategorySport.
  ///
  /// In fr, this message translates to:
  /// **'Sport'**
  String get eventCategorySport;

  /// No description provided for @eventCategoryCulture.
  ///
  /// In fr, this message translates to:
  /// **'Culture'**
  String get eventCategoryCulture;

  /// No description provided for @eventCategoryMarket.
  ///
  /// In fr, this message translates to:
  /// **'Marché'**
  String get eventCategoryMarket;

  /// No description provided for @eventCategoryLeisure.
  ///
  /// In fr, this message translates to:
  /// **'Loisirs'**
  String get eventCategoryLeisure;

  /// No description provided for @eventCategoryOutdoor.
  ///
  /// In fr, this message translates to:
  /// **'Plein air'**
  String get eventCategoryOutdoor;

  /// No description provided for @eventCategoryIndoor.
  ///
  /// In fr, this message translates to:
  /// **'Intérieur'**
  String get eventCategoryIndoor;

  /// No description provided for @eventCategoryTheater.
  ///
  /// In fr, this message translates to:
  /// **'Théâtre'**
  String get eventCategoryTheater;

  /// No description provided for @eventCategoryCinema.
  ///
  /// In fr, this message translates to:
  /// **'Cinéma'**
  String get eventCategoryCinema;

  /// No description provided for @eventCategoryOther.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get eventCategoryOther;

  /// No description provided for @eventAudienceAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout public'**
  String get eventAudienceAll;

  /// No description provided for @eventAudienceFamily.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get eventAudienceFamily;

  /// No description provided for @eventAudienceChildren.
  ///
  /// In fr, this message translates to:
  /// **'Enfants'**
  String get eventAudienceChildren;

  /// No description provided for @eventAudienceTeenagers.
  ///
  /// In fr, this message translates to:
  /// **'Ados'**
  String get eventAudienceTeenagers;

  /// No description provided for @eventAudienceAdults.
  ///
  /// In fr, this message translates to:
  /// **'Adultes'**
  String get eventAudienceAdults;

  /// No description provided for @eventAudienceSeniors.
  ///
  /// In fr, this message translates to:
  /// **'Seniors'**
  String get eventAudienceSeniors;

  /// No description provided for @eventDatesAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Dates disponibles'**
  String get eventDatesAvailable;

  /// No description provided for @eventChooseDate.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une date'**
  String get eventChooseDate;

  /// No description provided for @eventViewAllCount.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout ({count})'**
  String eventViewAllCount(int count);

  /// No description provided for @eventNoDateAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune date disponible'**
  String get eventNoDateAvailable;

  /// No description provided for @eventNoOpenSlots.
  ///
  /// In fr, this message translates to:
  /// **'Cet événement n\'a pas de créneaux ouverts'**
  String get eventNoOpenSlots;

  /// No description provided for @eventSpotsRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 place restante} other{{count} places restantes}}'**
  String eventSpotsRemaining(int count);

  /// No description provided for @eventTicketsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billets'**
  String get eventTicketsTitle;

  /// No description provided for @eventShowMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus'**
  String get eventShowMore;

  /// No description provided for @eventShowLess.
  ///
  /// In fr, this message translates to:
  /// **'Voir moins'**
  String get eventShowLess;

  /// No description provided for @eventSoldOut.
  ///
  /// In fr, this message translates to:
  /// **'Épuisé'**
  String get eventSoldOut;

  /// No description provided for @eventTicketLowStock.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Plus qu\'1 !} other{Plus que {count} !}}'**
  String eventTicketLowStock(int count);

  /// No description provided for @eventTicketsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 disponible} other{{count} disponibles}}'**
  String eventTicketsAvailable(int count);

  /// No description provided for @eventTotal.
  ///
  /// In fr, this message translates to:
  /// **'total'**
  String get eventTotal;

  /// No description provided for @eventTicketsSelected.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 billet sélectionné} other{{count} billets sélectionnés}}'**
  String eventTicketsSelected(int count);

  /// No description provided for @eventTicketsForDate.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 billet • {date}} other{{count} billets • {date}}}'**
  String eventTicketsForDate(int count, String date);

  /// No description provided for @eventNoSeatsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Plus de places disponibles'**
  String get eventNoSeatsAvailable;

  /// No description provided for @eventExpectedCapacity.
  ///
  /// In fr, this message translates to:
  /// **'Capacité prévue : {count}'**
  String eventExpectedCapacity(int count);

  /// No description provided for @eventViewDates.
  ///
  /// In fr, this message translates to:
  /// **'Voir les dates'**
  String get eventViewDates;

  /// No description provided for @eventReminded.
  ///
  /// In fr, this message translates to:
  /// **'Rappelé'**
  String get eventReminded;

  /// No description provided for @eventRemindMe.
  ///
  /// In fr, this message translates to:
  /// **'Me rappeler'**
  String get eventRemindMe;

  /// No description provided for @eventViewWebsite.
  ///
  /// In fr, this message translates to:
  /// **'Voir le site'**
  String get eventViewWebsite;

  /// No description provided for @eventIndicativePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix indicatif'**
  String get eventIndicativePrice;

  /// No description provided for @eventDateFromTo.
  ///
  /// In fr, this message translates to:
  /// **'{date} de {start} à {end}'**
  String eventDateFromTo(String date, String start, String end);

  /// No description provided for @eventDateAtStart.
  ///
  /// In fr, this message translates to:
  /// **'{date} à {start}'**
  String eventDateAtStart(String date, String start);

  /// No description provided for @eventServicesAdditionalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Services additionnels (indicatif)'**
  String get eventServicesAdditionalTitle;

  /// No description provided for @eventPracticalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Infos pratiques'**
  String get eventPracticalInfoTitle;

  /// No description provided for @eventParkingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Parking'**
  String get eventParkingTitle;

  /// No description provided for @eventParkingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Places disponibles'**
  String get eventParkingSubtitle;

  /// No description provided for @eventTransportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transports'**
  String get eventTransportTitle;

  /// No description provided for @eventTransportSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Bus, métro, tram'**
  String get eventTransportSubtitle;

  /// No description provided for @eventFoodService.
  ///
  /// In fr, this message translates to:
  /// **'Restauration'**
  String get eventFoodService;

  /// No description provided for @eventFoodOnSite.
  ///
  /// In fr, this message translates to:
  /// **'Restauration sur place'**
  String get eventFoodOnSite;

  /// No description provided for @eventDrinks.
  ///
  /// In fr, this message translates to:
  /// **'Boissons'**
  String get eventDrinks;

  /// No description provided for @eventDrinksAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Boissons disponibles'**
  String get eventDrinksAvailable;

  /// No description provided for @eventWifiAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Wi-Fi disponible'**
  String get eventWifiAvailable;

  /// No description provided for @eventServiceDefaultDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ce service est disponible sur place.'**
  String get eventServiceDefaultDescription;

  /// No description provided for @eventServiceEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Matériel fourni'**
  String get eventServiceEquipment;

  /// No description provided for @eventServiceFacilitator.
  ///
  /// In fr, this message translates to:
  /// **'Animateur'**
  String get eventServiceFacilitator;

  /// No description provided for @eventServiceAccommodation.
  ///
  /// In fr, this message translates to:
  /// **'Hébergement'**
  String get eventServiceAccommodation;

  /// No description provided for @eventServiceCloakroom.
  ///
  /// In fr, this message translates to:
  /// **'Vestiaire'**
  String get eventServiceCloakroom;

  /// No description provided for @eventServiceSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get eventServiceSecurity;

  /// No description provided for @eventServiceFirstAid.
  ///
  /// In fr, this message translates to:
  /// **'Premiers secours'**
  String get eventServiceFirstAid;

  /// No description provided for @eventServiceChildcare.
  ///
  /// In fr, this message translates to:
  /// **'Garderie'**
  String get eventServiceChildcare;

  /// No description provided for @eventServicePhotoBooth.
  ///
  /// In fr, this message translates to:
  /// **'Photobooth'**
  String get eventServicePhotoBooth;

  /// No description provided for @eventPlace.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get eventPlace;

  /// No description provided for @eventParkingSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Stationnement'**
  String get eventParkingSheetTitle;

  /// No description provided for @eventParkingDirections.
  ///
  /// In fr, this message translates to:
  /// **'Naviguer vers le parking'**
  String get eventParkingDirections;

  /// No description provided for @eventTransportSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transports en commun'**
  String get eventTransportSheetTitle;

  /// No description provided for @eventAccessibilityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité'**
  String get eventAccessibilityTitle;

  /// No description provided for @eventAccessibilityPmr.
  ///
  /// In fr, this message translates to:
  /// **'Accessible PMR'**
  String get eventAccessibilityPmr;

  /// No description provided for @eventAccessibilityPmrTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité PMR'**
  String get eventAccessibilityPmrTitle;

  /// No description provided for @eventAccessibilitySignLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue des signes'**
  String get eventAccessibilitySignLanguage;

  /// No description provided for @eventAccessibilityElevator.
  ///
  /// In fr, this message translates to:
  /// **'Ascenseur'**
  String get eventAccessibilityElevator;

  /// No description provided for @eventAccessibilityDisabledParking.
  ///
  /// In fr, this message translates to:
  /// **'Parking handicapé'**
  String get eventAccessibilityDisabledParking;

  /// No description provided for @eventAccessibilityDisabledSeats.
  ///
  /// In fr, this message translates to:
  /// **'Places handicapé'**
  String get eventAccessibilityDisabledSeats;

  /// No description provided for @eventAccessibilityGuideDog.
  ///
  /// In fr, this message translates to:
  /// **'Chien guide'**
  String get eventAccessibilityGuideDog;

  /// No description provided for @eventAccessibilityHearingLoop.
  ///
  /// In fr, this message translates to:
  /// **'Boucle magnétique'**
  String get eventAccessibilityHearingLoop;

  /// No description provided for @eventAccessibilityAudioDescription.
  ///
  /// In fr, this message translates to:
  /// **'Audiodescription'**
  String get eventAccessibilityAudioDescription;

  /// No description provided for @eventAccessibilityBraille.
  ///
  /// In fr, this message translates to:
  /// **'Braille'**
  String get eventAccessibilityBraille;

  /// No description provided for @eventAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get eventAvailable;

  /// No description provided for @eventQuickActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions rapides'**
  String get eventQuickActions;

  /// No description provided for @eventDrivingDirections.
  ///
  /// In fr, this message translates to:
  /// **'Itinéraire en voiture'**
  String get eventDrivingDirections;

  /// No description provided for @eventWalkingDirections.
  ///
  /// In fr, this message translates to:
  /// **'Y aller à pied'**
  String get eventWalkingDirections;

  /// No description provided for @eventPublicTransportDirections.
  ///
  /// In fr, this message translates to:
  /// **'Transports en commun'**
  String get eventPublicTransportDirections;

  /// No description provided for @eventCopyAddress.
  ///
  /// In fr, this message translates to:
  /// **'Copier l\'adresse'**
  String get eventCopyAddress;

  /// No description provided for @eventAddressCopied.
  ///
  /// In fr, this message translates to:
  /// **'Adresse copiée'**
  String get eventAddressCopied;

  /// No description provided for @eventDetailsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get eventDetailsLabel;

  /// No description provided for @eventLocationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get eventLocationTitle;

  /// No description provided for @eventViewOnGoogleMaps.
  ///
  /// In fr, this message translates to:
  /// **'Voir sur Google Maps'**
  String get eventViewOnGoogleMaps;

  /// No description provided for @eventNoImage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune image'**
  String get eventNoImage;

  /// No description provided for @eventNoImageAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune image disponible'**
  String get eventNoImageAvailable;

  /// No description provided for @eventViewVideo.
  ///
  /// In fr, this message translates to:
  /// **'Voir la vidéo'**
  String get eventViewVideo;

  /// No description provided for @eventViewAllPhotosCount.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les photos ({count})'**
  String eventViewAllPhotosCount(int count);

  /// No description provided for @eventPrivateNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Événement introuvable.'**
  String get eventPrivateNotFound;

  /// No description provided for @eventPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe est requis.'**
  String get eventPasswordRequired;

  /// No description provided for @eventPasswordIncorrect.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe incorrect.'**
  String get eventPasswordIncorrect;

  /// No description provided for @eventPasswordInvalidFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format invalide.'**
  String get eventPasswordInvalidFormat;

  /// No description provided for @eventPasswordNetworkError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur réseau. Réessaie.'**
  String get eventPasswordNetworkError;

  /// No description provided for @eventPasswordRetryIn.
  ///
  /// In fr, this message translates to:
  /// **'Réessaye dans {seconds}s'**
  String eventPasswordRetryIn(int seconds);

  /// No description provided for @eventPasswordChecking.
  ///
  /// In fr, this message translates to:
  /// **'Vérification...'**
  String get eventPasswordChecking;

  /// No description provided for @eventUnlock.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller'**
  String get eventUnlock;

  /// No description provided for @eventPrivateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cet événement est privé'**
  String get eventPrivateTitle;

  /// No description provided for @eventPrivateInstructions.
  ///
  /// In fr, this message translates to:
  /// **'Entre le mot de passe communiqué par l\'organisateur.'**
  String get eventPrivateInstructions;

  /// No description provided for @eventPasswordAttemptsWarning.
  ///
  /// In fr, this message translates to:
  /// **'Encore 3 essais avant un délai de 1 minute.'**
  String get eventPasswordAttemptsWarning;

  /// No description provided for @eventPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get eventPasswordLabel;

  /// No description provided for @eventPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Saisis le mot de passe'**
  String get eventPasswordHint;

  /// No description provided for @eventMembersOnlyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservé aux membres'**
  String get eventMembersOnlyTitle;

  /// No description provided for @eventMembersOnlyPrefix.
  ///
  /// In fr, this message translates to:
  /// **'L\'événement '**
  String get eventMembersOnlyPrefix;

  /// No description provided for @eventMembersOnlyReservedFor.
  ///
  /// In fr, this message translates to:
  /// **'est réservé aux membres de '**
  String get eventMembersOnlyReservedFor;

  /// No description provided for @eventMembersOnlySuffix.
  ///
  /// In fr, this message translates to:
  /// **'. Rejoins la communauté pour y accéder.'**
  String get eventMembersOnlySuffix;

  /// No description provided for @eventOrganizationFallback.
  ///
  /// In fr, this message translates to:
  /// **'cette organisation'**
  String get eventOrganizationFallback;

  /// No description provided for @eventViewOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'organisateur'**
  String get eventViewOrganizer;

  /// No description provided for @eventEnterPassword.
  ///
  /// In fr, this message translates to:
  /// **'Entrer le mot de passe'**
  String get eventEnterPassword;

  /// No description provided for @eventPrivateFallbackSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Cet événement est privé. Entre le mot de passe communiqué par l\'organisateur.'**
  String get eventPrivateFallbackSubtitle;

  /// No description provided for @eventShareWithSender.
  ///
  /// In fr, this message translates to:
  /// **'{senderName} vous partage l\'événement {eventTitle} : {url}'**
  String eventShareWithSender(String senderName, String eventTitle, String url);

  /// No description provided for @eventShareDefault.
  ///
  /// In fr, this message translates to:
  /// **'Découvre l\'événement {eventTitle} : {url}'**
  String eventShareDefault(String eventTitle, String url);

  /// No description provided for @eventQuestionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions'**
  String get eventQuestionsTitle;

  /// No description provided for @eventAsk.
  ///
  /// In fr, this message translates to:
  /// **'Poser'**
  String get eventAsk;

  /// No description provided for @eventQuestionSent.
  ///
  /// In fr, this message translates to:
  /// **'Votre question a été envoyée !'**
  String get eventQuestionSent;

  /// No description provided for @eventQuestionAlreadyAsked.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà posé une question sur cet événement.'**
  String get eventQuestionAlreadyAsked;

  /// No description provided for @eventYourQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Votre question'**
  String get eventYourQuestion;

  /// No description provided for @eventQuestionStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente de modération'**
  String get eventQuestionStatusPending;

  /// No description provided for @eventQuestionStatusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvée'**
  String get eventQuestionStatusApproved;

  /// No description provided for @eventQuestionStatusAnswered.
  ///
  /// In fr, this message translates to:
  /// **'Répondue'**
  String get eventQuestionStatusAnswered;

  /// No description provided for @eventQuestionStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get eventQuestionStatusRejected;

  /// No description provided for @eventViewAllQuestionsCount.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les questions ({count})'**
  String eventViewAllQuestionsCount(int count);

  /// No description provided for @eventNoQuestionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune question pour le moment'**
  String get eventNoQuestionsTitle;

  /// No description provided for @eventNoQuestionsBody.
  ///
  /// In fr, this message translates to:
  /// **'Soyez le premier à poser une question sur cet événement.'**
  String get eventNoQuestionsBody;

  /// No description provided for @eventAskQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Poser une question'**
  String get eventAskQuestion;

  /// No description provided for @eventQuestionsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les questions'**
  String get eventQuestionsLoadError;

  /// No description provided for @eventQuestionsEnd.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez vu toutes les questions'**
  String get eventQuestionsEnd;

  /// No description provided for @eventVoteUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de voter pour le moment.'**
  String get eventVoteUnavailable;

  /// No description provided for @eventQuestionsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}}'**
  String eventQuestionsCount(int count);

  /// No description provided for @eventOfficialAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Réponse officielle'**
  String get eventOfficialAnswer;

  /// No description provided for @eventAnonymous.
  ///
  /// In fr, this message translates to:
  /// **'Anonyme'**
  String get eventAnonymous;

  /// No description provided for @eventHelpful.
  ///
  /// In fr, this message translates to:
  /// **'Utile'**
  String get eventHelpful;

  /// No description provided for @eventHelpfulCount.
  ///
  /// In fr, this message translates to:
  /// **'Utile ({count})'**
  String eventHelpfulCount(int count);

  /// No description provided for @eventAskQuestionHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: À quelle heure ouvrent les portes ?'**
  String get eventAskQuestionHint;

  /// No description provided for @eventQuestionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir votre question.'**
  String get eventQuestionRequired;

  /// No description provided for @eventQuestionMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Votre question doit contenir au moins 10 caractères.'**
  String get eventQuestionMinLength;

  /// No description provided for @eventQuestionTooLong.
  ///
  /// In fr, this message translates to:
  /// **'Votre question est trop longue (1000 max).'**
  String get eventQuestionTooLong;

  /// No description provided for @eventQuestionInfo.
  ///
  /// In fr, this message translates to:
  /// **'L\'organisateur recevra votre question et vous répondra bientôt.'**
  String get eventQuestionInfo;

  /// No description provided for @eventSendQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer ma question'**
  String get eventSendQuestion;

  /// No description provided for @eventCheckConnectionRetry.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre connexion puis réessayez.'**
  String get eventCheckConnectionRetry;

  /// No description provided for @eventOrganizerInfoSources.
  ///
  /// In fr, this message translates to:
  /// **'Sources Infos'**
  String get eventOrganizerInfoSources;

  /// No description provided for @eventOrganizerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur'**
  String get eventOrganizerTitle;

  /// No description provided for @eventOrganizerVerified.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur vérifié'**
  String get eventOrganizerVerified;

  /// No description provided for @eventOrganizerNotVerified.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur non vérifié'**
  String get eventOrganizerNotVerified;

  /// No description provided for @eventOrganizerEventsPublished.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 événement publié} other{{count} événements publiés}}'**
  String eventOrganizerEventsPublished(int count);

  /// No description provided for @eventOrganizerFollowers.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 abonné} other{{count} abonnés}}'**
  String eventOrganizerFollowers(int count);

  /// No description provided for @eventContact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get eventContact;

  /// No description provided for @eventViewProfile.
  ///
  /// In fr, this message translates to:
  /// **'Voir le profil'**
  String get eventViewProfile;

  /// No description provided for @eventWrittenBy.
  ///
  /// In fr, this message translates to:
  /// **'Rédigé par'**
  String get eventWrittenBy;

  /// No description provided for @eventLehibooExperiences.
  ///
  /// In fr, this message translates to:
  /// **'LEHIBOO EXPÉRIENCES'**
  String get eventLehibooExperiences;

  /// No description provided for @eventSourceInfo.
  ///
  /// In fr, this message translates to:
  /// **'Source infos : '**
  String get eventSourceInfo;

  /// No description provided for @eventSimilarEvents.
  ///
  /// In fr, this message translates to:
  /// **'Événements similaires'**
  String get eventSimilarEvents;

  /// No description provided for @bookingCheckoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Finaliser ma réservation'**
  String get bookingCheckoutTitle;

  /// No description provided for @bookingSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get bookingSummaryTitle;

  /// No description provided for @bookingTicketFallback.
  ///
  /// In fr, this message translates to:
  /// **'Billet'**
  String get bookingTicketFallback;

  /// No description provided for @bookingTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get bookingTotal;

  /// No description provided for @bookingBuyerContactTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos coordonnées'**
  String get bookingBuyerContactTitle;

  /// No description provided for @bookingContactDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées'**
  String get bookingContactDetailsTitle;

  /// No description provided for @bookingContactDetailsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous recevrez votre confirmation et vos billets à cette adresse.'**
  String get bookingContactDetailsSubtitle;

  /// No description provided for @bookingAdditionalInfoOptional.
  ///
  /// In fr, this message translates to:
  /// **'Informations complémentaires (optionnel)'**
  String get bookingAdditionalInfoOptional;

  /// No description provided for @bookingFirstNameLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Prénom *'**
  String get bookingFirstNameLabelRequired;

  /// No description provided for @bookingLastNameLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Nom *'**
  String get bookingLastNameLabelRequired;

  /// No description provided for @bookingEmailLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Email *'**
  String get bookingEmailLabelRequired;

  /// No description provided for @bookingPhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get bookingPhoneLabel;

  /// No description provided for @bookingAgeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Âge'**
  String get bookingAgeLabel;

  /// No description provided for @bookingMembershipCityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ville d\'appartenance'**
  String get bookingMembershipCityLabel;

  /// No description provided for @bookingFirstNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le prénom est requis'**
  String get bookingFirstNameRequired;

  /// No description provided for @bookingLastNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est requis'**
  String get bookingLastNameRequired;

  /// No description provided for @bookingEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'email est requis'**
  String get bookingEmailRequired;

  /// No description provided for @bookingEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get bookingEmailInvalid;

  /// No description provided for @bookingCityMaxLength.
  ///
  /// In fr, this message translates to:
  /// **'La ville ne doit pas dépasser 255 caractères'**
  String get bookingCityMaxLength;

  /// No description provided for @bookingTermsPrefix.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les '**
  String get bookingTermsPrefix;

  /// No description provided for @bookingTermsConnector.
  ///
  /// In fr, this message translates to:
  /// **' et la '**
  String get bookingTermsConnector;

  /// No description provided for @bookingAcceptSalesRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez accepter les conditions générales de vente'**
  String get bookingAcceptSalesRequired;

  /// No description provided for @bookingEveryTicketNeedsParticipant.
  ///
  /// In fr, this message translates to:
  /// **'Chaque billet doit avoir un participant renseigné'**
  String get bookingEveryTicketNeedsParticipant;

  /// No description provided for @bookingParticipantsMissingDetails.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez renseigner le prénom, le nom, la date de naissance, la ville et la relation de chaque participant'**
  String get bookingParticipantsMissingDetails;

  /// No description provided for @bookingParticipantsMissingCartDetails.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez renseigner le prénom, la date de naissance, la ville et la relation de chaque participant'**
  String get bookingParticipantsMissingCartDetails;

  /// No description provided for @bookingConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get bookingConfirm;

  /// No description provided for @bookingPay.
  ///
  /// In fr, this message translates to:
  /// **'Payer'**
  String get bookingPay;

  /// No description provided for @bookingContinueToPayment.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers le paiement'**
  String get bookingContinueToPayment;

  /// No description provided for @bookingPaymentCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Paiement annulé'**
  String get bookingPaymentCancelled;

  /// No description provided for @bookingTicketsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 billet} other{{count} billets}}'**
  String bookingTicketsCount(int count);

  /// No description provided for @bookingCartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Panier'**
  String get bookingCartTitle;

  /// No description provided for @bookingCartHoldExpired.
  ///
  /// In fr, this message translates to:
  /// **'Le délai du panier est dépassé. Ajoutez à nouveau vos billets pour continuer.'**
  String get bookingCartHoldExpired;

  /// No description provided for @bookingClearCartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vider le panier ?'**
  String get bookingClearCartTitle;

  /// No description provided for @bookingClearCartBody.
  ///
  /// In fr, this message translates to:
  /// **'Tous les billets ajoutés seront supprimés. Cette action est irréversible.'**
  String get bookingClearCartBody;

  /// No description provided for @bookingClear.
  ///
  /// In fr, this message translates to:
  /// **'Vider'**
  String get bookingClear;

  /// No description provided for @bookingCartHoldLabel.
  ///
  /// In fr, this message translates to:
  /// **'Panier {time}'**
  String bookingCartHoldLabel(String time);

  /// No description provided for @bookingPlacesHoldLabel.
  ///
  /// In fr, this message translates to:
  /// **'Places {time}'**
  String bookingPlacesHoldLabel(String time);

  /// No description provided for @bookingCartHoldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conservation du panier'**
  String get bookingCartHoldTitle;

  /// No description provided for @bookingCartHoldBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre sélection est conservée 15 minutes après le dernier ajout. Au moment du paiement, les places sont bloquées le temps nécessaire à la finalisation.'**
  String get bookingCartHoldBody;

  /// No description provided for @bookingUnderstood.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get bookingUnderstood;

  /// No description provided for @bookingEmptyCartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide'**
  String get bookingEmptyCartTitle;

  /// No description provided for @bookingEmptyCartBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des billets depuis une fiche événement pour payer plusieurs réservations en une fois.'**
  String get bookingEmptyCartBody;

  /// No description provided for @bookingExploreEvents.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les événements'**
  String get bookingExploreEvents;

  /// No description provided for @bookingParticipantsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Participants'**
  String get bookingParticipantsTitle;

  /// No description provided for @bookingParticipantsInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une personne enregistrée ou renseignez chaque billet.'**
  String get bookingParticipantsInstruction;

  /// No description provided for @bookingParticipantSectionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Un formulaire par billet — renseignez chaque participant'**
  String get bookingParticipantSectionSubtitle;

  /// No description provided for @bookingParticipantInfoNote.
  ///
  /// In fr, this message translates to:
  /// **'Le prénom, la date de naissance, la ville et la relation aident l\'IA et l\'expérience Le Hiboo à proposer les offres et événements les plus pertinents.'**
  String get bookingParticipantInfoNote;

  /// No description provided for @bookingChooseSavedParticipant.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un participant enregistré'**
  String get bookingChooseSavedParticipant;

  /// No description provided for @bookingAddToNextEmptyTicket.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au prochain billet vide'**
  String get bookingAddToNextEmptyTicket;

  /// No description provided for @bookingMyParticipants.
  ///
  /// In fr, this message translates to:
  /// **'Mes participants'**
  String get bookingMyParticipants;

  /// No description provided for @bookingSavedParticipantsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 enregistré} other{{count} enregistrés}}'**
  String bookingSavedParticipantsCount(int count);

  /// No description provided for @bookingPrefillTicketsOneClick.
  ///
  /// In fr, this message translates to:
  /// **'Pré-remplissez vos billets en un clic'**
  String get bookingPrefillTicketsOneClick;

  /// No description provided for @bookingParticipantsReady.
  ///
  /// In fr, this message translates to:
  /// **'{completed} / {total} participants prêts'**
  String bookingParticipantsReady(int completed, int total);

  /// No description provided for @bookingFillAllWithProfile.
  ///
  /// In fr, this message translates to:
  /// **'Remplir tous les billets avec mon profil'**
  String get bookingFillAllWithProfile;

  /// No description provided for @bookingIncompleteProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil incomplet'**
  String get bookingIncompleteProfileTitle;

  /// No description provided for @bookingIncompleteProfileBody.
  ///
  /// In fr, this message translates to:
  /// **'Complétez votre profil (date de naissance, ville) pour pré-remplir tous les champs requis.'**
  String get bookingIncompleteProfileBody;

  /// No description provided for @bookingCompleteProfile.
  ///
  /// In fr, this message translates to:
  /// **'Compléter mon profil >'**
  String get bookingCompleteProfile;

  /// No description provided for @bookingPrefillTicket.
  ///
  /// In fr, this message translates to:
  /// **'Pré-remplir ce billet'**
  String get bookingPrefillTicket;

  /// No description provided for @bookingManualEntry.
  ///
  /// In fr, this message translates to:
  /// **'Saisie manuelle'**
  String get bookingManualEntry;

  /// No description provided for @bookingBuyerSelf.
  ///
  /// In fr, this message translates to:
  /// **'Moi (acheteur)'**
  String get bookingBuyerSelf;

  /// No description provided for @bookingRelationshipSelf.
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get bookingRelationshipSelf;

  /// No description provided for @bookingRelationshipChild.
  ///
  /// In fr, this message translates to:
  /// **'Enfant'**
  String get bookingRelationshipChild;

  /// No description provided for @bookingRelationshipSpouse.
  ///
  /// In fr, this message translates to:
  /// **'Conjoint'**
  String get bookingRelationshipSpouse;

  /// No description provided for @bookingRelationshipFamily.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get bookingRelationshipFamily;

  /// No description provided for @bookingRelationshipFriend.
  ///
  /// In fr, this message translates to:
  /// **'Ami'**
  String get bookingRelationshipFriend;

  /// No description provided for @bookingRelationshipOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get bookingRelationshipOther;

  /// No description provided for @bookingFirstNameShortRequired.
  ///
  /// In fr, this message translates to:
  /// **'Prénom requis'**
  String get bookingFirstNameShortRequired;

  /// No description provided for @bookingCityRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ville requise'**
  String get bookingCityRequired;

  /// No description provided for @bookingRelationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Relation requise'**
  String get bookingRelationRequired;

  /// No description provided for @bookingLastNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get bookingLastNameLabel;

  /// No description provided for @bookingRelationLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Relation *'**
  String get bookingRelationLabelRequired;

  /// No description provided for @bookingBirthDateLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance *'**
  String get bookingBirthDateLabelRequired;

  /// No description provided for @bookingBirthDateHelp.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get bookingBirthDateHelp;

  /// No description provided for @bookingBirthDatePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'jj/mm/aaaa'**
  String get bookingBirthDatePlaceholder;

  /// No description provided for @bookingContactOptional.
  ///
  /// In fr, this message translates to:
  /// **'Contact optionnel'**
  String get bookingContactOptional;

  /// No description provided for @bookingSaveParticipant.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à Mes participants'**
  String get bookingSaveParticipant;

  /// No description provided for @bookingParticipantComplete.
  ///
  /// In fr, this message translates to:
  /// **'Complet'**
  String get bookingParticipantComplete;

  /// No description provided for @bookingParticipantActionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Action requise'**
  String get bookingParticipantActionRequired;

  /// No description provided for @bookingRecapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get bookingRecapTitle;

  /// No description provided for @bookingTotalTickets.
  ///
  /// In fr, this message translates to:
  /// **'Total billets'**
  String get bookingTotalTickets;

  /// No description provided for @bookingPerTicket.
  ///
  /// In fr, this message translates to:
  /// **'{price} / billet'**
  String bookingPerTicket(String price);

  /// No description provided for @bookingRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get bookingRemove;

  /// No description provided for @bookingOrderConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Commande confirmée'**
  String get bookingOrderConfirmed;

  /// No description provided for @bookingReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence : {reference}'**
  String bookingReference(String reference);

  /// No description provided for @bookingCreatedReservations.
  ///
  /// In fr, this message translates to:
  /// **'Réservations créées'**
  String get bookingCreatedReservations;

  /// No description provided for @bookingTicketsGeneratingOrder.
  ///
  /// In fr, this message translates to:
  /// **'Vos billets sont en cours de génération. Vous les retrouverez dans Mes réservations.'**
  String get bookingTicketsGeneratingOrder;

  /// No description provided for @bookingViewMyBookings.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes réservations'**
  String get bookingViewMyBookings;

  /// No description provided for @bookingBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get bookingBackHome;

  /// No description provided for @bookingReservationFallback.
  ///
  /// In fr, this message translates to:
  /// **'Réservation'**
  String get bookingReservationFallback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
