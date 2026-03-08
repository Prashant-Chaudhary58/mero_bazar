import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mero_bazar/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/product_provider.dart';
import 'package:mero_bazar/features/notifications/presentation/providers/notification_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';
import 'package:mero_bazar/features/chat/presentation/providers/chat_provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import 'package:mero_bazar/core/providers/language_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/admin_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProvider extends Mock implements UserProvider {}

class MockProductProvider extends Mock implements ProductProvider {}

class MockNotificationProvider extends Mock implements NotificationProvider {}

class MockFavoriteProvider extends Mock implements FavoriteProvider {}

class MockChatProvider extends Mock implements ChatProvider {}

class MockDashboardProvider extends Mock implements DashboardProvider {}

class MockLanguageProvider extends Mock implements LanguageProvider {}

class MockAdminProvider extends Mock implements AdminProvider {}

Widget createTestableWidget({
  required Widget child,
  UserProvider? userProvider,
  ProductProvider? productProvider,
  NotificationProvider? notificationProvider,
  FavoriteProvider? favoriteProvider,
  ChatProvider? chatProvider,
  DashboardProvider? dashboardProvider,
  LanguageProvider? languageProvider,
  AdminProvider? adminProvider,
  GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  final uProvider = userProvider ?? MockUserProvider();
  final pProvider = productProvider ?? MockProductProvider();
  final nProvider = notificationProvider ?? MockNotificationProvider();
  final fProvider = favoriteProvider ?? MockFavoriteProvider();
  final cProvider = chatProvider ?? MockChatProvider();
  final dProvider = dashboardProvider ?? MockDashboardProvider();
  final lProvider = languageProvider ?? MockLanguageProvider();
  final aProvider = adminProvider ?? MockAdminProvider();

  // Stub defaults if they are mocks and not already stubbed
  if (userProvider == null && uProvider is MockUserProvider) {
    when(() => uProvider.user).thenReturn(null);
  }
  if (productProvider == null && pProvider is MockProductProvider) {
    when(() => pProvider.products).thenReturn([]);
    when(() => pProvider.isLoading).thenReturn(false);
    when(() => pProvider.error).thenReturn(null);
  }
  if (notificationProvider == null && nProvider is MockNotificationProvider) {
    when(() => nProvider.notifications).thenReturn([]);
    when(() => nProvider.unreadCount).thenReturn(0);
    when(() => nProvider.isLoading).thenReturn(false);
  }
  if (favoriteProvider == null && fProvider is MockFavoriteProvider) {
    when(() => fProvider.favorites).thenReturn([]);
    when(() => fProvider.isFavorite(any())).thenReturn(false);
  }
  if (chatProvider == null && cProvider is MockChatProvider) {
    when(() => cProvider.chats).thenReturn([]);
    when(() => cProvider.unreadMessagesCount).thenReturn(0);
    when(() => cProvider.isLoading).thenReturn(false);
  }
  if (dashboardProvider == null && dProvider is MockDashboardProvider) {
    when(() => dProvider.selectedIndex).thenReturn(0);
  }
  if (languageProvider == null && lProvider is MockLanguageProvider) {
    when(() => lProvider.locale).thenReturn(const Locale('en'));
  }
  if (adminProvider == null && aProvider is MockAdminProvider) {
    when(() => aProvider.stats).thenReturn({});
    when(() => aProvider.pendingProducts).thenReturn([]);
    when(() => aProvider.isLoading).thenReturn(false);
    when(() => aProvider.fetchStats()).thenAnswer((_) async => {});
    when(() => aProvider.fetchPendingProducts()).thenAnswer((_) async => []);
  }

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>.value(value: uProvider),
      ChangeNotifierProvider<ProductProvider>.value(value: pProvider),
      ChangeNotifierProvider<NotificationProvider>.value(value: nProvider),
      ChangeNotifierProvider<FavoriteProvider>.value(value: fProvider),
      ChangeNotifierProvider<ChatProvider>.value(value: cProvider),
      ChangeNotifierProvider<DashboardProvider>.value(value: dProvider),
      ChangeNotifierProvider<LanguageProvider>.value(value: lProvider),
      ChangeNotifierProvider<AdminProvider>.value(value: aProvider),
    ],
    child: MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ne')],
      home: child,
    ),
  );
}
