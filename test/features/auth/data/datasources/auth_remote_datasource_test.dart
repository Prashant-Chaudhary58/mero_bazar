import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(mockDio);
  });

  group('AuthRemoteDataSource Unit Tests', () {
    test('should login successfully', () async {
      final responseData = {
        'success': true,
        'token': 'tok123',
        'data': {
          '_id': '1',
          'fullName': 'John',
          'phone': '123',
          'role': 'buyer',
        },
      };

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.loginUser('123', 'pass');

      expect(result.fullName, 'John');
    });
  });
}
