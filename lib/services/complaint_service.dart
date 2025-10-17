import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../models/complaint_model.dart';

class ComplaintService {
  // Use different URLs based on platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      // For Android emulator, use 10.0.2.2 to access host machine
      return 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      // For iOS simulator, localhost works
      return 'http://localhost:3000/api';
    } else {
      // For web or other platforms
      return 'http://localhost:3000/api';
    }
  }

  // Alternative URLs to try if the primary fails
  static List<String> get alternativeUrls => [
    'http://localhost:3000/api',
    'http://127.0.0.1:3000/api',
    'http://10.0.2.2:3000/api',
    // Add your computer's local IP here if needed
    // 'http://192.168.1.XXX:3000/api',
  ];

  // Test connection to server
  static Future<bool> testConnection() async {
    for (String url in [baseUrl, ...alternativeUrls]) {
      try {
        final response = await http.get(
          Uri.parse('$url/complaints/stats'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 5));
        
        if (response.statusCode == 200) {
          return true;
        }
      } catch (e) {
        continue;
      }
    }
    return false;
  }

  // Get the working base URL
  static Future<String?> getWorkingBaseUrl() async {
    for (String url in [baseUrl, ...alternativeUrls]) {
      try {
        final response = await http.get(
          Uri.parse('$url/complaints/stats'),
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
  
  // Create a new complaint with evidence (combined)
  static Future<Map<String, dynamic>> createComplaintWithEvidence(
    ComplaintModel complaint, 
    List<File> evidenceFiles
  ) async {
    try {
      // Get working base URL
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server. Please check if the server is running and try again.',
        };
      }

      final url = Uri.parse('$workingBaseUrl/complaints/with-evidence');
      final request = http.MultipartRequest('POST', url);

      // Add complaint data as JSON field
      request.fields['complaintData'] = json.encode(complaint.toJson());

      // Add evidence files if any
      for (int i = 0; i < evidenceFiles.length; i++) {
        File file = evidenceFiles[i];
        final filename = path.basename(file.path);
        
        final multipartFile = await http.MultipartFile.fromPath(
          'evidence',
          file.path,
          filename: filename,
        );
        request.files.add(multipartFile);
      }

      final response = await request.send().timeout(Duration(seconds: 60));
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'complaintId': responseData['data']['complaintId'],
          'message': responseData['message'],
          'evidenceCount': responseData['data']['evidenceCount'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create complaint',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}. Please check your internet connection and server status.',
      };
    }
  }

  // Create a new complaint (without evidence - kept for backward compatibility)
  static Future<Map<String, dynamic>> createComplaint(ComplaintModel complaint) async {
    try {
      // Get working base URL
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server. Please check if the server is running and try again.',
        };
      }

      final url = Uri.parse('$workingBaseUrl/complaints');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(complaint.toJson()),
      ).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'complaintId': responseData['data']['complaintId'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create complaint',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}. Please check your internet connection and server status.',
      };
    }
  }

  // Upload evidence files
  static Future<Map<String, dynamic>> uploadEvidence(String complaintId, List<File> files) async {
    try {
      // Get working base URL
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server for file upload.',
        };
      }

      final url = Uri.parse('$workingBaseUrl/complaints/$complaintId/evidence');
      final request = http.MultipartRequest('POST', url);

      // Add files to request
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        final filename = path.basename(file.path);
        
        final multipartFile = await http.MultipartFile.fromPath(
          'evidence',
          file.path,
          filename: filename,
        );
        request.files.add(multipartFile);
      }

      final response = await request.send().timeout(Duration(seconds: 60));
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'uploadedFiles': responseData['data']['uploadedFiles'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to upload evidence',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Upload error: ${e.toString()}',
      };
    }
  }

  // Get customer's complaints
  static Future<Map<String, dynamic>> getCustomerComplaints(String customerId, {int limit = 20, int offset = 0}) async {
    try {
      // Get working base URL
      final workingBaseUrl = await getWorkingBaseUrl();
      if (workingBaseUrl == null) {
        return {
          'success': false,
          'message': 'Unable to connect to server.',
        };
      }

      final url = Uri.parse('$workingBaseUrl/complaints/customer/$customerId?limit=$limit&offset=$offset');
      final response = await http.get(url).timeout(Duration(seconds: 30));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final complaints = (responseData['data'] as List)
            .map((json) => ComplaintModel.fromJson(json, json['id'] ?? ''))
            .toList();

        return {
          'success': true,
          'complaints': complaints,
          'total': responseData['total'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch complaints',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get complaint by ID
  static Future<Map<String, dynamic>> getComplaintById(String complaintId) async {
    try {
      final url = Uri.parse('$baseUrl/complaints/$complaintId');
      final response = await http.get(url);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final complaint = ComplaintModel.fromJson(responseData['data'], complaintId);
        return {
          'success': true,
          'complaint': complaint,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch complaint',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Update complaint status (for internal use if needed)
  static Future<Map<String, dynamic>> updateComplaintStatus(String complaintId, String status, {String? notes}) async {
    try {
      final url = Uri.parse('$baseUrl/complaints/$complaintId/status');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'status': status,
          if (notes != null) 'notes': notes,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get complaint statistics
  static Future<Map<String, dynamic>> getComplaintStats() async {
    try {
      final url = Uri.parse('$baseUrl/complaints/stats');
      final response = await http.get(url);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'stats': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch stats',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
