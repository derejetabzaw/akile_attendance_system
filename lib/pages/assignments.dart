import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/api/assignments_api.dart';

class Assignments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AssignmentsPage();
  }
}

class AssignmentsPage extends StatefulWidget {
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  List<dynamic> _assignments = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAssignments());
  }

  Future<void> _loadAssignments() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = ''; });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final token = auth.getTokenFun();
      if (token == null) {
        setState(() { _loading = false; _error = 'Not logged in.'; });
        return;
      }
      final data = await fetchMyAssignments(token: token);
      if (mounted) {
        setState(() { 
          _assignments = data; 
          _loading = false; 
          if (_assignments.isEmpty) {
             print("No assignments found for user");
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load assignments: $e'; });
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':    return Colors.green;
      case 'completed': return Colors.grey;
      default:          return Colors.orange;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'shift':    return Colors.blue;
      case 'schedule': return Colors.indigo;
      case 'task':     return Colors.cyan;
      default:         return Colors.red;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'shift':    return Icons.access_time;
      case 'schedule': return Icons.calendar_today;
      case 'task':     return Icons.check_circle;
      default:         return Icons.location_on;
    }
  }

  Widget _buildCard(Map<String, dynamic> a) {
    final String type     = a['type'] ?? 'task';
    final String status   = a['status'] ?? 'pending';
    final String title    = a['title'] ?? 'Untitled';
    final String site     = a['site'] ?? '';
    final String start    = a['shiftStart'] ?? '';
    final String end      = a['shiftEnd'] ?? '';
    final String date     = a['scheduledDate'] ?? '';
    final double hours    = (a['workingHours'] ?? 0).toDouble();

    final Color tColor = _typeColor(type);
    final Color sColor = _statusColor(status);

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_typeIcon(type), color: tColor),
                    SizedBox(width: 10),
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: sColor, borderRadius: BorderRadius.circular(12)),
                  child: Text(status.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Divider(height: 20),
            if (site.isNotEmpty)
              _infoRow(Icons.location_on, "Site: $site"),
            if (date.isNotEmpty)
              _infoRow(Icons.calendar_today, "Date: $date"),
            if (start.isNotEmpty && end.isNotEmpty)
              _infoRow(Icons.access_time, "Shift: $start - $end"),
            if (hours > 0)
              _infoRow(Icons.timer, "Hours: ${hours.toStringAsFixed(1)}h"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Distinct background
      appBar: AppBar(
        title: Text("My Assignments"),
        backgroundColor: Color(0xFF4f46e5),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadAssignments),
        ],
      ),
      body: _loading 
        ? Center(child: CircularProgressIndicator())
        : _error.isNotEmpty
          ? Center(child: Text(_error, style: TextStyle(color: Colors.red)))
          : _assignments.isEmpty
            ? Center(child: Text("No assignments found"))
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: _assignments.length,
                itemBuilder: (context, index) => _buildCard(Map<String, dynamic>.from(_assignments[index])),
              ),
    );
  }
}
