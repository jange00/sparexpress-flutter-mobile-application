class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://localhost:3000";

  static const String baseUrl = "$serverAddress/api/";
  static const String imagrUrl = "$serverAddress/uploads/";

  // Auth 
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String uploadImage = "auth/uploadImage";
  static const String getMe="auth/getMe";
  
  // Users 
  static const String createUser = "admin/create";
  static const String getAllUsers = "auth/users/";
  static const String getUsersById = "auth/users/:id";
  static const String updateUsers = "auth/users/:id";
  static const String deleteUsers = "auth/users/:id";

  // Category

  // SubCategory

  // Brands

  // Products ..etc
}