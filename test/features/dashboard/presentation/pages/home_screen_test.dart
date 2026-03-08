import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/home_screen.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/category_widget.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/home_banner_widget.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/home_search_widget.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/home_screen.dart';
import '../../../../test_helper.dart';

void main() {
  late MockUserProvider mockUserProvider;
  late MockProductProvider mockProductProvider;
  late MockNotificationProvider mockNotificationProvider;
  late MockFavoriteProvider mockFavoriteProvider;

  setUp(() {
    mockUserProvider = MockUserProvider();
    mockProductProvider = MockProductProvider();
    mockNotificationProvider = MockNotificationProvider();
    mockFavoriteProvider = MockFavoriteProvider();

    when(() => mockUserProvider.user).thenReturn(null);
    when(() => mockProductProvider.isLoading).thenReturn(false);
    when(() => mockProductProvider.error).thenReturn(null);
    when(() => mockProductProvider.products).thenReturn([
      ProductModel(
        id: '1',
        name: 'Maize',
        price: 100,
        category: 'Grains',
        quantity: '10',
        description: 'Quality maize',
      ),
    ]);

    when(() => mockNotificationProvider.unreadCount).thenReturn(0);
    when(() => mockFavoriteProvider.isFavorite(any())).thenReturn(false);
  });

  Widget createHomeScreen() {
    return createTestableWidget(
      child: const HomeScreen(),
      userProvider: mockUserProvider,
      productProvider: mockProductProvider,
      notificationProvider: mockNotificationProvider,
      favoriteProvider: mockFavoriteProvider,
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders all major components', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester
          .pump(); // Use pump instead of pumpAndSettle if there's an animation

      expect(find.byType(HomeSearchWidget), findsOneWidget);
      expect(find.byType(HomeBannerWidget), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.byType(CategoryWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('displays localized category titles', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Vegetables'), findsOneWidget);
    });
  });
}
