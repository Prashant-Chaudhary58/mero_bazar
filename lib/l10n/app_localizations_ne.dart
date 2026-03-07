// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'मेरो बजार';

  @override
  String get myAccount => 'मेरो खाता';

  @override
  String helloUser(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get viewEditProfile => 'आफ्नो प्रोफाइल हेर्नुहोस् र सम्पादन गर्नुहोस्';

  @override
  String get myListing => 'मेरो सूची';

  @override
  String get switchToAdmin => 'एडमिनमा जानुहोस्';

  @override
  String get language => 'भाषा';

  @override
  String get logout => 'लग आउट';

  @override
  String get logoutConfirmTitle => 'लग आउट';

  @override
  String get logoutConfirmMessage =>
      'के तपाईं निश्चित रूपमा लग आउट गर्न चाहनुहुन्छ?';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get ok => 'ठीक छ';

  @override
  String get search => 'खोज्नुहोस्';

  @override
  String get categories => 'कोटिहरू';

  @override
  String get all => 'सबै';

  @override
  String get vegetables => 'तरकारी';

  @override
  String get fruits => 'फलफूल';

  @override
  String get grains => 'अन्न';

  @override
  String get others => 'अन्य';

  @override
  String get notifications => 'सूचनाहरू';

  @override
  String get noNotifications => 'अहिलेसम्म कुनै सूचना छैन';

  @override
  String get newReview => 'नयाँ समीक्षा';

  @override
  String get newFavorite => 'नयाँ मनपर्ने';

  @override
  String get newMessage => 'नयाँ सन्देश';
}
