import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/data/datasources/product_remote_datasource.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = ProductRemoteDataSourceImpl(mockDio);
  });

  group('ProductRemoteDataSource Unit Tests', () {
    test('should get all products from API', () async {
      final responseData = {
        'success': true,
        'data': [
          {
            '_id': '1',
            'name': 'Apple',
            'description': 'Fresh',
            'price': 100,
            'category': 'Fruit',
            'quantity': '10',
          },
        ],
      };

      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getAllProducts();

      expect(result.length, 1);
      expect(result.first.name, 'Apple');
    });
  });
}
