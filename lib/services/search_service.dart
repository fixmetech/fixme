import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SearchService {
  // Use the same base URL structure as complaint service
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  // Alternative URLs to try if the primary fails
  static List<String> get alternativeUrls => [
    'http://localhost:3000/api',
    'http://127.0.0.1:3000/api',
    'http://10.0.2.2:3000/api',
  ];

  // Get the working base URL
  static Future<String?> getWorkingBaseUrl() async {
    for (String url in [baseUrl, ...alternativeUrls]) {
      try {
        final response = await http.get(
          Uri.parse('$url/search/categories'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 5));
        
        if (response.statusCode == 200) {
          return url;
        }
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  // Search technicians with filters
  static Future<Map<String, dynamic>> searchTechnicians({
    String? query,
    String? category,
    Map<String, dynamic>? filters,
    String? location,
    int page = 1,
    int limit = 10,
    String sort = 'rating',
  }) async {
    try {
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server. Please check if the server is running.',
        };
      }

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'sort': sort,
      };

      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      // Add filters to query params
      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            queryParams['filters[$key]'] = value.toString();
          }
        });
      }

      final uri = Uri.parse('$workingBaseUrl/search/technicians').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
          'total': responseData['total'],
          'page': responseData['page'],
          'totalPages': responseData['totalPages'],
          'filters': responseData['filters'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to search technicians',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Search service centers with filters
  static Future<Map<String, dynamic>> searchServiceCenters({
    String? query,
    String? category,
    Map<String, dynamic>? filters,
    String? location,
    int page = 1,
    int limit = 10,
    String sort = 'rating',
  }) async {
    try {
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server. Please check if the server is running.',
        };
      }

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'sort': sort,
      };

      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      // Add filters to query params
      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            queryParams['filters[$key]'] = value.toString();
          }
        });
      }

      final uri = Uri.parse('$workingBaseUrl/search/service-centers').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
          'total': responseData['total'],
          'page': responseData['page'],
          'totalPages': responseData['totalPages'],
          'filters': responseData['filters'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to search service centers',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get service categories
  static Future<Map<String, dynamic>> getServiceCategories({
    String type = 'technician',
  }) async {
    try {
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server.',
        };
      }

      final uri = Uri.parse('$workingBaseUrl/search/categories').replace(
        queryParameters: {'type': type},
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch categories',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get featured results
  static Future<Map<String, dynamic>> getFeaturedResults({
    String type = 'technician',
    String section = 'featured',
  }) async {
    try {
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server.',
        };
      }

      final uri = Uri.parse('$workingBaseUrl/search/featured').replace(
        queryParameters: {
          'type': type,
          'section': section,
        },
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'section': responseData['section'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch featured results',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get search suggestions
  static Future<Map<String, dynamic>> getSearchSuggestions({
    required String query,
    String type = 'technician',
  }) async {
    try {
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server.',
        };
      }

      final uri = Uri.parse('$workingBaseUrl/search/suggestions').replace(
        queryParameters: {
          'query': query,
          'type': type,
        },
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch suggestions',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Test connection to search service
  static Future<bool> testConnection() async {
    try {
      final workingBaseUrl = await getWorkingBaseUrl();
      return workingBaseUrl != null;
    } catch (e) {
      return false;
    }
  }
}