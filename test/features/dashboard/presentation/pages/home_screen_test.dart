import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/home_screen.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/category_widget.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/home_banner_widget.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/home_search_widget.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/product_card_widget.dart';

import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class MockUserProvider extends Mock implements UserProvider {}

void main() {
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockUserProvider = MockUserProvider();
    when(() => mockUserProvider.user).thenReturn(null);
  });

  Widget createHomeScreen() {
    return ChangeNotifierProvider<UserProvider>.value(
      value: mockUserProvider,
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders all major components', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(HomeSearchWidget), findsOneWidget);
      expect(find.byType(HomeBannerWidget), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.byType(CategoryWidget), findsAtLeastNWidgets(1));
      expect(find.byType(ProductCardWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('displays correct category titles', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Vegetables (तरकारी)'), findsOneWidget);
      expect(find.text('Fruits (फलफूल)'), findsOneWidget);
    });

    testWidgets('scrolls and finds products', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Ensure some products are found even if not all visible at once
      expect(find.text('Maize'), findsAtLeastNWidgets(1));
      expect(find.text('Potato'), findsAtLeastNWidgets(1));
    });
  });
}
