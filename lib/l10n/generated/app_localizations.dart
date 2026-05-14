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
