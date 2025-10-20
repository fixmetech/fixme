import 'package:flutter/material.dart';
import 'package:fixme/services/search_service.dart';

class SearchTestScreen extends StatefulWidget {
  @override
  _SearchTestScreenState createState() => _SearchTestScreenState();
}

class _SearchTestScreenState extends State<SearchTestScreen> {
  String _testResult = 'Not tested yet';
  bool _isLoading = false;

  void _testConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing connection...';
    });

    try {
      // Test 1: Basic connection
      final canConnect = await SearchService.testConnection();
      
      if (!canConnect) {
        setState(() {
          _testResult = '❌ Cannot connect to server. Check if server is running on localhost:3000';
          _isLoading = false;
        });
        return;
      }

      // Test 2: Search API
      final searchResult = await SearchService.searchAll(
        query: 'subahu',
        userId: 'test-user-123',
      );

      setState(() {
        if (searchResult['success']) {
          final count = searchResult['total'] ?? 0;
          _testResult = '✅ Connection successful!\nFound $count results for "subahu"';
          
          if (searchResult['data'] != null && searchResult['data'].isNotEmpty) {
            final firstName = searchResult['data'][0]['name'];
            _testResult += '\nFirst result: $firstName';
          }
        } else {
          _testResult = '❌ Search failed: ${searchResult['message']}';
        }
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _testResult = '❌ Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search API Test')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              child: _isLoading 
                ? CircularProgressIndicator()
                : Text('Test Search API'),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _testResult,
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Instructions:\n'
              '1. Make sure your server is running: node server.js\n'
              '2. If on Android emulator, server should be accessible on 10.0.2.2:3000\n'
              '3. If on iOS simulator, server should be accessible on localhost:3000\n'
              '4. Check your firewall settings if connection fails',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}