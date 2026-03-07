import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.chats.isEmpty) {
            return const Center(
              child: Text(
                'No conversations yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.chats.length,
            itemBuilder: (context, index) {
              final chat = provider.chats[index];
              final otherUser = chat.otherParticipant;
              final String name = otherUser != null
                  ? otherUser['fullName'] ?? 'User'
                  : 'Unknown';
              final String? image = otherUser != null
                  ? otherUser['image']
                  : null;
              final lastMsg = chat.lastMessage;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: image != null
                      ? (image.startsWith('file://') || image.startsWith('/')
                            ? FileImage(File(image.replaceFirst('file://', '')))
                                  as ImageProvider
                            : (image.startsWith('http')
                                  ? NetworkImage(image)
                                  : CachedNetworkImageProvider(
                                      ApiService.getImageUrl(image, 'users'),
                                    )))
                      : null,
                  child: image == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMsg != null ? lastMsg['text'] ?? '' : 'Start chatting',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  chat.updatedAt.toLocal().toString().substring(11, 16),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat-details',
                    arguments: {
                      'chatId': chat.id,
                      'receiverName': name,
                      'receiverImage': image,
                      'receiverPhone': otherUser?['phone'],
                      'receiverId': otherUser?['_id'],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
