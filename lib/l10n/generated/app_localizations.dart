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

  /// No description provided for @commonNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// No description provided for @commonRestart.
  ///
  /// In fr, this message translates to:
  /// **'Redémarrer'**
  String get commonRestart;

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get commonLoading;

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

  /// No description provided for @commonAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get commonAdd;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonDelete;

  /// No description provided for @commonOk.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get commonValidate;

  /// No description provided for @commonErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Oups !'**
  String get commonErrorTitle;

  /// No description provided for @commonGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get commonGenericError;

  /// No description provided for @commonGenericRetryError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Veuillez réessayer.'**
  String get commonGenericRetryError;

  /// No description provided for @commonConnectionError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion. Vérifiez votre connexion internet.'**
  String get commonConnectionError;

  /// No description provided for @commonSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher...'**
  String get commonSearchHint;

  /// No description provided for @routeEventFallbackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get routeEventFallbackTitle;

  /// No description provided for @routeRecommendedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recommandés pour vous'**
  String get routeRecommendedTitle;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Oups ! Page non trouvée'**
  String get routeNotFoundTitle;

  /// No description provided for @routeNotFoundBody.
  ///
  /// In fr, this message translates to:
  /// **'La page que vous recherchez n\'existe pas.'**
  String get routeNotFoundBody;

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

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileDefaultUser.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get profileDefaultUser;

  /// No description provided for @profileBookingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get profileBookingsTitle;

  /// No description provided for @profileBookingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Voir vos billets et réservations'**
  String get profileBookingsSubtitle;

  /// No description provided for @profileParticipantsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes participants'**
  String get profileParticipantsTitle;

  /// No description provided for @profileParticipantsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Famille et proches pour attribuer les billets'**
  String get profileParticipantsSubtitle;

  /// No description provided for @profileFavoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get profileFavoritesTitle;

  /// No description provided for @profileFavoritesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités sauvegardées'**
  String get profileFavoritesSubtitle;

  /// No description provided for @profileFollowedOrganizersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Organisateurs suivis'**
  String get profileFollowedOrganizersTitle;

  /// No description provided for @profileFollowedOrganizersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les organisateurs que vous suivez'**
  String get profileFollowedOrganizersSubtitle;

  /// No description provided for @profileMembershipsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes adhésions'**
  String get profileMembershipsTitle;

  /// No description provided for @profileMembershipsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Adhésions, invitations, événements privés'**
  String get profileMembershipsSubtitle;

  /// No description provided for @profileMessagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes messages'**
  String get profileMessagesTitle;

  /// No description provided for @profileMessagesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Conversations avec les organisateurs'**
  String get profileMessagesSubtitle;

  /// No description provided for @profileTripsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes sorties'**
  String get profileTripsTitle;

  /// No description provided for @profileTripsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Plans et itinéraires'**
  String get profileTripsSubtitle;

  /// No description provided for @profileRemindersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes rappels'**
  String get profileRemindersTitle;

  /// No description provided for @profileRemindersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappels d\'activités à venir'**
  String get profileRemindersSubtitle;

  /// No description provided for @profileQuestionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes questions'**
  String get profileQuestionsTitle;

  /// No description provided for @profileQuestionsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos questions sur les événements'**
  String get profileQuestionsSubtitle;

  /// No description provided for @userQuestionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes questions'**
  String get userQuestionsTitle;

  /// No description provided for @userQuestionsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos questions.'**
  String get userQuestionsLoadError;

  /// No description provided for @userQuestionsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune question'**
  String get userQuestionsEmptyTitle;

  /// No description provided for @userQuestionsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez encore posé aucune question sur un événement.'**
  String get userQuestionsEmptyBody;

  /// No description provided for @userQuestionsExploreEvents.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir des événements'**
  String get userQuestionsExploreEvents;

  /// No description provided for @userQuestionsDeletedEvent.
  ///
  /// In fr, this message translates to:
  /// **'Événement supprimé'**
  String get userQuestionsDeletedEvent;

  /// No description provided for @userQuestionsOrganizerFallback.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur'**
  String get userQuestionsOrganizerFallback;

  /// No description provided for @userQuestionsRejectedNotice.
  ///
  /// In fr, this message translates to:
  /// **'Cette question a été rejetée par la modération.'**
  String get userQuestionsRejectedNotice;

  /// No description provided for @userQuestionsStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get userQuestionsStatusPending;

  /// No description provided for @userQuestionsStatusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvée'**
  String get userQuestionsStatusApproved;

  /// No description provided for @userQuestionsStatusAnswered.
  ///
  /// In fr, this message translates to:
  /// **'Répondue'**
  String get userQuestionsStatusAnswered;

  /// No description provided for @userQuestionsStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetée'**
  String get userQuestionsStatusRejected;

  /// No description provided for @profileReviewsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes avis'**
  String get profileReviewsTitle;

  /// No description provided for @profileReviewsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos avis et réponses des organisateurs'**
  String get profileReviewsSubtitle;

  /// No description provided for @profileAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get profileAccountTitle;

  /// No description provided for @profileAccountSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier vos informations'**
  String get profileAccountSubtitle;

  /// No description provided for @profileAlertsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes alertes & recherches'**
  String get profileAlertsTitle;

  /// No description provided for @profileAlertsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer vos recherches enregistrées'**
  String get profileAlertsSubtitle;

  /// No description provided for @profileVendorScanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner les billets'**
  String get profileVendorScanTitle;

  /// No description provided for @profileVendorScanSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode vendeur - contrôle d\'accès'**
  String get profileVendorScanSubtitle;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue, thème, confidentialité'**
  String get profileSettingsSubtitle;

  /// No description provided for @profileHelpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aide & support'**
  String get profileHelpTitle;

  /// No description provided for @profileHelpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'FAQ et contact'**
  String get profileHelpSubtitle;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get profileLogout;

  /// No description provided for @profileSignInPromptTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous'**
  String get profileSignInPromptTitle;

  /// No description provided for @profileSignInPromptSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Accédez à vos réservations, favoris et plus encore'**
  String get profileSignInPromptSubtitle;

  /// No description provided for @profileCompletionFirstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get profileCompletionFirstName;

  /// No description provided for @profileCompletionLastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get profileCompletionLastName;

  /// No description provided for @profileCompletionPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Photo'**
  String get profileCompletionPhoto;

  /// No description provided for @profileCompletionBirthDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get profileCompletionBirthDate;

  /// No description provided for @profileCompletionMembershipCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville d\'adhésion'**
  String get profileCompletionMembershipCity;

  /// No description provided for @profileCompletionComplete.
  ///
  /// In fr, this message translates to:
  /// **'Profil complet'**
  String get profileCompletionComplete;

  /// No description provided for @profileCompletionProgress.
  ///
  /// In fr, this message translates to:
  /// **'Profil {completed}/{total} - gagne 50 Hibons'**
  String profileCompletionProgress(int completed, int total);

  /// No description provided for @profileStatsBookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get profileStatsBookings;

  /// No description provided for @profileStatsFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get profileStatsFavorites;

  /// No description provided for @profileStatsReviews.
  ///
  /// In fr, this message translates to:
  /// **'Avis'**
  String get profileStatsReviews;

  /// No description provided for @profileLogoutDialogBody.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get profileLogoutDialogBody;

  /// No description provided for @profileHelpOpenFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir l\'aide'**
  String get profileHelpOpenFailed;

  /// No description provided for @profileAvatarUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil mise à jour'**
  String get profileAvatarUpdated;

  /// No description provided for @profileAvatarUploadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'upload : {message}'**
  String profileAvatarUploadError(String message);

  /// No description provided for @profileLoginRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez vous connecter'**
  String get profileLoginRequired;

  /// No description provided for @profilePersonalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get profilePersonalInfoTitle;

  /// No description provided for @profileFirstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get profileFirstNameLabel;

  /// No description provided for @profileFirstNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le prénom est requis'**
  String get profileFirstNameRequired;

  /// No description provided for @profileLastNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get profileLastNameLabel;

  /// No description provided for @profileLastNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est requis'**
  String get profileLastNameRequired;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get profilePhoneLabel;

  /// No description provided for @profileBirthDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get profileBirthDateLabel;

  /// No description provided for @profileBirthDateUnset.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get profileBirthDateUnset;

  /// No description provided for @profileCityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get profileCityLabel;

  /// No description provided for @profileEmailReadOnlyHelper.
  ///
  /// In fr, this message translates to:
  /// **'L\'email ne peut pas être modifié'**
  String get profileEmailReadOnlyHelper;

  /// No description provided for @profileChangePasswordCta.
  ///
  /// In fr, this message translates to:
  /// **'Changer mon mot de passe'**
  String get profileChangePasswordCta;

  /// No description provided for @profileUploadImageError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'upload de l\'image : {message}'**
  String profileUploadImageError(String message);

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour avec succès'**
  String get profileUpdateSuccess;

  /// No description provided for @profileGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {message}'**
  String profileGenericError(String message);

  /// No description provided for @profileChangePasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get profileChangePasswordTitle;

  /// No description provided for @profileCurrentPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get profileCurrentPasswordLabel;

  /// No description provided for @profileNewPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get profileNewPasswordLabel;

  /// No description provided for @profilePasswordChangeSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe changé avec succès'**
  String get profilePasswordChangeSuccess;

  /// No description provided for @profileChangePasswordSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Changer'**
  String get profileChangePasswordSubmit;

  /// No description provided for @profileParticipantsPersonalizationNotice.
  ///
  /// In fr, this message translates to:
  /// **'Le prénom, la date de naissance, la ville et la relation aident Petit Boo et LeHiboo Expériences à vous proposer des offres et des événements plus pertinents.'**
  String get profileParticipantsPersonalizationNotice;

  /// No description provided for @profileParticipantsAddShort.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get profileParticipantsAddShort;

  /// No description provided for @profileParticipantsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos participants'**
  String get profileParticipantsLoadError;

  /// No description provided for @profileParticipantAdded.
  ///
  /// In fr, this message translates to:
  /// **'Participant ajouté'**
  String get profileParticipantAdded;

  /// No description provided for @profileParticipantUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Participant modifié'**
  String get profileParticipantUpdated;

  /// No description provided for @profileParticipantDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Participant supprimé'**
  String get profileParticipantDeleted;

  /// No description provided for @profileParticipantsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun participant'**
  String get profileParticipantsEmptyTitle;

  /// No description provided for @profileParticipantsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez vos enfants, proches ou participants récurrents pour les choisir rapidement au moment de réserver.'**
  String get profileParticipantsEmptyBody;

  /// No description provided for @profileParticipantsAddCta.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un participant'**
  String get profileParticipantsAddCta;

  /// No description provided for @profileParticipantAddTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un participant'**
  String get profileParticipantAddTitle;

  /// No description provided for @profileParticipantEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le participant'**
  String get profileParticipantEditTitle;

  /// No description provided for @profileParticipantFirstNameLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Prénom *'**
  String get profileParticipantFirstNameLabelRequired;

  /// No description provided for @profileParticipantFirstNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Prénom requis'**
  String get profileParticipantFirstNameRequired;

  /// No description provided for @profileParticipantLastNameLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Nom *'**
  String get profileParticipantLastNameLabelRequired;

  /// No description provided for @profileParticipantLastNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Nom requis'**
  String get profileParticipantLastNameRequired;

  /// No description provided for @profileParticipantNicknameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Surnom'**
  String get profileParticipantNicknameLabel;

  /// No description provided for @profileParticipantRelationshipLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Relation *'**
  String get profileParticipantRelationshipLabelRequired;

  /// No description provided for @profileParticipantRelationshipRequired.
  ///
  /// In fr, this message translates to:
  /// **'Relation requise'**
  String get profileParticipantRelationshipRequired;

  /// No description provided for @profileParticipantBirthDateLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance *'**
  String get profileParticipantBirthDateLabelRequired;

  /// No description provided for @profileParticipantBirthDateRequired.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance requise'**
  String get profileParticipantBirthDateRequired;

  /// No description provided for @profileParticipantBirthDateHint.
  ///
  /// In fr, this message translates to:
  /// **'jj/mm/aaaa'**
  String get profileParticipantBirthDateHint;

  /// No description provided for @profileParticipantCityLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ville d\'appartenance *'**
  String get profileParticipantCityLabelRequired;

  /// No description provided for @profileParticipantCityRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ville requise'**
  String get profileParticipantCityRequired;

  /// No description provided for @messagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesTabOrganizers.
  ///
  /// In fr, this message translates to:
  /// **'Organisateurs'**
  String get messagesTabOrganizers;

  /// No description provided for @messagesTabSupportLeHiboo.
  ///
  /// In fr, this message translates to:
  /// **'Support LeHiboo'**
  String get messagesTabSupportLeHiboo;

  /// No description provided for @messagesTabClients.
  ///
  /// In fr, this message translates to:
  /// **'Clients'**
  String get messagesTabClients;

  /// No description provided for @messagesTabBroadcasts.
  ///
  /// In fr, this message translates to:
  /// **'Diffusions'**
  String get messagesTabBroadcasts;

  /// No description provided for @messagesTabSupport.
  ///
  /// In fr, this message translates to:
  /// **'Support'**
  String get messagesTabSupport;

  /// No description provided for @messagesTabUsers.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get messagesTabUsers;

  /// No description provided for @messagesTabReports.
  ///
  /// In fr, this message translates to:
  /// **'Signalements'**
  String get messagesTabReports;

  /// No description provided for @messagesNewMessage.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau message'**
  String get messagesNewMessage;

  /// No description provided for @messagesContactSupport.
  ///
  /// In fr, this message translates to:
  /// **'Contacter le support'**
  String get messagesContactSupport;

  /// No description provided for @messagesContactParticipant.
  ///
  /// In fr, this message translates to:
  /// **'Contacter un participant'**
  String get messagesContactParticipant;

  /// No description provided for @messagesNewBroadcast.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle diffusion'**
  String get messagesNewBroadcast;

  /// No description provided for @messagesContactPartner.
  ///
  /// In fr, this message translates to:
  /// **'Contacter un partenaire'**
  String get messagesContactPartner;

  /// No description provided for @messagesBroadcastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Diffusion'**
  String get messagesBroadcastTitle;

  /// No description provided for @messagesBroadcastCreateStepTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle diffusion - Étape {step}/{total}'**
  String messagesBroadcastCreateStepTitle(int step, int total);

  /// No description provided for @messagesBroadcastStepRecipients.
  ///
  /// In fr, this message translates to:
  /// **'Destinataires'**
  String get messagesBroadcastStepRecipients;

  /// No description provided for @messagesBroadcastStepReview.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get messagesBroadcastStepReview;

  /// No description provided for @messagesBroadcastSentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Diffusion envoyée avec succès.'**
  String get messagesBroadcastSentSuccess;

  /// No description provided for @messagesBroadcastSlotLabel.
  ///
  /// In fr, this message translates to:
  /// **'Créneau'**
  String get messagesBroadcastSlotLabel;

  /// No description provided for @messagesBroadcastChooseEvent.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un événement'**
  String get messagesBroadcastChooseEvent;

  /// No description provided for @messagesBroadcastSelectEventFirst.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez d\'abord un événement'**
  String get messagesBroadcastSelectEventFirst;

  /// No description provided for @messagesBroadcastLoadingSlots.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des créneaux...'**
  String get messagesBroadcastLoadingSlots;

  /// No description provided for @messagesBroadcastCalculatingRecipients.
  ///
  /// In fr, this message translates to:
  /// **'Calcul des destinataires...'**
  String get messagesBroadcastCalculatingRecipients;

  /// No description provided for @messagesBroadcastRecipientsPreviewError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de calculer les destinataires.'**
  String get messagesBroadcastRecipientsPreviewError;

  /// No description provided for @messagesBroadcastPotentialRecipients.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 destinataire potentiel} other{{count} destinataires potentiels}}'**
  String messagesBroadcastPotentialRecipients(int count);

  /// No description provided for @messagesBroadcastNoRecipientsForSelection.
  ///
  /// In fr, this message translates to:
  /// **'Aucun destinataire trouvé pour cette sélection'**
  String get messagesBroadcastNoRecipientsForSelection;

  /// No description provided for @messagesBroadcastAllSlots.
  ///
  /// In fr, this message translates to:
  /// **'Tous les créneaux'**
  String get messagesBroadcastAllSlots;

  /// No description provided for @messagesBroadcastChooseEventTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un événement'**
  String get messagesBroadcastChooseEventTitle;

  /// No description provided for @messagesBroadcastNoEventsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement trouvé'**
  String get messagesBroadcastNoEventsFound;

  /// No description provided for @messagesBroadcastSubjectLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sujet'**
  String get messagesBroadcastSubjectLabel;

  /// No description provided for @messagesBroadcastSubjectHint.
  ///
  /// In fr, this message translates to:
  /// **'Objet de votre message...'**
  String get messagesBroadcastSubjectHint;

  /// No description provided for @messagesMinimumCharacters.
  ///
  /// In fr, this message translates to:
  /// **'Minimum {count} caractères'**
  String messagesMinimumCharacters(int count);

  /// No description provided for @messagesBroadcastReviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get messagesBroadcastReviewTitle;

  /// No description provided for @messagesRecipientsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Destinataires'**
  String get messagesRecipientsLabel;

  /// No description provided for @messagesBroadcastRecipientsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 destinataire} other{{count} destinataires}}'**
  String messagesBroadcastRecipientsCount(int count);

  /// No description provided for @messagesBroadcastProcessing.
  ///
  /// In fr, this message translates to:
  /// **'L\'envoi est en cours de traitement par le serveur.'**
  String get messagesBroadcastProcessing;

  /// No description provided for @messagesBroadcastStatusSent.
  ///
  /// In fr, this message translates to:
  /// **'Envoyée'**
  String get messagesBroadcastStatusSent;

  /// No description provided for @messagesBroadcastStatusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get messagesBroadcastStatusInProgress;

  /// No description provided for @messagesBroadcastReadLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lus'**
  String get messagesBroadcastReadLabel;

  /// No description provided for @messagesBroadcastConversationsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Conversations'**
  String get messagesBroadcastConversationsLabel;

  /// No description provided for @messagesBroadcastTargetedEventsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Événements ciblés'**
  String get messagesBroadcastTargetedEventsLabel;

  /// No description provided for @messagesBroadcastSending.
  ///
  /// In fr, this message translates to:
  /// **'En cours d\'envoi...'**
  String get messagesBroadcastSending;

  /// No description provided for @messagesBroadcastSlotFallback.
  ///
  /// In fr, this message translates to:
  /// **'Créneau {id}'**
  String messagesBroadcastSlotFallback(int id);

  /// No description provided for @messagesSupportTicket.
  ///
  /// In fr, this message translates to:
  /// **'Ticket support'**
  String get messagesSupportTicket;

  /// No description provided for @messagesContactUser.
  ///
  /// In fr, this message translates to:
  /// **'Contacter un utilisateur'**
  String get messagesContactUser;

  /// No description provided for @messagesContactOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Contacter un organisateur'**
  String get messagesContactOrganizer;

  /// No description provided for @messagesGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get messagesGenericError;

  /// No description provided for @messagesFallbackOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur'**
  String get messagesFallbackOrganizer;

  /// No description provided for @messagesNewConversationSubtitleSupport.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre problème et notre équipe vous répondra rapidement.'**
  String get messagesNewConversationSubtitleSupport;

  /// No description provided for @messagesNewConversationSubtitleRecipient.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez un destinataire et composez votre message.'**
  String get messagesNewConversationSubtitleRecipient;

  /// No description provided for @messagesNewConversationSubtitleDefault.
  ///
  /// In fr, this message translates to:
  /// **'Composez votre message ci-dessous.'**
  String get messagesNewConversationSubtitleDefault;

  /// No description provided for @messagesRecipientLabel.
  ///
  /// In fr, this message translates to:
  /// **'Destinataire'**
  String get messagesRecipientLabel;

  /// No description provided for @messagesOrganizationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get messagesOrganizationLabel;

  /// No description provided for @messagesParticipantLabel.
  ///
  /// In fr, this message translates to:
  /// **'Participant'**
  String get messagesParticipantLabel;

  /// No description provided for @messagesPartnerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Partenaire'**
  String get messagesPartnerLabel;

  /// No description provided for @messagesSearchUserPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un utilisateur…'**
  String get messagesSearchUserPlaceholder;

  /// No description provided for @messagesSearchOrganizationPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une organisation…'**
  String get messagesSearchOrganizationPlaceholder;

  /// No description provided for @messagesSearchParticipantPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un participant…'**
  String get messagesSearchParticipantPlaceholder;

  /// No description provided for @messagesSearchPartnerPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un partenaire…'**
  String get messagesSearchPartnerPlaceholder;

  /// No description provided for @messagesNoOrganizerAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun organisateur disponible'**
  String get messagesNoOrganizerAvailable;

  /// No description provided for @messagesSelectOrganizerPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un organisateur…'**
  String get messagesSelectOrganizerPlaceholder;

  /// No description provided for @messagesOrganizerPickerHelp.
  ///
  /// In fr, this message translates to:
  /// **'Parcourez les événements pour trouver un organisateur à contacter.'**
  String get messagesOrganizerPickerHelp;

  /// No description provided for @messagesSelectOrganizerRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un organisateur.'**
  String get messagesSelectOrganizerRequired;

  /// No description provided for @messagesFieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est requis.'**
  String get messagesFieldRequired;

  /// No description provided for @messagesEventLabel.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get messagesEventLabel;

  /// No description provided for @messagesOptionalLabel.
  ///
  /// In fr, this message translates to:
  /// **'(optionnel)'**
  String get messagesOptionalLabel;

  /// No description provided for @messagesSupportSubjectPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Quel est le sujet de votre demande ?'**
  String get messagesSupportSubjectPrompt;

  /// No description provided for @messagesSubjectLabel.
  ///
  /// In fr, this message translates to:
  /// **'Objet'**
  String get messagesSubjectLabel;

  /// No description provided for @messagesSubjectHint.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet de votre message'**
  String get messagesSubjectHint;

  /// No description provided for @messagesSubjectRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le sujet est obligatoire.'**
  String get messagesSubjectRequired;

  /// No description provided for @messagesMessageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Message'**
  String get messagesMessageLabel;

  /// No description provided for @messagesMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez votre message…'**
  String get messagesMessageHint;

  /// No description provided for @messagesMessageRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le message est obligatoire.'**
  String get messagesMessageRequired;

  /// No description provided for @messagesSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get messagesSend;

  /// No description provided for @messagesChooseOrganizerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un organisateur'**
  String get messagesChooseOrganizerTitle;

  /// No description provided for @messagesSearchByNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par nom…'**
  String get messagesSearchByNameHint;

  /// No description provided for @messagesNoSearchResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour \"{query}\".'**
  String messagesNoSearchResults(String query);

  /// No description provided for @messagesSearchUserTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un utilisateur'**
  String get messagesSearchUserTitle;

  /// No description provided for @messagesUserSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom, prénom ou e-mail…'**
  String get messagesUserSearchHint;

  /// No description provided for @messagesNoUsersAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur disponible.'**
  String get messagesNoUsersAvailable;

  /// No description provided for @messagesSearchOrganizationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une organisation'**
  String get messagesSearchOrganizationTitle;

  /// No description provided for @messagesOrganizationSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'organisation…'**
  String get messagesOrganizationSearchHint;

  /// No description provided for @messagesNoOrganizationsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune organisation disponible.'**
  String get messagesNoOrganizationsAvailable;

  /// No description provided for @messagesSearchParticipantTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un participant'**
  String get messagesSearchParticipantTitle;

  /// No description provided for @messagesVendorParticipantSearchHelper.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les participants ayant interagi avec votre organisation.'**
  String get messagesVendorParticipantSearchHelper;

  /// No description provided for @messagesNameOrEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom ou e-mail…'**
  String get messagesNameOrEmailHint;

  /// No description provided for @messagesNoParticipantsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun participant disponible.'**
  String get messagesNoParticipantsAvailable;

  /// No description provided for @messagesSearchPartnerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un partenaire'**
  String get messagesSearchPartnerTitle;

  /// No description provided for @messagesPartnerSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'organisation partenaire…'**
  String get messagesPartnerSearchHint;

  /// No description provided for @messagesNoPartnersAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun partenaire disponible.'**
  String get messagesNoPartnersAvailable;

  /// No description provided for @messagesSupportSubjectBookingIssue.
  ///
  /// In fr, this message translates to:
  /// **'Problème de réservation'**
  String get messagesSupportSubjectBookingIssue;

  /// No description provided for @messagesSupportSubjectEventQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question sur un événement'**
  String get messagesSupportSubjectEventQuestion;

  /// No description provided for @messagesSupportSubjectPaymentIssue.
  ///
  /// In fr, this message translates to:
  /// **'Problème de paiement'**
  String get messagesSupportSubjectPaymentIssue;

  /// No description provided for @messagesSupportSubjectRefundRequest.
  ///
  /// In fr, this message translates to:
  /// **'Demande de remboursement'**
  String get messagesSupportSubjectRefundRequest;

  /// No description provided for @messagesSupportSubjectAccountIssue.
  ///
  /// In fr, this message translates to:
  /// **'Problème de compte'**
  String get messagesSupportSubjectAccountIssue;

  /// No description provided for @messagesSupportSubjectContentReport.
  ///
  /// In fr, this message translates to:
  /// **'Signalement d\'un contenu'**
  String get messagesSupportSubjectContentReport;

  /// No description provided for @messagesCreateConversation.
  ///
  /// In fr, this message translates to:
  /// **'Créer la conversation'**
  String get messagesCreateConversation;

  /// No description provided for @messagesNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get messagesNoResults;

  /// No description provided for @messagesSelectUserRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un utilisateur.'**
  String get messagesSelectUserRequired;

  /// No description provided for @messagesSelectOrganizationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une organisation.'**
  String get messagesSelectOrganizationRequired;

  /// No description provided for @messagesSelectParticipantRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un participant.'**
  String get messagesSelectParticipantRequired;

  /// No description provided for @messagesSelectPartnerRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un partenaire.'**
  String get messagesSelectPartnerRequired;

  /// No description provided for @messagesNoAcceptedPartners.
  ///
  /// In fr, this message translates to:
  /// **'Aucun partenaire accepté'**
  String get messagesNoAcceptedPartners;

  /// No description provided for @messagesVendorParticipantAccessDenied.
  ///
  /// In fr, this message translates to:
  /// **'Ce participant n\'a pas d\'interaction avec votre organisation.'**
  String get messagesVendorParticipantAccessDenied;

  /// No description provided for @messagesVendorPartnerAccessDenied.
  ///
  /// In fr, this message translates to:
  /// **'Ce partenariat n\'est pas accepté.'**
  String get messagesVendorPartnerAccessDenied;

  /// No description provided for @messagesAccessDenied.
  ///
  /// In fr, this message translates to:
  /// **'Accès refusé.'**
  String get messagesAccessDenied;

  /// No description provided for @messagesNoConversations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation'**
  String get messagesNoConversations;

  /// No description provided for @messagesNoSupportConversations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation avec le support'**
  String get messagesNoSupportConversations;

  /// No description provided for @messagesNoClients.
  ///
  /// In fr, this message translates to:
  /// **'Aucun client'**
  String get messagesNoClients;

  /// No description provided for @messagesNoBroadcasts.
  ///
  /// In fr, this message translates to:
  /// **'Aucune diffusion envoyée'**
  String get messagesNoBroadcasts;

  /// No description provided for @messagesNoPartners.
  ///
  /// In fr, this message translates to:
  /// **'Aucun partenaire'**
  String get messagesNoPartners;

  /// No description provided for @messagesNoSupportTickets.
  ///
  /// In fr, this message translates to:
  /// **'Aucun ticket support'**
  String get messagesNoSupportTickets;

  /// No description provided for @messagesNoReports.
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement'**
  String get messagesNoReports;

  /// No description provided for @messagesLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String messagesLoadError(String error);

  /// No description provided for @messagesSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher…'**
  String get messagesSearchHint;

  /// No description provided for @messagesFilterReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get messagesFilterReset;

  /// No description provided for @messagesFilterUnread.
  ///
  /// In fr, this message translates to:
  /// **'Non lus'**
  String get messagesFilterUnread;

  /// No description provided for @messagesFilterOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouverts'**
  String get messagesFilterOpen;

  /// No description provided for @messagesFilterClosed.
  ///
  /// In fr, this message translates to:
  /// **'Fermés'**
  String get messagesFilterClosed;

  /// No description provided for @messagesFilterThisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get messagesFilterThisWeek;

  /// No description provided for @messagesFilterThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get messagesFilterThisMonth;

  /// No description provided for @messagesFilterOlder.
  ///
  /// In fr, this message translates to:
  /// **'Plus ancien'**
  String get messagesFilterOlder;

  /// No description provided for @messagesReasonInappropriate.
  ///
  /// In fr, this message translates to:
  /// **'Contenu inapproprié'**
  String get messagesReasonInappropriate;

  /// No description provided for @messagesReasonHarassment.
  ///
  /// In fr, this message translates to:
  /// **'Harcèlement'**
  String get messagesReasonHarassment;

  /// No description provided for @messagesReasonSpam.
  ///
  /// In fr, this message translates to:
  /// **'Spam'**
  String get messagesReasonSpam;

  /// No description provided for @messagesReasonOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get messagesReasonOther;

  /// No description provided for @messagesReportLabel.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get messagesReportLabel;

  /// No description provided for @messagesReportedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Signalé'**
  String get messagesReportedLabel;

  /// No description provided for @messagesReportBadge.
  ///
  /// In fr, this message translates to:
  /// **'Signalement'**
  String get messagesReportBadge;

  /// No description provided for @messagesStatusClosed.
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get messagesStatusClosed;

  /// No description provided for @messagesStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get messagesStatusPending;

  /// No description provided for @messagesStatusOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get messagesStatusOpen;

  /// No description provided for @messagesNotificationOpenAction.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir'**
  String get messagesNotificationOpenAction;

  /// No description provided for @messagesDeletedPreview.
  ///
  /// In fr, this message translates to:
  /// **'Message supprimé'**
  String get messagesDeletedPreview;

  /// No description provided for @messagesRelativeJustNow.
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant'**
  String get messagesRelativeJustNow;

  /// No description provided for @messagesRelativeDaysShort.
  ///
  /// In fr, this message translates to:
  /// **'{count}j'**
  String messagesRelativeDaysShort(int count);

  /// No description provided for @messagesComposerHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre message…'**
  String get messagesComposerHint;

  /// No description provided for @messagesComposerClosed.
  ///
  /// In fr, this message translates to:
  /// **'Cette conversation est fermée'**
  String get messagesComposerClosed;

  /// No description provided for @messagesDeletedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ce message a été supprimé'**
  String get messagesDeletedMessage;

  /// No description provided for @messagesEditedSuffix.
  ///
  /// In fr, this message translates to:
  /// **'(modifié)'**
  String get messagesEditedSuffix;

  /// No description provided for @messagesEditAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get messagesEditAction;

  /// No description provided for @messagesCopyTextAction.
  ///
  /// In fr, this message translates to:
  /// **'Copier le texte'**
  String get messagesCopyTextAction;

  /// No description provided for @messagesDeleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get messagesDeleteAction;

  /// No description provided for @messagesReopenTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Rouvrir'**
  String get messagesReopenTooltip;

  /// No description provided for @messagesCloseConversation.
  ///
  /// In fr, this message translates to:
  /// **'Fermer la conversation'**
  String get messagesCloseConversation;

  /// No description provided for @messagesReadonlyBanner.
  ///
  /// In fr, this message translates to:
  /// **'Mode lecture seule - conversation liée à un signalement. Vous observez les échanges entre les deux parties.'**
  String get messagesReadonlyBanner;

  /// No description provided for @messagesClosedNotice.
  ///
  /// In fr, this message translates to:
  /// **'Cette conversation est fermée.'**
  String get messagesClosedNotice;

  /// No description provided for @messagesEmptyThread.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message. Soyez le premier à écrire !'**
  String get messagesEmptyThread;

  /// No description provided for @messagesCloseConversationBody.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous fermer cette conversation ? Vous ne pourrez plus envoyer de messages.'**
  String get messagesCloseConversationBody;

  /// No description provided for @messagesReportSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signaler la conversation'**
  String get messagesReportSheetTitle;

  /// No description provided for @messagesReportSheetSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Aidez-nous à maintenir un environnement sûr en signalant les contenus inappropriés.'**
  String get messagesReportSheetSubtitle;

  /// No description provided for @messagesReportReasonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Raison'**
  String get messagesReportReasonLabel;

  /// No description provided for @messagesReportCommentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Commentaire'**
  String get messagesReportCommentLabel;

  /// No description provided for @messagesReportMinCharsHint.
  ///
  /// In fr, this message translates to:
  /// **'(min. 10 caractères)'**
  String get messagesReportMinCharsHint;

  /// No description provided for @messagesReportReasonRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une raison.'**
  String get messagesReportReasonRequired;

  /// No description provided for @messagesReportCommentMinError.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 10 caractères.'**
  String get messagesReportCommentMinError;

  /// No description provided for @messagesReportCommentHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez le problème…'**
  String get messagesReportCommentHint;

  /// No description provided for @messagesReportSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get messagesReportSubmit;

  /// No description provided for @messagesReportSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signalement transmis'**
  String get messagesReportSuccessTitle;

  /// No description provided for @messagesReportSuccessBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre signalement a bien été transmis à l\'équipe LeHiboo.'**
  String get messagesReportSuccessBody;

  /// No description provided for @messagesReportSupportCreated.
  ///
  /// In fr, this message translates to:
  /// **'Un ticket support a été créé pour le suivi.'**
  String get messagesReportSupportCreated;

  /// No description provided for @messagesSendFailedRetry.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'envoi. Réessayez.'**
  String get messagesSendFailedRetry;

  /// No description provided for @messagesViewAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get messagesViewAction;

  /// No description provided for @messagesAdminReportFallbackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signalement {reportId}'**
  String messagesAdminReportFallbackTitle(String reportId);

  /// No description provided for @messagesAdminReportDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail du signalement'**
  String get messagesAdminReportDetailTitle;

  /// No description provided for @messagesAdminReportNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Signalement introuvable'**
  String get messagesAdminReportNotFound;

  /// No description provided for @messagesUntitledConversation.
  ///
  /// In fr, this message translates to:
  /// **'Conversation sans titre'**
  String get messagesUntitledConversation;

  /// No description provided for @messagesAdminReportPartiesSection.
  ///
  /// In fr, this message translates to:
  /// **'Parties impliquées'**
  String get messagesAdminReportPartiesSection;

  /// No description provided for @messagesAdminReportReporterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rapporteur'**
  String get messagesAdminReportReporterLabel;

  /// No description provided for @messagesAdminReportReportedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Signalé'**
  String get messagesAdminReportReportedLabel;

  /// No description provided for @messagesUserLabel.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get messagesUserLabel;

  /// No description provided for @messagesAdminReportReasonSection.
  ///
  /// In fr, this message translates to:
  /// **'Motif du signalement'**
  String get messagesAdminReportReasonSection;

  /// No description provided for @messagesAdminReportInternalNoteSection.
  ///
  /// In fr, this message translates to:
  /// **'Note interne (non visible par les usagers)'**
  String get messagesAdminReportInternalNoteSection;

  /// No description provided for @messagesAdminReportNoteHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une note de modération…'**
  String get messagesAdminReportNoteHint;

  /// No description provided for @messagesAdminReportNoteSaved.
  ///
  /// In fr, this message translates to:
  /// **'Note enregistrée.'**
  String get messagesAdminReportNoteSaved;

  /// No description provided for @messagesAdminReportModerationActionsSection.
  ///
  /// In fr, this message translates to:
  /// **'Actions de modération'**
  String get messagesAdminReportModerationActionsSection;

  /// No description provided for @messagesAdminReportFinalActionsWarning.
  ///
  /// In fr, this message translates to:
  /// **'Ces actions sont définitives et ne peuvent pas être annulées.'**
  String get messagesAdminReportFinalActionsWarning;

  /// No description provided for @messagesAdminReportDismissAction.
  ///
  /// In fr, this message translates to:
  /// **'Ignorer'**
  String get messagesAdminReportDismissAction;

  /// No description provided for @messagesAdminReportMarkReviewedAction.
  ///
  /// In fr, this message translates to:
  /// **'Marquer traité'**
  String get messagesAdminReportMarkReviewedAction;

  /// No description provided for @messagesAdminReportDismissConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Ce signalement sera marqué comme ignoré. Confirmez-vous cette action ?'**
  String get messagesAdminReportDismissConfirmBody;

  /// No description provided for @messagesAdminReportReviewConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Ce signalement sera marqué comme traité. Confirmez-vous cette action ?'**
  String get messagesAdminReportReviewConfirmBody;

  /// No description provided for @messagesAdminReportDismissedSnackbar.
  ///
  /// In fr, this message translates to:
  /// **'Signalement ignoré.'**
  String get messagesAdminReportDismissedSnackbar;

  /// No description provided for @messagesAdminReportReviewedSnackbar.
  ///
  /// In fr, this message translates to:
  /// **'Signalement marqué comme traité.'**
  String get messagesAdminReportReviewedSnackbar;

  /// No description provided for @messagesAdminReportViewConversation.
  ///
  /// In fr, this message translates to:
  /// **'Voir la conversation liée'**
  String get messagesAdminReportViewConversation;

  /// No description provided for @messagesAdminReportStatusReviewed.
  ///
  /// In fr, this message translates to:
  /// **'Traité'**
  String get messagesAdminReportStatusReviewed;

  /// No description provided for @messagesAdminReportStatusDismissed.
  ///
  /// In fr, this message translates to:
  /// **'Ignoré'**
  String get messagesAdminReportStatusDismissed;

  /// No description provided for @messagesAdminReportStatusSuspended.
  ///
  /// In fr, this message translates to:
  /// **'Suspendu'**
  String get messagesAdminReportStatusSuspended;

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

  /// No description provided for @petitBooStatusResponding.
  ///
  /// In fr, this message translates to:
  /// **'Répond...'**
  String get petitBooStatusResponding;

  /// No description provided for @petitBooStatusAssistantAi.
  ///
  /// In fr, this message translates to:
  /// **'Assistant IA'**
  String get petitBooStatusAssistantAi;

  /// No description provided for @petitBooHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get petitBooHistoryTitle;

  /// No description provided for @petitBooNewConversation.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle conversation'**
  String get petitBooNewConversation;

  /// No description provided for @petitBooServiceUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Petit Boo est temporairement indisponible'**
  String get petitBooServiceUnavailable;

  /// No description provided for @petitBooGreetingMorning.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get petitBooGreetingMorning;

  /// No description provided for @petitBooGreetingAfternoon.
  ///
  /// In fr, this message translates to:
  /// **'Bon après-midi'**
  String get petitBooGreetingAfternoon;

  /// No description provided for @petitBooGreetingEvening.
  ///
  /// In fr, this message translates to:
  /// **'Bonsoir'**
  String get petitBooGreetingEvening;

  /// No description provided for @petitBooGreetingWithName.
  ///
  /// In fr, this message translates to:
  /// **'{greeting} {name} !'**
  String petitBooGreetingWithName(String greeting, String name);

  /// No description provided for @petitBooGreetingNoName.
  ///
  /// In fr, this message translates to:
  /// **'{greeting} !'**
  String petitBooGreetingNoName(String greeting);

  /// No description provided for @petitBooSubtitleWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Que puis-je faire pour vous à {city} ?'**
  String petitBooSubtitleWithCity(String city);

  /// No description provided for @petitBooSubtitleDefault.
  ///
  /// In fr, this message translates to:
  /// **'Comment puis-je vous aider aujourd\'hui ?'**
  String get petitBooSubtitleDefault;

  /// No description provided for @petitBooQuickTonight.
  ///
  /// In fr, this message translates to:
  /// **'Ce soir'**
  String get petitBooQuickTonight;

  /// No description provided for @petitBooQuickTonightPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Que faire ce soir ?'**
  String get petitBooQuickTonightPrompt;

  /// No description provided for @petitBooQuickTonightPromptWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Que faire ce soir à {city} ?'**
  String petitBooQuickTonightPromptWithCity(String city);

  /// No description provided for @petitBooQuickWeekend.
  ///
  /// In fr, this message translates to:
  /// **'Week-end'**
  String get petitBooQuickWeekend;

  /// No description provided for @petitBooQuickWeekendPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Événements ce week-end'**
  String get petitBooQuickWeekendPrompt;

  /// No description provided for @petitBooQuickWeekendPromptWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Événements ce week-end à {city}'**
  String petitBooQuickWeekendPromptWithCity(String city);

  /// No description provided for @petitBooQuickTickets.
  ///
  /// In fr, this message translates to:
  /// **'Mes billets'**
  String get petitBooQuickTickets;

  /// No description provided for @petitBooQuickTicketsPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Affiche mes réservations'**
  String get petitBooQuickTicketsPrompt;

  /// No description provided for @petitBooQuickFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get petitBooQuickFavorites;

  /// No description provided for @petitBooQuickFavoritesPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get petitBooQuickFavoritesPrompt;

  /// No description provided for @petitBooTryAsking.
  ///
  /// In fr, this message translates to:
  /// **'Essayez de me demander...'**
  String get petitBooTryAsking;

  /// No description provided for @petitBooSuggestionTonight.
  ///
  /// In fr, this message translates to:
  /// **'Quels événements ce soir ?'**
  String get petitBooSuggestionTonight;

  /// No description provided for @petitBooSuggestionTonightWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Quels événements ce soir à {city} ?'**
  String petitBooSuggestionTonightWithCity(String city);

  /// No description provided for @petitBooSuggestionKids.
  ///
  /// In fr, this message translates to:
  /// **'Activités pour enfants ce week-end'**
  String get petitBooSuggestionKids;

  /// No description provided for @petitBooSuggestionKidsWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Activités pour enfants à {city}'**
  String petitBooSuggestionKidsWithCity(String city);

  /// No description provided for @petitBooSuggestionFood.
  ///
  /// In fr, this message translates to:
  /// **'Sorties gastronomiques ce week-end'**
  String get petitBooSuggestionFood;

  /// No description provided for @petitBooSuggestionFoodWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Sorties gastronomiques à {city}'**
  String petitBooSuggestionFoodWithCity(String city);

  /// No description provided for @petitBooSuggestionConcerts.
  ///
  /// In fr, this message translates to:
  /// **'Concerts et spectacles à venir'**
  String get petitBooSuggestionConcerts;

  /// No description provided for @petitBooSuggestionConcertsWithCity.
  ///
  /// In fr, this message translates to:
  /// **'Concerts et spectacles à {city}'**
  String petitBooSuggestionConcertsWithCity(String city);

  /// No description provided for @petitBooEmptyHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation'**
  String get petitBooEmptyHistoryTitle;

  /// No description provided for @petitBooEmptyHistoryBody.
  ///
  /// In fr, this message translates to:
  /// **'Démarrez une conversation avec Petit Boo\npour obtenir de l\'aide personnalisée'**
  String get petitBooEmptyHistoryBody;

  /// No description provided for @petitBooErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Oups !'**
  String get petitBooErrorTitle;

  /// No description provided for @petitBooDeleteConversationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette conversation ?'**
  String get petitBooDeleteConversationTitle;

  /// No description provided for @petitBooDeleteConversationBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get petitBooDeleteConversationBody;

  /// No description provided for @petitBooConversationDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Conversation supprimée'**
  String get petitBooConversationDeleted;

  /// No description provided for @petitBooConversationFallbackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conversation'**
  String get petitBooConversationFallbackTitle;

  /// No description provided for @petitBooConversationsAuthRequired.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour voir vos conversations'**
  String get petitBooConversationsAuthRequired;

  /// No description provided for @petitBooConversationsLoadFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les conversations'**
  String get petitBooConversationsLoadFailed;

  /// No description provided for @petitBooEngagementWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour ! Je peux vous aider ? 🌟'**
  String get petitBooEngagementWelcome;

  /// No description provided for @petitBooEngagementInspiration.
  ///
  /// In fr, this message translates to:
  /// **'Vous cherchez l\'inspiration ? 💡'**
  String get petitBooEngagementInspiration;

  /// No description provided for @petitBooEngagementNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Oups, rien trouvé ? Je peux chercher pour vous ! 🕵️‍♂️'**
  String get petitBooEngagementNoResults;

  /// No description provided for @petitBooEngagementIdle.
  ///
  /// In fr, this message translates to:
  /// **'Psst... Je connais des coins sympas ! 🗺️'**
  String get petitBooEngagementIdle;

  /// No description provided for @petitBooRelativeDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il y a 1 jour} other{Il y a {count} jours}}'**
  String petitBooRelativeDaysAgo(int count);

  /// No description provided for @petitBooMessageCountShort.
  ///
  /// In fr, this message translates to:
  /// **'{count} msg'**
  String petitBooMessageCountShort(int count);

  /// No description provided for @petitBooBrainTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire de Petit Boo'**
  String get petitBooBrainTitle;

  /// No description provided for @petitBooMemoryKnownTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce que je sais sur vous'**
  String get petitBooMemoryKnownTitle;

  /// No description provided for @petitBooMemoryClearAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer'**
  String get petitBooMemoryClearAll;

  /// No description provided for @petitBooMemoryEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire activée'**
  String get petitBooMemoryEnabled;

  /// No description provided for @petitBooMemoryPaused.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire en pause'**
  String get petitBooMemoryPaused;

  /// No description provided for @petitBooMemoryEnabledDescription.
  ///
  /// In fr, this message translates to:
  /// **'Petit Boo apprend de vos échanges pour vous proposer des sorties qui vous ressemblent. Vous pouvez corriger ou supprimer ces infos ci-dessous.'**
  String get petitBooMemoryEnabledDescription;

  /// No description provided for @petitBooMemoryPausedDescription.
  ///
  /// In fr, this message translates to:
  /// **'Petit Boo ne retient plus rien de vos nouvelles conversations. Les anciennes informations restent stockées mais ne sont pas utilisées.'**
  String get petitBooMemoryPausedDescription;

  /// No description provided for @petitBooMemoryEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Je n\'ai pas encore d\'infos sur vous.'**
  String get petitBooMemoryEmptyTitle;

  /// No description provided for @petitBooMemoryEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Discutez avec moi pour que j\'apprenne vos goûts.'**
  String get petitBooMemoryEmptyBody;

  /// No description provided for @petitBooMemoryDisabledBody.
  ///
  /// In fr, this message translates to:
  /// **'Réactivez la mémoire pour voir et modifier vos informations.'**
  String get petitBooMemoryDisabledBody;

  /// No description provided for @petitBooMemoryEditAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get petitBooMemoryEditAction;

  /// No description provided for @petitBooMemoryForgetAction.
  ///
  /// In fr, this message translates to:
  /// **'Oublier'**
  String get petitBooMemoryForgetAction;

  /// No description provided for @petitBooMemoryEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier {label}'**
  String petitBooMemoryEditTitle(String label);

  /// No description provided for @petitBooMemoryNewValueHint.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle valeur'**
  String get petitBooMemoryNewValueHint;

  /// No description provided for @petitBooMemoryForgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Oublier cette info ?'**
  String get petitBooMemoryForgetTitle;

  /// No description provided for @petitBooMemoryForgetBody.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment que Petit Boo oublie : {label} ?'**
  String petitBooMemoryForgetBody(String label);

  /// No description provided for @petitBooMemoryNoKeep.
  ///
  /// In fr, this message translates to:
  /// **'Non, garder'**
  String get petitBooMemoryNoKeep;

  /// No description provided for @petitBooMemoryForgetConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Oui, oublier'**
  String get petitBooMemoryForgetConfirm;

  /// No description provided for @petitBooMemoryClearAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer ?'**
  String get petitBooMemoryClearAllTitle;

  /// No description provided for @petitBooMemoryClearAllBody.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment effacer toutes les informations que Petit Boo a apprises sur vous ?'**
  String get petitBooMemoryClearAllBody;

  /// No description provided for @petitBooMemoryClearAllConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Oui, tout effacer'**
  String get petitBooMemoryClearAllConfirm;

  /// No description provided for @petitBooMemoryLabelFirstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get petitBooMemoryLabelFirstName;

  /// No description provided for @petitBooMemoryLabelLastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get petitBooMemoryLabelLastName;

  /// No description provided for @petitBooMemoryLabelNickname.
  ///
  /// In fr, this message translates to:
  /// **'Surnom'**
  String get petitBooMemoryLabelNickname;

  /// No description provided for @petitBooMemoryLabelAge.
  ///
  /// In fr, this message translates to:
  /// **'Âge'**
  String get petitBooMemoryLabelAge;

  /// No description provided for @petitBooMemoryLabelBirthYear.
  ///
  /// In fr, this message translates to:
  /// **'Année de naissance'**
  String get petitBooMemoryLabelBirthYear;

  /// No description provided for @petitBooMemoryLabelAgeGroup.
  ///
  /// In fr, this message translates to:
  /// **'Tranche d\'âge'**
  String get petitBooMemoryLabelAgeGroup;

  /// No description provided for @petitBooMemoryLabelCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get petitBooMemoryLabelCity;

  /// No description provided for @petitBooMemoryLabelRegion.
  ///
  /// In fr, this message translates to:
  /// **'Région'**
  String get petitBooMemoryLabelRegion;

  /// No description provided for @petitBooMemoryLabelCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get petitBooMemoryLabelCountry;

  /// No description provided for @petitBooMemoryLabelLatitude.
  ///
  /// In fr, this message translates to:
  /// **'Latitude'**
  String get petitBooMemoryLabelLatitude;

  /// No description provided for @petitBooMemoryLabelLongitude.
  ///
  /// In fr, this message translates to:
  /// **'Longitude'**
  String get petitBooMemoryLabelLongitude;

  /// No description provided for @petitBooMemoryLabelMaxDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance max (km)'**
  String get petitBooMemoryLabelMaxDistance;

  /// No description provided for @petitBooMemoryLabelFavoriteActivities.
  ///
  /// In fr, this message translates to:
  /// **'Activités préférées'**
  String get petitBooMemoryLabelFavoriteActivities;

  /// No description provided for @petitBooMemoryLabelDislikedActivities.
  ///
  /// In fr, this message translates to:
  /// **'Activités à éviter'**
  String get petitBooMemoryLabelDislikedActivities;

  /// No description provided for @petitBooMemoryLabelFavoriteCategories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories préférées'**
  String get petitBooMemoryLabelFavoriteCategories;

  /// No description provided for @petitBooMemoryLabelBudgetPreference.
  ///
  /// In fr, this message translates to:
  /// **'Budget'**
  String get petitBooMemoryLabelBudgetPreference;

  /// No description provided for @petitBooMemoryLabelGroupType.
  ///
  /// In fr, this message translates to:
  /// **'Type de groupe'**
  String get petitBooMemoryLabelGroupType;

  /// No description provided for @petitBooMemoryLabelHasChildren.
  ///
  /// In fr, this message translates to:
  /// **'A des enfants'**
  String get petitBooMemoryLabelHasChildren;

  /// No description provided for @petitBooMemoryLabelChildrenAges.
  ///
  /// In fr, this message translates to:
  /// **'Âge des enfants'**
  String get petitBooMemoryLabelChildrenAges;

  /// No description provided for @petitBooMemoryLabelDietaryPreferences.
  ///
  /// In fr, this message translates to:
  /// **'Régime alimentaire'**
  String get petitBooMemoryLabelDietaryPreferences;

  /// No description provided for @petitBooMemoryLabelMobilityConstraints.
  ///
  /// In fr, this message translates to:
  /// **'Contraintes de mobilité'**
  String get petitBooMemoryLabelMobilityConstraints;

  /// No description provided for @petitBooMemoryLabelPetFriendlyNeeded.
  ///
  /// In fr, this message translates to:
  /// **'Animaux acceptés'**
  String get petitBooMemoryLabelPetFriendlyNeeded;

  /// No description provided for @petitBooMemoryLabelPreferredTimes.
  ///
  /// In fr, this message translates to:
  /// **'Moments préférés'**
  String get petitBooMemoryLabelPreferredTimes;

  /// No description provided for @petitBooMemoryLabelPreferredLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue préférée'**
  String get petitBooMemoryLabelPreferredLanguage;

  /// No description provided for @petitBooMemoryLabelInterests.
  ///
  /// In fr, this message translates to:
  /// **'Centres d\'intérêt'**
  String get petitBooMemoryLabelInterests;

  /// No description provided for @petitBooMemoryLabelLastUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour'**
  String get petitBooMemoryLabelLastUpdated;

  /// No description provided for @petitBooMemoryUndefined.
  ///
  /// In fr, this message translates to:
  /// **'Non défini'**
  String get petitBooMemoryUndefined;

  /// No description provided for @petitBooMemoryYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get petitBooMemoryYes;

  /// No description provided for @petitBooMemoryNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get petitBooMemoryNo;

  /// No description provided for @petitBooMemoryAgeGroupYoungAdult.
  ///
  /// In fr, this message translates to:
  /// **'Jeune adulte'**
  String get petitBooMemoryAgeGroupYoungAdult;

  /// No description provided for @petitBooMemoryAgeGroupAdult.
  ///
  /// In fr, this message translates to:
  /// **'Adulte'**
  String get petitBooMemoryAgeGroupAdult;

  /// No description provided for @petitBooMemoryAgeGroupSenior.
  ///
  /// In fr, this message translates to:
  /// **'Senior'**
  String get petitBooMemoryAgeGroupSenior;

  /// No description provided for @petitBooMemoryBudgetLow.
  ///
  /// In fr, this message translates to:
  /// **'Petit budget'**
  String get petitBooMemoryBudgetLow;

  /// No description provided for @petitBooMemoryBudgetMedium.
  ///
  /// In fr, this message translates to:
  /// **'Budget moyen'**
  String get petitBooMemoryBudgetMedium;

  /// No description provided for @petitBooMemoryBudgetHigh.
  ///
  /// In fr, this message translates to:
  /// **'Gros budget'**
  String get petitBooMemoryBudgetHigh;

  /// No description provided for @petitBooMemoryGroupSolo.
  ///
  /// In fr, this message translates to:
  /// **'Seul(e)'**
  String get petitBooMemoryGroupSolo;

  /// No description provided for @petitBooMemoryGroupCouple.
  ///
  /// In fr, this message translates to:
  /// **'En couple'**
  String get petitBooMemoryGroupCouple;

  /// No description provided for @petitBooMemoryGroupFamily.
  ///
  /// In fr, this message translates to:
  /// **'En famille'**
  String get petitBooMemoryGroupFamily;

  /// No description provided for @petitBooMemoryGroupFriends.
  ///
  /// In fr, this message translates to:
  /// **'Entre amis'**
  String get petitBooMemoryGroupFriends;

  /// No description provided for @petitBooQuotaHeaderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos messages avec Petit Boo'**
  String get petitBooQuotaHeaderTitle;

  /// No description provided for @petitBooQuotaHeaderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionne votre quota'**
  String get petitBooQuotaHeaderSubtitle;

  /// No description provided for @petitBooQuotaRemainingLabel.
  ///
  /// In fr, this message translates to:
  /// **'restants'**
  String get petitBooQuotaRemainingLabel;

  /// No description provided for @petitBooQuotaUsage.
  ///
  /// In fr, this message translates to:
  /// **'{used, plural, =1{1 message utilisé} other{{used} messages utilisés}} sur {limit}'**
  String petitBooQuotaUsage(int used, int limit);

  /// No description provided for @petitBooQuotaRenewalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Renouvellement {period}'**
  String petitBooQuotaRenewalTitle(String period);

  /// No description provided for @petitBooQuotaRenewsAt.
  ///
  /// In fr, this message translates to:
  /// **'Votre quota se renouvelle {time}'**
  String petitBooQuotaRenewsAt(String time);

  /// No description provided for @petitBooQuotaRenewsAutomatically.
  ///
  /// In fr, this message translates to:
  /// **'Votre quota se renouvelle automatiquement'**
  String get petitBooQuotaRenewsAutomatically;

  /// No description provided for @petitBooQuotaTipTitle.
  ///
  /// In fr, this message translates to:
  /// **'Astuce'**
  String get petitBooQuotaTipTitle;

  /// No description provided for @petitBooQuotaTipDescription.
  ///
  /// In fr, this message translates to:
  /// **'Posez des questions précises pour obtenir des réponses plus pertinentes et économiser vos messages.'**
  String get petitBooQuotaTipDescription;

  /// No description provided for @petitBooQuotaWhyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi un quota ?'**
  String get petitBooQuotaWhyTitle;

  /// No description provided for @petitBooQuotaWhyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Petit Boo utilise une IA avancée pour vous aider. Le quota nous permet de garantir un service de qualité pour tous.'**
  String get petitBooQuotaWhyDescription;

  /// No description provided for @petitBooQuotaUnderstood.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai compris'**
  String get petitBooQuotaUnderstood;

  /// No description provided for @petitBooQuotaPeriodDaily.
  ///
  /// In fr, this message translates to:
  /// **'quotidien'**
  String get petitBooQuotaPeriodDaily;

  /// No description provided for @petitBooQuotaPeriodWeekly.
  ///
  /// In fr, this message translates to:
  /// **'hebdomadaire'**
  String get petitBooQuotaPeriodWeekly;

  /// No description provided for @petitBooQuotaPeriodMonthly.
  ///
  /// In fr, this message translates to:
  /// **'mensuel'**
  String get petitBooQuotaPeriodMonthly;

  /// No description provided for @petitBooQuotaPeriodAutomatic.
  ///
  /// In fr, this message translates to:
  /// **'automatique'**
  String get petitBooQuotaPeriodAutomatic;

  /// No description provided for @petitBooQuotaResetVerySoon.
  ///
  /// In fr, this message translates to:
  /// **'très bientôt'**
  String get petitBooQuotaResetVerySoon;

  /// No description provided for @petitBooQuotaResetInDays.
  ///
  /// In fr, this message translates to:
  /// **'dans {count, plural, =1{1 jour} other{{count} jours}}'**
  String petitBooQuotaResetInDays(int count);

  /// No description provided for @petitBooQuotaResetTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'demain'**
  String get petitBooQuotaResetTomorrow;

  /// No description provided for @petitBooQuotaResetInHours.
  ///
  /// In fr, this message translates to:
  /// **'dans {count, plural, =1{1 heure} other{{count} heures}}'**
  String petitBooQuotaResetInHours(int count);

  /// No description provided for @petitBooQuotaResetInOneHour.
  ///
  /// In fr, this message translates to:
  /// **'dans 1 heure'**
  String get petitBooQuotaResetInOneHour;

  /// No description provided for @petitBooQuotaResetInMinutes.
  ///
  /// In fr, this message translates to:
  /// **'dans {count, plural, =1{1 minute} other{{count} minutes}}'**
  String petitBooQuotaResetInMinutes(int count);

  /// No description provided for @petitBooQuotaResetSoon.
  ///
  /// In fr, this message translates to:
  /// **'dans quelques instants'**
  String get petitBooQuotaResetSoon;

  /// No description provided for @petitBooQuotaResetAutomatically.
  ///
  /// In fr, this message translates to:
  /// **'automatiquement'**
  String get petitBooQuotaResetAutomatically;

  /// No description provided for @petitBooQuotaDisplayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quota de messages'**
  String get petitBooQuotaDisplayTitle;

  /// No description provided for @petitBooQuotaDisplayResets.
  ///
  /// In fr, this message translates to:
  /// **'Renouvellement : {time}'**
  String petitBooQuotaDisplayResets(String time);

  /// No description provided for @petitBooLimitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Oups, c\'est déjà fini ?'**
  String get petitBooLimitTitle;

  /// No description provided for @petitBooLimitBody.
  ///
  /// In fr, this message translates to:
  /// **'Petit Boo a besoin d\'énergie pour continuer à chercher des pépites pour vous. Rechargez son stock de Hibons pour débloquer la conversation.'**
  String get petitBooLimitBody;

  /// No description provided for @petitBooLimitWalletBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde : {balance} Hibons'**
  String petitBooLimitWalletBalance(int balance);

  /// No description provided for @petitBooLimitContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer pour {cost} Hibons (+{messages, plural, =1{1 msg} other{{messages} msg}})'**
  String petitBooLimitContinue(int cost, int messages);

  /// No description provided for @petitBooLimitWatchAdReward.
  ///
  /// In fr, this message translates to:
  /// **'Regarder une pub (+{amount} Hibons)'**
  String petitBooLimitWatchAdReward(int amount);

  /// No description provided for @petitBooLimitComeBackTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Revenez demain pour de nouveaux messages.'**
  String get petitBooLimitComeBackTomorrow;

  /// No description provided for @petitBooMaybeLater.
  ///
  /// In fr, this message translates to:
  /// **'Peut-être plus tard'**
  String get petitBooMaybeLater;

  /// No description provided for @petitBooConversationUnlocked.
  ///
  /// In fr, this message translates to:
  /// **'Conversation débloquée.'**
  String get petitBooConversationUnlocked;

  /// No description provided for @petitBooUnlockFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de débloquer la conversation'**
  String get petitBooUnlockFailed;

  /// No description provided for @petitBooComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalité bientôt disponible.'**
  String get petitBooComingSoon;

  /// No description provided for @petitBooErrorWithMessage.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {message}'**
  String petitBooErrorWithMessage(String message);

  /// No description provided for @petitBooFavoriteAddedWithTitle.
  ///
  /// In fr, this message translates to:
  /// **'\"{eventTitle}\" ajouté aux favoris'**
  String petitBooFavoriteAddedWithTitle(String eventTitle);

  /// No description provided for @petitBooFavoriteAdded.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté aux favoris'**
  String get petitBooFavoriteAdded;

  /// No description provided for @petitBooFavoriteRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Retiré des favoris'**
  String get petitBooFavoriteRemoved;

  /// No description provided for @petitBooHibonsEarned.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} Hibons gagnés !'**
  String petitBooHibonsEarned(int amount);

  /// No description provided for @petitBooToolFavoritesDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mes événements favoris'**
  String get petitBooToolFavoritesDescription;

  /// No description provided for @petitBooToolFavoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes favoris'**
  String get petitBooToolFavoritesTitle;

  /// No description provided for @petitBooToolFavoritesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori'**
  String get petitBooToolFavoritesEmpty;

  /// No description provided for @petitBooToolSearchEventsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Recherche d\'événements'**
  String get petitBooToolSearchEventsDescription;

  /// No description provided for @petitBooToolSearchEventsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Événements trouvés'**
  String get petitBooToolSearchEventsTitle;

  /// No description provided for @petitBooToolSearchEventsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement trouvé avec ces critères'**
  String get petitBooToolSearchEventsEmpty;

  /// No description provided for @petitBooToolFreeBadge.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get petitBooToolFreeBadge;

  /// No description provided for @petitBooToolBookingsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get petitBooToolBookingsDescription;

  /// No description provided for @petitBooToolBookingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes réservations'**
  String get petitBooToolBookingsTitle;

  /// No description provided for @petitBooToolBookingsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation'**
  String get petitBooToolBookingsEmpty;

  /// No description provided for @petitBooToolTicketsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mes billets'**
  String get petitBooToolTicketsDescription;

  /// No description provided for @petitBooToolTicketsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes billets'**
  String get petitBooToolTicketsTitle;

  /// No description provided for @petitBooToolTicketsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun billet'**
  String get petitBooToolTicketsEmpty;

  /// No description provided for @petitBooToolEventDetailsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Détails d\'un événement'**
  String get petitBooToolEventDetailsDescription;

  /// No description provided for @petitBooToolAlertsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mes alertes'**
  String get petitBooToolAlertsDescription;

  /// No description provided for @petitBooToolAlertsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes alertes'**
  String get petitBooToolAlertsTitle;

  /// No description provided for @petitBooToolAlertsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune alerte'**
  String get petitBooToolAlertsEmpty;

  /// No description provided for @petitBooToolProfileDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get petitBooToolProfileDescription;

  /// No description provided for @petitBooToolProfileStatBookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get petitBooToolProfileStatBookings;

  /// No description provided for @petitBooToolProfileStatParticipations.
  ///
  /// In fr, this message translates to:
  /// **'Participations'**
  String get petitBooToolProfileStatParticipations;

  /// No description provided for @petitBooToolProfileStatFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get petitBooToolProfileStatFavorites;

  /// No description provided for @petitBooToolProfileStatAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get petitBooToolProfileStatAlerts;

  /// No description provided for @petitBooToolNotificationsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mes notifications'**
  String get petitBooToolNotificationsDescription;

  /// No description provided for @petitBooToolNotificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes notifications'**
  String get petitBooToolNotificationsTitle;

  /// No description provided for @petitBooToolNotificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get petitBooToolNotificationsEmpty;

  /// No description provided for @petitBooToolBrainDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ma mémoire'**
  String get petitBooToolBrainDescription;

  /// No description provided for @petitBooToolBrainTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce que je sais de toi'**
  String get petitBooToolBrainTitle;

  /// No description provided for @petitBooToolBrainEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Je ne sais encore rien. Discutons.'**
  String get petitBooToolBrainEmpty;

  /// No description provided for @petitBooToolBrainSectionFamily.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get petitBooToolBrainSectionFamily;

  /// No description provided for @petitBooToolBrainSectionLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get petitBooToolBrainSectionLocation;

  /// No description provided for @petitBooToolBrainSectionPreferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get petitBooToolBrainSectionPreferences;

  /// No description provided for @petitBooToolBrainSectionConstraints.
  ///
  /// In fr, this message translates to:
  /// **'Contraintes'**
  String get petitBooToolBrainSectionConstraints;

  /// No description provided for @petitBooToolUpdateBrainDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour ma mémoire'**
  String get petitBooToolUpdateBrainDescription;

  /// No description provided for @petitBooToolAddFavoriteDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get petitBooToolAddFavoriteDescription;

  /// No description provided for @petitBooToolRemoveFavoriteDescription.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get petitBooToolRemoveFavoriteDescription;

  /// No description provided for @petitBooToolCreateFavoriteListDescription.
  ///
  /// In fr, this message translates to:
  /// **'Créer une liste de favoris'**
  String get petitBooToolCreateFavoriteListDescription;

  /// No description provided for @petitBooToolMoveToListDescription.
  ///
  /// In fr, this message translates to:
  /// **'Déplacer vers une liste'**
  String get petitBooToolMoveToListDescription;

  /// No description provided for @petitBooToolFavoriteListsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes listes de favoris'**
  String get petitBooToolFavoriteListsDescription;

  /// No description provided for @petitBooToolFavoriteListsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes listes de favoris'**
  String get petitBooToolFavoriteListsTitle;

  /// No description provided for @petitBooToolUpdateFavoriteListDescription.
  ///
  /// In fr, this message translates to:
  /// **'Renommer une liste'**
  String get petitBooToolUpdateFavoriteListDescription;

  /// No description provided for @petitBooToolDeleteFavoriteListDescription.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer une liste'**
  String get petitBooToolDeleteFavoriteListDescription;

  /// No description provided for @petitBooToolPlanTripDescription.
  ///
  /// In fr, this message translates to:
  /// **'Planifier un itinéraire'**
  String get petitBooToolPlanTripDescription;

  /// No description provided for @petitBooToolPlanTripTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton itinéraire'**
  String get petitBooToolPlanTripTitle;

  /// No description provided for @petitBooToolSaveTripPlanDescription.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder un plan de sortie'**
  String get petitBooToolSaveTripPlanDescription;

  /// No description provided for @petitBooToolTripPlansDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mes plans de sortie'**
  String get petitBooToolTripPlansDescription;

  /// No description provided for @petitBooToolTripPlansTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes sorties planifiées'**
  String get petitBooToolTripPlansTitle;

  /// No description provided for @petitBooToolTripPlansEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sortie planifiée'**
  String get petitBooToolTripPlansEmpty;

  /// No description provided for @petitBooToolItemCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 élément} other{{count} éléments}}'**
  String petitBooToolItemCount(int count);

  /// No description provided for @petitBooToolViewItems.
  ///
  /// In fr, this message translates to:
  /// **'Voir {count, plural, =1{1 élément} other{les {count} éléments}}'**
  String petitBooToolViewItems(int count);

  /// No description provided for @petitBooToolEmptyListFallback.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément'**
  String get petitBooToolEmptyListFallback;

  /// No description provided for @petitBooToolUntitled.
  ///
  /// In fr, this message translates to:
  /// **'Sans titre'**
  String get petitBooToolUntitled;

  /// No description provided for @petitBooToolStatusActive.
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get petitBooToolStatusActive;

  /// No description provided for @petitBooToolStatusInactive.
  ///
  /// In fr, this message translates to:
  /// **'Inactive'**
  String get petitBooToolStatusInactive;

  /// No description provided for @petitBooToolEventFallbackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get petitBooToolEventFallbackTitle;

  /// No description provided for @petitBooToolEventCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 événement} other{{count} événements}}'**
  String petitBooToolEventCount(int count);

  /// No description provided for @petitBooToolViewEvents.
  ///
  /// In fr, this message translates to:
  /// **'Voir {count, plural, =1{1 événement} other{les {count} événements}}'**
  String petitBooToolViewEvents(int count);

  /// No description provided for @petitBooEventDateTime.
  ///
  /// In fr, this message translates to:
  /// **'{date} à {time}'**
  String petitBooEventDateTime(String date, String time);

  /// No description provided for @petitBooEventAvailabilityAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir les disponibilités'**
  String get petitBooEventAvailabilityAction;

  /// No description provided for @petitBooEventPriceFrom.
  ///
  /// In fr, this message translates to:
  /// **'À partir de'**
  String get petitBooEventPriceFrom;

  /// No description provided for @petitBooEventPriceTiers.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 tarif} other{{count} tarifs}}'**
  String petitBooEventPriceTiers(int count);

  /// No description provided for @petitBooTripSavedPlansCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 plan sauvegardé} other{{count} plans sauvegardés}}'**
  String petitBooTripSavedPlansCount(int count);

  /// No description provided for @petitBooTripStopsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 étape} other{{count} étapes}}'**
  String petitBooTripStopsCount(int count);

  /// No description provided for @petitBooTripMoreStops.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{+1 autre étape} other{+{count} autres étapes}}'**
  String petitBooTripMoreStops(int count);

  /// No description provided for @petitBooTripFallbackStop.
  ///
  /// In fr, this message translates to:
  /// **'Étape'**
  String get petitBooTripFallbackStop;

  /// No description provided for @petitBooTripFallbackListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plan sans titre'**
  String get petitBooTripFallbackListTitle;

  /// No description provided for @petitBooTripLoadErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger tes sorties'**
  String get petitBooTripLoadErrorTitle;

  /// No description provided for @petitBooTripLoadErrorRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessaie dans quelques instants'**
  String get petitBooTripLoadErrorRetry;

  /// No description provided for @petitBooTripEmptyPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Demande-moi de planifier une sortie !'**
  String get petitBooTripEmptyPrompt;

  /// No description provided for @petitBooTripViewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes mes sorties'**
  String get petitBooTripViewAll;

  /// No description provided for @petitBooTripExpandMap.
  ///
  /// In fr, this message translates to:
  /// **'Agrandir la carte'**
  String get petitBooTripExpandMap;

  /// No description provided for @petitBooTripCollapseMap.
  ///
  /// In fr, this message translates to:
  /// **'Réduire'**
  String get petitBooTripCollapseMap;

  /// No description provided for @petitBooTripTipsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conseils'**
  String get petitBooTripTipsTitle;

  /// No description provided for @petitBooTripSave.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get petitBooTripSave;

  /// No description provided for @petitBooTripSaved.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardé'**
  String get petitBooTripSaved;

  /// No description provided for @petitBooTripShowMap.
  ///
  /// In fr, this message translates to:
  /// **'Voir carte'**
  String get petitBooTripShowMap;

  /// No description provided for @petitBooTripHideMap.
  ///
  /// In fr, this message translates to:
  /// **'Masquer carte'**
  String get petitBooTripHideMap;

  /// No description provided for @petitBooTripSavePlanPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde ce plan de sortie'**
  String get petitBooTripSavePlanPrompt;

  /// No description provided for @petitBooTripNoCoordinates.
  ///
  /// In fr, this message translates to:
  /// **'Aucune coordonnée disponible'**
  String get petitBooTripNoCoordinates;

  /// No description provided for @petitBooQuotaExceededError.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez atteint votre limite de messages'**
  String get petitBooQuotaExceededError;

  /// No description provided for @petitBooConnectionError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion'**
  String get petitBooConnectionError;

  /// No description provided for @petitBooAuthRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour discuter avec Petit Boo'**
  String get petitBooAuthRequiredError;

  /// No description provided for @petitBooConversationLoadFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la conversation'**
  String get petitBooConversationLoadFailed;

  /// No description provided for @petitBooApiErrorFallback.
  ///
  /// In fr, this message translates to:
  /// **'Erreur Petit Boo'**
  String get petitBooApiErrorFallback;

  /// No description provided for @petitBooGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get petitBooGenericError;

  /// No description provided for @petitBooBrainManageMemory.
  ///
  /// In fr, this message translates to:
  /// **'Gérer ma mémoire'**
  String get petitBooBrainManageMemory;

  /// No description provided for @petitBooBrainRecommendationHint.
  ///
  /// In fr, this message translates to:
  /// **'Parle-moi de toi pour que je puisse te faire de meilleures recommandations.'**
  String get petitBooBrainRecommendationHint;

  /// No description provided for @petitBooToolHibonsBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde Hibons'**
  String get petitBooToolHibonsBalance;

  /// No description provided for @petitBooToolHibonsAmount.
  ///
  /// In fr, this message translates to:
  /// **'{amount} Hibons'**
  String petitBooToolHibonsAmount(int amount);

  /// No description provided for @petitBooActionView.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get petitBooActionView;

  /// No description provided for @petitBooActionMyFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get petitBooActionMyFavorites;

  /// No description provided for @petitBooActionAddedSuccessfully.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté avec succès'**
  String get petitBooActionAddedSuccessfully;

  /// No description provided for @petitBooActionRemovedSuccessfully.
  ///
  /// In fr, this message translates to:
  /// **'Retiré avec succès'**
  String get petitBooActionRemovedSuccessfully;

  /// No description provided for @petitBooActionBrainNoted.
  ///
  /// In fr, this message translates to:
  /// **'C\'est noté !'**
  String get petitBooActionBrainNoted;

  /// No description provided for @petitBooActionListCreatedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Liste créée'**
  String get petitBooActionListCreatedTitle;

  /// No description provided for @petitBooActionNewListCreated.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle liste créée'**
  String get petitBooActionNewListCreated;

  /// No description provided for @petitBooActionListCreatedWithName.
  ///
  /// In fr, this message translates to:
  /// **'Liste \"{name}\" créée'**
  String petitBooActionListCreatedWithName(String name);

  /// No description provided for @petitBooActionViewList.
  ///
  /// In fr, this message translates to:
  /// **'Voir la liste'**
  String get petitBooActionViewList;

  /// No description provided for @petitBooActionMovedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Déplacé'**
  String get petitBooActionMovedTitle;

  /// No description provided for @petitBooActionMovedToList.
  ///
  /// In fr, this message translates to:
  /// **'\"{eventTitle}\" déplacé vers \"{listName}\"'**
  String petitBooActionMovedToList(String eventTitle, String listName);

  /// No description provided for @petitBooActionMovedSuccessfully.
  ///
  /// In fr, this message translates to:
  /// **'Déplacé avec succès'**
  String get petitBooActionMovedSuccessfully;

  /// No description provided for @petitBooActionMovedToListFallback.
  ///
  /// In fr, this message translates to:
  /// **'Déplacé vers la liste'**
  String get petitBooActionMovedToListFallback;

  /// No description provided for @petitBooActionMyLists.
  ///
  /// In fr, this message translates to:
  /// **'Mes listes'**
  String get petitBooActionMyLists;

  /// No description provided for @petitBooActionListRenamedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Liste renommée'**
  String get petitBooActionListRenamedTitle;

  /// No description provided for @petitBooActionListRenamedWithName.
  ///
  /// In fr, this message translates to:
  /// **'Liste renommée en \"{name}\"'**
  String petitBooActionListRenamedWithName(String name);

  /// No description provided for @petitBooActionListDeletedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Liste supprimée'**
  String get petitBooActionListDeletedTitle;

  /// No description provided for @petitBooActionListDeletedWithName.
  ///
  /// In fr, this message translates to:
  /// **'\"{name}\" supprimée'**
  String petitBooActionListDeletedWithName(String name);

  /// No description provided for @petitBooActionDoneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Action effectuée'**
  String get petitBooActionDoneTitle;

  /// No description provided for @petitBooActionDoneSuccessfully.
  ///
  /// In fr, this message translates to:
  /// **'Effectué avec succès'**
  String get petitBooActionDoneSuccessfully;

  /// No description provided for @petitBooActionBrainProfileUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour'**
  String get petitBooActionBrainProfileUpdated;

  /// No description provided for @petitBooActionBrainFamilyUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Famille mise à jour'**
  String get petitBooActionBrainFamilyUpdated;

  /// No description provided for @petitBooActionBrainPreferenceSaved.
  ///
  /// In fr, this message translates to:
  /// **'Préférence notée'**
  String get petitBooActionBrainPreferenceSaved;

  /// No description provided for @petitBooActionBrainConstraintSaved.
  ///
  /// In fr, this message translates to:
  /// **'Contrainte notée'**
  String get petitBooActionBrainConstraintSaved;

  /// No description provided for @petitBooActionBrainMemoryUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire mise à jour'**
  String get petitBooActionBrainMemoryUpdated;

  /// No description provided for @petitBooActionBrainNotedValue.
  ///
  /// In fr, this message translates to:
  /// **'Noté : {value}'**
  String petitBooActionBrainNotedValue(String value);

  /// No description provided for @petitBooActionBrainRememberFallback.
  ///
  /// In fr, this message translates to:
  /// **'Je me souviendrai de ça'**
  String get petitBooActionBrainRememberFallback;

  /// No description provided for @petitBooActionListRenamedFromTo.
  ///
  /// In fr, this message translates to:
  /// **'\"{oldName}\" → \"{newName}\"'**
  String petitBooActionListRenamedFromTo(String oldName, String newName);

  /// No description provided for @petitBooActionListNewName.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau nom : \"{name}\"'**
  String petitBooActionListNewName(String name);

  /// No description provided for @petitBooActionListRenamedSuccessfully.
  ///
  /// In fr, this message translates to:
  /// **'Liste renommée avec succès'**
  String get petitBooActionListRenamedSuccessfully;

  /// No description provided for @petitBooActionErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Échec'**
  String get petitBooActionErrorTitle;

  /// No description provided for @petitBooActionGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get petitBooActionGenericError;

  /// No description provided for @petitBooFavoriteListsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 liste} other{{count} listes}}'**
  String petitBooFavoriteListsCount(int count);

  /// No description provided for @petitBooFavoriteListsNoName.
  ///
  /// In fr, this message translates to:
  /// **'Sans nom'**
  String get petitBooFavoriteListsNoName;

  /// No description provided for @petitBooFavoriteListsViewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get petitBooFavoriteListsViewAll;

  /// No description provided for @petitBooFavoriteListsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune liste pour le moment'**
  String get petitBooFavoriteListsEmptyTitle;

  /// No description provided for @petitBooFavoriteListsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Demande-moi d\'en créer une.'**
  String get petitBooFavoriteListsEmptyBody;

  /// No description provided for @petitBooFavoriteListEventsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Vide'**
  String get petitBooFavoriteListEventsEmpty;

  /// No description provided for @petitBooFavoriteListEventsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 événement} other{{count} événements}}'**
  String petitBooFavoriteListEventsCount(int count);

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

  /// No description provided for @membershipSearchOrganizationHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une organisation…'**
  String get membershipSearchOrganizationHint;

  /// No description provided for @membershipTabActive.
  ///
  /// In fr, this message translates to:
  /// **'Actives ({count})'**
  String membershipTabActive(int count);

  /// No description provided for @membershipTabPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente ({count})'**
  String membershipTabPending(int count);

  /// No description provided for @membershipTabRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusées ({count})'**
  String membershipTabRejected(int count);

  /// No description provided for @membershipTabInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Invitations ({count})'**
  String membershipTabInvitations(int count);

  /// No description provided for @membershipEmptyActive.
  ///
  /// In fr, this message translates to:
  /// **'Aucune adhésion active.\nRejoignez vos organisations préférées pour ne rien manquer.'**
  String get membershipEmptyActive;

  /// No description provided for @membershipEmptyPending.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas de demande en attente.'**
  String get membershipEmptyPending;

  /// No description provided for @membershipEmptyRejected.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande refusée.'**
  String get membershipEmptyRejected;

  /// No description provided for @membershipEmptyInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune invitation pour le moment.'**
  String get membershipEmptyInvitations;

  /// No description provided for @membershipDiscoverOrganizations.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir les organisations'**
  String get membershipDiscoverOrganizations;

  /// No description provided for @membershipLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos adhésions.'**
  String get membershipLoadError;

  /// No description provided for @membershipStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get membershipStatusPending;

  /// No description provided for @membershipStatusActive.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get membershipStatusActive;

  /// No description provided for @membershipStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get membershipStatusRejected;

  /// No description provided for @membershipStatusInvitation.
  ///
  /// In fr, this message translates to:
  /// **'Invitation'**
  String get membershipStatusInvitation;

  /// No description provided for @membershipStatusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expirée'**
  String get membershipStatusExpired;

  /// No description provided for @membershipViewOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Voir la fiche'**
  String get membershipViewOrganizer;

  /// No description provided for @membershipPrivateEventsAction.
  ///
  /// In fr, this message translates to:
  /// **'Événements privés'**
  String get membershipPrivateEventsAction;

  /// No description provided for @membershipMembersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 membre} other{{count} membres}}'**
  String membershipMembersCount(int count);

  /// No description provided for @membershipJoinAction.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get membershipJoinAction;

  /// No description provided for @membershipPendingAction.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get membershipPendingAction;

  /// No description provided for @membershipRetryRequestAction.
  ///
  /// In fr, this message translates to:
  /// **'Refaire la demande'**
  String get membershipRetryRequestAction;

  /// No description provided for @membershipCancelRequestAction.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la demande'**
  String get membershipCancelRequestAction;

  /// No description provided for @membershipLeaveAction.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get membershipLeaveAction;

  /// No description provided for @membershipCancelRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la demande ?'**
  String get membershipCancelRequestTitle;

  /// No description provided for @membershipCancelRequestBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre demande de rejoindre {organizerName} sera annulée. Vous pourrez en refaire une à tout moment.'**
  String membershipCancelRequestBody(String organizerName);

  /// No description provided for @membershipLeaveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter l\'organisation ?'**
  String get membershipLeaveTitle;

  /// No description provided for @membershipLeaveBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne verrez plus les événements privés de {organizerName}. Vous pourrez refaire une demande à tout moment.'**
  String membershipLeaveBody(String organizerName);

  /// No description provided for @membershipJoinTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre l\'espace privé de {organizerName} ?'**
  String membershipJoinTitle(String organizerName);

  /// No description provided for @membershipJoinBody.
  ///
  /// In fr, this message translates to:
  /// **'En rejoignant, vous accédez aux événements exclusifs proposés aux membres. Votre demande sera examinée par l\'organisateur.'**
  String get membershipJoinBody;

  /// No description provided for @membersOnlyGateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Événement réservé aux membres'**
  String get membersOnlyGateTitle;

  /// No description provided for @membersOnlyGateBody.
  ///
  /// In fr, this message translates to:
  /// **'Cet événement est uniquement accessible aux membres de {organizerName}. Rejoignez l\'organisation pour débloquer son agenda privé.'**
  String membersOnlyGateBody(String organizerName);

  /// No description provided for @membersOnlyGateJoin.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre {organizerName}'**
  String membersOnlyGateJoin(String organizerName);

  /// No description provided for @privateEventsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes événements privés'**
  String get privateEventsTitle;

  /// No description provided for @privateEventsSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un événement…'**
  String get privateEventsSearchHint;

  /// No description provided for @privateEventsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les événements.'**
  String get privateEventsLoadError;

  /// No description provided for @privateEventsPrivateBadge.
  ///
  /// In fr, this message translates to:
  /// **'Privé'**
  String get privateEventsPrivateBadge;

  /// No description provided for @privateEventsAllOrganizations.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les organisations'**
  String get privateEventsAllOrganizations;

  /// No description provided for @privateEventsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement privé pour l\'instant.'**
  String get privateEventsEmptyTitle;

  /// No description provided for @privateEventsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez des organisations pour découvrir leurs activités exclusives.'**
  String get privateEventsEmptyBody;

  /// No description provided for @privateEventsEmptyFiltered.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement privé correspondant.'**
  String get privateEventsEmptyFiltered;

  /// No description provided for @membershipInvitationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Invitation'**
  String get membershipInvitationTitle;

  /// No description provided for @membershipInvitedBy.
  ///
  /// In fr, this message translates to:
  /// **'Invité par {name}'**
  String membershipInvitedBy(String name);

  /// No description provided for @membershipInvitationExpiredBlurb.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation a expiré. Demandez à l\'organisation de vous renvoyer une invitation.'**
  String get membershipInvitationExpiredBlurb;

  /// No description provided for @membershipInvitationAcceptedBlurb.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation a déjà été acceptée. Retrouvez l\'organisation dans votre liste d\'adhésions.'**
  String get membershipInvitationAcceptedBlurb;

  /// No description provided for @membershipInvitationActiveBlurb.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes invité(e) à rejoindre cet espace privé. Acceptez l\'invitation pour accéder aux événements exclusifs.'**
  String get membershipInvitationActiveBlurb;

  /// No description provided for @membershipInvitationActiveWithExpiryBlurb.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes invité(e) à rejoindre cet espace privé. Acceptez l\'invitation pour accéder aux événements exclusifs. Cette invitation expire dans {hours} h.'**
  String membershipInvitationActiveWithExpiryBlurb(int hours);

  /// No description provided for @membershipInvitationWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans {organizationName}'**
  String membershipInvitationWelcome(String organizationName);

  /// No description provided for @membershipInvitationAcceptFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'accepter cette invitation.'**
  String get membershipInvitationAcceptFailed;

  /// No description provided for @membershipInvitationDeclineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Décliner l\'invitation ?'**
  String get membershipInvitationDeclineTitle;

  /// No description provided for @membershipInvitationDeclineBody.
  ///
  /// In fr, this message translates to:
  /// **'Refuser l\'invitation de {organizationName} ?'**
  String membershipInvitationDeclineBody(String organizationName);

  /// No description provided for @membershipInvitationDeclineAction.
  ///
  /// In fr, this message translates to:
  /// **'Décliner'**
  String get membershipInvitationDeclineAction;

  /// No description provided for @membershipInvitationAcceptAction.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get membershipInvitationAcceptAction;

  /// No description provided for @membershipInvitationDeclined.
  ///
  /// In fr, this message translates to:
  /// **'Invitation déclinée'**
  String get membershipInvitationDeclined;

  /// No description provided for @membershipInvitationSignInToAccept.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter pour accepter'**
  String get membershipInvitationSignInToAccept;

  /// No description provided for @membershipInvitationAlreadyAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Invitation déjà acceptée.'**
  String get membershipInvitationAlreadyAccepted;

  /// No description provided for @membershipInvitationExpired.
  ///
  /// In fr, this message translates to:
  /// **'Invitation expirée.'**
  String get membershipInvitationExpired;

  /// No description provided for @membershipInvitationExpiresInDays.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Expire dans 1 jour} other{Expire dans {count} jours}}'**
  String membershipInvitationExpiresInDays(int count);

  /// No description provided for @membershipInvitationExpiresInHours.
  ///
  /// In fr, this message translates to:
  /// **'Expire dans {count} h'**
  String membershipInvitationExpiresInHours(int count);

  /// No description provided for @membershipInvitationNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation est introuvable.'**
  String get membershipInvitationNotFoundTitle;

  /// No description provided for @membershipInvitationNotFoundBody.
  ///
  /// In fr, this message translates to:
  /// **'Le lien a peut-être été désactivé. Demandez à l\'organisateur de vous renvoyer une invitation.'**
  String get membershipInvitationNotFoundBody;

  /// No description provided for @personalizedFeedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour vous'**
  String get personalizedFeedTitle;

  /// No description provided for @organizerInvalidIdentifier.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant organisateur invalide'**
  String get organizerInvalidIdentifier;

  /// No description provided for @organizerActivitiesTab.
  ///
  /// In fr, this message translates to:
  /// **'Activités'**
  String get organizerActivitiesTab;

  /// No description provided for @organizerReviewsTab.
  ///
  /// In fr, this message translates to:
  /// **'Avis'**
  String get organizerReviewsTab;

  /// No description provided for @organizerProfileLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger ce profil.'**
  String get organizerProfileLoadError;

  /// No description provided for @organizerContactAction.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get organizerContactAction;

  /// No description provided for @organizerCoordinatesAction.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées'**
  String get organizerCoordinatesAction;

  /// No description provided for @organizerNoCoordinates.
  ///
  /// In fr, this message translates to:
  /// **'Cet organisateur n\'a pas renseigné de coordonnées.'**
  String get organizerNoCoordinates;

  /// No description provided for @organizerAboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get organizerAboutTitle;

  /// No description provided for @organizerEstablishmentTypesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Types d\'établissement'**
  String get organizerEstablishmentTypesTitle;

  /// No description provided for @organizerSocialLinksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réseaux sociaux'**
  String get organizerSocialLinksTitle;

  /// No description provided for @organizerEventsCount.
  ///
  /// In fr, this message translates to:
  /// **'{countLabel} {count, plural, =1{événement} other{événements}}'**
  String organizerEventsCount(String countLabel, int count);

  /// No description provided for @organizerFollowersCount.
  ///
  /// In fr, this message translates to:
  /// **'{countLabel} {count, plural, =1{abonné} other{abonnés}}'**
  String organizerFollowersCount(String countLabel, int count);

  /// No description provided for @organizerMembersCount.
  ///
  /// In fr, this message translates to:
  /// **'{countLabel} {count, plural, =1{membre} other{membres}}'**
  String organizerMembersCount(String countLabel, int count);

  /// No description provided for @organizerRatingWithReviews.
  ///
  /// In fr, this message translates to:
  /// **'{rating} ({countLabel} {count, plural, =1{avis} other{avis}})'**
  String organizerRatingWithReviews(
      String rating, String countLabel, int count);

  /// No description provided for @organizerFollowAction.
  ///
  /// In fr, this message translates to:
  /// **'Suivre'**
  String get organizerFollowAction;

  /// No description provided for @organizerUnfollowAction.
  ///
  /// In fr, this message translates to:
  /// **'Ne plus suivre'**
  String get organizerUnfollowAction;

  /// No description provided for @organizerFollowedSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un organisateur'**
  String get organizerFollowedSearchHint;

  /// No description provided for @organizerFollowedEmptySearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun organisateur trouvé'**
  String get organizerFollowedEmptySearchTitle;

  /// No description provided for @organizerFollowedEmptySearchBody.
  ///
  /// In fr, this message translates to:
  /// **'Essayez un autre mot-clé.'**
  String get organizerFollowedEmptySearchBody;

  /// No description provided for @organizerFollowedEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne suivez aucun organisateur'**
  String get organizerFollowedEmptyTitle;

  /// No description provided for @organizerFollowedEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Suivez un organisateur depuis sa page pour le retrouver ici.'**
  String get organizerFollowedEmptyBody;

  /// No description provided for @organizerFollowedLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la liste.'**
  String get organizerFollowedLoadError;

  /// No description provided for @organizerActivitiesLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les activités.'**
  String get organizerActivitiesLoadError;

  /// No description provided for @organizerActivitiesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité publiée pour le moment.'**
  String get organizerActivitiesEmpty;

  /// No description provided for @organizerActivitiesNoUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'événement à venir.'**
  String get organizerActivitiesNoUpcoming;

  /// No description provided for @organizerActivitiesNoPast.
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'événement passé.'**
  String get organizerActivitiesNoPast;

  /// No description provided for @organizerActivitiesCurrentTab.
  ///
  /// In fr, this message translates to:
  /// **'En cours ({count})'**
  String organizerActivitiesCurrentTab(int count);

  /// No description provided for @organizerActivitiesPastTab.
  ///
  /// In fr, this message translates to:
  /// **'Passés ({count})'**
  String organizerActivitiesPastTab(int count);

  /// No description provided for @organizerReviewsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les avis.'**
  String get organizerReviewsLoadError;

  /// No description provided for @organizerReviewsTotal.
  ///
  /// In fr, this message translates to:
  /// **'Sur {count, plural, =1{1 avis} other{{count} avis}}'**
  String organizerReviewsTotal(int count);

  /// No description provided for @organizerVerifiedPurchasesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{dont 1 achat vérifié} other{dont {count} achats vérifiés}}'**
  String organizerVerifiedPurchasesCount(int count);

  /// No description provided for @organizerNoReviewsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis pour le moment'**
  String get organizerNoReviewsTitle;

  /// No description provided for @organizerNoReviewsBody.
  ///
  /// In fr, this message translates to:
  /// **'Soyez parmi les premiers à laisser un avis sur l\'un de ses événements.'**
  String get organizerNoReviewsBody;

  /// No description provided for @organizerReviewUserFallback.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get organizerReviewUserFallback;

  /// No description provided for @organizerReviewFor.
  ///
  /// In fr, this message translates to:
  /// **'Avis pour'**
  String get organizerReviewFor;

  /// No description provided for @organizerVerifiedPurchase.
  ///
  /// In fr, this message translates to:
  /// **'Achat vérifié'**
  String get organizerVerifiedPurchase;

  /// No description provided for @organizerHelpfulCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 utile} other{{count} utiles}}'**
  String organizerHelpfulCount(int count);

  /// No description provided for @organizerReplyBy.
  ///
  /// In fr, this message translates to:
  /// **'Réponse de {author}'**
  String organizerReplyBy(String author);

  /// No description provided for @organizerReplyFallback.
  ///
  /// In fr, this message translates to:
  /// **'Réponse de l\'organisateur'**
  String get organizerReplyFallback;

  /// No description provided for @partnerTypeVenue.
  ///
  /// In fr, this message translates to:
  /// **'Salle/Lieu'**
  String get partnerTypeVenue;

  /// No description provided for @partnerTypeOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur'**
  String get partnerTypeOrganizer;

  /// No description provided for @partnerTypeIndividual.
  ///
  /// In fr, this message translates to:
  /// **'Particulier'**
  String get partnerTypeIndividual;

  /// No description provided for @partnerSubscriptionBasic.
  ///
  /// In fr, this message translates to:
  /// **'Basique'**
  String get partnerSubscriptionBasic;

  /// No description provided for @partnerSubscriptionEnterprise.
  ///
  /// In fr, this message translates to:
  /// **'Enterprise'**
  String get partnerSubscriptionEnterprise;

  /// No description provided for @checkinScannerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner les billets'**
  String get checkinScannerTitle;

  /// No description provided for @checkinTorchTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Lampe'**
  String get checkinTorchTooltip;

  /// No description provided for @checkinCameraTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Caméra'**
  String get checkinCameraTooltip;

  /// No description provided for @checkinMoreTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get checkinMoreTooltip;

  /// No description provided for @checkinSwitchOrganization.
  ///
  /// In fr, this message translates to:
  /// **'Changer d\'organisation'**
  String get checkinSwitchOrganization;

  /// No description provided for @checkinManualEntryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisie manuelle'**
  String get checkinManualEntryTitle;

  /// No description provided for @checkinGateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Étiquette de gate'**
  String get checkinGateLabel;

  /// No description provided for @checkinGateHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Nord, VIP, Entrée 2…'**
  String get checkinGateHint;

  /// No description provided for @checkinGateDisplay.
  ///
  /// In fr, this message translates to:
  /// **'Gate : {gate}'**
  String checkinGateDisplay(String gate);

  /// No description provided for @checkinEntryRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue ! Entrée enregistrée.'**
  String get checkinEntryRecorded;

  /// No description provided for @checkinReEntryRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Ré-entrée enregistrée (entrée n°{count})'**
  String checkinReEntryRecorded(int count);

  /// No description provided for @checkinNetworkRescan.
  ///
  /// In fr, this message translates to:
  /// **'Réseau instable — re-scannez pour confirmer.'**
  String get checkinNetworkRescan;

  /// No description provided for @checkinNetworkRetype.
  ///
  /// In fr, this message translates to:
  /// **'Réseau instable — re-saisissez pour confirmer.'**
  String get checkinNetworkRetype;

  /// No description provided for @checkinCameraPermissionDeniedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accès caméra refusé'**
  String get checkinCameraPermissionDeniedTitle;

  /// No description provided for @checkinCameraUnavailableTitle.
  ///
  /// In fr, this message translates to:
  /// **'Caméra indisponible'**
  String get checkinCameraUnavailableTitle;

  /// No description provided for @checkinCameraPermissionDeniedBody.
  ///
  /// In fr, this message translates to:
  /// **'Autorisez la caméra dans les paramètres système, ou utilisez la saisie manuelle.'**
  String get checkinCameraPermissionDeniedBody;

  /// No description provided for @checkinCameraUnavailableBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucune caméra n\'a été détectée. Utilisez la saisie manuelle.'**
  String get checkinCameraUnavailableBody;

  /// No description provided for @checkinChooseOrganizationFirst.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une organisation depuis le scanner.'**
  String get checkinChooseOrganizationFirst;

  /// No description provided for @checkinManualWarning.
  ///
  /// In fr, this message translates to:
  /// **'À utiliser uniquement avec une vérification d\'identité visuelle. La saisie manuelle ne contrôle pas le secret du QR.'**
  String get checkinManualWarning;

  /// No description provided for @checkinOrganizationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Organisation : {name}'**
  String checkinOrganizationLabel(String name);

  /// No description provided for @checkinManualCodeHelper.
  ///
  /// In fr, this message translates to:
  /// **'Code imprimé sur le billet'**
  String get checkinManualCodeHelper;

  /// No description provided for @checkinVerifyCode.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier le code'**
  String get checkinVerifyCode;

  /// No description provided for @checkinValidTicketTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet valide'**
  String get checkinValidTicketTitle;

  /// No description provided for @checkinReEntryDetectedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ré-entrée détectée'**
  String get checkinReEntryDetectedTitle;

  /// No description provided for @checkinConfirmEntry.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer l\'entrée'**
  String get checkinConfirmEntry;

  /// No description provided for @checkinConfirmReEntry.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la ré-entrée'**
  String get checkinConfirmReEntry;

  /// No description provided for @checkinAlreadyEnteredWarning.
  ///
  /// In fr, this message translates to:
  /// **'Déjà entré {count}× — vérifiez avant d\'admettre.'**
  String checkinAlreadyEnteredWarning(int count);

  /// No description provided for @checkinChooseOrganizationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une organisation'**
  String get checkinChooseOrganizationTitle;

  /// No description provided for @checkinChooseOrganizationBody.
  ///
  /// In fr, this message translates to:
  /// **'Le scanner enverra les billets à l\'organisation sélectionnée.'**
  String get checkinChooseOrganizationBody;

  /// No description provided for @checkinRoleOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get checkinRoleOwner;

  /// No description provided for @checkinRoleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get checkinRoleAdmin;

  /// No description provided for @checkinRoleStaff.
  ///
  /// In fr, this message translates to:
  /// **'Équipe'**
  String get checkinRoleStaff;

  /// No description provided for @checkinRoleViewer.
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get checkinRoleViewer;

  /// No description provided for @checkinNoVendorOrganizationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune organisation vendeur trouvée'**
  String get checkinNoVendorOrganizationTitle;

  /// No description provided for @checkinNoVendorOrganizationBody.
  ///
  /// In fr, this message translates to:
  /// **'Si vous attendiez d\'apparaître ici, contactez le support — votre profil n\'est peut-être pas encore lié à une organisation.'**
  String get checkinNoVendorOrganizationBody;

  /// No description provided for @checkinRefresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get checkinRefresh;

  /// No description provided for @checkinBlockedTicketCancelledTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet annulé'**
  String get checkinBlockedTicketCancelledTitle;

  /// No description provided for @checkinBlockedTicketRefundedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet remboursé'**
  String get checkinBlockedTicketRefundedTitle;

  /// No description provided for @checkinBlockedTicketTransferredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet transféré'**
  String get checkinBlockedTicketTransferredTitle;

  /// No description provided for @checkinBlockedSlotNotStartedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créneau non commencé'**
  String get checkinBlockedSlotNotStartedTitle;

  /// No description provided for @checkinBlockedWrongEventTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mauvais événement'**
  String get checkinBlockedWrongEventTitle;

  /// No description provided for @checkinBlockedUnauthorizedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Non autorisé'**
  String get checkinBlockedUnauthorizedTitle;

  /// No description provided for @checkinBlockedTicketNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet introuvable'**
  String get checkinBlockedTicketNotFoundTitle;

  /// No description provided for @checkinBlockedUnknownTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get checkinBlockedUnknownTitle;

  /// No description provided for @checkinBlockedDoNotAdmit.
  ///
  /// In fr, this message translates to:
  /// **'Ne pas laisser entrer.'**
  String get checkinBlockedDoNotAdmit;

  /// No description provided for @checkinBlockedTicketTransferredBody.
  ///
  /// In fr, this message translates to:
  /// **'Le billet a été transféré à un autre porteur — re-scannez son QR.'**
  String get checkinBlockedTicketTransferredBody;

  /// No description provided for @checkinBlockedSlotNotStartedBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'entrée n\'est pas encore ouverte pour ce créneau.'**
  String get checkinBlockedSlotNotStartedBody;

  /// No description provided for @checkinBlockedWrongEventBody.
  ///
  /// In fr, this message translates to:
  /// **'Ce billet ne correspond pas à l\'événement filtré.'**
  String get checkinBlockedWrongEventBody;

  /// No description provided for @checkinBlockedUnauthorizedBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'êtes pas autorisé à scanner ce billet pour cette organisation.'**
  String get checkinBlockedUnauthorizedBody;

  /// No description provided for @checkinBlockedTicketNotFoundBody.
  ///
  /// In fr, this message translates to:
  /// **'QR non reconnu — réessayez ou saisissez le code.'**
  String get checkinBlockedTicketNotFoundBody;

  /// No description provided for @checkinBlockedUnknownBody.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inattendue, réessayez.'**
  String get checkinBlockedUnknownBody;

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

  /// No description provided for @authAccountAlreadyVerified.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte est déjà vérifié. Veuillez vous connecter.'**
  String get authAccountAlreadyVerified;

  /// No description provided for @authEmailOrPasswordIncorrect.
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect'**
  String get authEmailOrPasswordIncorrect;

  /// No description provided for @authAccountAlreadyExists.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet email'**
  String get authAccountAlreadyExists;

  /// No description provided for @authWeakPasswordDetailed.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre'**
  String get authWeakPasswordDetailed;

  /// No description provided for @authVerificationCodeInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Code de vérification invalide'**
  String get authVerificationCodeInvalid;

  /// No description provided for @authVerificationCodeExpired.
  ///
  /// In fr, this message translates to:
  /// **'Le code a expiré. Veuillez en demander un nouveau.'**
  String get authVerificationCodeExpired;

  /// No description provided for @authTooManyAttempts.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Réessayez dans 15 minutes.'**
  String get authTooManyAttempts;

  /// No description provided for @authVerificationCodeSent.
  ///
  /// In fr, this message translates to:
  /// **'Un code de vérification a été envoyé'**
  String get authVerificationCodeSent;

  /// No description provided for @authVerificationCodeVerified.
  ///
  /// In fr, this message translates to:
  /// **'Code vérifié'**
  String get authVerificationCodeVerified;

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

  /// No description provided for @authFirstNameMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le prénom doit contenir au moins 2 caractères'**
  String get authFirstNameMinLength;

  /// No description provided for @authLastNameMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le nom doit contenir au moins 2 caractères'**
  String get authLastNameMinLength;

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

  /// No description provided for @authPasswordNeedsUppercaseNumberSpecial.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères, une majuscule, un chiffre et un symbole'**
  String get authPasswordNeedsUppercaseNumberSpecial;

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

  /// No description provided for @authCompanyNameMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le nom de l\'entreprise doit contenir au moins 2 caractères'**
  String get authCompanyNameMinLength;

  /// No description provided for @authSiretMustHave14Digits.
  ///
  /// In fr, this message translates to:
  /// **'Le numéro SIRET doit contenir 14 chiffres'**
  String get authSiretMustHave14Digits;

  /// No description provided for @authAddressMinLength.
  ///
  /// In fr, this message translates to:
  /// **'L\'adresse doit contenir au moins 5 caractères'**
  String get authAddressMinLength;

  /// No description provided for @authCityMinLength.
  ///
  /// In fr, this message translates to:
  /// **'La ville doit contenir au moins 2 caractères'**
  String get authCityMinLength;

  /// No description provided for @authPostalCodeLength.
  ///
  /// In fr, this message translates to:
  /// **'Le code postal doit contenir entre 3 et 10 caractères'**
  String get authPostalCodeLength;

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

  /// No description provided for @authBusinessTermsRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez accepter les conditions business'**
  String get authBusinessTermsRequired;

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

  /// No description provided for @homePartnerBadge.
  ///
  /// In fr, this message translates to:
  /// **'Partenaire'**
  String get homePartnerBadge;

  /// No description provided for @homePartnerSeeAllSelection.
  ///
  /// In fr, this message translates to:
  /// **'Voir toute la sélection'**
  String get homePartnerSeeAllSelection;

  /// No description provided for @homePersonalizedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour vous'**
  String get homePersonalizedTitle;

  /// No description provided for @homePersonalizedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Basé sur vos préférences'**
  String get homePersonalizedSubtitle;

  /// No description provided for @homeNativeAdSponsored.
  ///
  /// In fr, this message translates to:
  /// **'Sponsorisé'**
  String get homeNativeAdSponsored;

  /// No description provided for @homeRecommendedPopularTag.
  ///
  /// In fr, this message translates to:
  /// **'Populaire'**
  String get homeRecommendedPopularTag;

  /// No description provided for @homeRecommendedLastSpotsTag.
  ///
  /// In fr, this message translates to:
  /// **'Dernières places'**
  String get homeRecommendedLastSpotsTag;

  /// No description provided for @homeSavedSearchAlertFallback.
  ///
  /// In fr, this message translates to:
  /// **'Alerte personnalisée'**
  String get homeSavedSearchAlertFallback;

  /// No description provided for @homeSavedSearchFallback.
  ///
  /// In fr, this message translates to:
  /// **'Recherche sauvegardée'**
  String get homeSavedSearchFallback;

  /// No description provided for @homeMobileConfigDefaultHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez votre prochaine aventure locale'**
  String get homeMobileConfigDefaultHeroTitle;

  /// No description provided for @homeMobileConfigDefaultHeroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez les meilleurs événements près de chez vous'**
  String get homeMobileConfigDefaultHeroSubtitle;

  /// No description provided for @homeMobileConfigEventsSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez tous vos événements'**
  String get homeMobileConfigEventsSectionTitle;

  /// No description provided for @homeMobileConfigEventsSectionDescription.
  ///
  /// In fr, this message translates to:
  /// **'Explorez notre sélection d\'événements locaux'**
  String get homeMobileConfigEventsSectionDescription;

  /// No description provided for @homeMobileConfigThematiquesSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorez par thématique'**
  String get homeMobileConfigThematiquesSectionTitle;

  /// No description provided for @homeMobileConfigCitiesSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Événements par ville'**
  String get homeMobileConfigCitiesSectionTitle;

  /// No description provided for @homeMobileConfigExploreButton.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les activités'**
  String get homeMobileConfigExploreButton;

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
  /// **'Billetterie uniquement'**
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

  /// No description provided for @searchPushTitle.
  ///
  /// In fr, this message translates to:
  /// **'Push'**
  String get searchPushTitle;

  /// No description provided for @searchPushSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications sur l\'app mobile'**
  String get searchPushSubtitle;

  /// No description provided for @searchEmailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get searchEmailTitle;

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

  /// No description provided for @eventPriceDonation.
  ///
  /// In fr, this message translates to:
  /// **'Participation libre'**
  String get eventPriceDonation;

  /// No description provided for @eventPriceVariable.
  ///
  /// In fr, this message translates to:
  /// **'Prix variable'**
  String get eventPriceVariable;

  /// No description provided for @eventPriceRange.
  ///
  /// In fr, this message translates to:
  /// **'De {minPrice} à {maxPrice}'**
  String eventPriceRange(String minPrice, String maxPrice);

  /// No description provided for @eventAgeMinimum.
  ///
  /// In fr, this message translates to:
  /// **'{minAge} ans et +'**
  String eventAgeMinimum(int minAge);

  /// No description provided for @eventAgeMaximum.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu\'à {maxAge} ans'**
  String eventAgeMaximum(int maxAge);

  /// No description provided for @eventAgeRange.
  ///
  /// In fr, this message translates to:
  /// **'{minAge}-{maxAge} ans'**
  String eventAgeRange(int minAge, int maxAge);

  /// No description provided for @eventLocationIndoorOutdoor.
  ///
  /// In fr, this message translates to:
  /// **'Intérieur/Extérieur'**
  String get eventLocationIndoorOutdoor;

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

  /// No description provided for @eventWifiLabel.
  ///
  /// In fr, this message translates to:
  /// **'Wi-Fi'**
  String get eventWifiLabel;

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

  /// No description provided for @eventQuestionInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Question invalide.'**
  String get eventQuestionInvalid;

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

  /// No description provided for @eventPeopleWatching.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 personne regarde} other{{count} personnes regardent}}'**
  String eventPeopleWatching(int count);

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

  /// No description provided for @bookingMyBookingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get bookingMyBookingsTitle;

  /// No description provided for @bookingSortTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Trier'**
  String get bookingSortTooltip;

  /// No description provided for @bookingSortByTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get bookingSortByTitle;

  /// No description provided for @bookingSortDateAsc.
  ///
  /// In fr, this message translates to:
  /// **'Date (plus proche)'**
  String get bookingSortDateAsc;

  /// No description provided for @bookingSortDateDesc.
  ///
  /// In fr, this message translates to:
  /// **'Date (plus lointaine)'**
  String get bookingSortDateDesc;

  /// No description provided for @bookingSortStatusAsc.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get bookingSortStatusAsc;

  /// No description provided for @bookingFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get bookingFilterAll;

  /// No description provided for @bookingFilterUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get bookingFilterUpcoming;

  /// No description provided for @bookingFilterPast.
  ///
  /// In fr, this message translates to:
  /// **'Passés'**
  String get bookingFilterPast;

  /// No description provided for @bookingFilterCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulés'**
  String get bookingFilterCancelled;

  /// No description provided for @bookingLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement : {message}'**
  String bookingLoadError(String message);

  /// No description provided for @bookingEmptyAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation'**
  String get bookingEmptyAllTitle;

  /// No description provided for @bookingEmptyAllBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore de réservation.\nDécouvrez nos événements !'**
  String get bookingEmptyAllBody;

  /// No description provided for @bookingEmptyUpcomingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation à venir'**
  String get bookingEmptyUpcomingTitle;

  /// No description provided for @bookingEmptyUpcomingBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas de réservation prévue.\nExplorez nos événements !'**
  String get bookingEmptyUpcomingBody;

  /// No description provided for @bookingEmptyPastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation passée'**
  String get bookingEmptyPastTitle;

  /// No description provided for @bookingEmptyPastBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore participé à un événement.'**
  String get bookingEmptyPastBody;

  /// No description provided for @bookingEmptyCancelledTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation annulée'**
  String get bookingEmptyCancelledTitle;

  /// No description provided for @bookingEmptyCancelledBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez aucune réservation annulée.'**
  String get bookingEmptyCancelledBody;

  /// No description provided for @bookingNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservation introuvable'**
  String get bookingNotFoundTitle;

  /// No description provided for @bookingNotFoundBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette réservation n\'existe pas ou a été supprimée.'**
  String get bookingNotFoundBody;

  /// No description provided for @bookingEventFallback.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get bookingEventFallback;

  /// No description provided for @bookingStandardTicket.
  ///
  /// In fr, this message translates to:
  /// **'Standard'**
  String get bookingStandardTicket;

  /// No description provided for @bookingShareBookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma réservation Le Hiboo'**
  String get bookingShareBookingTitle;

  /// No description provided for @bookingShareTicketTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon billet Le Hiboo'**
  String get bookingShareTicketTitle;

  /// No description provided for @bookingShareTicketCode.
  ///
  /// In fr, this message translates to:
  /// **'Code : {code}'**
  String bookingShareTicketCode(String code);

  /// No description provided for @bookingShareTicketsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 billet} other{{count} billets}}'**
  String bookingShareTicketsCount(int count);

  /// No description provided for @bookingCalendarReference.
  ///
  /// In fr, this message translates to:
  /// **'Réservation Le Hiboo : {reference}'**
  String bookingCalendarReference(String reference);

  /// No description provided for @bookingCalendarAdded.
  ///
  /// In fr, this message translates to:
  /// **'Événement ajouté au calendrier'**
  String get bookingCalendarAdded;

  /// No description provided for @bookingCalendarAddFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ajouter au calendrier'**
  String get bookingCalendarAddFailed;

  /// No description provided for @bookingCancelDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get bookingCancelDialogTitle;

  /// No description provided for @bookingCancelDialogBody.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.'**
  String get bookingCancelDialogBody;

  /// No description provided for @bookingCancelDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Date limite : {deadline}'**
  String bookingCancelDeadline(String deadline);

  /// No description provided for @bookingCancelReasonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Raison (optionnel)'**
  String get bookingCancelReasonLabel;

  /// No description provided for @bookingCancelReasonHint.
  ///
  /// In fr, this message translates to:
  /// **'Empêchement personnel…'**
  String get bookingCancelReasonHint;

  /// No description provided for @bookingCancelWarning.
  ///
  /// In fr, this message translates to:
  /// **'Attention : aucun remboursement ne sera effectué après l\'annulation.'**
  String get bookingCancelWarning;

  /// No description provided for @bookingCancelKeep.
  ///
  /// In fr, this message translates to:
  /// **'Non, garder'**
  String get bookingCancelKeep;

  /// No description provided for @bookingCancelConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Oui, annuler'**
  String get bookingCancelConfirm;

  /// No description provided for @bookingCancelSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Réservation annulée. Aucun remboursement ne sera effectué.'**
  String get bookingCancelSuccess;

  /// No description provided for @bookingCancelForbidden.
  ///
  /// In fr, this message translates to:
  /// **'L\'annulation n\'est plus possible (délai dépassé ou non autorisé par l\'organisateur).'**
  String get bookingCancelForbidden;

  /// No description provided for @bookingCancelNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Cette réservation est introuvable.'**
  String get bookingCancelNotFound;

  /// No description provided for @bookingCancelValidationTooLong.
  ///
  /// In fr, this message translates to:
  /// **'La raison saisie est trop longue (1000 caractères max).'**
  String get bookingCancelValidationTooLong;

  /// No description provided for @bookingCancelGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'annuler la réservation. Réessayez.'**
  String get bookingCancelGenericError;

  /// No description provided for @bookingPreparingPdf.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du PDF…'**
  String get bookingPreparingPdf;

  /// No description provided for @bookingAndroidDownloadsLocation.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargements/Lehiboo'**
  String get bookingAndroidDownloadsLocation;

  /// No description provided for @bookingDocumentsTicketsLocation.
  ///
  /// In fr, this message translates to:
  /// **'Documents > Lehiboo > tickets'**
  String get bookingDocumentsTicketsLocation;

  /// No description provided for @bookingTicketsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Billets enregistrés dans {location}'**
  String bookingTicketsSaved(String location);

  /// No description provided for @bookingTicketSaved.
  ///
  /// In fr, this message translates to:
  /// **'Billet enregistré dans {location}'**
  String bookingTicketSaved(String location);

  /// No description provided for @bookingTicketsNotReady.
  ///
  /// In fr, this message translates to:
  /// **'Vos billets sont en cours de génération, réessayez dans un instant.'**
  String get bookingTicketsNotReady;

  /// No description provided for @bookingTicketNotReady.
  ///
  /// In fr, this message translates to:
  /// **'Ce billet est en cours de génération, réessayez dans un instant.'**
  String get bookingTicketNotReady;

  /// No description provided for @bookingTicketsNotAuthorized.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'êtes pas autorisé à télécharger ces billets.'**
  String get bookingTicketsNotAuthorized;

  /// No description provided for @bookingTicketNotDownloadable.
  ///
  /// In fr, this message translates to:
  /// **'Ce billet n\'est plus téléchargeable.'**
  String get bookingTicketNotDownloadable;

  /// No description provided for @bookingDownloadError.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement impossible. Réessayez plus tard.'**
  String get bookingDownloadError;

  /// No description provided for @bookingDownloadSingleTicket.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger le billet PDF'**
  String get bookingDownloadSingleTicket;

  /// No description provided for @bookingDownloadAllTickets.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger tous les billets'**
  String get bookingDownloadAllTickets;

  /// No description provided for @bookingTicketTitle.
  ///
  /// In fr, this message translates to:
  /// **'Billet'**
  String get bookingTicketTitle;

  /// No description provided for @bookingTicketNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Billet non trouvé'**
  String get bookingTicketNotFound;

  /// No description provided for @bookingTicketPosition.
  ///
  /// In fr, this message translates to:
  /// **'Billet {current}/{total}'**
  String bookingTicketPosition(int current, int total);

  /// No description provided for @bookingTicketSwipeHint.
  ///
  /// In fr, this message translates to:
  /// **'← Swipe pour voir les autres billets →'**
  String get bookingTicketSwipeHint;

  /// No description provided for @bookingQrTapFullscreenHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur le QR code pour l\'afficher en plein écran'**
  String get bookingQrTapFullscreenHint;

  /// No description provided for @bookingQrTapCloseHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez n\'importe où pour fermer'**
  String get bookingQrTapCloseHint;

  /// No description provided for @bookingParticipantDefault.
  ///
  /// In fr, this message translates to:
  /// **'Participant'**
  String get bookingParticipantDefault;

  /// No description provided for @bookingParticipantNumber.
  ///
  /// In fr, this message translates to:
  /// **'Participant {index}'**
  String bookingParticipantNumber(int index);

  /// No description provided for @bookingAgeYears.
  ///
  /// In fr, this message translates to:
  /// **'{age} ans'**
  String bookingAgeYears(int age);

  /// No description provided for @bookingAddToCalendar.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au calendrier'**
  String get bookingAddToCalendar;

  /// No description provided for @bookingContactOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Contacter l\'organisateur'**
  String get bookingContactOrganizer;

  /// No description provided for @bookingAdditionalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations complémentaires'**
  String get bookingAdditionalInfoTitle;

  /// No description provided for @bookingSectionEvent.
  ///
  /// In fr, this message translates to:
  /// **'ÉVÉNEMENT'**
  String get bookingSectionEvent;

  /// No description provided for @bookingViewEvent.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'événement'**
  String get bookingViewEvent;

  /// No description provided for @bookingSectionSummary.
  ///
  /// In fr, this message translates to:
  /// **'RÉSUMÉ'**
  String get bookingSectionSummary;

  /// No description provided for @bookingDiscountFallback.
  ///
  /// In fr, this message translates to:
  /// **'Réduction'**
  String get bookingDiscountFallback;

  /// No description provided for @bookingMyTicketsCount.
  ///
  /// In fr, this message translates to:
  /// **'MES BILLETS ({count})'**
  String bookingMyTicketsCount(int count);

  /// No description provided for @bookingStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmé'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusRefunded.
  ///
  /// In fr, this message translates to:
  /// **'Remboursé'**
  String get bookingStatusRefunded;

  /// No description provided for @bookingTicketStatusActive.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get bookingTicketStatusActive;

  /// No description provided for @bookingTicketStatusUsed.
  ///
  /// In fr, this message translates to:
  /// **'Utilisé'**
  String get bookingTicketStatusUsed;

  /// No description provided for @bookingTicketStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get bookingTicketStatusCancelled;

  /// No description provided for @bookingTicketStatusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expiré'**
  String get bookingTicketStatusExpired;

  /// No description provided for @bookingLegacyReservationForEvent.
  ///
  /// In fr, this message translates to:
  /// **'Réservation pour l\'événement {eventId}'**
  String bookingLegacyReservationForEvent(String eventId);

  /// No description provided for @bookingLegacyReserveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réserver : {eventTitle}'**
  String bookingLegacyReserveTitle(String eventTitle);

  /// No description provided for @bookingLegacyStepSlot.
  ///
  /// In fr, this message translates to:
  /// **'Créneau'**
  String get bookingLegacyStepSlot;

  /// No description provided for @bookingLegacyStepInfo.
  ///
  /// In fr, this message translates to:
  /// **'Infos'**
  String get bookingLegacyStepInfo;

  /// No description provided for @bookingLegacyStepPayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get bookingLegacyStepPayment;

  /// No description provided for @bookingLegacyChooseSlot.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un créneau'**
  String get bookingLegacyChooseSlot;

  /// No description provided for @bookingLegacyNoSlotTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun créneau'**
  String get bookingLegacyNoSlotTitle;

  /// No description provided for @bookingLegacyNoSlotBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucun créneau disponible pour le moment.'**
  String get bookingLegacyNoSlotBody;

  /// No description provided for @bookingLegacyParticipantsCountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de participants'**
  String get bookingLegacyParticipantsCountTitle;

  /// No description provided for @bookingLegacyPeopleCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 personne} other{{count} personnes}}'**
  String bookingLegacyPeopleCount(int count);

  /// No description provided for @bookingLegacyContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get bookingLegacyContinue;

  /// No description provided for @bookingLegacySelectSlotRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un créneau.'**
  String get bookingLegacySelectSlotRequired;

  /// No description provided for @bookingLegacyRequiredInfo.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir toutes les informations obligatoires.'**
  String get bookingLegacyRequiredInfo;

  /// No description provided for @bookingLegacyOtherParticipantsLater.
  ///
  /// In fr, this message translates to:
  /// **'Note : Les détails des autres participants seront demandés ultérieurement.'**
  String get bookingLegacyOtherParticipantsLater;

  /// No description provided for @bookingConfirmReservation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la réservation'**
  String get bookingConfirmReservation;

  /// No description provided for @bookingGoToPayment.
  ///
  /// In fr, this message translates to:
  /// **'Aller au paiement'**
  String get bookingGoToPayment;

  /// No description provided for @bookingPaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get bookingPaymentTitle;

  /// No description provided for @bookingPaymentCardSimulated.
  ///
  /// In fr, this message translates to:
  /// **'Carte bancaire (simulée)'**
  String get bookingPaymentCardSimulated;

  /// No description provided for @bookingCardNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte'**
  String get bookingCardNumberLabel;

  /// No description provided for @bookingCardExpiryLabel.
  ///
  /// In fr, this message translates to:
  /// **'MM/AA'**
  String get bookingCardExpiryLabel;

  /// No description provided for @bookingCardCvcLabel.
  ///
  /// In fr, this message translates to:
  /// **'CVC'**
  String get bookingCardCvcLabel;

  /// No description provided for @bookingPayAmount.
  ///
  /// In fr, this message translates to:
  /// **'Payer {amount} {currency}'**
  String bookingPayAmount(String amount, String currency);

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée !'**
  String get bookingConfirmedTitle;

  /// No description provided for @bookingConfirmedBody.
  ///
  /// In fr, this message translates to:
  /// **'Merci {firstName}, votre réservation pour \"{eventTitle}\" est validée.'**
  String bookingConfirmedBody(String firstName, String eventTitle);

  /// No description provided for @bookingTicketId.
  ///
  /// In fr, this message translates to:
  /// **'Billet #{ticketId}'**
  String bookingTicketId(String ticketId);

  /// No description provided for @bookingTicketValid.
  ///
  /// In fr, this message translates to:
  /// **'Valide'**
  String get bookingTicketValid;

  /// No description provided for @bookingSuccessThanks.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour votre confiance'**
  String get bookingSuccessThanks;

  /// No description provided for @bookingReferenceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get bookingReferenceLabel;

  /// No description provided for @bookingReferenceCopied.
  ///
  /// In fr, this message translates to:
  /// **'Référence copiée'**
  String get bookingReferenceCopied;

  /// No description provided for @bookingCopyTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get bookingCopyTooltip;

  /// No description provided for @bookingYourTickets.
  ///
  /// In fr, this message translates to:
  /// **'Vos billets'**
  String get bookingYourTickets;

  /// No description provided for @bookingTicketsGenerating.
  ///
  /// In fr, this message translates to:
  /// **'Génération de vos billets...'**
  String get bookingTicketsGenerating;

  /// No description provided for @bookingTicketsAvailableInBookings.
  ///
  /// In fr, this message translates to:
  /// **'Vos billets seront disponibles\ndans votre espace \"Mes réservations\"'**
  String get bookingTicketsAvailableInBookings;

  /// No description provided for @bookingConfirmationEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Un email de confirmation avec vos billets vous a été envoyé.'**
  String get bookingConfirmationEmailSent;

  /// No description provided for @bookingTicketsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les billets'**
  String get bookingTicketsLoadError;

  /// No description provided for @tripPlansListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes sorties'**
  String get tripPlansListTitle;

  /// No description provided for @tripPlansDeletedSnack.
  ///
  /// In fr, this message translates to:
  /// **'Plan \"{title}\" supprimé'**
  String tripPlansDeletedSnack(String title);

  /// No description provided for @tripPlansUntitledPlan.
  ///
  /// In fr, this message translates to:
  /// **'Plan sans titre'**
  String get tripPlansUntitledPlan;

  /// No description provided for @tripPlansEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sortie planifiée'**
  String get tripPlansEmptyTitle;

  /// No description provided for @tripPlansEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Demande à Petit Boo de te créer un itinéraire pour ta prochaine sortie !'**
  String get tripPlansEmptyBody;

  /// No description provided for @tripPlansTalkToPetitBoo.
  ///
  /// In fr, this message translates to:
  /// **'Parler à Petit Boo'**
  String get tripPlansTalkToPetitBoo;

  /// No description provided for @tripPlansErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get tripPlansErrorTitle;

  /// No description provided for @tripPlansLoadErrorBody.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos sorties'**
  String get tripPlansLoadErrorBody;

  /// No description provided for @tripPlanEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get tripPlanEditTitle;

  /// No description provided for @tripPlanEditErrorWithMessage.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {message}'**
  String tripPlanEditErrorWithMessage(String message);

  /// No description provided for @tripPlanEditNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Plan non trouvé'**
  String get tripPlanEditNotFound;

  /// No description provided for @tripPlanEditTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get tripPlanEditTitleLabel;

  /// No description provided for @tripPlanEditNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la sortie'**
  String get tripPlanEditNameHint;

  /// No description provided for @tripPlanEditDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get tripPlanEditDateLabel;

  /// No description provided for @tripPlanEditSelectDate.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date'**
  String get tripPlanEditSelectDate;

  /// No description provided for @tripPlanEditStopsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Étapes'**
  String get tripPlanEditStopsLabel;

  /// No description provided for @tripPlanEditReorderHint.
  ///
  /// In fr, this message translates to:
  /// **'Glisser pour réorganiser'**
  String get tripPlanEditReorderHint;

  /// No description provided for @tripPlanEditUpdatedSnack.
  ///
  /// In fr, this message translates to:
  /// **'Plan mis à jour'**
  String get tripPlanEditUpdatedSnack;

  /// No description provided for @tripPlanEditDiscardChangesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abandonner les modifications ?'**
  String get tripPlanEditDiscardChangesTitle;

  /// No description provided for @tripPlanEditDiscardChangesBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos modifications ne seront pas sauvegardées.'**
  String get tripPlanEditDiscardChangesBody;

  /// No description provided for @tripPlanEditDiscard.
  ///
  /// In fr, this message translates to:
  /// **'Abandonner'**
  String get tripPlanEditDiscard;

  /// No description provided for @tripPlansStopsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 étape} other{{count} étapes}}'**
  String tripPlansStopsCount(int count);

  /// No description provided for @tripPlansStopsPlanned.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 étape prévue} other{{count} étapes prévues}}'**
  String tripPlansStopsPlanned(int count);

  /// No description provided for @tripPlansStopFallback.
  ///
  /// In fr, this message translates to:
  /// **'Étape'**
  String get tripPlansStopFallback;

  /// No description provided for @tripPlansNoCoordinatesAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune coordonnée disponible'**
  String get tripPlansNoCoordinatesAvailable;

  /// No description provided for @tripPlansDeleteDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce plan ?'**
  String get tripPlansDeleteDialogTitle;

  /// No description provided for @tripPlansDeleteDialogBody.
  ///
  /// In fr, this message translates to:
  /// **'Le plan \"{title}\" sera définitivement supprimé.'**
  String tripPlansDeleteDialogBody(String title);

  /// No description provided for @tripPlansDurationMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String tripPlansDurationMinutes(int minutes);

  /// No description provided for @tripPlansDurationHours.
  ///
  /// In fr, this message translates to:
  /// **'{hours}h'**
  String tripPlansDurationHours(int hours);

  /// No description provided for @tripPlansDurationHoursMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{hours}h{minutes}'**
  String tripPlansDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @reviewsAllRatingsFilter.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get reviewsAllRatingsFilter;

  /// No description provided for @reviewsAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tous les avis'**
  String get reviewsAllTitle;

  /// No description provided for @reviewsCannotReviewAlreadyReviewed.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà laissé un avis sur cet événement.'**
  String get reviewsCannotReviewAlreadyReviewed;

  /// No description provided for @reviewsCannotReviewEventNotEnded.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez laisser un avis une fois l\'événement passé.'**
  String get reviewsCannotReviewEventNotEnded;

  /// No description provided for @reviewsCannotReviewNotParticipated.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les participants à l\'événement peuvent laisser un avis.'**
  String get reviewsCannotReviewNotParticipated;

  /// No description provided for @reviewsCannotReviewOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez pas noter vos propres événements.'**
  String get reviewsCannotReviewOrganizer;

  /// No description provided for @reviewsCannotReviewUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez pas laisser d\'avis pour le moment.'**
  String get reviewsCannotReviewUnknown;

  /// No description provided for @reviewsCommentMinLengthError.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis doit faire au moins {minLength} caractères'**
  String reviewsCommentMinLengthError(int minLength);

  /// No description provided for @reviewsCommentRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez écrire votre avis'**
  String get reviewsCommentRequiredError;

  /// No description provided for @reviewsCommentRequiredLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis *'**
  String get reviewsCommentRequiredLabel;

  /// No description provided for @reviewsCreateSuccessPendingModeration.
  ///
  /// In fr, this message translates to:
  /// **'Avis envoyé. Il sera publié après validation.'**
  String get reviewsCreateSuccessPendingModeration;

  /// No description provided for @reviewsDeleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get reviewsDeleteAction;

  /// No description provided for @reviewsDeleteConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est définitive. Vous pourrez en écrire un nouveau plus tard.'**
  String get reviewsDeleteConfirmBody;

  /// No description provided for @reviewsDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cet avis ?'**
  String get reviewsDeleteConfirmTitle;

  /// No description provided for @reviewsDeleteSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Avis supprimé'**
  String get reviewsDeleteSuccess;

  /// No description provided for @reviewsEditAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get reviewsEditAction;

  /// No description provided for @reviewsEditModerationNotice.
  ///
  /// In fr, this message translates to:
  /// **'Toute modification remettra votre avis en attente de modération.'**
  String get reviewsEditModerationNotice;

  /// No description provided for @reviewsEditMyReviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon avis'**
  String get reviewsEditMyReviewTitle;

  /// No description provided for @reviewsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Partagez votre expérience et aidez les autres à choisir !'**
  String get reviewsEmptyBody;

  /// No description provided for @reviewsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore d\'avis'**
  String get reviewsEmptyTitle;

  /// No description provided for @reviewsEventFallback.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get reviewsEventFallback;

  /// No description provided for @reviewsFeaturedFilter.
  ///
  /// In fr, this message translates to:
  /// **'Mis en avant'**
  String get reviewsFeaturedFilter;

  /// No description provided for @reviewsUserLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos avis.'**
  String get reviewsUserLoadError;

  /// No description provided for @reviewsUserLoadMoreError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la suite.'**
  String get reviewsUserLoadMoreError;

  /// No description provided for @reviewsMyEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez encore laissé aucun avis. Une fois un événement terminé, vous pourrez partager votre expérience !'**
  String get reviewsMyEmptyBody;

  /// No description provided for @reviewsMyEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis'**
  String get reviewsMyEmptyTitle;

  /// No description provided for @reviewsNoFilteredResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis ne correspond aux filtres sélectionnés.'**
  String get reviewsNoFilteredResults;

  /// No description provided for @reviewsNoReviewsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis'**
  String get reviewsNoReviewsTitle;

  /// No description provided for @reviewsOrganizerReplied.
  ///
  /// In fr, this message translates to:
  /// **'L\'organisateur a répondu'**
  String get reviewsOrganizerReplied;

  /// No description provided for @reviewsReportAction.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get reviewsReportAction;

  /// No description provided for @reviewsReportDetailsOptionalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Précisions (optionnel)'**
  String get reviewsReportDetailsOptionalLabel;

  /// No description provided for @reviewsReportReasonFake.
  ///
  /// In fr, this message translates to:
  /// **'Faux avis'**
  String get reviewsReportReasonFake;

  /// No description provided for @reviewsReportReasonInappropriate.
  ///
  /// In fr, this message translates to:
  /// **'Contenu inapproprié'**
  String get reviewsReportReasonInappropriate;

  /// No description provided for @reviewsReportReasonOffensive.
  ///
  /// In fr, this message translates to:
  /// **'Propos offensants'**
  String get reviewsReportReasonOffensive;

  /// No description provided for @reviewsReportReasonOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get reviewsReportReasonOther;

  /// No description provided for @reviewsReportReasonQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi cet avis pose-t-il problème ?'**
  String get reviewsReportReasonQuestion;

  /// No description provided for @reviewsReportReasonSpam.
  ///
  /// In fr, this message translates to:
  /// **'Spam'**
  String get reviewsReportReasonSpam;

  /// No description provided for @reviewsReportSubmitAction.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le signalement'**
  String get reviewsReportSubmitAction;

  /// No description provided for @reviewsReportSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Signalement envoyé. Merci de votre vigilance.'**
  String get reviewsReportSuccess;

  /// No description provided for @reviewsReportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signaler cet avis'**
  String get reviewsReportTitle;

  /// No description provided for @reviewsRewriteAction.
  ///
  /// In fr, this message translates to:
  /// **'Réécrire'**
  String get reviewsRewriteAction;

  /// No description provided for @reviewsSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avis'**
  String get reviewsSectionTitle;

  /// No description provided for @reviewsSelectRatingRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une note'**
  String get reviewsSelectRatingRequired;

  /// No description provided for @reviewsSortMostHelpful.
  ///
  /// In fr, this message translates to:
  /// **'Plus utiles'**
  String get reviewsSortMostHelpful;

  /// No description provided for @reviewsSortNewest.
  ///
  /// In fr, this message translates to:
  /// **'Plus récents'**
  String get reviewsSortNewest;

  /// No description provided for @reviewsSortRating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get reviewsSortRating;

  /// No description provided for @reviewsSortTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Trier'**
  String get reviewsSortTooltip;

  /// No description provided for @reviewsStatusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Publié'**
  String get reviewsStatusApproved;

  /// No description provided for @reviewsStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get reviewsStatusPending;

  /// No description provided for @reviewsStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusé'**
  String get reviewsStatusRejected;

  /// No description provided for @reviewsSubmitAction.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer mon avis'**
  String get reviewsSubmitAction;

  /// No description provided for @reviewsTitleRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez ajouter un titre'**
  String get reviewsTitleRequiredError;

  /// No description provided for @reviewsTitleRequiredLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre *'**
  String get reviewsTitleRequiredLabel;

  /// No description provided for @reviewsTotalCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun avis} =1{1 avis} other{{count} avis}}'**
  String reviewsTotalCount(int count);

  /// No description provided for @reviewsUpdateAction.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour'**
  String get reviewsUpdateAction;

  /// No description provided for @reviewsUpdateSuccessPendingModeration.
  ///
  /// In fr, this message translates to:
  /// **'Avis mis à jour. Il sera de nouveau modéré.'**
  String get reviewsUpdateSuccessPendingModeration;

  /// No description provided for @reviewsVerifiedFilter.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiés'**
  String get reviewsVerifiedFilter;

  /// No description provided for @reviewsViewAllAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir tous les avis ({count})'**
  String reviewsViewAllAction(int count);

  /// No description provided for @reviewsViewMyReviewAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir mon avis →'**
  String get reviewsViewMyReviewAction;

  /// No description provided for @reviewsWriteAction.
  ///
  /// In fr, this message translates to:
  /// **'Écrire'**
  String get reviewsWriteAction;

  /// No description provided for @reviewsWriteFirstAction.
  ///
  /// In fr, this message translates to:
  /// **'Écrire le premier avis'**
  String get reviewsWriteFirstAction;

  /// No description provided for @reviewsWriteReviewAction.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un avis'**
  String get reviewsWriteReviewAction;

  /// No description provided for @reviewsWriteReviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Laisser un avis'**
  String get reviewsWriteReviewTitle;

  /// No description provided for @reviewsYourRatingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre note'**
  String get reviewsYourRatingLabel;

  /// No description provided for @reviewsYourReviewLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis'**
  String get reviewsYourReviewLabel;

  /// No description provided for @gamificationActionsCatalogLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le catalogue'**
  String get gamificationActionsCatalogLoadError;

  /// No description provided for @gamificationActionsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune action disponible pour le moment'**
  String get gamificationActionsEmpty;

  /// No description provided for @gamificationActivitiesBonusTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activités & Bonus'**
  String get gamificationActivitiesBonusTitle;

  /// No description provided for @gamificationAllFilter.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get gamificationAllFilter;

  /// No description provided for @gamificationBadgeLocked.
  ///
  /// In fr, this message translates to:
  /// **'À débloquer'**
  String get gamificationBadgeLocked;

  /// No description provided for @gamificationBadgeUnlocked.
  ///
  /// In fr, this message translates to:
  /// **'Débloqué'**
  String get gamificationBadgeUnlocked;

  /// No description provided for @gamificationBadgeUnlockedCongrats.
  ///
  /// In fr, this message translates to:
  /// **'Bravo, tu as débloqué ce badge !'**
  String get gamificationBadgeUnlockedCongrats;

  /// No description provided for @gamificationBadgesLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger tes badges'**
  String get gamificationBadgesLoadError;

  /// No description provided for @gamificationBoostersUtilitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Boosters & Utilitaires'**
  String get gamificationBoostersUtilitiesTitle;

  /// No description provided for @gamificationCapReached.
  ///
  /// In fr, this message translates to:
  /// **'Atteint'**
  String get gamificationCapReached;

  /// No description provided for @gamificationChallengesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Challenges'**
  String get gamificationChallengesTitle;

  /// No description provided for @gamificationClaimDailyReward.
  ///
  /// In fr, this message translates to:
  /// **'Réclamer ma récompense'**
  String get gamificationClaimDailyReward;

  /// No description provided for @gamificationComeBackTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Reviens demain !'**
  String get gamificationComeBackTomorrow;

  /// No description provided for @gamificationCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Effectué'**
  String get gamificationCompleted;

  /// No description provided for @gamificationCurrentRankPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Tu es'**
  String get gamificationCurrentRankPrefix;

  /// No description provided for @gamificationDailyClaimError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la réclamation'**
  String get gamificationDailyClaimError;

  /// No description provided for @gamificationDailyRewardAlreadyClaimed.
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà réclamé ta récompense aujourd\'hui !'**
  String get gamificationDailyRewardAlreadyClaimed;

  /// No description provided for @gamificationDailyRewardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récompense quotidienne'**
  String get gamificationDailyRewardTitle;

  /// No description provided for @gamificationDayNumber.
  ///
  /// In fr, this message translates to:
  /// **'J-{dayNumber}'**
  String gamificationDayNumber(int dayNumber);

  /// No description provided for @gamificationEarningsByPillarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par pilier'**
  String get gamificationEarningsByPillarTitle;

  /// No description provided for @gamificationErrorWithMessage.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {message}'**
  String gamificationErrorWithMessage(String message);

  /// No description provided for @gamificationGreatCta.
  ///
  /// In fr, this message translates to:
  /// **'Super !'**
  String get gamificationGreatCta;

  /// No description provided for @gamificationHibonsAmount.
  ///
  /// In fr, this message translates to:
  /// **'{count} HIBONs'**
  String gamificationHibonsAmount(int count);

  /// No description provided for @gamificationHibonsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Hibons disponibles'**
  String get gamificationHibonsAvailable;

  /// No description provided for @gamificationHibonsDelta.
  ///
  /// In fr, this message translates to:
  /// **'{delta} Hibons'**
  String gamificationHibonsDelta(int delta);

  /// No description provided for @gamificationHibonsEarned.
  ///
  /// In fr, this message translates to:
  /// **'{count} Hibons gagnés'**
  String gamificationHibonsEarned(int count);

  /// No description provided for @gamificationHibonsGainedToast.
  ///
  /// In fr, this message translates to:
  /// **'+{delta} Hibons gagnés !'**
  String gamificationHibonsGainedToast(int delta);

  /// No description provided for @gamificationHibonsPacksComingSoonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Packs de Hibons (bientôt)'**
  String get gamificationHibonsPacksComingSoonTitle;

  /// No description provided for @gamificationHibonsProgress.
  ///
  /// In fr, this message translates to:
  /// **'{current} / {total} HIBONs'**
  String gamificationHibonsProgress(int current, int total);

  /// No description provided for @gamificationHibonsRemainingForBadge.
  ///
  /// In fr, this message translates to:
  /// **'Encore {count} HIBONs pour débloquer ce badge'**
  String gamificationHibonsRemainingForBadge(int count);

  /// No description provided for @gamificationHibonsUnit.
  ///
  /// In fr, this message translates to:
  /// **'Hibons'**
  String get gamificationHibonsUnit;

  /// No description provided for @gamificationHibonsUntilNextRank.
  ///
  /// In fr, this message translates to:
  /// **'Plus que {count} avant {rankLabel}'**
  String gamificationHibonsUntilNextRank(int count, String rankLabel);

  /// No description provided for @gamificationHibouExpressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Hibou Express (24 h)'**
  String get gamificationHibouExpressTitle;

  /// No description provided for @gamificationHibouExpressDescription.
  ///
  /// In fr, this message translates to:
  /// **'Messages illimités avec Petit Boo'**
  String get gamificationHibouExpressDescription;

  /// No description provided for @gamificationHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get gamificationHistoryTitle;

  /// No description provided for @gamificationHowToEarnTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment gagner des Hibons'**
  String get gamificationHowToEarnTitle;

  /// No description provided for @gamificationInAppPurchasesComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Les achats In-App arrivent bientôt !'**
  String get gamificationInAppPurchasesComingSoon;

  /// No description provided for @gamificationInsufficientHibons.
  ///
  /// In fr, this message translates to:
  /// **'Hibons insuffisants !'**
  String get gamificationInsufficientHibons;

  /// No description provided for @gamificationLifetimeHibonsAccumulated.
  ///
  /// In fr, this message translates to:
  /// **'{count} HIBONs cumulés'**
  String gamificationLifetimeHibonsAccumulated(int count);

  /// No description provided for @gamificationLockedCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'À débloquer'**
  String get gamificationLockedCountLabel;

  /// No description provided for @gamificationLuckyWheelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Roue de la Fortune'**
  String get gamificationLuckyWheelTitle;

  /// No description provided for @gamificationMaxRankReached.
  ///
  /// In fr, this message translates to:
  /// **'Rang maximal atteint'**
  String get gamificationMaxRankReached;

  /// No description provided for @gamificationMultiplierDescription.
  ///
  /// In fr, this message translates to:
  /// **'Gagnez plus de Hibons pendant 1h'**
  String get gamificationMultiplierDescription;

  /// No description provided for @gamificationMultiplierTitle.
  ///
  /// In fr, this message translates to:
  /// **'Multiplicateur x1.5 (1h)'**
  String get gamificationMultiplierTitle;

  /// No description provided for @gamificationMyBadgesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes badges'**
  String get gamificationMyBadgesTitle;

  /// No description provided for @gamificationNewHibonsBalance.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau solde : {balance} Hibons'**
  String gamificationNewHibonsBalance(int balance);

  /// No description provided for @gamificationNoTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get gamificationNoTransactions;

  /// No description provided for @gamificationPetitBooDailyBonus.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{+1 message Petit Boo / jour} other{+{count} messages Petit Boo / jour}}'**
  String gamificationPetitBooDailyBonus(int count);

  /// No description provided for @gamificationPillarCommunity.
  ///
  /// In fr, this message translates to:
  /// **'Communauté'**
  String get gamificationPillarCommunity;

  /// No description provided for @gamificationPillarDiscovery.
  ///
  /// In fr, this message translates to:
  /// **'Découverte'**
  String get gamificationPillarDiscovery;

  /// No description provided for @gamificationPillarEngagement.
  ///
  /// In fr, this message translates to:
  /// **'Engagement'**
  String get gamificationPillarEngagement;

  /// No description provided for @gamificationPillarOnboarding.
  ///
  /// In fr, this message translates to:
  /// **'Onboarding'**
  String get gamificationPillarOnboarding;

  /// No description provided for @gamificationPillarParticipation.
  ///
  /// In fr, this message translates to:
  /// **'Participation'**
  String get gamificationPillarParticipation;

  /// No description provided for @gamificationProgressionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Progression'**
  String get gamificationProgressionTitle;

  /// No description provided for @gamificationProgressThisWeek.
  ///
  /// In fr, this message translates to:
  /// **'{completed}/{total} cette semaine'**
  String gamificationProgressThisWeek(int completed, int total);

  /// No description provided for @gamificationProgressToday.
  ///
  /// In fr, this message translates to:
  /// **'{completed}/{total} aujourd\'hui'**
  String gamificationProgressToday(int completed, int total);

  /// No description provided for @gamificationPurchaseCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Achat effectué : {itemName}'**
  String gamificationPurchaseCompleted(String itemName);

  /// No description provided for @gamificationRankUpCongratsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bravo !'**
  String get gamificationRankUpCongratsTitle;

  /// No description provided for @gamificationRankUpNowRank.
  ///
  /// In fr, this message translates to:
  /// **'Tu es maintenant {rankLabel} !'**
  String gamificationRankUpNowRank(String rankLabel);

  /// No description provided for @gamificationRemainingLifetime.
  ///
  /// In fr, this message translates to:
  /// **'{count} restant'**
  String gamificationRemainingLifetime(int count);

  /// No description provided for @gamificationShopTitle.
  ///
  /// In fr, this message translates to:
  /// **'Boutique Hibons'**
  String get gamificationShopTitle;

  /// No description provided for @gamificationStartingRank.
  ///
  /// In fr, this message translates to:
  /// **'Rang de départ'**
  String get gamificationStartingRank;

  /// No description provided for @gamificationStreakShieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bouclier de série'**
  String get gamificationStreakShieldTitle;

  /// No description provided for @gamificationStreakShieldDescription.
  ///
  /// In fr, this message translates to:
  /// **'Protégez votre série pour 1 jour'**
  String get gamificationStreakShieldDescription;

  /// No description provided for @gamificationTopCta.
  ///
  /// In fr, this message translates to:
  /// **'Top !'**
  String get gamificationTopCta;

  /// No description provided for @gamificationTotalCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get gamificationTotalCountLabel;

  /// No description provided for @gamificationUnlockedCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Débloqués'**
  String get gamificationUnlockedCountLabel;

  /// No description provided for @gamificationWheelAlreadyUsedToday.
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà utilisé ta chance aujourd\'hui.'**
  String get gamificationWheelAlreadyUsedToday;

  /// No description provided for @gamificationWheelLoseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pas de chance...'**
  String get gamificationWheelLoseTitle;

  /// No description provided for @gamificationWheelSpinCta.
  ///
  /// In fr, this message translates to:
  /// **'Lancer'**
  String get gamificationWheelSpinCta;

  /// No description provided for @gamificationWheelWinTitle.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations !'**
  String get gamificationWheelWinTitle;

  /// No description provided for @alertsListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes alertes et recherches'**
  String get alertsListTitle;

  /// No description provided for @alertsFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get alertsFilterAll;

  /// No description provided for @alertsFilterAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get alertsFilterAlerts;

  /// No description provided for @alertsFilterSearches.
  ///
  /// In fr, this message translates to:
  /// **'Recherches'**
  String get alertsFilterSearches;

  /// No description provided for @alertsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos alertes'**
  String get alertsLoadError;

  /// No description provided for @alertsEmptyAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune alerte pour le moment'**
  String get alertsEmptyAllTitle;

  /// No description provided for @alertsEmptyAllBody.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez vos recherches pour les retrouver ici et recevoir des notifications'**
  String get alertsEmptyAllBody;

  /// No description provided for @alertsEmptyActiveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune alerte active'**
  String get alertsEmptyActiveTitle;

  /// No description provided for @alertsEmptyActiveBody.
  ///
  /// In fr, this message translates to:
  /// **'Activez les notifications sur vos recherches pour être alerté des nouveaux événements'**
  String get alertsEmptyActiveBody;

  /// No description provided for @alertsEmptySearchesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune recherche enregistrée'**
  String get alertsEmptySearchesTitle;

  /// No description provided for @alertsEmptySearchesBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos recherches sans notification apparaîtront ici'**
  String get alertsEmptySearchesBody;

  /// No description provided for @alertsExploreActivities.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les activités'**
  String get alertsExploreActivities;

  /// No description provided for @alertsDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'alerte'**
  String get alertsDeleteTitle;

  /// No description provided for @alertsDeleteBody.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer cette recherche enregistrée ?'**
  String get alertsDeleteBody;

  /// No description provided for @alertsDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Alerte « {name} » supprimée'**
  String alertsDeleted(String name);

  /// No description provided for @alertsCreatedOn.
  ///
  /// In fr, this message translates to:
  /// **'Créée le {date}'**
  String alertsCreatedOn(String date);

  /// No description provided for @alertsAllEvents.
  ///
  /// In fr, this message translates to:
  /// **'Tous les événements'**
  String get alertsAllEvents;

  /// No description provided for @alertsUnnamed.
  ///
  /// In fr, this message translates to:
  /// **'Alerte sans nom'**
  String get alertsUnnamed;

  /// No description provided for @favoritesLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get favoritesLoadError;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des événements à vos favoris en cliquant sur le cœur pour les retrouver facilement.'**
  String get favoritesEmptyBody;

  /// No description provided for @favoritesEmptyUncategorizedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori non classé'**
  String get favoritesEmptyUncategorizedTitle;

  /// No description provided for @favoritesEmptyUncategorizedBody.
  ///
  /// In fr, this message translates to:
  /// **'Tous vos favoris sont organisés dans des listes.'**
  String get favoritesEmptyUncategorizedBody;

  /// No description provided for @favoritesEmptyListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cette liste est vide'**
  String get favoritesEmptyListTitle;

  /// No description provided for @favoritesEmptyListBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des favoris à cette liste depuis le détail d\'un événement.'**
  String get favoritesEmptyListBody;

  /// No description provided for @favoritesExploreEvents.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les événements'**
  String get favoritesExploreEvents;

  /// No description provided for @favoriteListsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes listes'**
  String get favoriteListsTitle;

  /// No description provided for @favoriteListsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get favoriteListsLoadError;

  /// No description provided for @favoriteListsAllFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Tous les favoris'**
  String get favoriteListsAllFavorites;

  /// No description provided for @favoriteListsAllShort.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get favoriteListsAllShort;

  /// No description provided for @favoriteListsUncategorized.
  ///
  /// In fr, this message translates to:
  /// **'Non classés'**
  String get favoriteListsUncategorized;

  /// No description provided for @favoriteListsUncategorizedSingular.
  ///
  /// In fr, this message translates to:
  /// **'Non classé'**
  String get favoriteListsUncategorizedSingular;

  /// No description provided for @favoriteListsSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'MES LISTES'**
  String get favoriteListsSectionTitle;

  /// No description provided for @favoriteListNewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle liste'**
  String get favoriteListNewTitle;

  /// No description provided for @favoriteListOrganizeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Organisez vos favoris'**
  String get favoriteListOrganizeSubtitle;

  /// No description provided for @favoriteListNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la liste'**
  String get favoriteListNameLabel;

  /// No description provided for @favoriteListNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. : Concerts à voir'**
  String get favoriteListNameHint;

  /// No description provided for @favoriteListNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un nom'**
  String get favoriteListNameRequired;

  /// No description provided for @favoriteListNameMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le nom doit contenir au moins 2 caractères'**
  String get favoriteListNameMinLength;

  /// No description provided for @favoriteListNameMaxLength.
  ///
  /// In fr, this message translates to:
  /// **'Le nom ne peut pas dépasser 50 caractères'**
  String get favoriteListNameMaxLength;

  /// No description provided for @favoriteListDescriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description (optionnelle)'**
  String get favoriteListDescriptionLabel;

  /// No description provided for @favoriteListDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. : Mes événements musicaux préférés'**
  String get favoriteListDescriptionHint;

  /// No description provided for @favoriteListColorLabel.
  ///
  /// In fr, this message translates to:
  /// **'Couleur'**
  String get favoriteListColorLabel;

  /// No description provided for @favoriteListIconLabel.
  ///
  /// In fr, this message translates to:
  /// **'Icône'**
  String get favoriteListIconLabel;

  /// No description provided for @favoriteListCreateAction.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get favoriteListCreateAction;

  /// No description provided for @favoriteListCreateError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création de la liste'**
  String get favoriteListCreateError;

  /// No description provided for @favoriteListEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la liste'**
  String get favoriteListEditTitle;

  /// No description provided for @favoriteListFavoritesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 favori} =1{1 favori} other{{count} favoris}}'**
  String favoriteListFavoritesCount(int count);

  /// No description provided for @favoriteListUpdateError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la mise à jour'**
  String get favoriteListUpdateError;

  /// No description provided for @favoriteListDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la liste ?'**
  String get favoriteListDeleteTitle;

  /// No description provided for @favoriteListDeleteBody.
  ///
  /// In fr, this message translates to:
  /// **'La liste « {name} » sera supprimée.'**
  String favoriteListDeleteBody(String name);

  /// No description provided for @favoriteListDeleteMoveBody.
  ///
  /// In fr, this message translates to:
  /// **'Les événements favoris ne seront pas supprimés, ils seront déplacés dans « Non classés ».'**
  String get favoriteListDeleteMoveBody;

  /// No description provided for @favoriteListDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Liste « {name} » supprimée'**
  String favoriteListDeleted(String name);

  /// No description provided for @favoriteListDeleteError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la suppression'**
  String get favoriteListDeleteError;

  /// No description provided for @favoriteListDeleteThisAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette liste'**
  String get favoriteListDeleteThisAction;

  /// No description provided for @favoriteListPickerMoveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Déplacer vers...'**
  String get favoriteListPickerMoveTitle;

  /// No description provided for @favoriteListPickerAddTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get favoriteListPickerAddTitle;

  /// No description provided for @favoriteListPickerUncategorizedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Favoris sans liste'**
  String get favoriteListPickerUncategorizedSubtitle;

  /// No description provided for @favoriteListCreateSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer une liste'**
  String get favoriteListCreateSheetTitle;

  /// No description provided for @favoriteListCreateSheetSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle collection de favoris'**
  String get favoriteListCreateSheetSubtitle;

  /// No description provided for @favoriteListPickerRemoveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get favoriteListPickerRemoveTitle;

  /// No description provided for @favoriteListPickerRemoveSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer de tous les favoris'**
  String get favoriteListPickerRemoveSubtitle;

  /// No description provided for @favoriteAddError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ajouter aux favoris'**
  String get favoriteAddError;

  /// No description provided for @favoriteRemoveError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de retirer des favoris'**
  String get favoriteRemoveError;

  /// No description provided for @favoriteUpdateError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de modifier le favori'**
  String get favoriteUpdateError;

  /// No description provided for @favoriteMovedToList.
  ///
  /// In fr, this message translates to:
  /// **'Déplacé vers la liste'**
  String get favoriteMovedToList;

  /// No description provided for @favoriteMovedToUncategorized.
  ///
  /// In fr, this message translates to:
  /// **'Déplacé vers « Non classés »'**
  String get favoriteMovedToUncategorized;

  /// No description provided for @favoriteAddedToList.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté à la liste'**
  String get favoriteAddedToList;

  /// No description provided for @favoriteGenericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get favoriteGenericError;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get notificationsFilterAll;

  /// No description provided for @notificationsFilterUnread.
  ///
  /// In fr, this message translates to:
  /// **'Non lues'**
  String get notificationsFilterUnread;

  /// No description provided for @notificationsGuestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous'**
  String get notificationsGuestTitle;

  /// No description provided for @notificationsGuestBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos notifications apparaîtront ici après connexion.'**
  String get notificationsGuestBody;

  /// No description provided for @notificationsReadSyncError.
  ///
  /// In fr, this message translates to:
  /// **'Lecture non synchronisée'**
  String get notificationsReadSyncError;

  /// No description provided for @notificationsMarkRead.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme lu'**
  String get notificationsMarkRead;

  /// No description provided for @notificationsMarkReadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de marquer comme lu'**
  String get notificationsMarkReadError;

  /// No description provided for @notificationsMarkedAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Notifications marquées comme lues'**
  String get notificationsMarkedAllRead;

  /// No description provided for @notificationsActionError.
  ///
  /// In fr, this message translates to:
  /// **'Action impossible pour le moment'**
  String get notificationsActionError;

  /// No description provided for @notificationsDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Notification supprimée'**
  String get notificationsDeleted;

  /// No description provided for @notificationsDeleteError.
  ///
  /// In fr, this message translates to:
  /// **'Suppression impossible'**
  String get notificationsDeleteError;

  /// No description provided for @notificationsDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la notification'**
  String get notificationsDeleteTitle;

  /// No description provided for @notificationsDeleteBody.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer cette notification ?'**
  String get notificationsDeleteBody;

  /// No description provided for @notificationsJustNow.
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant'**
  String get notificationsJustNow;

  /// No description provided for @notificationsMinutesAgoShort.
  ///
  /// In fr, this message translates to:
  /// **'{count} min'**
  String notificationsMinutesAgoShort(int count);

  /// No description provided for @notificationsHoursAgoShort.
  ///
  /// In fr, this message translates to:
  /// **'{count} h'**
  String notificationsHoursAgoShort(int count);

  /// No description provided for @notificationsDaysAgoShort.
  ///
  /// In fr, this message translates to:
  /// **'{count} j'**
  String notificationsDaysAgoShort(int count);

  /// No description provided for @notificationsTypeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Message'**
  String get notificationsTypeMessage;

  /// No description provided for @notificationsTypeBooking.
  ///
  /// In fr, this message translates to:
  /// **'Réservation'**
  String get notificationsTypeBooking;

  /// No description provided for @notificationsTypeTicket.
  ///
  /// In fr, this message translates to:
  /// **'Billet'**
  String get notificationsTypeTicket;

  /// No description provided for @notificationsTypeEvent.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get notificationsTypeEvent;

  /// No description provided for @notificationsTypeReview.
  ///
  /// In fr, this message translates to:
  /// **'Avis'**
  String get notificationsTypeReview;

  /// No description provided for @notificationsTypeQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question'**
  String get notificationsTypeQuestion;

  /// No description provided for @notificationsTypeOrganization.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get notificationsTypeOrganization;

  /// No description provided for @notificationsTypeInfo.
  ///
  /// In fr, this message translates to:
  /// **'Info'**
  String get notificationsTypeInfo;

  /// No description provided for @notificationsEmptyUnreadTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification non lue'**
  String get notificationsEmptyUnreadTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification pour le moment'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyUnreadBody.
  ///
  /// In fr, this message translates to:
  /// **'Les nouvelles notifications apparaîtront ici.'**
  String get notificationsEmptyUnreadBody;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos messages, réservations et mises à jour importantes apparaîtront ici.'**
  String get notificationsEmptyBody;

  /// No description provided for @notificationsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos notifications'**
  String get notificationsLoadError;

  /// No description provided for @remindersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes rappels'**
  String get remindersTitle;

  /// No description provided for @remindersUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get remindersUpcoming;

  /// No description provided for @remindersPast.
  ///
  /// In fr, this message translates to:
  /// **'Passés'**
  String get remindersPast;

  /// No description provided for @remindersDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le rappel ?'**
  String get remindersDeleteTitle;

  /// No description provided for @remindersDeleteBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne recevrez plus de notifications pour « {eventTitle} » le {date}.'**
  String remindersDeleteBody(String eventTitle, String date);

  /// No description provided for @remindersDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Rappel supprimé'**
  String get remindersDeleted;

  /// No description provided for @remindersDateFromTo.
  ///
  /// In fr, this message translates to:
  /// **'{date} de {start} à {end}'**
  String remindersDateFromTo(String date, String start, String end);

  /// No description provided for @remindersDateAtTime.
  ///
  /// In fr, this message translates to:
  /// **'{date} à {start}'**
  String remindersDateAtTime(String date, String start);

  /// No description provided for @remindersEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rappel'**
  String get remindersEmptyTitle;

  /// No description provided for @remindersEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Activez des rappels sur les activités qui vous intéressent pour être notifié.'**
  String get remindersEmptyBody;

  /// No description provided for @remindersLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos rappels'**
  String get remindersLoadError;

  /// No description provided for @remindersDaysBeforeBadge.
  ///
  /// In fr, this message translates to:
  /// **'J-{count}'**
  String remindersDaysBeforeBadge(int count);

  /// No description provided for @onboardingExploreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sortez et expérimentez'**
  String get onboardingExploreTitle;

  /// No description provided for @onboardingExploreDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ateliers, balades, spectacles enfants : trouvez l\'activité du week-end sans y passer votre soirée.'**
  String get onboardingExploreDescription;

  /// No description provided for @onboardingMusicTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vibrez au rythme de votre ville'**
  String get onboardingMusicTitle;

  /// No description provided for @onboardingMusicDescription.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez les concerts, festivals et soirées qui font bouger votre région. Ne ratez plus aucun événement musical.'**
  String get onboardingMusicDescription;

  /// No description provided for @onboardingLocalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restez connecté aux nouveautés du coin'**
  String get onboardingLocalTitle;

  /// No description provided for @onboardingLocalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Marchés, lieux à découvrir : les bonnes adresses à deux pas de chez vous.'**
  String get onboardingLocalDescription;

  /// No description provided for @onboardingAssociationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Membre d\'une asso ?'**
  String get onboardingAssociationTitle;

  /// No description provided for @onboardingAssociationDescription.
  ///
  /// In fr, this message translates to:
  /// **'Accédez aux événements privés réservés à vos associations : sport, école, culture, loisirs. Tout au même endroit.'**
  String get onboardingAssociationDescription;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti'**
  String get onboardingGetStarted;

  /// No description provided for @thematiquesExploreByTypeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorer par type d\'événement'**
  String get thematiquesExploreByTypeTitle;

  /// No description provided for @thematiquesSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get thematiquesSeeAll;

  /// No description provided for @thematiquesAllTypesCount.
  ///
  /// In fr, this message translates to:
  /// **'Tous les types ({count})'**
  String thematiquesAllTypesCount(int count);

  /// No description provided for @thematiquesSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un type d\'événement...'**
  String get thematiquesSearchHint;

  /// No description provided for @thematiquesEventCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 événement} =1{1 événement} other{{count} événements}}'**
  String thematiquesEventCount(int count);

  /// No description provided for @categoriesAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get categoriesAllTitle;

  /// No description provided for @categoriesSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les catégories'**
  String get categoriesSeeAll;

  /// No description provided for @categoriesAllCount.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories ({count})'**
  String categoriesAllCount(int count);

  /// No description provided for @categoriesSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une catégorie...'**
  String get categoriesSearchHint;

  /// No description provided for @categoriesEmptySearch.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie trouvée'**
  String get categoriesEmptySearch;

  /// No description provided for @blogLatestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Derniers articles'**
  String get blogLatestTitle;

  /// No description provided for @blogEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun article disponible'**
  String get blogEmpty;

  /// No description provided for @blogReadingTimeMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String blogReadingTimeMinutes(int minutes);
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
