import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/api/leave_api.dart';
import 'package:intl/intl.dart';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  String _leaveType = 'annual';
  DateTime _startDate;
  DateTime _endDate;
  final _reasonController = TextEditingController();

  bool _submitting = false;
  String _submitMsg;
  bool _submitSuccess = false;

  List<dynamic> _myLeaves = [];
  bool _loadingHistory = true;

  static const Color _indigo = Color(0xFF4F46E5);
  static const Color _indigoDark = Color(0xFF3730A3);

  final Map<String, Map<String, dynamic>> _leaveTypes = {
    'annual': {
      'label': 'Annual Leave',
      'color': Color(0xFF4F46E5),
      'icon': Icons.beach_access
    },
    'sick': {
      'label': 'Sick Leave',
      'color': Color(0xFFEF4444),
      'icon': Icons.local_hospital
    },
    'emergency': {
      'label': 'Emergency',
      'color': Color(0xFFF59E0B),
      'icon': Icons.warning   // FIXED
    },
    'unpaid': {
      'label': 'Unpaid Leave',
      'color': Color(0xFF64748B),
      'icon': Icons.money_off
    },
  };

  final Map<String, Map<String, dynamic>> _statusStyle = {
    'pending': {
      'color': Color(0xFFF59E0B),
      'label': 'Pending',
      'icon': Icons.hourglass_empty
    },
    'approved': {
      'color': Color(0xFF10B981),
      'label': 'Approved',
      'icon': Icons.check_circle
    },
    'rejected': {
      'color': Color(0xFFEF4444),
      'label': 'Rejected',
      'icon': Icons.cancel
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  String get _token {
    return Provider.of<Auth>(context, listen: false).getTokenFun();
  }

  Future<void> _loadHistory() async {
    setState(() => _loadingHistory = true);
    final leaves = await fetchMyLeaves(token: _token);
    if (mounted) {
      setState(() {
        _myLeaves = leaves;
        _loadingHistory = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) return;

    if (_startDate == null || _endDate == null) {
      setState(() {
        _submitMsg = "Please select dates";
        _submitSuccess = false;
      });
      return;
    }

    setState(() {
      _submitting = true;
      _submitMsg = null;
    });

    final fmt = DateFormat('yyyy-MM-dd');

    final result = await submitLeaveRequest(
      token: _token,
      leaveType: _leaveType,
      startDate: fmt.format(_startDate),
      endDate: fmt.format(_endDate),
      reason: _reasonController.text.trim(),
    );

    setState(() {
      _submitting = false;
      _submitMsg = result['msg'];
      _submitSuccess = result['success'] == true;
    });

    if (_submitSuccess) {
      _reasonController.clear();
      _startDate = null;
      _endDate = null;
      _leaveType = 'annual';
      _loadHistory();

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) setState(() => _submitMsg = null);
      });
    }
  }

  Future<void> _cancel(String leaveId) async {
    final result = await cancelLeaveRequest(
      token: _token,
      leaveId: leaveId,
    );

    // FIXED: Flutter 1.22 uses Scaffold.of
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(result['msg'] ?? 'Done'),
        backgroundColor:
            result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) _loadHistory();
  }

  Future<void> _pickDate({bool isStart = true}) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;

    setState(() {
      if (isStart)
        _startDate = picked;
      else
        _endDate = picked;
    });
  }

  int get _numberOfDays {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate.difference(_startDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: _indigo,
        title: Text("Leave Management"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "New Request"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForm(),
          _buildHistory(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
          if (_submitMsg != null)
            Container(
              padding: EdgeInsets.all(12),
              color: _submitSuccess ? Colors.green[50] : Colors.red[50],
              child: Text(_submitMsg ?? ""),
            ),

          TextFormField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(labelText: "Reason"),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  child: Text(_startDate == null ? "Start" : DateFormat('MMM d, yyyy').format(_startDate)),
                  onPressed: () => _pickDate(isStart: true),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RaisedButton(
                  child: Text(_endDate == null ? "End" : DateFormat('MMM d, yyyy').format(_endDate)),
                  onPressed: () => _pickDate(isStart: false),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          RaisedButton(
            color: _indigo,
            textColor: Colors.white,
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text("Submit"),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHistory() {
    if (_loadingHistory)
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_indigo),
        ),
      );

    return ListView.builder(
      itemCount: _myLeaves.length,
      itemBuilder: (ctx, i) {
        final leave = _myLeaves[i];
        final status = leave['status'] ?? 'pending';
        final style = _statusStyle[status] ?? _statusStyle['pending'];
        
        final hasNote = leave['adminNote'] != null && leave['adminNote'].toString().trim().isNotEmpty;
        
        return ListTile(
          title: Text(leave['reason'] ?? ''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${leave['startDate']} → ${leave['endDate']}"),
              if (hasNote)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Note: ${leave['adminNote']}",
                    style: TextStyle(
                      color: status == 'rejected' ? Colors.red[700] : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
          trailing: Chip(
            label: Text(style['label'], style: TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: style['color'],
          ),
        );
      },
    );
  }
}