import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:mero_bazar/features/chat/presentation/providers/chat_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

void main() {
  late MockChatProvider mockChatProvider;
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockChatProvider = MockChatProvider();
    mockUserProvider = MockUserProvider();
    when(() => mockChatProvider.chats).thenReturn([]);
    when(() => mockChatProvider.isLoading).thenReturn(false);
    when(() => mockUserProvider.user).thenReturn(null);
  });

  Widget createChatListScreen() {
    return createTestableWidget(
      child: const ChatListScreen(),
      chatProvider: mockChatProvider,
      userProvider: mockUserProvider,
    );
  }

  group('ChatListScreen Widget Tests', () {
    testWidgets('renders title and empty message', (tester) async {
      await tester.pumpWidget(createChatListScreen());
      await tester.pumpAndSettle();

      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('No messages yet'), findsOneWidget);
    });
  });
}
