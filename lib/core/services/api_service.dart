import 'package:dio/dio.dart' as dio_pkg;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../Model/TUser.dart';

class ApiService extends GetxService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      // للأندرويد إيمولايتر
      return 'http://10.0.2.2:8000/api';
      // للأجهزة الفعلية، استخدم IP الجهاز المحلي:
    }
  }

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  late dio_pkg.Dio _dio;
  String? _accessToken;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio_pkg.Dio(
      dio_pkg.BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // إضافة interceptors للتعامل مع التوكن والأخطاء
    _dio.interceptors.add(_AuthInterceptor(this));
    _dio.interceptors.add(_LoggingInterceptor());
  }

  // تعيين التوكن
  void setToken(String token) {
    _accessToken = token;
  }

  // إزالة التوكن
  void removeToken() {
    _accessToken = null;
  }

  // طرق HTTP العامة
  Future<dio_pkg.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    dio_pkg.Options? options,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } on dio_pkg.DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio_pkg.Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio_pkg.Options? options,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on dio_pkg.DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio_pkg.Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio_pkg.Options? options,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on dio_pkg.DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio_pkg.Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio_pkg.Options? options,
  }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on dio_pkg.DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dio_pkg.Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio_pkg.Options? options,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on dio_pkg.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // رفع الملفات
  Future<dio_pkg.Response> uploadFile(
    String endpoint,
    String filePath, {
    String? fileName,
    Map<String, dynamic>? data,
    dio_pkg.ProgressCallback? onProgress,
  }) async {
    try {
      final formData = dio_pkg.FormData.fromMap({
        'file': await dio_pkg.MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        if (data != null) ...data,
      });

      return await _dio.post(
        endpoint,
        data: formData,
        options: dio_pkg.Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: onProgress,
      );
    } on dio_pkg.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // === API المصادقة ===
  Future<TUser> login(String userName, String password) async {
    final response = await post(
      '/auth/login',
      data: {
        'user_name': userName,
        'password': password,
      },
    );

    final responseData = response.data['data'];
    final userData = responseData['user'];
    final token = responseData['token'];

    setToken(token);
    return TUser.fromJson(userData);
  }

  Future<void> logout() async {
    try {
      await post('/auth/logout');
    } finally {
      removeToken();
    }
  }

  Future<String> refreshToken() async {
    final response = await post('/auth/refresh');
    final newToken = response.data['access_token'];
    setToken(newToken);
    return newToken;
  }

  Future<TUser> getCurrentUser() async {
    final response = await get('/auth/me');
    return TUser.fromJson(response.data);
  }

  // === API إدارة المستخدمين ===
  Future<List<TUser>> getUsers({
    String? search,
    UserType? userType,
    bool? isActive,
    int? page,
    int? limit,
  }) async {
    final response = await get('/users', queryParameters: {
      if (search != null) 'search': search,
      if (userType != null) 'user_type': userType,
      if (isActive != null) 'is_active': isActive,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    });

    final List usersData = response.data['users'];
    return usersData.map((json) => TUser.fromJson(json)).toList();
  }

  Future<TUser> getUserById(int userId) async {
    final response = await get('/users/$userId');
    return TUser.fromJson(response.data);
  }

  Future<TUser> createUser(TUser user) async {
    final response = await post('/users', data: user.toJson());
    return TUser.fromJson(response.data);
  }

  Future<TUser> updateUser(int userId, TUser user) async {
    final response = await put('/users/$userId', data: user.toJson());
    return TUser.fromJson(response.data);
  }

  Future<void> deleteUser(int userId) async {
    await delete('/users/$userId');
  }

  Future<void> deleteItem(int itemId) async {
    await delete('/items/$itemId');
  }

  Future<void> deleteReport(int reportId) async {
    await delete('/reports/$reportId');
  }

  Future<String> downloadReport(int reportId) async {
    final response = await get('/reports/$reportId/download');
    return response.data['download_url'];
  }

  // === API إحصائيات عامة ===
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await get('/dashboard/stats');
    return response.data;
  }

  Future<Map<String, int>> getComplaintsByType() async {
    final response = await get('/stats/complaints-by-type');
    return Map<String, int>.from(response.data);
  }

  Future<Map<String, int>> getComplaintsByStatus() async {
    final response = await get('/stats/complaints-by-status');
    return Map<String, int>.from(response.data);
  }

  Future<Map<String, int>> getComplaintsByNeighborhood() async {
    final response = await get('/stats/complaints-by-neighborhood');
    return Map<String, int>.from(response.data);
  }

  // معالجة الأخطاء
  ApiException _handleError(dio_pkg.DioException error) {
    if (error.type == dio_pkg.DioExceptionType.connectionTimeout) {
      return ApiException(
        'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت',
        error.response?.statusCode,
      );
    } else if (error.type == dio_pkg.DioExceptionType.receiveTimeout) {
      return ApiException(
        'انتهت مهلة استقبال البيانات',
        error.response?.statusCode,
      );
    } else if (error.type == dio_pkg.DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data?['message'] ?? 'خطأ في الخادم';

      if (statusCode == 401) {
        removeToken();
        return ApiException(
            'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى', 401);
      } else if (statusCode == 403) {
        return ApiException('ليس لديك صلاحية للوصول لهذا المورد', 403);
      } else if (statusCode == 404) {
        return ApiException('المورد المطلوب غير موجود', 404);
      } else if (statusCode == 422) {
        return ApiException('بيانات غير صحيحة', 422, error.response?.data);
      } else if (statusCode != null && statusCode >= 500) {
        return ApiException('خطأ في الخادم. يرجى المحاولة لاحقاً', statusCode);
      }

      return ApiException(message, statusCode);
    } else if (error.type == dio_pkg.DioExceptionType.unknown) {
      return ApiException('لا يوجد اتصال بالإنترنت', null);
    }

    return ApiException('حدث خطأ غير متوقع', null);
  }
}

// Interceptor للمصادقة
class _AuthInterceptor extends dio_pkg.Interceptor {
  final ApiService _apiService;

  _AuthInterceptor(this._apiService);

  @override
  void onRequest(dio_pkg.RequestOptions options,
      dio_pkg.RequestInterceptorHandler handler) {
    if (_apiService._accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${_apiService._accessToken}';
    }
    super.onRequest(options, handler);
  }
}

// Interceptor للسجلات
class _LoggingInterceptor extends dio_pkg.Interceptor {
  @override
  void onRequest(dio_pkg.RequestOptions options,
      dio_pkg.RequestInterceptorHandler handler) {
    print('🌐 REQUEST: ${options.method} ${options.uri}');
    if (options.data != null) {
      print('📤 DATA: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      dio_pkg.Response response, dio_pkg.ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(
      dio_pkg.DioException err, dio_pkg.ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message} ${err.requestOptions.uri}');
    super.onError(err, handler);
  }
}

// استثناء API مخصص
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, this.statusCode, [this.data]);

  @override
  String toString() => message;
}
