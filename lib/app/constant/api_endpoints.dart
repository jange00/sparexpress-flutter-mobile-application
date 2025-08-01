class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // static const String serverAddress = "http://localhost:3000";
  // static const String serverAddress = "http://10.0.2.2:3000";
  static const String serverAddress = "http://192.168.1.73:3000";

  static const String baseUrl = "$serverAddress/api/";
  static const String imagrUrl = "$serverAddress/uploads/";

  // Auth 
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String uploadImage = "auth/uploadImage";
  static const String getMe="auth/getMe";
  static const String changePassword = "auth/change-password";
  static const String requestResetPassword = "auth/request-reset";
  static const String resetPassword = "auth/reset-password";
  // static const String getMe="admin/users/getMe";
  
  // Users 
  static const String createUser = "admin/create";
  static const String getAllUsers = "auth/users/";
  static const String getUsersById = "auth/users/:id";
  static const String updateUsers = "auth/users/:id";
  static const String deleteUsers = "auth/users/:id";

  // Products
  static const String getAllProducts = "admin/products";
  static const String getProductsById = "admin/products/:id";

  // Category
  static const String getAllCategory = "admin/categories";
  static const String getAllCategoryById = "admin/categories/:id";

  // Cart
 static const String createCart = "cart/";
 static const String getCartByUser = "cart/user"; 
//  static const String deleteCart = "cart/item/:cartItemId";
 static const String deleteCart = "cart/item/:cartItemId"; 
 static const String clearCartByUser = "cart/clear/:userId";

  // Shipping address
  static const String getShippingAddressesByUserId = "shipping-address/users/:userId";
  static const String createShippingAddress = "shipping-address/";
  static const String deleteShippingAddress = "shipping-address/:id";

  // Order
  static const String getOrderByUserId = "orders/users/:userId";
  static const String createOrder = "/orders/";
  static const String deleteOrder = "orders/:id";

  // Payments
  static const String getPaymentByUserId = "payments/users/:userId";
  static const String createPayment = "payments/";
  static const String deletePayment = "payments/:id";

}