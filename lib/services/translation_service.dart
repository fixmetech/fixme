import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final GetStorage _storage = GetStorage();
  
  // Language codes
  static const String englishCode = 'en';
  static const String sinhalaCode = 'si';
  static const String tamilCode = 'ta';
  
  // Available languages
  static const Map<String, String> availableLanguages = {
    'English': englishCode,
    'සිංහල': sinhalaCode,
    'தமிழ்': tamilCode,
  };

  // Cache for translated texts to avoid repeated API calls
  final Map<String, Map<String, String>> _translationCache = {};

  /// Get current selected language
  String getCurrentLanguage() {
    return _storage.read('selected_language') ?? englishCode;
  }

  /// Set current language
  Future<void> setCurrentLanguage(String languageCode) async {
    await _storage.write('selected_language', languageCode);
  }

  /// Get language name from code
  String getLanguageName(String languageCode) {
    return availableLanguages.entries
        .firstWhere((entry) => entry.value == languageCode,
            orElse: () => const MapEntry('English', englishCode))
        .key;
  }

  /// Check if current language is not English
  bool isTranslationNeeded() {
    return getCurrentLanguage() != englishCode;
  }

  /// Translate text using Google Translate API
  Future<String> translateText(String text, {String? targetLanguage}) async {
    if (text.isEmpty) return text;
    
    final target = targetLanguage ?? getCurrentLanguage();
    
    // If target is English, return original text
    if (target == englishCode) return text;

    // Check cache first
    if (_translationCache.containsKey(target) && 
        _translationCache[target]!.containsKey(text)) {
      return _translationCache[target]![text]!;
    }

    // Check for custom short translations first
    final customTranslation = _getCustomShortTranslation(text, target);
    if (customTranslation != null) {
      // Cache the custom translation
      _translationCache[target] ??= {};
      _translationCache[target]![text] = customTranslation;
      return customTranslation;
    }

    try {
      // Use Google Translate free API
      final encodedText = Uri.encodeComponent(text);
      final url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$englishCode&tl=$target&dt=t&q=$encodedText';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        String translatedText = '';
        
        if (decoded != null && decoded[0] != null) {
          for (var item in decoded[0]) {
            if (item[0] != null) {
              translatedText += item[0];
            }
          }
        }
        
        // Cache the translation
        _translationCache[target] ??= {};
        _translationCache[target]![text] = translatedText;
        
        return translatedText.isNotEmpty ? translatedText : text;
      }
    } catch (e) {
      print('Translation error: $e');
    }
    
    // Return original text if translation fails
    return text;
  }

  /// Get custom short translations for UI elements that need to fit in small spaces
  String? _getCustomShortTranslation(String text, String targetLanguage) {
    if (targetLanguage != sinhalaCode && targetLanguage != tamilCode) return null;
    
    // Custom short translations for service categories and UI elements
    final Map<String, String> shortTranslations;
    
    if (targetLanguage == sinhalaCode) {
      shortTranslations = _getSinhalaTranslations();
    } else if (targetLanguage == tamilCode) {
      shortTranslations = _getTamilTranslations();
    } else {
      return null;
    }
    
    return shortTranslations[text];
  }

  /// Get Sinhala translations
  Map<String, String> _getSinhalaTranslations() {
    return {
      // Service categories (keep them short for UI)
      'Service': 'සේවා',
      'Repair': 'අළුත්වැඩියා', 
      'Electricians': 'විදුලි',
      'Plumbers': 'ජල',
      'car': 'වාහන',
      'home': 'නිවස',
      'Car Repair': 'වාහන අළුත්වැඩියා',
      'House Cleaning': 'නිවස පිරිසිදු කිරීම',
      
      // Filter options (shorter versions)
      'Visiting Fee': 'ගමන් ගාස්තු',
      'Price': 'මිල',
      'Rating': 'ඇගයීම',
      'Distance': 'දුර',
      'Experience': 'අත්දැකීම',
      'Availability': 'ලබා ගත හැකි',
      'Highly Rated': 'ඉහළ ඇගයීම',
      'Language': 'භාෂාව',
      
      // Navigation and common UI
      'Home': 'මුල් පිටුව',
      'Services': 'සේවා',
      'Profile': 'පැතිකඩ',
      'Settings': 'සැකසීම්',
      'Search': 'සොයන්න',
      'Search services': 'සේවා සොයන්න',
      'Activities': 'ක්‍රියාකාරකම්',
      'Account': 'ගිණුම',
      
      // Profile section
      'Contact Information': 'සම්බන්ධතා තොරතුරු',
      'Email': 'ඊමේල්',
      'Phone': 'දුරකථන',
      'Home Details': 'නිවස විස්තර',
      'Vehicle Details': 'වාහන විස්තර',
      'History': 'ඉතිහාසය',
      'Support Center': 'සහාය මධ්‍යස්ථානය',
      'Account Settings': 'ගිණුම් සැකසීම්',
      'Security & Privacy': 'ආරක්ෂාව සහ පෞද්ගලිකත්වය',
      
      // Common actions
      'Book Now': 'දැන් වෙන්කරවන්න',
      'Cancel': 'අවලංගු කරන්න',
      'Confirm': 'තහවුරු කරන්න',
      'Save': 'සුරකින්න',
      'Edit': 'සංස්කරණය',
      'Submit': 'ඉදිරිපත් කරන්න',
      
      // Status and messages
      'Loading...': 'පූරණය වෙමින්...',
      'Error': 'දෝෂයක්',
      'Success': 'සාර්ථකයි',
      'Please wait': 'කරුණාකර රැඳී සිටින්න',
      'Recently Booked': 'මෑතකදී වෙන්කරවා ගත්',
      
      // Greetings
      'Good Morning': 'සුභ උදෑසනක්',
      'Good Afternoon': 'සුභ දහවලක්',
      'Good Evening': 'සුභ සැන්දෑවක්',
      'Good Night': 'සුභ රාත්‍රියක්',
      'Welcome': 'ආයුබෝවන්',
      'Welcome to FixMe': 'FixMe වෙත ආයුබෝවන්',
    };
  }

  /// Get Tamil translations
  Map<String, String> _getTamilTranslations() {
    return {
      // Service categories (keep them short for UI)
      'Service': 'சேவை',
      'Repair': 'பழுது',
      'Electricians': 'மின்சாரம்',
      'Plumbers': 'குழாய்',
      'car': 'வாகனம்',
      'home': 'வீடு',
      'Car Repair': 'வாகன பழுது',
      'House Cleaning': 'வீட்டு சுத்தம்',
      
      // Filter options (shorter versions)
      'Visiting Fee': 'வருகை கட்டணம்',
      'Price': 'விலை',
      'Rating': 'மதிப்பீடு',
      'Distance': 'தூரம்',
      'Experience': 'அனுபவம்',
      'Availability': 'கிடைக்கும்',
      'Highly Rated': 'உயர் மதிப்பீடு',
      'Language': 'மொழி',
      
      // Navigation and common UI
      'Home': 'முகப்பு',
      'Services': 'சேவைகள்',
      'Profile': 'சுயவிவரம்',
      'Settings': 'அமைப்புகள்',
      'Search': 'தேடல்',
      'Search services': 'சேவைகளைத் தேடவும்',
      'Activities': 'செயல்பாடுகள்',
      'Account': 'கணக்கு',
      
      // Profile section
      'Contact Information': 'தொடர்பு தகவல்',
      'Email': 'மின்னஞ்சல்',
      'Phone': 'தொலைபேசி',
      'Home Details': 'வீட்டு விவரங்கள்',
      'Vehicle Details': 'வாகன விவரங்கள்',
      'History': 'வரலாறு',
      'Support Center': 'ஆதரவு மையம்',
      'Account Settings': 'கணக்கு அமைப்புகள்',
      'Security & Privacy': 'பாதுகாப்பு மற்றும் தனியுரிமை',
      
      // Common actions
      'Book Now': 'இப்போது முன்பதிவு',
      'Cancel': 'ரத்து செய்',
      'Confirm': 'உறுதிப்படுத்து',
      'Save': 'சேமி',
      'Edit': 'திருத்து',
      'Submit': 'சமர்ப்பி',
      
      // Status and messages
      'Loading...': 'ஏற்றுகிறது...',
      'Error': 'பிழை',
      'Success': 'வெற்றி',
      'Please wait': 'காத்திருக்கவும்',
      'Recently Booked': 'சமீபத்தில் முன்பதிவு',
      
      // Greetings
      'Good Morning': 'காலை வணக்கம்',
      'Good Afternoon': 'மதிய வணக்கம்',
      'Good Evening': 'மாலை வணக்கம்',
      'Good Night': 'இரவு வணக்கம்',
      'Welcome': 'வரவேற்கிறோம்',
      'Welcome to FixMe': 'FixMe வில் வரவேற்கிறோம்',
    };
  }

  /// Translate multiple texts at once
  Future<List<String>> translateTexts(List<String> texts, 
      {String? targetLanguage}) async {
    final target = targetLanguage ?? getCurrentLanguage();
    
    if (target == englishCode) return texts;

    final translatedTexts = <String>[];
    
    for (String text in texts) {
      final translated = await translateText(text, targetLanguage: target);
      translatedTexts.add(translated);
    }
    
    return translatedTexts;
  }

  /// Clear translation cache
  void clearCache() {
    _translationCache.clear();
  }

  /// Get cached translations count for debugging
  int getCacheSize() {
    int totalSize = 0;
    _translationCache.values.forEach((cache) {
      totalSize += cache.length;
    });
    return totalSize;
  }

  /// Preload common translations for better performance
  Future<void> preloadCommonTranslations() async {
    if (!isTranslationNeeded()) return;

    final commonTexts = [
      // Navigation and basic UI
      'Home',
      'Services',
      'Profile',
      'Settings',
      'Search',
      'Search services',
      'Activities',
      'Account',
      
      // Actions
      'Book Now',
      'Cancel',
      'Confirm',
      'Save',
      'Edit',
      'Delete',
      'Submit',
      'Continue',
      'Back',
      'Next',
      
      // Status messages
      'Loading...',
      'Error',
      'Success',
      'Please wait',
      'No data found',
      'Try again',
      'Failed to load',
      
      // Greetings
      'Good Morning',
      'Good Afternoon',
      'Good Evening',
      'Good Night',
      'Hello',
      'Welcome',
      'Welcome to FixMe',
      
      // Profile section
      'Contact Information',
      'Email',
      'Phone',
      'Home Details',
      'Vehicle Details',
      'History',
      'Support Center',
      'Account Settings',
      'Security & Privacy',
      'Language',
      
      // Service categories
      'Car Repair',
      'House Cleaning',
      'Repair',
      'Service',
      'Electricians',
      'Plumbers',
      
      // Filter options
      'Visiting Fee',
      'Price',
      'Rating',
      'Distance',
      'Experience',
      'Availability',
      'Highly Rated',
      
      // Common descriptions
      'Recently Booked',
      'Your one-stop solution for home and vehicle services.\nFind help anytime, anywhere!',
      'Featured in FixMe',
      'Top Technicians',
      
      // Service types
      'car',
      'home',
      
      // Additional common terms for multi-language support
      'தமிழ்', // Tamil language name
      'සිංහල', // Sinhala language name
    ];

    await translateTexts(commonTexts);
  }
}