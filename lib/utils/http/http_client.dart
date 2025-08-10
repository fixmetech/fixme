import 'dart:convert';
import 'package:http/http.dart' as http;

class FixMeHttpHelper {
  FixMeHttpHelper._(); 
  static const String _baseUrl = 'http://10.0.2.2:3000/'; // Replace with your API base URL
  static const int _timeoutDuration = 30; // Timeout in seconds
  
  // Default headers
  static Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Helper method to handle HTTP responses
static Map<String, dynamic> _handleResponse(http.Response response) {
  try {
    // Check if the response status code indicates success
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Try to decode the JSON response
      if (response.body.isNotEmpty) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return {'success': true, 'message': 'Request completed successfully'};
      }
    } else {
      // Handle error responses
      String errorMessage = 'Request failed with status: ${response.statusCode}';
      
      // Try to get error details from response body
      if (response.body.isNotEmpty) {
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map<String, dynamic> && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          // If JSON parsing fails, use the raw response body
          errorMessage = response.body;
        }
      }
      
      throw Exception(errorMessage);
    }
  } catch (e) {
    if (e is Exception) {
      rethrow;
    }
    throw Exception('Failed to process response: ${e.toString()}');
  }
}

  // ============ GET REQUEST ============
  
  /// Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      // Clean the endpoint to avoid double slashes
      String cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
      String url = _baseUrl.endsWith('/') ? '$_baseUrl$cleanEndpoint' : '$_baseUrl/$cleanEndpoint';
      
      print('Making GET request to: $url');
      
      final response = await http
          .get(Uri.parse(url), headers: _defaultHeaders)
          .timeout(Duration(seconds: _timeoutDuration));
          
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('GET request error: $e');
      throw Exception('GET request failed: ${e.toString()}');
    }
  }

  /// GET request with query parameters
  static Future<Map<String, dynamic>> getWithParams(
    String endpoint,
    Map<String, dynamic> queryParams,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint').replace(
        queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())),
      );
      final response = await http
          .get(uri, headers: _defaultHeaders)
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request with params failed: ${e.toString()}');
    }
  }

  // ============ POST REQUEST ============
  
  /// Helper method to make a POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: _defaultHeaders,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: ${e.toString()}');
    }
  }

  /// POST request with custom headers
  static Future<Map<String, dynamic>> postWithHeaders(
    String endpoint,
    dynamic data,
    Map<String, String> customHeaders,
  ) async {
    try {
      final headers = {..._defaultHeaders, ...customHeaders};
      final response = await http
          .post(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request with headers failed: ${e.toString()}');
    }
  }

  /// POST multipart request (for file uploads)
  static Future<Map<String, dynamic>> postMultipart(
    String endpoint,
    Map<String, String> fields, {
    List<http.MultipartFile>? files,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final request = http.MultipartRequest('POST', uri);
      
      // Add fields
      request.fields.addAll(fields);
      
      // Add files if provided
      if (files != null) {
        request.files.addAll(files);
      }
      
      // Add headers
      request.headers.addAll(_defaultHeaders);
      
      final streamedResponse = await request.send().timeout(Duration(seconds: _timeoutDuration));
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST multipart request failed: ${e.toString()}');
    }
  }

  // ============ PUT REQUEST ============
  
  /// Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: _defaultHeaders,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: ${e.toString()}');
    }
  }

  /// PUT request with custom headers
  static Future<Map<String, dynamic>> putWithHeaders(
    String endpoint,
    dynamic data,
    Map<String, String> customHeaders,
  ) async {
    try {
      final headers = {..._defaultHeaders, ...customHeaders};
      final response = await http
          .put(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request with headers failed: ${e.toString()}');
    }
  }

  // ============ DELETE REQUEST ============
  
  /// Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl$endpoint'), headers: _defaultHeaders)
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: ${e.toString()}');
    }
  }

  /// DELETE request with body
  static Future<Map<String, dynamic>> deleteWithBody(String endpoint, dynamic data) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: _defaultHeaders,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request with body failed: ${e.toString()}');
    }
  }
}