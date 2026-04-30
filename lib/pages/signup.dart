import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:akile_attendance_system/api/auth.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/logo/logo.dart';
import 'package:akile_attendance_system/pages/widgets/clip_shape.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/utilities/validation.dart';
import 'package:provider/provider.dart';
import 'package:device_id/device_id.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // ── Controllers ─────────────────────────────────────────────
  final TextEditingController _firstNameController  = TextEditingController();
  final TextEditingController _lastNameController   = TextEditingController();
  final TextEditingController _phoneController      = TextEditingController();
  final TextEditingController _emailController      = TextEditingController();
  final TextEditingController _ageController        = TextEditingController();
  final TextEditingController _passwordController   = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // ── State ────────────────────────────────────────────────────
  String _selectedGender = '';
  String _deviceId       = '';
  bool   _isLoading      = false;
  bool   _showErrors     = false;
  bool   _obscurePassword = true;

  // ── Field-level errors ───────────────────────────────────────
  String _firstNameError = '';
  String _lastNameError  = '';
  String _phoneError     = '';
  String _emailError     = '';
  String _ageError       = '';
  String _genderError    = '';
  String _passwordError  = '';
  String _confirmPasswordError = '';
  String _serverError    = '';

  // ── Gender options ───────────────────────────────────────────
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchDeviceId();
  }

  // ── Device ID ────────────────────────────────────────────────
  Future _fetchDeviceId() async {
    try {
      final id = await DeviceId.getID;
      setState(() => _deviceId = id ?? '');
    } catch (_) {
      setState(() => _deviceId = '');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Validation ───────────────────────────────────────────────
  bool _validate() {
    setState(() {
      _firstNameError = validateStringField(_firstNameController.text);
      _lastNameError  = validateStringField(_lastNameController.text);
      _phoneError     = validateStringField(_phoneController.text);
      _emailError     = validateEmail(_emailController.text);
      _ageError       = _ageController.text.trim().isEmpty ? 'Age is required' : '';
      _genderError    = _selectedGender.isEmpty ? 'Please select a gender' : '';
      
      // Password validation
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'At least 6 characters';
      } else {
        _passwordError = '';
      }

      // Confirm Password validation
      if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = '';
      }
      
      _serverError    = '';
    });

    return _firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _phoneError.isEmpty &&
        _emailError.isEmpty &&
        _ageError.isEmpty &&
        _genderError.isEmpty &&
        _passwordError.isEmpty &&
        _confirmPasswordError.isEmpty;
  }

  // ── Submit ───────────────────────────────────────────────────
  Future _submitForm() async {
    setState(() => _showErrors = true);
    if (!_validate()) return;

    if (_deviceId.isEmpty) {
      setState(() => _serverError = 'Device ID not detected.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final staffId = await registerApi(
        firstName: _firstNameController.text.trim(),
        lastName:  _lastNameController.text.trim(),
        email:     _emailController.text.trim(),
        phone:     _phoneController.text.trim(),
        age:       int.tryParse(_ageController.text.trim()) ?? 0,
        gender:    _selectedGender,
        deviceId:  _deviceId,
        password:  _passwordController.text,
      );

      setState(() => _isLoading = false);
      _showSuccessDialog(staffId);
    } catch (e) {
      setState(() {
        _isLoading   = false;
        _serverError = e.toString();
      });
    }
  }

  // ── Success dialog ───────────────────────────────────────────
  void _showSuccessDialog(String staffId) {
    // Legacy auto-redirect
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Constant.SIGN_IN);
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: PRIMARY_COLOR, size: 56),
            SizedBox(height: 8),
            Text('Success!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'APPROVAL PENDING',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: PRIMARY_COLOR),
            ),
            SizedBox(height: 10),
            Text('Note your Staff ID:', style: TextStyle(fontSize: 13, color: Colors.grey)),
            SizedBox(height: 8),
            SelectableText(staffId, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: PRIMARY_COLOR)),
            SizedBox(height: 12),
            Text(
              'You will be notified by email upon approval. Returning to login in 5s...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Go to Login', style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pushReplacementNamed(Constant.SIGN_IN),
          ),
        ],
      ),
    );
  }

  // ── Input field helper ────────────────────────────────────────
  Widget _buildField({
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
    TextInputType keyboardType,
    String errorText,
    List<TextInputFormatter> inputFormatters,
    int maxLength,
    bool obscureText = false,
    Widget suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 8,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters ?? [],
            maxLength: maxLength,
            obscureText: obscureText,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: Icon(icon, color: PRIMARY_COLOR, size: 18),
              labelText: label,
              hintText: hint,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
        if (_showErrors && errorText != null && errorText.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 15, top: 4),
            child: Text(errorText, style: TextStyle(color: Colors.red, fontSize: 11)),
          ),
        SizedBox(height: 12),
      ],
    );
  }

  // ── Body ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<AppState>(context).getTheme() == Constant.lightTheme ? clipShape(context) : SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  logo(context),
                  SizedBox(height: 20),
                  Text('Registration', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 25),
                  
                  _buildField(label: 'First Name', icon: Icons.person_outline, controller: _firstNameController, errorText: _firstNameError),
                  _buildField(label: 'Last Name', icon: Icons.person, controller: _lastNameController, errorText: _lastNameError),
                  _buildField(label: 'Phone Number', icon: Icons.phone_android, controller: _phoneController, keyboardType: TextInputType.phone, errorText: _phoneError),
                  _buildField(label: 'Email', icon: Icons.alternate_email, controller: _emailController, keyboardType: TextInputType.emailAddress, errorText: _emailError),
                  _buildField(label: 'Age', icon: Icons.cake, controller: _ageController, keyboardType: TextInputType.number, errorText: _ageError),
                  
                  _buildField(
                    label: 'Password', 
                    icon: Icons.lock_outline, 
                    controller: _passwordController, 
                    errorText: _passwordError,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  
                  _buildField(
                    label: 'Confirm Password', 
                    icon: Icons.lock, 
                    controller: _confirmPasswordController, 
                    errorText: _confirmPasswordError,
                    obscureText: _obscurePassword,
                  ),

                  // Gender selector
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _genders.map((g) {
                        final selected = _selectedGender == g;
                        return ChoiceChip(
                          label: Text(g, style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 12)),
                          selected: selected,
                          selectedColor: PRIMARY_COLOR,
                          onSelected: (val) => setState(() => _selectedGender = g),
                        );
                      }).toList(),
                    ),
                  ),

                  if (_serverError.isNotEmpty) Text(_serverError, style: TextStyle(color: Colors.red, fontSize: 13)),
                  
                  SizedBox(height: 20),
                  
                  // Legacy RaisedButton
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: _isLoading 
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white))) 
                        : Text('REGISTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      color: PRIMARY_COLOR,
                      elevation: 8,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      onPressed: _isLoading ? null : _submitForm,
                    ),
                  ),

                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacementNamed(Constant.SIGN_IN),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        children: [TextSpan(text: 'Sign In', style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold))],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
