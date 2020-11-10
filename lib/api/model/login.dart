class JsonUser {
  String accessToken;

  JsonUser({accessToken}) {
    this.accessToken=accessToken;

  }

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    return JsonUser(
      accessToken: parsedJson['accessToken'],
    );
  }
}