import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akile_attendance_system/api/endpoints.dart';

// ─── Fetch logged-in employee's assignments ───────────────────────────────────
Future<List<dynamic>> fetchMyAssignments({String token}) async {
  try {
    final response = await http.get(
      Uri.parse(API.ASSIGNMENTS),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['assignments'] ?? [];
    } else {
      print('fetchMyAssignments error: ${response.statusCode} ${response.body}');
      return [];
    }
  } catch (e) {
    print('fetchMyAssignments exception: $e');
    return [];
  }
}

// ─── Fetch employee notifications ────────────────────────────────────────────
Future<Map<String, dynamic>> fetchMyNotifications({String token, String userId}) async {
  try {
    final response = await http.get(
      Uri.parse(API.NOTIFICATIONS_MY + userId),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
      // returns { notifications: [...], unreadCount: N }
    } else {
      print('fetchMyNotifications error: ${response.statusCode}');
      return {'notifications': [], 'unreadCount': 0};
    }
  } catch (e) {
    print('fetchMyNotifications exception: $e');
    return {'notifications': [], 'unreadCount': 0};
  }
}

// ─── Fetch unread count (lightweight, for badge) ──────────────────────────────
Future<int> fetchUnreadCount({String token, String userId}) async {
  try {
    final response = await http.get(
      Uri.parse(API.UNREAD_COUNT + userId),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['unreadCount'] ?? 0;
    }
    return 0;
  } catch (e) {
    print('fetchUnreadCount exception: $e');
    return 0;
  }
}

// ─── Mark a single notification as read ──────────────────────────────────────
Future<void> markNotificationRead({String token, String notifId}) async {
  try {
    // Dynamic notifications (overtime) start with "ot_" — they're not in the DB
    if (notifId.startsWith('ot_')) return;

    await http.put(
      Uri.parse(API.MARK_READ + '$notifId/read'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
  } catch (e) {
    print('markNotificationRead exception: $e');
  }
}

// ─── Mark all notifications as read ─────────────────────────────────────────
Future<void> markAllNotificationsRead({String token, String userId}) async {
  try {
    await http.put(
      Uri.parse(API.MARK_READ_ALL + userId),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
  } catch (e) {
    print('markAllNotificationsRead exception: $e');
  }
}
