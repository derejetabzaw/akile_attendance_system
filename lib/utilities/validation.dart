// Validate any string field including staffId
validateStringField(String value) {
  if (value.isEmpty||value==null) {
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

