import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/profile/presentation/pages/my_listings_screen.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/product_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import '../../../../test_helper.dart';

class MockProductRepositoryImpl extends Mock implements ProductRepositoryImpl {}

void main() {
  late MockProductRepositoryImpl mockRepo;
  late MockUserProvider mockUserProvider;
  late MockProductProvider mockProductProvider;

  setUp(() {
    mockRepo = MockProductRepositoryImpl();
    mockUserProvider = MockUserProvider();
    mockProductProvider = MockProductProvider();

    when(() => mockUserProvider.user).thenReturn(null);
    when(() => mockRepo.getMyProducts()).thenAnswer((_) async => []);
  });

  Widget createMyListingsScreen() {
    return createTestableWidget(
      child: MultiProvider(
        providers: [Provider<ProductRepositoryImpl>.value(value: mockRepo)],
        child: const MyListingsScreen(),
      ),
      userProvider: mockUserProvider,
      productProvider: mockProductProvider,
    );
  }

  group('MyListingsScreen Widget Tests', () {
    testWidgets('renders my listings title', (tester) async {
      await tester.pumpWidget(createMyListingsScreen());
      // Use pump() instead of pumpAndSettle if there are infinite animations or asset issues
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('My Listing'), findsOneWidget);
    });
  });
}
