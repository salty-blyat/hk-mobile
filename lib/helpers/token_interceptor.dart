import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/const.dart';

class DioClient {
  final Dio dio = Dio();
  final AuthService authService = AuthService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final AuthController authController = Get.put(AuthController());
  final String baseUrl = '${AppSetting.setting['BASE_API_URL']}';

  DioClient() {
    // Adding token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _getAccessToken();

        // If token exists, add it to the Authorization header
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          options.headers['Tenant-Code'] = AppSetting.setting['TENANT_CODE'];
          options.headers['App-Code'] = AppSetting.setting['APP_CODE'];
          options.headers['Content-Type'] = 'application/json';
        }

        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Attempt to refresh the token
          bool isRefreshed = await _refreshAuthToken();

          if (isRefreshed) {
            // Retry the original request with the new token
            final options = e.requestOptions;

            // Clone the request options and update headers
            final newOptions = Options(
              method: options.method,
              headers: {
                ...options.headers,
                'Authorization': 'Bearer ${await _getAccessToken()}',
              },
            );

            try {
              // Retry the request
              final response = await dio.request(
                options.path,
                options: newOptions,
                data: options.data,
                queryParameters: options.queryParameters,
              );
              return handler
                  .resolve(response); // Return the successful response
            } on DioException catch (e) {
              return handler.reject(e); //
            }
          } else {
            // Navigate to login page if token refresh fails
            authController.handleLogoutError();
          }
        } else {
          if (Get.isDialogOpen == true) Get.back();
          Modal.errorDialog('Unsuccessful', _getResponseMessage(e));
        }

        // Pass the error to the next handler if not handled
        return handler.next(e);
      },
    ));
  }

  // Fetch the access token from secure storage
  Future<String?> _getAccessToken() async {
    return await secureStorage.read(key: Const.authorized['AccessToken']!);
  }

  // Fetch the refresh token from secure storage
  Future<String?> _getRefreshToken() async {
    return await secureStorage.read(key: Const.authorized['RefreshToken']!);
  }

  // Function to refresh the access token
  Future<bool> _refreshAuthToken() async {
    try {
      String? refreshToken = await _getRefreshToken();
      String? token = await _getAccessToken();
      if (refreshToken == null) {
        return false;
      }
      // Perform the token refresh API request
      Response response = await dio.post(
        '${AppSetting.setting['AUTH_API_URL']}/auth/refresh/mobile', // Your refresh token endpoint
        data: {
          'refreshToken': refreshToken,
          'accessToken': token,
          'permission': []
        },
      );

      if (response.statusCode == 200) {
        // Save the new access token
        String newAccessToken = response.data['accessToken'];
        await secureStorage.write(
            key: Const.authorized['AccessToken']!, value: newAccessToken);
        return true;
      } else {
        return false;
      }
    } on DioException {
      // Modal.errorDialog('Error', _getResponseMessage(e));
      return false;
    }
  }

  // Example method to make GET requests
  Future<Response?> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response =
          await dio.get('$baseUrl/$url', queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Example method to make POST requests
  Future<Response?> post(String url, {Map<String, dynamic>? data}) async {
    try {
      Response response = await dio.post('$baseUrl/$url', data: data);
      return response;
    } on DioException {
      return null;
    }
  }

  Future<Response?> getCustom(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(url, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response?> postCustom(String url, {Map<String, dynamic>? data}) async {
    try {
      Response response = await dio.post(url, data: data);
      return response;
    } on DioException {
      return null;
    }
  }

  // Example method to make PUT requests
  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    try {
      Response response = await dio.put('$baseUrl/$url', data: data);
      return response;
    } on DioException {
      // Modal.errorDialog('Error', _getResponseMessage(e));
      rethrow;
    }
  }

  // Example method to make DELETE requests
  Future<Response?> delete(String url, Map<String, dynamic>? data) async {
    try {
      Response response = await dio.delete('$baseUrl/$url',
          data: data,
          options: Options(
            headers: {
              'disableErrorNotification': 'yes',
            },
          ));
      return response;
    } on DioException {
      // Modal.errorDialog('Error', _getResponseMessage(e));
      return null;
    }
  }

  String _getResponseMessage(DioException e) {
    if (e.response?.data['args'] != null) {
      String messageTemplate = e.response!.data['message'].toString().tr;
      Map<String, dynamic> args = e.response!.data['args'];

      args.forEach((key, value) {
        String placeholder = '{{$key}}';
        messageTemplate =
            messageTemplate.replaceAll(placeholder, value.toString());
      });
      return messageTemplate;
    }
    return e.response?.data['message'].toString().tr ?? '';
  }
}
