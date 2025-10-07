// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'रेनवाटर हब';

  @override
  String get signInWithGoogle => 'गूगल से साइन इन करें';

  @override
  String get shareLocationTitle => 'स्थान साझा करें';

  @override
  String get shareLocationDesc =>
      'क्या आप अपना स्थान साझा करना चाहते हैं? इससे वर्षा और व्यवहार्यता डेटा स्वतः अपडेट करने में मदद मिलेगी।';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get tosPrivacy =>
      'साइन इन करके, आप हमारी सेवा की शर्तों और गोपनीयता नीति से सहमत हैं';

  @override
  String get sustainableWaterSolutions => 'सतत जल समाधान';

  @override
  String get sustainableWaterDesc =>
      'छत पर वर्षा जल संचयन क्षमता का अनुमान लगाएँ और भूजल संरक्षण में सहायता करें';

  @override
  String homeWelcomeBack(Object firstName) {
    return 'वापसी पर स्वागत है, $firstName 👋';
  }

  @override
  String get homeTagline =>
      'अपने वर्षा जल संचयन को आसानी से ट्रैक और प्रबंधित करें';

  @override
  String get homeWaterInsightsTitle => 'वॉटर इनसाइट्स';

  @override
  String get homeWaterInsightsSub => 'हाल के रुझान और वर्षा अपडेट देखें';

  @override
  String get homeFeasibilityTitle => 'व्यवहार्यता जाँचें';

  @override
  String get homeFeasibilitySub =>
      'छत पर वर्षा जल संचयन क्षमता का मूल्यांकन करें';

  @override
  String get homePastReportsTitle => 'पिछली रिपोर्टें';

  @override
  String get homePastReportsSub => 'अपनी पिछली व्यवहार्यता के परिणाम देखें';

  @override
  String get homeUsersInDistrictTitle => 'आपके जिले के उपयोगकर्ता';

  @override
  String get homeUsersInDistrictSub =>
      'देखें आपके क्षेत्र में कितने लोग आरडब्ल्यूएच का उपयोग कर रहे हैं';

  @override
  String get waterSavingTip => 'जल संरक्षण सुझाव';

  @override
  String get waterSavingBody =>
      '1000 वर्ग फीट की छत से 1 इंच वर्षा में 600 गैलन तक पानी बचाया जा सकता है। वर्षा जल संचयन से पानी का संरक्षण होता है और नगरपालिका आपूर्ति पर demand कम होती है।';

  @override
  String get feasibilityAppBar => 'व्यवहार्यता फॉर्म';

  @override
  String get feasibilityHeader => 'अपनी व्यवहार्यता जाँचें';

  @override
  String get feasibilitySub =>
      'वर्षा जल संचयन क्षमता का मूल्यांकन करने के लिए विवरण भरें';

  @override
  String get selectState => 'राज्य चुनें';

  @override
  String get chooseState => 'अपना राज्य चुनें';

  @override
  String get errorSelectState => 'कृपया राज्य चुनें';

  @override
  String get numDwellers => 'निवासियों की संख्या';

  @override
  String get numDwellersHint => 'लोगों की संख्या दर्ज करें';

  @override
  String get errorNumDwellers => 'निवासियों की संख्या दर्ज करें';

  @override
  String get roofArea => 'छत का क्षेत्रफल (m²)';

  @override
  String get roofAreaHint => 'अपनी छत का क्षेत्रफल दर्ज करें';

  @override
  String get errorRoofArea => 'छत का क्षेत्रफल दर्ज करें';

  @override
  String get roofType => 'छत का प्रकार';

  @override
  String get roofTypeHint => 'छत का प्रकार चुनें';

  @override
  String get roofTypeFlat => 'समतल';

  @override
  String get roofTypeSloping => 'ढलान';

  @override
  String get roofMaterial => 'छत की सामग्री';

  @override
  String get roofMaterialHint => 'छत की सामग्री चुनें';

  @override
  String get roofMaterialGiSheet => 'जीआई शीट';

  @override
  String get roofMaterialAsbestos => 'एस्बेस्टस';

  @override
  String get roofMaterialTiled => 'टाइल्ड';

  @override
  String get roofMaterialConcrete => 'कंक्रीट';

  @override
  String get openSpace => 'उपलब्ध खुला स्थान (m²)';

  @override
  String get openSpaceHint => 'उपलब्ध खुला स्थान दर्ज करें';

  @override
  String get errorOpenSpace => 'खुले स्थान का क्षेत्रफल दर्ज करें';

  @override
  String get checkFeasibilityCta => 'व्यवहार्यता जाँचें';

  @override
  String get didYouKnow => 'क्या आप जानते हैं?';

  @override
  String get didYouKnowBody =>
      'छत की सामग्री इस बात को प्रभावित करती है कि आप कितना वर्षा जल एकत्र कर सकते हैं। जीआई शीट्स की दक्षता सबसे अधिक होती है।';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get guest => 'अतिथि';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get district => 'ज़िला';

  @override
  String get enterDistrict => 'अपना ज़िला दर्ज करें';

  @override
  String get districtUpdated => 'ज़िला अपडेट किया गया!';

  @override
  String districtUpdateError(Object error) {
    return 'ज़िला अपडेट करने में त्रुटि: $error';
  }

  @override
  String get logout => 'लॉगआउट';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get usersInDistrictTitle => 'आपके जिले के उपयोगकर्ता';

  @override
  String districtHeader(Object district) {
    return '🌎 $district ज़िला';
  }

  @override
  String usersCount(Object app, Object count) {
    return 'आपके जिले से $count उपयोगकर्ता $app का उपयोग कर रहे हैं';
  }

  @override
  String get usersEmpty =>
      'अपने जिले में वर्षा जल संचयन शुरू करने वाले पहले व्यक्ति बनें!';

  @override
  String get usersJoinOthers =>
      'अपने जिले के अन्य लोगों के साथ जुड़ें और बदलाव लाएँ! अपने मित्रों और पड़ोसियों को वर्षा जल संचयन शुरू करने के लिए प्रोत्साहित करें।';

  @override
  String get noDistrictTitle => 'ज़िला सेट नहीं है!';

  @override
  String get noDistrictDesc =>
      'अपने क्षेत्र के अन्य उपयोगकर्ताओं को देखने के लिए कृपया प्रोफ़ाइल में अपना ज़िला सेट करें।';

  @override
  String get goToProfile => 'प्रोफ़ाइल पर जाएँ';

  @override
  String get pastReportsTitle => 'पिछली रिपोर्टें';

  @override
  String get previousReportsHeader => 'आपकी पिछली व्यवहार्यता रिपोर्टें';

  @override
  String get noSavedReports => 'अभी तक कोई सहेजी गई रिपोर्ट नहीं';

  @override
  String get generateToSeeHere =>
      'यहाँ देखने के लिए एक व्यवहार्यता रिपोर्ट बनाएं';

  @override
  String get dateLabel => 'तारीख:';

  @override
  String get suggestedStructureLabel => 'सुझाई गई संरचना:';

  @override
  String get stateLabel => 'राज्य:';

  @override
  String get roofAreaLabel => 'छत का क्षेत्रफल:';

  @override
  String get deleteReportTitle => 'रिपोर्ट हटाएँ';

  @override
  String get deleteReportConfirm =>
      'क्या आप वाकई इस रिपोर्ट को हटाना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get reportDeleted => 'रिपोर्ट सफलतापूर्वक हटाई गई';

  @override
  String get failedDelete => 'रिपोर्ट हटाने में विफल';

  @override
  String get feasibilityReportTitle => 'व्यवहार्यता रिपोर्ट';

  @override
  String get insightsHeader => 'वर्षा जल संचयन इनसाइट्स';

  @override
  String get insightsSub => 'आपके स्थान और संपत्ति विवरण के आधार पर';

  @override
  String get storageTank => 'स्टोरेज टैंक';

  @override
  String get rechargeStructure => 'रीचार्ज संरचना';

  @override
  String get runoffCapacity => 'रनऑफ जनरेशन क्षमता';

  @override
  String get requiredTankCapacity => 'आवश्यक टैंक क्षमता';

  @override
  String get costEstimationBenefit => 'लागत अनुमान और लाभ';

  @override
  String get soilTypeLabel => 'मृदा प्रकार';

  @override
  String get back => 'वापस';

  @override
  String get saveReport => 'रिपोर्ट सहेजें';

  @override
  String get saving => 'सहेजा जा रहा है...';

  @override
  String get downloadPdf => 'पीडीएफ डाउनलोड करें';

  @override
  String get errorGeneratingPdf => 'पीडीएफ जनरेट करने में त्रुटि';

  @override
  String get volumeLabel => 'आयतन';

  @override
  String get dimensionsLabel => 'आयाम';

  @override
  String get loadingPipe => 'पाइप आयाम लोड हो रहे हैं...';

  @override
  String pipeInfo(Object diameter, Object width) {
    return 'पाइप: $diameter मिमी व्यास × $width मिमी चौड़ाई';
  }

  @override
  String get noSuitablePipe => 'उपयुक्त पाइप नहीं मिला';

  @override
  String get recommendedDimensions => 'अनुशंसित आयाम';

  @override
  String get estimatedRunoffAvailable => 'अनुमानित उपलब्ध रनऑफ';

  @override
  String litresPerYear(Object litres) {
    return '$litres एल/वर्ष';
  }

  @override
  String personsDays(Object days, Object persons) {
    return '$persons व्यक्ति, $days दिन';
  }
}
