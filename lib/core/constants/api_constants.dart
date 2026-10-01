class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';
  
  // Endpoints
  static const String products = '/products';
  static const String searchProducts = '/products/search';
  static const String groceriesCategory = '/products/category/groceries';
  static const String singleProduct = '/products'; // /products/{id}
  static const String userProfile = '/users/1'; // Emily Johnson (Loyalty VIP)
  
  // Networking Config
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int maxRetryAttempts = 3;
  static const Duration retryInitialDelay = Duration(milliseconds: 500);
}
