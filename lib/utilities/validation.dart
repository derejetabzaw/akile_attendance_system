// Validate any string field including staffId
validateStringField(String value) {
  if (value == null || value.isEmpty) {
    return "This field is required! ";
  }
  return "";
}

// Validate login password
validatePassword(String value) {
  if (value.isEmpty) {
    return "Enter Password field";
  }
  return "";
}

// Validate email address format
String validateEmail(String value) {
  if (value == null || value.trim().isEmpty) {
    return "Email is required";
  }
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return "Enter a valid email address";
  }
  return "";
}
