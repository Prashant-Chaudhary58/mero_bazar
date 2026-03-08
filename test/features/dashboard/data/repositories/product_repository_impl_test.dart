import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/dashboard/data/datasources/product_remote_datasource.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(mockRemoteDataSource);
  });

  group('ProductRepositoryImpl Unit Tests', () {
    test('should return all products from remote datasource', () async {
      final products = [
        ProductModel(
          id: '1',
          name: 'P1',
          description: 'D1',
          price: 10,
          category: 'C1',
          quantity: '1',
        ),
      ];
      when(
        () => mockRemoteDataSource.getAllProducts(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
          radius: any(named: 'radius'),
        ),
      ).thenAnswer((_) async => products);

      final result = await repository.getAllProducts();

      expect(result, products);
      verify(() => mockRemoteDataSource.getAllProducts()).called(1);
    });
  });
}
