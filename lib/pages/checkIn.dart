import 'package:akile_attendance_system/utilities/abstract_classes/confirmation_abstract.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/dialog/confirmationDialog.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/api/auth.dart';
import 'package:akile_attendance_system/pages/dialog/infoDialog.dart';
import 'package:device_id/device_id.dart';
import 'package:geolocator/geolocator.dart';

class CheckIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: CheckInPage()
    );
  }
}

class CheckInPage extends StatefulWidget {
  CheckInPage({Key key}) : super(key: key);

  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> implements ShouldImp {
  bool showError = false;
  var _isIPressed = true;
  var _isOPressed = true;
  String _workHours = "0.0";
  String _ot1 = "0.0";
  String _ot2 = "0.0";
  int _recordCount = 0;
  String _status = "checkedOut";

  @override
  void initState() {
    super.initState();
    _fetchWorkedHours();
    _fetchAttendanceStatus();
  }

  void _fetchAttendanceStatus() async {
    try {
      String token = Provider.of<Auth>(context, listen: false).getTokenFun();
      String userId = Provider.of<Auth>(context, listen: false).getId();
      if (token != null && userId != null && userId.isNotEmpty) {
        var statusData = await getAttendanceStatusApi(token: token, userId: userId);
        if (mounted) {
          setState(() {
            _status = statusData['status'] ?? "checkedOut";
            _recordCount = statusData['recordCount'] ?? 0;
            
            if (_status == 'checkedIn') {
              _isIPressed = false;
              _isOPressed = true;
            } else {
              _isIPressed = true;
              _isOPressed = false;
              if (_recordCount >= 3) {
                 _isIPressed = false;
              }
            }
          });
        }
      }
    } catch (e) {
      print("Error fetching attendance status: $e");
    }
  }

  void _fetchWorkedHours() async {
    try {
      String token = Provider.of<Auth>(context, listen: false).getTokenFun();
      String userId = Provider.of<Auth>(context, listen: false).getId();
      if (token != null && userId != null && userId.isNotEmpty) {
        var summary = await getWorkedHoursApi(token: token, userId: userId);
        if (mounted) {
          setState(() {
            _workHours = (summary['todayWorkHours'] ?? summary['totalWorkHours'] ?? 0.0).toDouble().toStringAsFixed(1);
            _ot1 = (summary['totalOT1'] ?? 0.0).toDouble().toStringAsFixed(1);
            _ot2 = (summary['totalOT2'] ?? 0.0).toDouble().toStringAsFixed(1);
          });
        }
      }
    } catch (e) {
      print("Error fetching worked hours: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckInCounter(),
                SizedBox(height: 24),
                _buildActionButtons(),
                SizedBox(height: 30),
                _buildDetailsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(color: Color(0x334F46E5), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 60, 24, 40),
      child: Column(
        children: [
          Text(
            "Today's Work Duration",
            style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Text(
            "$_workHours h",
            style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold, letterSpacing: -1),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _status == 'checkedIn' ? Icons.fiber_manual_record : Icons.pause_circle_filled,
                  color: _status == 'checkedIn' ? Color(0xFF34D399) : Colors.white70,
                  size: 14,
                ),
                SizedBox(width: 6),
                Text(
                  _status == 'checkedIn' ? "Active Session" : "Paused",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInCounter() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Check-ins Today", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16)),
              Text("$_recordCount / 3", style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _recordCount / 3,
              backgroundColor: Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _recordCount >= 3 ? "Daily limit reached" : "You have ${3 - _recordCount} sessions left",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: "Check In",
            icon: Icons.input, // Compatible icon
            color: Color(0xFF4F46E5),
            isActive: _isIPressed,
            onTap: () => _submitCheckIn(),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _actionButton(
            label: "Check Out",
            icon: Icons.exit_to_app, // Compatible icon
            color: Color(0xFFEF4444),
            isActive: _isOPressed,
            onTap: () {
              ConfirmationDialog(
                context: context,
                title: "Ready to checkout?",
                callback: this,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton({String label, IconData icon, Color color, bool isActive, VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: isActive ? 1.0 : 0.4,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isActive ? color.withOpacity(0.2) : Colors.transparent, width: 2),
              boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))] : [],
            ),
            child: Column(
              children: [
                Icon(icon, color: isActive ? color : Colors.grey, size: 32),
                SizedBox(height: 8),
                Text(label, style: TextStyle(color: isActive ? color : Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("OT 1", _ot1, Colors.orangeAccent),
          Container(width: 1, height: 40, color: Colors.white10),
          _statItem("OT 2", _ot2, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 12)),
        SizedBox(height: 4),
        Text("$value h", style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _submitCheckIn() async {
    String deviceId = await DeviceId.getID;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String token = Provider.of<Auth>(context, listen: false).getTokenFun();
    Provider.of<Auth>(context, listen: false).setLoadingStateFun(true);

    var result = await checkInApi(deviceId: deviceId, position: position, token: token, context: context);
    Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);
    
    if (result == true) {
      _fetchWorkedHours();
      _fetchAttendanceStatus();
      InfoDialog(context: context, callback: this, title: "Success! Clocked in.", type: Constant.success);
    }
  }

  void _submitCheckOut() async {
    String token = Provider.of<Auth>(context, listen: false).getTokenFun();
    Provider.of<Auth>(context, listen: false).setLoadingStateFun(true);
    String deviceId = await DeviceId.getID;

    var result = await checkOutApi(deviceId: deviceId, token: token, context: context);
    Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);

    if (result == true) {
      _fetchWorkedHours();
      _fetchAttendanceStatus();
      InfoDialog(context: context, callback: this, title: "Success! Clocked out.", type: Constant.success);
    }
  }

  @override
  void changer({context, id}) {
    _submitCheckOut();
  }
}