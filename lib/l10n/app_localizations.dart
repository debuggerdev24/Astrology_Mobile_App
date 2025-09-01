import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @spiritualDisclaimers.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Disclaimers'**
  String get spiritualDisclaimers;

  /// No description provided for @faqS.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqS;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @dasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha'**
  String get dasha;

  /// No description provided for @moonSign.
  ///
  /// In en, this message translates to:
  /// **'Moon Sign'**
  String get moonSign;

  /// No description provided for @dailyMantra.
  ///
  /// In en, this message translates to:
  /// **'Daily Mantra'**
  String get dailyMantra;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @mantras.
  ///
  /// In en, this message translates to:
  /// **'Mantras'**
  String get mantras;

  /// No description provided for @remedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get remedies;

  /// No description provided for @consult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get consult;

  /// No description provided for @viewDetailedReading.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Reading'**
  String get viewDetailedReading;

  /// No description provided for @dailyMantraLog.
  ///
  /// In en, this message translates to:
  /// **'Daily Mantra Log'**
  String get dailyMantraLog;

  /// No description provided for @pleaseUploadYourPalmImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please upload your palm image first.'**
  String get pleaseUploadYourPalmImageFirst;

  /// No description provided for @leftHand.
  ///
  /// In en, this message translates to:
  /// **'Left Hand'**
  String get leftHand;

  /// No description provided for @rightHand.
  ///
  /// In en, this message translates to:
  /// **'Right Hand'**
  String get rightHand;

  /// No description provided for @submitForReading.
  ///
  /// In en, this message translates to:
  /// **'Submit For Reading'**
  String get submitForReading;

  /// No description provided for @uploadImageScreenPara.
  ///
  /// In en, this message translates to:
  /// **'Your personalized palm reading will only be generated after uploading your palm photo.  Once the analysis is complete, tailored remedies will be suggested based on your palm and horoscope alignment.'**
  String get uploadImageScreenPara;

  /// No description provided for @palmReading.
  ///
  /// In en, this message translates to:
  /// **'Palm Reading'**
  String get palmReading;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @mountAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Mount Analysis'**
  String get mountAnalysis;

  /// No description provided for @lifeLine.
  ///
  /// In en, this message translates to:
  /// **'Life Line'**
  String get lifeLine;

  /// No description provided for @headLine.
  ///
  /// In en, this message translates to:
  /// **'Head Line'**
  String get headLine;

  /// No description provided for @heartLine.
  ///
  /// In en, this message translates to:
  /// **'Heart Line'**
  String get heartLine;

  /// No description provided for @mountOfJupiter.
  ///
  /// In en, this message translates to:
  /// **'Mount Of Jupiter'**
  String get mountOfJupiter;

  /// No description provided for @mountOfVenus.
  ///
  /// In en, this message translates to:
  /// **'Mount Of Venus'**
  String get mountOfVenus;

  /// No description provided for @viewRemedies.
  ///
  /// In en, this message translates to:
  /// **'View Remedies'**
  String get viewRemedies;

  /// No description provided for @matchWithBirthCart.
  ///
  /// In en, this message translates to:
  /// **'Match With Birth Cart'**
  String get matchWithBirthCart;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @planet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get planet;

  /// No description provided for @birthChart.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart'**
  String get birthChart;

  /// No description provided for @birthChartSummary.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart Summary'**
  String get birthChartSummary;

  /// No description provided for @palmReadingSummary.
  ///
  /// In en, this message translates to:
  /// **'Palm Reading Summary'**
  String get palmReadingSummary;

  /// No description provided for @interpretation.
  ///
  /// In en, this message translates to:
  /// **'Interpretation'**
  String get interpretation;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @moonInPisces.
  ///
  /// In en, this message translates to:
  /// **'Moon in Pisces'**
  String get moonInPisces;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaning;

  /// No description provided for @suggestedAction.
  ///
  /// In en, this message translates to:
  /// **'Suggested Actions'**
  String get suggestedAction;

  /// No description provided for @textInstruction.
  ///
  /// In en, this message translates to:
  /// **'Text Instruction'**
  String get textInstruction;

  /// No description provided for @spiritualMeaning.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Meaning'**
  String get spiritualMeaning;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Title'**
  String get reminderTitle;

  /// No description provided for @reminderTitleHintText.
  ///
  /// In en, this message translates to:
  /// **'Morning Pooja for Mars Remedy'**
  String get reminderTitleHintText;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateAndTime;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get saveReminder;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get chooseYourPlan;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @basicHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Basic Horoscope'**
  String get basicHoroscope;

  /// No description provided for @dailyTips.
  ///
  /// In en, this message translates to:
  /// **'Daily Tips'**
  String get dailyTips;

  /// No description provided for @tier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get tier;

  /// No description provided for @dailyMantras.
  ///
  /// In en, this message translates to:
  /// **'Daily Mantras'**
  String get dailyMantras;

  /// No description provided for @historyAccess.
  ///
  /// In en, this message translates to:
  /// **'History Access'**
  String get historyAccess;

  /// No description provided for @basicRemedies.
  ///
  /// In en, this message translates to:
  /// **'Basic Remedies'**
  String get basicRemedies;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Plan'**
  String get choosePlan;

  /// No description provided for @palmistry.
  ///
  /// In en, this message translates to:
  /// **'Palmistry'**
  String get palmistry;

  /// No description provided for @birthChartMatching.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart Matching'**
  String get birthChartMatching;

  /// No description provided for @detailedRemedies.
  ///
  /// In en, this message translates to:
  /// **'Detailed Remedies'**
  String get detailedRemedies;

  /// No description provided for @consultBooking.
  ///
  /// In en, this message translates to:
  /// **'Consult Booking'**
  String get consultBooking;

  /// No description provided for @allFeaturesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All features unlocked'**
  String get allFeaturesUnlocked;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @elite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get elite;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @payAndSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Pay & Subscribe'**
  String get payAndSubscribe;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlan;

  /// No description provided for @purchasePlan.
  ///
  /// In en, this message translates to:
  /// **'Purchase Plan'**
  String get purchasePlan;

  /// No description provided for @choosePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get choosePaymentMethod;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmation'**
  String get paymentConfirmation;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed!'**
  String get paymentFailed;

  /// No description provided for @paymentWasSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Was Successful'**
  String get paymentWasSuccessful;

  /// No description provided for @paymentWasFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Was Failed'**
  String get paymentWasFailed;

  /// No description provided for @thanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get thanks;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @subscriptionDate.
  ///
  /// In en, this message translates to:
  /// **'Subscription Date'**
  String get subscriptionDate;

  /// No description provided for @subscriptionValidity.
  ///
  /// In en, this message translates to:
  /// **'Subscription Validity'**
  String get subscriptionValidity;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @timeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Time Of Birth'**
  String get timeOfBirth;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get placeOfBirth;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @currentSubscription.
  ///
  /// In en, this message translates to:
  /// **'Current Subscription'**
  String get currentSubscription;

  /// No description provided for @uploadedPalm.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Palm'**
  String get uploadedPalm;

  /// No description provided for @uploadPalm.
  ///
  /// In en, this message translates to:
  /// **'Upload Palm'**
  String get uploadPalm;

  /// No description provided for @checkYourCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Check Your Current Plan'**
  String get checkYourCurrentPlan;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @checkBoxWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check the box to agree to the terms and continue.'**
  String get checkBoxWarningMessage;

  /// No description provided for @internetConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Please check your internet connection.'**
  String get internetConnectionMessage;

  /// No description provided for @noChangesFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No updates found. Please make changes before saving.'**
  String get noChangesFoundMessage;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @pleaseEnterPalmImage.
  ///
  /// In en, this message translates to:
  /// **'Please enter palm image'**
  String get pleaseEnterPalmImage;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get isRequired;

  /// No description provided for @validNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name (Only alphabets allowed).'**
  String get validNameError;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your Full Name'**
  String get enterYourFullName;

  /// No description provided for @enterYourBirthPlace.
  ///
  /// In en, this message translates to:
  /// **'Enter your Birth Place'**
  String get enterYourBirthPlace;

  /// No description provided for @enterYourCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your Current Location'**
  String get enterYourCurrentLocation;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ta': return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
