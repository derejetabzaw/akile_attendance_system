class API {
  // static const String BASE_API = "https://akile-attendance-system.herokuapp.com/api/v1/";
  // static const String BASE_API = "http://localhost:8081/api/v1/";

  static const String BASE_API = "http://192.168.1.6:9000/api/v1/";

  // static const String BASE_API = "https://hrserver.akillepainting.com/api/v1/";
  static const String LOGIN_API = BASE_API + "auth/login";
  static const String REGISTER_API = BASE_API + "auth/register";
  static const String CHECKIN = BASE_API + "users/checkin";
  static const String CHECKOUT = BASE_API + "users/checkout";
  static const String CHANGE_PASSWORD = BASE_API + "users/change-password";
  static const String CHECKIN_STATUS = BASE_API + "attendance/status/";

  // For attendance summary, append userId: e.g. ATTENDANCE_SUMMARY + userId
  static const String ATTENDANCE_SUMMARY = BASE_API + "attendance/summary/";
}

