class JsonUser {
  String accessToken,staffId;

  JsonUser({accessToken, refreshToken,staffId}) {
    this.accessToken=accessToken;
    this.staffId=staffId;

  }

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    return JsonUser(
      accessToken: parsedJson['accessToken'],
      staffId: parsedJson['staffId'],
    );
  }
}