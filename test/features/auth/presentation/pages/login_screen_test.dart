import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/login_view_model.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockUserProvider extends Mock implements UserProvider {}

void main() {
  late MockLoginViewModel mockLoginViewModel;
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    mockUserProvider = MockUserProvider();

    // Default mock behaviors
    when(() => mockLoginViewModel.isLoading).thenReturn(false);
    when(() => mockLoginViewModel.obscurePassword).thenReturn(true);
  });

  Widget createLoginScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>.value(value: mockLoginViewModel),
        ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
      ],
      child: MaterialApp(
        home: const LoginScreen(),
        routes: {
          '/bottomnav': (context) => const Scaffold(body: Text('BottomNav')),
          '/signup': (context) => const Scaffold(body: Text('SignUp')),
        },
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Phone No'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      when(() => mockLoginViewModel.isLoading).thenReturn(true);

      await tester.pumpWidget(createLoginScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('toggles password visibility when icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      final visibilityIcon = find.byIcon(Icons.visibility_off);
      expect(visibilityIcon, findsOneWidget);

      await tester.tap(visibilityIcon);
      verify(() => mockLoginViewModel.togglePasswordVisibility()).called(1);
    });

    testWidgets('calls login on ViewModel when button is tapped', (
      tester,
    ) async {
      when(
        () => mockLoginViewModel.login(any(), any(), any()),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(createLoginScreen());

      final phoneField = find.ancestor(
        of: find.text('Enter your Phone No'),
        matching: find.byType(TextField),
      );
      final passwordField = find.ancestor(
        of: find.text('Enter your password'),
        matching: find.byType(TextField),
      );

      await tester.enterText(phoneField, '9800000000');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      verify(
        () => mockLoginViewModel.login('9800000000', 'password123', 'buyer'),
      ).called(1);
    });
  });
}
