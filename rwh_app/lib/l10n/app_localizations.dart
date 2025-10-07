import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rainwater Hub'**
  String get appTitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @shareLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get shareLocationTitle;

  /// No description provided for @shareLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Do you wish to share your location? This will help auto-update rainfall and feasibility data.'**
  String get shareLocationDesc;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @tosPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service and Privacy Policy'**
  String get tosPrivacy;

  /// No description provided for @sustainableWaterSolutions.
  ///
  /// In en, this message translates to:
  /// **'Sustainable Water Solutions'**
  String get sustainableWaterSolutions;

  /// No description provided for @sustainableWaterDesc.
  ///
  /// In en, this message translates to:
  /// **'Estimate rooftop rainwater harvesting potential and support groundwater conservation'**
  String get sustainableWaterDesc;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {firstName} 👋'**
  String homeWelcomeBack(Object firstName);

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Track and manage your rainwater harvesting with ease'**
  String get homeTagline;

  /// No description provided for @homeWaterInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Insights'**
  String get homeWaterInsightsTitle;

  /// No description provided for @homeWaterInsightsSub.
  ///
  /// In en, this message translates to:
  /// **'See recent trends and rainfall updates'**
  String get homeWaterInsightsSub;

  /// No description provided for @homeFeasibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Feasibility'**
  String get homeFeasibilityTitle;

  /// No description provided for @homeFeasibilitySub.
  ///
  /// In en, this message translates to:
  /// **'Evaluate rooftop rainwater harvesting potential'**
  String get homeFeasibilitySub;

  /// No description provided for @homePastReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Reports'**
  String get homePastReportsTitle;

  /// No description provided for @homePastReportsSub.
  ///
  /// In en, this message translates to:
  /// **'View your previous feasibility results'**
  String get homePastReportsSub;

  /// No description provided for @homeUsersInDistrictTitle.
  ///
  /// In en, this message translates to:
  /// **'Users in Your District'**
  String get homeUsersInDistrictTitle;

  /// No description provided for @homeUsersInDistrictSub.
  ///
  /// In en, this message translates to:
  /// **'See how many others are using RWH in your area'**
  String get homeUsersInDistrictSub;

  /// No description provided for @waterSavingTip.
  ///
  /// In en, this message translates to:
  /// **'Water Saving Tip'**
  String get waterSavingTip;

  /// No description provided for @waterSavingBody.
  ///
  /// In en, this message translates to:
  /// **'Harvesting rainwater from a 1,000 sq ft roof can save up to 600 gallons of water during a 1-inch rainfall. Implementing rainwater harvesting helps conserve water and reduces demand on municipal supplies.'**
  String get waterSavingBody;

  /// No description provided for @feasibilityAppBar.
  ///
  /// In en, this message translates to:
  /// **'Feasibility Form'**
  String get feasibilityAppBar;

  /// No description provided for @feasibilityHeader.
  ///
  /// In en, this message translates to:
  /// **'Check Your Feasibility'**
  String get feasibilityHeader;

  /// No description provided for @feasibilitySub.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to evaluate your rainwater harvesting potential'**
  String get feasibilitySub;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @chooseState.
  ///
  /// In en, this message translates to:
  /// **'Choose your state'**
  String get chooseState;

  /// No description provided for @errorSelectState.
  ///
  /// In en, this message translates to:
  /// **'Select a state'**
  String get errorSelectState;

  /// No description provided for @numDwellers.
  ///
  /// In en, this message translates to:
  /// **'Number of Dwellers'**
  String get numDwellers;

  /// No description provided for @numDwellersHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of people'**
  String get numDwellersHint;

  /// No description provided for @errorNumDwellers.
  ///
  /// In en, this message translates to:
  /// **'Enter number of dwellers'**
  String get errorNumDwellers;

  /// No description provided for @roofArea.
  ///
  /// In en, this message translates to:
  /// **'Roof Area (m²)'**
  String get roofArea;

  /// No description provided for @roofAreaHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your roof area'**
  String get roofAreaHint;

  /// No description provided for @errorRoofArea.
  ///
  /// In en, this message translates to:
  /// **'Enter roof area'**
  String get errorRoofArea;

  /// No description provided for @roofType.
  ///
  /// In en, this message translates to:
  /// **'Roof Type'**
  String get roofType;

  /// No description provided for @roofTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select roof type'**
  String get roofTypeHint;

  /// No description provided for @roofTypeFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get roofTypeFlat;

  /// No description provided for @roofTypeSloping.
  ///
  /// In en, this message translates to:
  /// **'Sloping'**
  String get roofTypeSloping;

  /// No description provided for @roofMaterial.
  ///
  /// In en, this message translates to:
  /// **'Roof Material'**
  String get roofMaterial;

  /// No description provided for @roofMaterialHint.
  ///
  /// In en, this message translates to:
  /// **'Select roof material'**
  String get roofMaterialHint;

  /// No description provided for @roofMaterialGiSheet.
  ///
  /// In en, this message translates to:
  /// **'GI Sheet'**
  String get roofMaterialGiSheet;

  /// No description provided for @roofMaterialAsbestos.
  ///
  /// In en, this message translates to:
  /// **'Asbestos'**
  String get roofMaterialAsbestos;

  /// No description provided for @roofMaterialTiled.
  ///
  /// In en, this message translates to:
  /// **'Tiled'**
  String get roofMaterialTiled;

  /// No description provided for @roofMaterialConcrete.
  ///
  /// In en, this message translates to:
  /// **'Concrete'**
  String get roofMaterialConcrete;

  /// No description provided for @openSpace.
  ///
  /// In en, this message translates to:
  /// **'Available Open Space (m²)'**
  String get openSpace;

  /// No description provided for @openSpaceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter available open space'**
  String get openSpaceHint;

  /// No description provided for @errorOpenSpace.
  ///
  /// In en, this message translates to:
  /// **'Enter open space area'**
  String get errorOpenSpace;

  /// No description provided for @checkFeasibilityCta.
  ///
  /// In en, this message translates to:
  /// **'Check Feasibility'**
  String get checkFeasibilityCta;

  /// No description provided for @didYouKnow.
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get didYouKnow;

  /// No description provided for @didYouKnowBody.
  ///
  /// In en, this message translates to:
  /// **'The roof material significantly affects how much rainwater you can collect. GI sheets have the highest collection efficiency.'**
  String get didYouKnowBody;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @enterDistrict.
  ///
  /// In en, this message translates to:
  /// **'Enter your district'**
  String get enterDistrict;

  /// No description provided for @districtUpdated.
  ///
  /// In en, this message translates to:
  /// **'District updated!'**
  String get districtUpdated;

  /// No description provided for @districtUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating district: {error}'**
  String districtUpdateError(Object error);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @usersInDistrictTitle.
  ///
  /// In en, this message translates to:
  /// **'Users in Your District'**
  String get usersInDistrictTitle;

  /// No description provided for @districtHeader.
  ///
  /// In en, this message translates to:
  /// **'🌎 {district} District'**
  String districtHeader(Object district);

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'There are {count} users from your district using {app}'**
  String usersCount(Object app, Object count);

  /// No description provided for @usersEmpty.
  ///
  /// In en, this message translates to:
  /// **'Be the first to start rainwater harvesting in your district!'**
  String get usersEmpty;

  /// No description provided for @usersJoinOthers.
  ///
  /// In en, this message translates to:
  /// **'Join others in your district and make a difference! Encourage your friends and neighbors to start harvesting rainwater.'**
  String get usersJoinOthers;

  /// No description provided for @noDistrictTitle.
  ///
  /// In en, this message translates to:
  /// **'District not set!'**
  String get noDistrictTitle;

  /// No description provided for @noDistrictDesc.
  ///
  /// In en, this message translates to:
  /// **'Please set your district in your profile to see other users from your area.'**
  String get noDistrictDesc;

  /// No description provided for @goToProfile.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile'**
  String get goToProfile;

  /// No description provided for @pastReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Reports'**
  String get pastReportsTitle;

  /// No description provided for @previousReportsHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Previous Feasibility Reports'**
  String get previousReportsHeader;

  /// No description provided for @noSavedReports.
  ///
  /// In en, this message translates to:
  /// **'No saved reports yet'**
  String get noSavedReports;

  /// No description provided for @generateToSeeHere.
  ///
  /// In en, this message translates to:
  /// **'Generate a feasibility report to see it here'**
  String get generateToSeeHere;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;

  /// No description provided for @suggestedStructureLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested Structure:'**
  String get suggestedStructureLabel;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State:'**
  String get stateLabel;

  /// No description provided for @roofAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Roof Area:'**
  String get roofAreaLabel;

  /// No description provided for @deleteReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Report'**
  String get deleteReportTitle;

  /// No description provided for @deleteReportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this report?'**
  String get deleteReportConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reportDeleted.
  ///
  /// In en, this message translates to:
  /// **'Report deleted successfully'**
  String get reportDeleted;

  /// No description provided for @failedDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete report'**
  String get failedDelete;

  /// No description provided for @feasibilityReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Feasibility Report'**
  String get feasibilityReportTitle;

  /// No description provided for @insightsHeader.
  ///
  /// In en, this message translates to:
  /// **'Rainwater Harvesting Insights'**
  String get insightsHeader;

  /// No description provided for @insightsSub.
  ///
  /// In en, this message translates to:
  /// **'Based on your location and property details'**
  String get insightsSub;

  /// No description provided for @storageTank.
  ///
  /// In en, this message translates to:
  /// **'Storage Tank'**
  String get storageTank;

  /// No description provided for @rechargeStructure.
  ///
  /// In en, this message translates to:
  /// **'Recharge Structure'**
  String get rechargeStructure;

  /// No description provided for @runoffCapacity.
  ///
  /// In en, this message translates to:
  /// **'Runoff Generation Capacity'**
  String get runoffCapacity;

  /// No description provided for @requiredTankCapacity.
  ///
  /// In en, this message translates to:
  /// **'Required Tank Capacity'**
  String get requiredTankCapacity;

  /// No description provided for @costEstimationBenefit.
  ///
  /// In en, this message translates to:
  /// **'Cost Estimation & Benefit'**
  String get costEstimationBenefit;

  /// No description provided for @soilTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilTypeLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @saveReport.
  ///
  /// In en, this message translates to:
  /// **'Save Report'**
  String get saveReport;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @errorGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF'**
  String get errorGeneratingPdf;

  /// No description provided for @volumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeLabel;

  /// No description provided for @dimensionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensionsLabel;

  /// No description provided for @loadingPipe.
  ///
  /// In en, this message translates to:
  /// **'Loading pipe dimensions...'**
  String get loadingPipe;

  /// No description provided for @pipeInfo.
  ///
  /// In en, this message translates to:
  /// **'Pipe: {diameter} mm dia × {width} mm width'**
  String pipeInfo(Object diameter, Object width);

  /// No description provided for @noSuitablePipe.
  ///
  /// In en, this message translates to:
  /// **'No suitable pipe found'**
  String get noSuitablePipe;

  /// No description provided for @recommendedDimensions.
  ///
  /// In en, this message translates to:
  /// **'Recommended Dimensions'**
  String get recommendedDimensions;

  /// No description provided for @estimatedRunoffAvailable.
  ///
  /// In en, this message translates to:
  /// **'Estimated Runoff Available'**
  String get estimatedRunoffAvailable;

  /// No description provided for @litresPerYear.
  ///
  /// In en, this message translates to:
  /// **'{litres} L/year'**
  String litresPerYear(Object litres);

  /// No description provided for @personsDays.
  ///
  /// In en, this message translates to:
  /// **'For {persons} persons, {days} days'**
  String personsDays(Object days, Object persons);
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
