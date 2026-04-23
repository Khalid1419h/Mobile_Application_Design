import 'package:university_event_management_system/models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  int get count => _notifications.length;

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
  }

  void removeAt(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
    }
  }

  void clearNotifications() => _notifications.clear();
}
