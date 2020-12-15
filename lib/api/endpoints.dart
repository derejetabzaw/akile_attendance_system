class API {
  // static const String BASE_API = "https://akile-attendance-system.herokuapp.com/api/v1/";
  // static const String BASE_API = "http://localhost:8081/api/v1/";

  static const String BASE_API = "http://192.168.0.39:9000/api/v1/";
  static const String LOGIN_API = BASE_API + "auth/login";
  static const String CHECKIN = BASE_API + "users/checkin";
  static const String CHECKOUT = BASE_API + "users/checkout";
}
