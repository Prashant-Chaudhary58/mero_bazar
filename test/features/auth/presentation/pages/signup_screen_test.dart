import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/presentation/pages/signup_screen.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/signup_view_model.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class MockSignupViewModel extends Mock implements SignupViewModel {}

class MockUserProvider extends Mock implements UserProvider {}

void main() {
  late MockSignupViewModel mockSignupViewModel;
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockSignupViewModel = MockSignupViewModel();
    mockUserProvider = MockUserProvider();

    when(() => mockSignupViewModel.isLoading).thenReturn(false);
    when(() => mockSignupViewModel.obscurePassword).thenReturn(true);
    when(() => mockSignupViewModel.obscureConfirmPassword).thenReturn(true);
    when(() => mockSignupViewModel.isAccepted).thenReturn(false);
  });

  Widget createSignupScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignupViewModel>.value(
          value: mockSignupViewModel,
        ),
        ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
      ],
      child: MaterialApp(
        home: const SignupScreen(),
        routes: {'/login': (context) => const Scaffold(body: Text('Login'))},
      ),
    );
  }

  group('SignupScreen Widget Tests', () {
    testWidgets('renders all UI elements', (tester) async {
      await tester.pumpWidget(createSignupScreen());

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone No'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('shows loading indicator', (tester) async {
      when(() => mockSignupViewModel.isLoading).thenReturn(true);

      await tester.pumpWidget(createSignupScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls register when button is tapped', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(
        () => mockSignupViewModel.register(any(), any(), any(), any()),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(createSignupScreen());

      await tester.enterText(
        find.widgetWithText(TextField, 'Enter your full Name'),
        'Prashant Chaudhary',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter your Phone No'),
        '9800000000',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter Your Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter your confirm password'),
        'password123',
      );

      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pump();
      await tester.pump();
      // Start request
      await tester.pump(); // Finish request

      verify(
        () => mockSignupViewModel.register(any(), any(), any(), any()),
      ).called(1);
    });
  });
}
