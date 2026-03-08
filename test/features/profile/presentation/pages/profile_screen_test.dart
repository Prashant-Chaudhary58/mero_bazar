import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/profile/presentation/pages/profile_screen.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/core/providers/language_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';

void main() {
  late MockUserProvider mockUserProvider;
  late MockLanguageProvider mockLanguageProvider;
  late MockDashboardProvider mockDashboardProvider;

  setUp(() {
    mockUserProvider = MockUserProvider();
    mockLanguageProvider = MockLanguageProvider();
    mockDashboardProvider = MockDashboardProvider();

    when(() => mockUserProvider.user).thenReturn(
      const UserEntity(
        id: '1',
        fullName: 'Prashant Chaudhary',
        phone: '9800000000',
        role: 'buyer',
      ),
    );
    when(() => mockLanguageProvider.locale).thenReturn(const Locale('en'));
    when(() => mockDashboardProvider.selectedIndex).thenReturn(0);
  });

  Widget createProfileScreen() {
    return createTestableWidget(
      child: const ProfileScreen(),
      userProvider: mockUserProvider,
      languageProvider: mockLanguageProvider,
      dashboardProvider: mockDashboardProvider,
    );
  }

  group('ProfileScreen Widget Tests', () {
    testWidgets('renders user profile information', (tester) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      final allText = tester.allWidgets
          .whereType<Text>()
          .map((t) => t.data)
          .toList();
      debugPrint('ALL TEXT WIDGETS: $allText');

      expect(find.textContaining('Prashant Chaudhary'), findsOneWidget);
    });
  });
}
