import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import '../../data/models/notification_model.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/app.dart'; // To access scaffoldMessengerKey

class NotificationProvider extends ChangeNotifier {
  final Dio _dio = ApiService.dio;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get('/notifications');
      if (response.data['success']) {
        final List data = response.data['data'];
        _notifications = data
            .map((n) => NotificationModel.fromJson(n))
            .toList();
        _unreadCount = _notifications.where((n) => !n.isRead).length;
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _dio.put('/notifications/$notificationId/read');
      if (response.data['success']) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = NotificationModel.fromJson(
            response.data['data'],
          );
          _unreadCount = _notifications.where((n) => !n.isRead).length;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  void addRealTimeNotification(Map<String, dynamic> data) {
    // Check if duplicate
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
      recipient: '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'User',
      type: data['type'] ?? 'message',
      content: data['content'] ?? 'sent you a message',
      isRead: false,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );

    _notifications.insert(0, newNotification);
    _unreadCount++;
    notifyListeners();

    // Show Top Banner (at top of screen)
    _showTopBanner(newNotification);
  }

  void _showTopBanner(NotificationModel notification) {
    if (scaffoldMessengerKey.currentState == null) return;

    scaffoldMessengerKey.currentState!.hideCurrentMaterialBanner();
    scaffoldMessengerKey.currentState!.showMaterialBanner(
      MaterialBanner(
        elevation: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(
            notification.type == 'review'
                ? Icons.star
                : (notification.type == 'message'
                      ? Icons.chat
                      : Icons.favorite),
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New ${notification.type.toUpperCase()}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              "${notification.senderName}: ${notification.content}",
              style: const TextStyle(color: Colors.white, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        actions: [
          TextButton(
            onPressed: () =>
                scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner(),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
    });
  }

  Future<void> sendFavoriteNotification(
    String sellerId,
    UserEntity? currentUser,
  ) async {
    if (currentUser == null) return;

    try {
      await _dio.post('/notifications/favorite', data: {'sellerId': sellerId});
      // Note: Socket broadcast is handled by server on this POST call?
      // Actually, we should probably emit it via socket here if the backend doesn't broadcast to all.
      // But usually, the backend handles the broadcast logic.
      // However, our server.js has an explicit 'sendNotification' event.
    } catch (e) {
      print("Error sending favorite notification: $e");
    }
  }
}
