import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/presentation/pages/signup_screen.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/signup_view_model.dart';
import '../../../../test_helper.dart';

class MockSignupViewModel extends Mock implements SignupViewModel {}

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
    return createTestableWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<SignupViewModel>.value(
            value: mockSignupViewModel,
          ),
        ],
        child: const SignupScreen(),
      ),
      userProvider: mockUserProvider,
    );
  }

  group('SignupScreen Widget Tests', () {
    testWidgets('renders all UI elements', (tester) async {
      await tester.pumpWidget(createSignupScreen());
      await tester.pumpAndSettle();

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone No'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });
  });
}
