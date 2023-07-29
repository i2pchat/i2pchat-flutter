import 'package:cake_wallet/generated/locales.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:intl/intl.dart';

class LanguageService {
  static const Map<String, String> supportedLocales = {
    'en': 'English',
    'ru': 'Русский (Russian)',
  };

  static const Map<String, String> localeCountryCode = {
    'en': 'usa',
    'ru': 'rus',
  };

  static final list = <String, String>{};

  static void loadLocaleList() {
    supportedLocales.forEach((key, value) {
      if (locales.contains(key)) {
        list[key] = value;
      }
    });
  }

  static Future<String> localeDetection() async {
    var locale = await Devicelocale.currentLocale ?? '';
    locale = Intl.shortLocale(locale);

    return list.keys.contains(locale) ? locale : 'en';
  }
}
