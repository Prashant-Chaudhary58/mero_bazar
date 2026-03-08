import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/login_view_model.dart';
import '../../../../test_helper.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockLoginViewModel;
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    mockUserProvider = MockUserProvider();

    when(() => mockLoginViewModel.isLoading).thenReturn(false);
    when(() => mockLoginViewModel.obscurePassword).thenReturn(true);
  });

  Widget createLoginScreen() {
    return createTestableWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginViewModel>.value(
            value: mockLoginViewModel,
          ),
        ],
        child: const LoginScreen(),
      ),
      userProvider: mockUserProvider,
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      expect(find.text('Phone No'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display forgot password link', (tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });
}
