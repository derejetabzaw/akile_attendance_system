class JsonUser {
  String accessToken;
  String staffId;

  JsonUser({accessToken, staffId}) {
    this.accessToken=accessToken;
    this.staffId=staffId;

  }

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    return JsonUser(
      accessToken: parsedJson['accessToken'],
      staffId: parsedJson['staffId']
    );
  }
}