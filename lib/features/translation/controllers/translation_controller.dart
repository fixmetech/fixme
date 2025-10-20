import 'package:get/get.dart';
import 'package:fixme/services/translation_service.dart';

class TranslationController extends GetxController {
  final TranslationService _translationService = TranslationService();
  
  // Observable current language
  var currentLanguage = TranslationService.englishCode.obs;
  var isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadCurrentLanguage();
  }

  /// Load saved language from storage
  void _loadCurrentLanguage() {
    final savedLanguage = _translationService.getCurrentLanguage();
    currentLanguage.value = savedLanguage;
  }

  /// Change the app language
  Future<void> changeLanguage(String languageCode) async {
    if (currentLanguage.value == languageCode) return;
    
    isLoading.value = true;
    
    try {
      await _translationService.setCurrentLanguage(languageCode);
      currentLanguage.value = languageCode;
      
      // Preload common translations if needed
      if (languageCode != TranslationService.englishCode) {
        await _translationService.preloadCommonTranslations();
      }
      
      // Show success message
      Get.snackbar(
        'Language Changed',
        'App language changed to ${_translationService.getLanguageName(languageCode)}',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change language: $e',
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get current language name
  String getCurrentLanguageName() {
    return _translationService.getLanguageName(currentLanguage.value);
  }

  /// Check if translation is needed
  bool isTranslationNeeded() {
    return currentLanguage.value != TranslationService.englishCode;
  }

  /// Get available languages
  Map<String, String> getAvailableLanguages() {
    return TranslationService.availableLanguages;
  }

  /// Translate a single text
  Future<String> translateText(String text) async {
    return await _translationService.translateText(text);
  }

  /// Clear translation cache
  void clearCache() {
    _translationService.clearCache();
    Get.snackbar(
      'Cache Cleared',
      'Translation cache has been cleared',
      duration: const Duration(seconds: 2),
    );
  }

  /// Get cache info for debugging
  String getCacheInfo() {
    final cacheSize = _translationService.getCacheSize();
    return 'Cached translations: $cacheSize';
  }
}