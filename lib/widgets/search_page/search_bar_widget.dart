import 'package:flutter/material.dart';
import 'detailed_search_screen.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBarWidget({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedSearchScreen(),
          ),
        );
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            SizedBox(width: 20),
            Icon(Icons.search, color: Colors.grey[500]),
            SizedBox(width: 12),
            Text(
              'Search services',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}