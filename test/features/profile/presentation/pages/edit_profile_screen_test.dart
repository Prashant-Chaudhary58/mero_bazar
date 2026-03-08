import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/product_provider.dart';
import 'package:mero_bazar/features/notifications/presentation/providers/notification_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';
import 'package:mero_bazar/features/chat/presentation/providers/chat_provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import '../../../../test_helper.dart';

class MockAuthRepositoryImpl extends Mock implements AuthRepositoryImpl {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockUserProvider mockUserProvider;
  late MockAuthRepositoryImpl mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockUserProvider = MockUserProvider();
    mockAuthRepository = MockAuthRepositoryImpl();

    const user = UserEntity(
      id: '1',
      phone: '9800000000',
      fullName: 'Prashant Chaudhary',
      role: 'buyer',
    );

    when(() => mockUserProvider.user).thenReturn(user);

    when(
      () => mockAuthRepository.updateProfile(
        user: any(named: 'user'),
        imageFile: any(named: 'imageFile'),
      ),
    ).thenAnswer(
      (_) async => const UserEntity(
        id: '1',
        phone: '9800000000',
        fullName: 'John Smith',
        role: 'buyer',
      ),
    );
  });

  Widget createEditProfileScreenWithRepo() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        Provider<AuthRepositoryImpl>.value(value: mockAuthRepository),
        ChangeNotifierProvider<ProductProvider>.value(
          value: MockProductProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>.value(
          value: MockNotificationProvider(),
        ),
        ChangeNotifierProvider<FavoriteProvider>.value(
          value: MockFavoriteProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>.value(value: MockChatProvider()),
        ChangeNotifierProvider<DashboardProvider>.value(
          value: MockDashboardProvider(),
        ),
      ],
      child: const MaterialApp(home: EditProfileScreen()),
    );
  }

  group('EditProfileScreen Widget Tests', () {
    testWidgets('renders all fields with initial user data', (tester) async {
      await tester.pumpWidget(createEditProfileScreenWithRepo());
      await tester.pumpAndSettle();

      expect(find.text('My Account'), findsOneWidget);
      expect(find.text('Prashant Chaudhary'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('calls updateProfile when Save is tapped', (tester) async {
      await tester.pumpWidget(createEditProfileScreenWithRepo());
      await tester.pumpAndSettle();

      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'John Smith');

      final saveButton = find.text('Save');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      verify(
        () => mockAuthRepository.updateProfile(
          user: any(named: 'user'),
          imageFile: any(named: 'imageFile'),
        ),
      ).called(1);
    });
  });
}
