import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/data/datasources/product_remote_datasource.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(mockDataSource);
  });

  group('ProductRepositoryImpl Unit Tests', () {
    final product = ProductModel(
      id: '1',
      name: 'Test Product',
      price: 100,
      image: 'test.png',
      category: 'Test',
      description: 'Test Description',
      quantity: '10',
    );

    test(
      'getAllProducts should call remoteDataSource.getAllProducts',
      () async {
        when(
          () => mockDataSource.getAllProducts(),
        ).thenAnswer((_) async => [product]);

        final result = await repository.getAllProducts();

        expect(result, [product]);
        verify(() => mockDataSource.getAllProducts()).called(1);
      },
    );

    test('getProduct should call remoteDataSource.getProduct', () async {
      when(
        () => mockDataSource.getProduct(any()),
      ).thenAnswer((_) async => product);

      final result = await repository.getProduct('1');

      expect(result, product);
      verify(() => mockDataSource.getProduct('1')).called(1);
    });
  });
}
