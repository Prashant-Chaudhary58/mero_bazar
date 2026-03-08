import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mero_bazar/features/chat/domain/entities/chat_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ChatRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = ChatRemoteDataSourceImpl(mockDio);
  });

  group('ChatRemoteDataSource Unit Tests', () {
    test('should get chats successfully', () async {
      final responseData = {
        'success': true,
        'data': [
          {'_id': 'c1', 'updatedAt': DateTime.now().toIso8601String()},
        ],
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getChats();

      expect(result.first.id, 'c1');
    });
  });
}
