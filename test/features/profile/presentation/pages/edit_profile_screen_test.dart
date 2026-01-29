import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/features/auth/data/repositories/auth_repository_impl.dart';

class MockUserProvider extends Mock implements UserProvider {}

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
      fullName: 'John Doe',
      role: 'buyer',
    );

    when(() => mockUserProvider.user).thenReturn(user);
  });

  Widget createEditProfileScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        Provider<AuthRepositoryImpl>.value(value: mockAuthRepository),
      ],
      child: const MaterialApp(home: EditProfileScreen()),
    );
  }

  group('EditProfileScreen Widget Tests', () {
    testWidgets('renders all fields with initial user data', (tester) async {
      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('My Account'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'John Doe'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('calls updateProfile when Save is tapped', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Mock updateProfile to return the updated user
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

      await tester.pumpWidget(createEditProfileScreen());

      // Change name
      final nameField = find.widgetWithText(TextField, 'John Doe');
      await tester.enterText(nameField, 'John Smith');

      final saveButton = find.text('Save');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pump(); // Show loading dialog
      await tester.pump(); // Finish updateProfile
      await tester.pump(); // Pop loading dialog
      await tester.pump(); // Pop screen

      verify(
        () => mockAuthRepository.updateProfile(
          user: any(named: 'user'),
          imageFile: any(named: 'imageFile'),
        ),
      ).called(1);
    });
  });
}
