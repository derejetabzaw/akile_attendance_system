import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akile_attendance_system/api/endpoints.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Submit a leave request
// ─────────────────────────────────────────────────────────────────────────────
Future<Map<String, dynamic>> submitLeaveRequest({
  String token,
  String leaveType,
  String startDate,
  String endDate,
  String reason,
}) async {
  try {
    final response = await http.post(
      Uri.parse(API.LEAVE_SUBMIT),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'leaveType': leaveType,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'msg': data['msg'] ?? 'Submitted'};
    } else {
      return {'success': false, 'msg': data['msg'] ?? 'Submission failed'};
    }
  } catch (e) {
    return {'success': false, 'msg': 'Network error: $e'};
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Get logged-in employee's own leave requests
// ─────────────────────────────────────────────────────────────────────────────
Future<List<dynamic>> fetchMyLeaves({String token}) async {
  try {
    final response = await http.get(
      Uri.parse(API.LEAVE_MY),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['leaves'] ?? [];
    }
    return [];
  } catch (e) {
    print('fetchMyLeaves error: $e');
    return [];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cancel a pending leave request
// ─────────────────────────────────────────────────────────────────────────────
Future<Map<String, dynamic>> cancelLeaveRequest({
  String token,
  String leaveId,
}) async {
  try {
    final response = await http.delete(
      Uri.parse('${API.LEAVE_CANCEL}$leaveId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'msg': data['msg'] ?? 'Cancelled'};
    } else {
      return {'success': false, 'msg': data['msg'] ?? 'Cannot cancel'};
    }
  } catch (e) {
    return {'success': false, 'msg': 'Network error: $e'};
  }
}
