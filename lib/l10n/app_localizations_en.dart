// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mero Bazar';

  @override
  String get myAccount => 'My Account';

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get viewEditProfile => 'view & edit your profile';

  @override
  String get myListing => 'My Listing';

  @override
  String get switchToAdmin => 'Switch to Admin';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get search => 'Search';

  @override
  String get categories => 'Categories';

  @override
  String get all => 'All';

  @override
  String get vegetables => 'Vegetables';

  @override
  String get fruits => 'Fruits';

  @override
  String get grains => 'Grains';

  @override
  String get others => 'Others';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get newReview => 'New Review';

  @override
  String get newFavorite => 'New Favorite';

  @override
  String get newMessage => 'New Message';
}
