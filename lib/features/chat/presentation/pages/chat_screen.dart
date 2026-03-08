import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/chat_provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/core/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String _chatId;
  late String _receiverName;
  String? _receiverImage;
  String? _receiverPhone;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['chatId'] != null) {
        _chatId = args['chatId'];
        _receiverName = args['receiverName'] ?? 'Chat';
        _receiverImage = args['receiverImage'];
        _receiverPhone = args['receiverPhone'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ChatProvider>().fetchMessages(_chatId);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!mounted) return;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final currentUserId = userProvider.user?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_receiverImage != null) ...[
              CircleAvatar(
                backgroundImage:
                    _receiverImage!.startsWith('file://') ||
                        _receiverImage!.startsWith('/')
                    ? FileImage(
                            File(_receiverImage!.replaceFirst('file://', '')),
                          )
                          as ImageProvider
                    : (_receiverImage!.startsWith('http')
                          ? NetworkImage(_receiverImage!)
                          : NetworkImage(
                              ApiService.getImageUrl(_receiverImage, 'users'),
                            )),
                radius: 16,
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 8),
            ],
            Text(_receiverName, style: const TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.call,
              color: _receiverPhone != null ? Colors.green : Colors.grey,
            ),
            onPressed: () async {
              if (_receiverPhone == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Phone number not available")),
                );
                return;
              }

              try {
                final cleanPhone = _receiverPhone!.replaceAll(
                  RegExp(r'[^\d+]'),
                  '',
                );
                final Uri launchUri = Uri(scheme: 'tel', path: cleanPhone);
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not launch dialer")),
                    );
                  }
                }
              } catch (e) {
                print("Error launching dialer: $e");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid phone number format"),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.currentMessages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.currentMessages.length,
                  itemBuilder: (context, index) {
                    final message = provider.currentMessages[index];
                    final isMe = message.sender?['_id'] == currentUserId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_msgController.text.trim().isNotEmpty) {
                        context.read<ChatProvider>().sendMessage(
                          _chatId,
                          _msgController.text.trim(),
                        );
                        _msgController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
