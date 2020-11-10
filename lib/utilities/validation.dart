// Validate any string field including staffId
validateStringField(String value) {
  if (value.isEmpty||value==null) {
    return "This field is required! ";
  }
  // This is just a regular expression for email addresses
  String p = "[a-zA-Z]{1,256}";
  RegExp regExp = new RegExp(p);

  if (regExp.hasMatch(value)) {
    return "";
  }
  return 'Value is not valid';
}

// Validate login password
validatePassword(String value) {
  if (value.isEmpty) {
    return "Enter Password field";
  }
  return "";
}

