import 'package:flutter_test/flutter_test.dart';
import 'package:fixme/services/search_service.dart';

void main() {
  group('Search Service Tests', () {
    test('should connect to backend', () async {
      final isConnected = await SearchService.testConnection();
      expect(isConnected, isTrue, reason: 'Should be able to connect to the backend');
    });

    test('should search technicians', () async {
      final result = await SearchService.searchTechniciansWithHistory(
        query: 'subahu',
        userId: 'test-user-123',
      );
      
      expect(result['success'], isTrue);
      expect(result['data'], isNotNull);
      print('Technician search results: ${result['total']} found');
      
      if (result['data'] != null && result['data'].isNotEmpty) {
        final firstResult = result['data'][0];
        print('First result: ${firstResult['name']}');
      }
    });

    test('should search all categories', () async {
      final result = await SearchService.searchAll(
        query: 'emergency',
        userId: 'test-user-123',
      );
      
      expect(result['success'], isTrue);
      expect(result['data'], isNotNull);
      print('All search results: ${result['total']} found');
      
      if (result['data'] != null && result['data'].isNotEmpty) {
        final categories = result['data'].map((item) => item['category']).toSet();
        print('Categories found: $categories');
      }
    });

    test('should search towing services', () async {
      final result = await SearchService.searchTowingServices(
        query: 'quick',
        userId: 'test-user-123',
      );
      
      expect(result['success'], isTrue);
      expect(result['data'], isNotNull);
      print('Towing search results: ${result['total']} found');
      
      if (result['data'] != null && result['data'].isNotEmpty) {
        final firstResult = result['data'][0];
        print('First towing service: ${firstResult['businessName']}');
      }
    });

    test('should get recent searches', () async {
      // First perform a search to create history
      await SearchService.searchAll(
        query: 'test search',
        userId: 'test-user-123',
      );
      
      // Wait a bit for the search to be saved
      await Future.delayed(Duration(seconds: 1));
      
      // Then get recent searches
      final result = await SearchService.getRecentSearches(
        userId: 'test-user-123',
        category: 'All',
        limit: 5,
      );
      
      expect(result['success'], isTrue);
      expect(result['data'], isNotNull);
      print('Recent searches: ${result['data'].length} found');
      
      if (result['data'] != null && result['data'].isNotEmpty) {
        final searches = result['data'].map((search) => search['query']).toList();
        print('Recent search queries: $searches');
      }
    });
  });
}