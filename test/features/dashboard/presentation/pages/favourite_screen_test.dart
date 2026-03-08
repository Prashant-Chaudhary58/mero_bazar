import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/favourite_screen.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';

void main() {
  late MockFavoriteProvider mockFavoriteProvider;

  setUp(() {
    mockFavoriteProvider = MockFavoriteProvider();
    when(() => mockFavoriteProvider.favorites).thenReturn([]);
  });

  Widget createFavouriteScreen() {
    return createTestableWidget(
      child: const FavouriteScreen(),
      favoriteProvider: mockFavoriteProvider,
    );
  }

  group('FavouriteScreen Widget Tests', () {
    testWidgets('renders title and empty state', (tester) async {
      await tester.pumpWidget(createFavouriteScreen());
      await tester.pumpAndSettle();

      expect(find.text('Favourites'), findsAtLeastNWidgets(1));
      expect(find.text('No favorites yet'), findsOneWidget);
    });
  });
}
