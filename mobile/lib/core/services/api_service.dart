import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_response.dart';
import '../models/category_model.dart';
import '../models/provider_model.dart';
import '../models/order_model.dart';
import '../models/review_model.dart';
import '../http/dio_provider.dart';

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  // Setter untuk token
  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    dio.options.headers.remove('Authorization');
  }

  // ===== AUTH ENDPOINTS =====

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await dio.post(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.token != null) {
        setToken(authResponse.token!);
      }
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('/api/auth/logout');
      clearToken();
    } catch (e) {
      rethrow;
    }
  }

  // ===== CATALOG ENDPOINTS =====

  Future<CategoriesResponse> getCategories() async {
    try {
      final response = await dio.get('/api/catalog/categories');
      return CategoriesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProvidersResponse> getProvidersByCategory(int categoryId) async {
    try {
      final response =
          await dio.get('/api/catalog/categories/$categoryId/providers');
      return ProvidersResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProviderProfile> getProviderDetail(int providerId) async {
    try {
      final response = await dio.get('/api/catalog/providers/$providerId');
      return ProviderProfile.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProvidersResponse> searchProviders(String query) async {
    try {
      final response = await dio.get(
        '/api/catalog/providers/search',
        queryParameters: {'q': query},
      );
      return ProvidersResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ===== ORDER ENDPOINTS =====

  Future<OrderData> createOrder(CreateOrderRequest request) async {
    try {
      final response = await dio.post(
        '/api/orders',
        data: request.toJson(),
      );
      return OrderData.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrdersResponse> getMyOrders() async {
    try {
      final response = await dio.get('/api/orders/my-orders');
      return OrdersResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderData> getOrderDetail(int orderId) async {
    try {
      final response = await dio.get('/api/orders/$orderId');
      return OrderData.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> respondToOrder({
    required int orderId,
    required String action,
  }) async {
    try {
      await dio.post(
        '/api/orders/$orderId/respond',
        data: {'action': action},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startWork(int orderId) async {
    try {
      await dio.post('/api/orders/$orderId/start-work');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeOrder({
    required int orderId,
    required int finalPrice,
  }) async {
    try {
      await dio.post(
        '/api/orders/$orderId/complete',
        data: {'final_price': finalPrice},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== PAYMENT ENDPOINTS =====

  /// Generate QRIS for a payment. Returns QRIS payload from backend.
  Future<Map<String, dynamic>> generateQRIS(int paymentId) async {
    try {
      final response =
          await dio.post('/api/payments/$paymentId/generate-qris');
      final data = Map<String, dynamic>.from(response.data['data'] ?? {});
      final checkoutUrl = data['checkout_url'];
      if (checkoutUrl != null) {
        data['checkout_url'] = checkoutUrl.toString();
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// Simulate payment gateway callback (for testing)
  /// In production, payment gateway will call /webhooks/payment
  Future<void> simulatePaymentCallback(int paymentId) async {
    try {
      await dio.post('/webhooks/payment', data: {
        'payment_id': paymentId,
        'transaction_id': 'SIM-$paymentId',
        'status': 'success',
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentData> getPaymentStatus(int paymentId) async {
    try {
      final response = await dio.get('/api/payments/$paymentId');
      return PaymentData.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  // ===== REVIEW ENDPOINTS =====

  Future<void> createReview({
    required int orderId,
    required int rating,
    String? comment,
  }) async {
    try {
      await dio.post(
        '/api/reviews/order/$orderId',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ReviewsResponse> getProviderReviews(int providerId) async {
    try {
      final response =
          await dio.get('/api/reviews/provider/$providerId');
      return ReviewsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ReviewData?> getOrderReview(int orderId) async {
    try {
      final response = await dio.get('/api/reviews/order/$orderId');
      return ReviewData.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } catch (e) {
      return null;
    }
  }

  // ===== ADMIN ENDPOINTS =====

  Future<ProvidersResponse> getPendingProviders() async {
    try {
      final response = await dio.get('/api/admin/providers/pending');
      return ProvidersResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProviderVerification({
    required int providerId,
    required bool isVerified,
  }) async {
    try {
      await dio.patch(
        '/api/admin/providers/$providerId/verification',
        data: {'is_verified': isVerified},
      );
    } catch (e) {
      rethrow;
    }
  }
}

// Riverpod Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio: dio);
});
