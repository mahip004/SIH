// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rainwater Hub';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get shareLocationTitle => 'Share Location';

  @override
  String get shareLocationDesc =>
      'Do you wish to share your location? This will help auto-update rainfall and feasibility data.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get tosPrivacy =>
      'By signing in, you agree to our Terms of Service and Privacy Policy';

  @override
  String get sustainableWaterSolutions => 'Sustainable Water Solutions';

  @override
  String get sustainableWaterDesc =>
      'Estimate rooftop rainwater harvesting potential and support groundwater conservation';

  @override
  String homeWelcomeBack(Object firstName) {
    return 'Welcome back, $firstName 👋';
  }

  @override
  String get homeTagline =>
      'Track and manage your rainwater harvesting with ease';

  @override
  String get homeWaterInsightsTitle => 'Water Insights';

  @override
  String get homeWaterInsightsSub => 'See recent trends and rainfall updates';

  @override
  String get homeFeasibilityTitle => 'Check Feasibility';

  @override
  String get homeFeasibilitySub =>
      'Evaluate rooftop rainwater harvesting potential';

  @override
  String get homePastReportsTitle => 'Past Reports';

  @override
  String get homePastReportsSub => 'View your previous feasibility results';

  @override
  String get homeUsersInDistrictTitle => 'Users in Your District';

  @override
  String get homeUsersInDistrictSub =>
      'See how many others are using RWH in your area';

  @override
  String get waterSavingTip => 'Water Saving Tip';

  @override
  String get waterSavingBody =>
      'Harvesting rainwater from a 1,000 sq ft roof can save up to 600 gallons of water during a 1-inch rainfall. Implementing rainwater harvesting helps conserve water and reduces demand on municipal supplies.';

  @override
  String get feasibilityAppBar => 'Feasibility Form';

  @override
  String get feasibilityHeader => 'Check Your Feasibility';

  @override
  String get feasibilitySub =>
      'Fill in the details to evaluate your rainwater harvesting potential';

  @override
  String get selectState => 'Select State';

  @override
  String get chooseState => 'Choose your state';

  @override
  String get errorSelectState => 'Select a state';

  @override
  String get numDwellers => 'Number of Dwellers';

  @override
  String get numDwellersHint => 'Enter the number of people';

  @override
  String get errorNumDwellers => 'Enter number of dwellers';

  @override
  String get roofArea => 'Roof Area (m²)';

  @override
  String get roofAreaHint => 'Enter your roof area';

  @override
  String get errorRoofArea => 'Enter roof area';

  @override
  String get roofType => 'Roof Type';

  @override
  String get roofTypeHint => 'Select roof type';

  @override
  String get roofTypeFlat => 'Flat';

  @override
  String get roofTypeSloping => 'Sloping';

  @override
  String get roofMaterial => 'Roof Material';

  @override
  String get roofMaterialHint => 'Select roof material';

  @override
  String get roofMaterialGiSheet => 'GI Sheet';

  @override
  String get roofMaterialAsbestos => 'Asbestos';

  @override
  String get roofMaterialTiled => 'Tiled';

  @override
  String get roofMaterialConcrete => 'Concrete';

  @override
  String get openSpace => 'Available Open Space (m²)';

  @override
  String get openSpaceHint => 'Enter available open space';

  @override
  String get errorOpenSpace => 'Enter open space area';

  @override
  String get checkFeasibilityCta => 'Check Feasibility';

  @override
  String get didYouKnow => 'Did you know?';

  @override
  String get didYouKnowBody =>
      'The roof material significantly affects how much rainwater you can collect. GI sheets have the highest collection efficiency.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get guest => 'Guest';

  @override
  String get username => 'Username';

  @override
  String get district => 'District';

  @override
  String get enterDistrict => 'Enter your district';

  @override
  String get districtUpdated => 'District updated!';

  @override
  String districtUpdateError(Object error) {
    return 'Error updating district: $error';
  }

  @override
  String get logout => 'Logout';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get usersInDistrictTitle => 'Users in Your District';

  @override
  String districtHeader(Object district) {
    return '🌎 $district District';
  }

  @override
  String usersCount(Object app, Object count) {
    return 'There are $count users from your district using $app';
  }

  @override
  String get usersEmpty =>
      'Be the first to start rainwater harvesting in your district!';

  @override
  String get usersJoinOthers =>
      'Join others in your district and make a difference! Encourage your friends and neighbors to start harvesting rainwater.';

  @override
  String get noDistrictTitle => 'District not set!';

  @override
  String get noDistrictDesc =>
      'Please set your district in your profile to see other users from your area.';

  @override
  String get goToProfile => 'Go to Profile';

  @override
  String get pastReportsTitle => 'Past Reports';

  @override
  String get previousReportsHeader => 'Your Previous Feasibility Reports';

  @override
  String get noSavedReports => 'No saved reports yet';

  @override
  String get generateToSeeHere =>
      'Generate a feasibility report to see it here';

  @override
  String get dateLabel => 'Date:';

  @override
  String get suggestedStructureLabel => 'Suggested Structure:';

  @override
  String get stateLabel => 'State:';

  @override
  String get roofAreaLabel => 'Roof Area:';

  @override
  String get deleteReportTitle => 'Delete Report';

  @override
  String get deleteReportConfirm =>
      'Are you sure you want to delete this report?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get reportDeleted => 'Report deleted successfully';

  @override
  String get failedDelete => 'Failed to delete report';

  @override
  String get feasibilityReportTitle => 'Feasibility Report';

  @override
  String get insightsHeader => 'Rainwater Harvesting Insights';

  @override
  String get insightsSub => 'Based on your location and property details';

  @override
  String get storageTank => 'Storage Tank';

  @override
  String get rechargeStructure => 'Recharge Structure';

  @override
  String get runoffCapacity => 'Runoff Generation Capacity';

  @override
  String get requiredTankCapacity => 'Required Tank Capacity';

  @override
  String get costEstimationBenefit => 'Cost Estimation & Benefit';

  @override
  String get soilTypeLabel => 'Soil Type';

  @override
  String get back => 'Back';

  @override
  String get saveReport => 'Save Report';

  @override
  String get saving => 'Saving...';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get errorGeneratingPdf => 'Error generating PDF';

  @override
  String get volumeLabel => 'Volume';

  @override
  String get dimensionsLabel => 'Dimensions';

  @override
  String get loadingPipe => 'Loading pipe dimensions...';

  @override
  String pipeInfo(Object diameter, Object width) {
    return 'Pipe: $diameter mm dia × $width mm width';
  }

  @override
  String get noSuitablePipe => 'No suitable pipe found';

  @override
  String get recommendedDimensions => 'Recommended Dimensions';

  @override
  String get estimatedRunoffAvailable => 'Estimated Runoff Available';

  @override
  String litresPerYear(Object litres) {
    return '$litres L/year';
  }

  @override
  String personsDays(Object days, Object persons) {
    return 'For $persons persons, $days days';
  }
}
