import 'package:flutter/widgets.dart';

String localizedStateName(BuildContext context, String state) {
  final code = Localizations.localeOf(context).languageCode;
  if (code != 'hi') return state;
  const hi = {
    'Andhra Pradesh': 'आंध्र प्रदेश',
    'Arunachal Pradesh': 'अरुणाचल प्रदेश',
    'Assam': 'असम',
    'Bihar': 'बिहार',
    'Chhattisgarh': 'छत्तीसगढ़',
    'Delhi': 'दिल्ली',
    'Goa': 'गोवा',
    'Gujarat': 'गुजरात',
    'Haryana': 'हरियाणा',
    'Himachal Pradesh': 'हिमाचल प्रदेश',
    'Jharkhand': 'झारखंड',
    'Karnataka': 'कर्नाटक',
    'Kerala': 'केरल',
    'Madhya Pradesh': 'मध्य प्रदेश',
    'Maharashtra': 'महाराष्ट्र',
    'Manipur': 'मणिपुर',
    'Meghalaya': 'मेघालय',
    'Mizoram': 'मिजोरम',
    'Nagaland': 'नागालैंड',
    'Odisha': 'ओडिशा',
    'Punjab': 'पंजाब',
    'Rajasthan': 'राजस्थान',
    'Sikkim': 'सिक्किम',
    'Tamil Nadu': 'तमिलनाडु',
    'Telangana': 'तेलंगाना',
    'Tripura': 'त्रिपुरा',
    'Uttar Pradesh': 'उत्तर प्रदेश',
    'Uttarakhand': 'उत्तराखंड',
    'West Bengal': 'पश्चिम बंगाल',
    'Andaman & Nicobar': 'अंडमान और निकोबार',
    'Chandigarh': 'चंडीगढ़',
    'Dadra & Nagar Haveli': 'दादरा और नगर हवेली',
    'Daman & Diu': 'दमन और दीव',
    'Jammu & Kashmir': 'जम्मू और कश्मीर',
    'Ladakh': 'लद्दाख',
    'Lakshadweep': 'लक्षद्वीप',
    'Puducherry': 'पुडुचेरी',
  };
  return hi[state] ?? state;
}
