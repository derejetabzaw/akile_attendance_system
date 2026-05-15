import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/api/assignments_api.dart';

class NotificationsPanel extends StatefulWidget {
  _NotificationsPanelState createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  // ── 1.22.6 compatible SnackBar handling ────────────────────────────────────
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> _notifications = [];
  int _unreadCount = 0;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadNotifications());
  }

  Future<void> _loadNotifications() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final token = auth.getTokenFun();
      final userId = auth.getId();
      if (token == null || userId == null || userId.isEmpty) {
        setState(() { _loading = false; _error = 'Not authenticated.'; });
        return;
      }
      final data = await fetchMyNotifications(token: token, userId: userId);
      if (mounted) {
        setState(() {
          _notifications = data['notifications'] ?? [];
          _unreadCount = data['unreadCount'] ?? 0;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load notifications.'; });
    }
  }

  Future<void> _markRead(dynamic notif) async {
    if (notif['isRead'] == true) return;
    final auth = Provider.of<Auth>(context, listen: false);
    final token = auth.getTokenFun();

    setState(() {
      final idx = _notifications.indexOf(notif);
      if (idx != -1) {
        _notifications[idx] = Map<String, dynamic>.from(_notifications[idx])..['isRead'] = true;
        if (_unreadCount > 0) _unreadCount--;
      }
    });

    final id = notif['_id']?.toString() ?? '';
    await markNotificationRead(token: token, notifId: id);
  }

  Future<void> _markAllRead() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final token = auth.getTokenFun();
    final userId = auth.getId();

    await markAllNotificationsRead(token: token, userId: userId);

    if (mounted) {
      setState(() {
        _notifications = _notifications.map((n) {
          return Map<String, dynamic>.from(n)..['isRead'] = true;
        }).toList();
        _unreadCount = 0;
      });

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('All notifications marked as read'),
          backgroundColor: PRIMARY_COLOR,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // ── Type → icon / color / label mapping (1.22.6 compatible icons) ──────────
  IconData _iconFor(String type) {
    switch (type) {
      case 'new_assignment':      return Icons.assignment; // assignment_add is newer
      case 'schedule_update':     return Icons.calendar_today;
      case 'working_hours_update':return Icons.schedule;
      case 'payroll_update':      return Icons.attach_money;
      case 'overtime_flag':       return Icons.warning;
      default:                    return Icons.notifications;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'new_assignment':      return PRIMARY_COLOR;
      case 'schedule_update':     return Color(0xFF0EA5E9);
      case 'working_hours_update':return Color(0xFFF59E0B);
      case 'payroll_update':      return Color(0xFF10B981);
      case 'overtime_flag':       return Color(0xFFEF4444);
      default:                    return Color(0xFF64748B);
    }
  }

  String _labelFor(String type) {
    switch (type) {
      case 'new_assignment':      return 'New Assignment';
      case 'schedule_update':     return 'Schedule Updated';
      case 'working_hours_update':return 'Working Hours';
      case 'payroll_update':      return 'Payroll Update';
      case 'overtime_flag':       return 'Overtime';
      default:                    return 'Notification';
    }
  }

  String _relativeTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1)  return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24)   return '${diff.inHours}h ago';
      if (diff.inDays < 7)     return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildNotificationTile(dynamic notif) {
    final Map<String, dynamic> n = Map<String, dynamic>.from(notif);
    final String type    = n['type'] ?? 'notification';
    final String title   = n['title'] ?? _labelFor(type);
    final String message = n['message'] ?? '';
    final String detail  = n['detail'] ?? '';
    final bool isRead    = n['isRead'] == true;
    final String ts      = n['createdAt']?.toString() ?? '';
    final Color color    = _colorFor(type);

    return GestureDetector(
      onTap: () => _markRead(n),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isRead ? Color(0xFFE2E8F0) : color.withOpacity(0.3), width: 1.2),
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(isRead ? 0.08 : 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_iconFor(type), color: color, size: 22),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                              fontSize: 14,
                              color: isRead ? Color(0xFF475569) : Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      message,
                      style: TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: isRead ? FontWeight.normal : FontWeight.w500),
                    ),
                    if (detail.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(detail, style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    ],
                    if (ts.isNotEmpty) ...[
                      SizedBox(height: 6),
                      Text(
                        _relativeTime(ts),
                        style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Required for showSnackBar in 1.22.6
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            if (_unreadCount > 0) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text('$_unreadCount', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_unreadCount > 0)
            FlatButton.icon( // FlatButton is standard in 1.22.6
              onPressed: _markAllRead,
              icon: Icon(Icons.done_all, color: Colors.white, size: 18),
              label: Text('Mark all read', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 12),
                      Text(_error, style: TextStyle(color: Color(0xFF64748B))),
                      SizedBox(height: 16),
                      RaisedButton.icon(
                        onPressed: _loadNotifications,
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        color: PRIMARY_COLOR,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                )
              : _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none, size: 72, color: Color(0xFFE2E8F0)),
                          SizedBox(height: 16),
                          Text('No notifications yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                          SizedBox(height: 8),
                          Text('You\'ll be notified here when your admin sends assignments.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) => _buildNotificationTile(_notifications[index]),
                      ),
                    ),
    );
  }
}
