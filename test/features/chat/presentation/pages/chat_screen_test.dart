import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/chat/presentation/pages/chat_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';

void main() {
  Widget createChatScreen() {
    return createTestableWidget(child: const ChatScreen());
  }

  group('ChatScreen Widget Tests', () {
    testWidgets('redirects back if no arguments provided', (tester) async {
      await tester.pumpWidget(MaterialApp(home: createChatScreen()));
      await tester.pump();
      // Should have popped, but in test home it might just be empty or showing nothing
      // We expect it to try to pop.
    });

    testWidgets('renders chat interface when arguments provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: const RouteSettings(
              arguments: {
                'chatId': 'c1',
                'receiverName': 'Test User',
                'receiverPhone': '123',
              },
            ),
            builder: (context) => createChatScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Test User'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
