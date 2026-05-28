import 'package:flutter/material.dart';
import 'package:akile_attendance_system/pages/assignments.dart';
import 'package:akile_attendance_system/pages/checkIn.dart';
import 'package:akile_attendance_system/pages/leave_request.dart';
import 'package:akile_attendance_system/pages/notifications_panel.dart';
import 'package:akile_attendance_system/pages/drawer/navigationDrawer.dart';
import 'package:akile_attendance_system/utilities/abstract_classes/confirmation_abstract.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/utilities/get_size.dart';
import 'package:akile_attendance_system/api/assignments_api.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> implements ShouldImp {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshUnreadCount();
    });
  }

  void _refreshUnreadCount() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final token = auth.getTokenFun();
      final userId = auth.getId();
      if (token != null && userId != null && userId.isNotEmpty) {
        final count = await fetchUnreadCount(token: token, userId: userId);
        if (mounted) setState(() => _unreadCount = count);
      }
    } catch (e) {
      print('Error refreshing unread count: $e');
    }
  }

  @override
  void changer({context, id}) {}

  Widget _buildPage(int tab) {
    switch (tab) {
      case 0:
        return CheckIn();
      case 1:
        return Assignments();
      case 2:
        return LeaveRequestPage();
      default:
        return CheckIn();
    }
  }

  void _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotificationsPanel()),
    );
    _refreshUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final currentTab = auth.getHomePageTabFun();

    // Custom Indigo Color to match the new UI
    final Color primaryIndigo = Color(0xFF4F46E5);

    return Scaffold(
      extendBodyBehindAppBar: currentTab == 0,
      appBar: currentTab == 2
          ? null // LeaveRequestPage has its own AppBar
          : currentTab == 0
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  actions: [_notificationsBadge()],
                )
              : AppBar(
                  backgroundColor: primaryIndigo,
                  title: Text("Assignments", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  actions: [_notificationsBadge()],
                ),
      drawer: Container(
        width: getWidth(context) * 0.75,
        height: getHeight(context),
        child: SideDrawer(),
      ),
      body: _buildPage(currentTab),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab,
          selectedItemColor: primaryIndigo,
          unselectedItemColor: Color(0xFF94A3B8),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home),
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.assignment),
              ),
              title: Text('Assignments'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.event_available),
              ),
              title: Text('Leave'),
            ),
          ],
          onTap: (index) {
            Provider.of<Auth>(context, listen: false).setHomePageTabFun(index);
          },
        ),
      ),
    );
  }

  Widget _notificationsBadge() {
    return GestureDetector(
      onTap: _openNotifications,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 12.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.notifications_outlined, size: 28),
            if (_unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Text(
                    _unreadCount > 9 ? '9+' : '$_unreadCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}