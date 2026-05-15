class JsonUser {
  String accessToken;
  String staffId;
  String userId;

  JsonUser({accessToken, staffId, userId}) {
    this.accessToken = accessToken;
    this.staffId = staffId;
    this.userId = userId;
  }

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    return JsonUser(
      accessToken: parsedJson['accessToken'],
      staffId: parsedJson['staffId'],
      userId: parsedJson['userId']?.toString() ?? '',
    );
  }
}