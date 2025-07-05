// address_button.dart
import 'package:flutter/material.dart';
import 'address_screen.dart'; // Import the addresses screen

class AddressButton extends StatefulWidget {
  @override
  _AddressButtonState createState() => _AddressButtonState();
}

class _AddressButtonState extends State<AddressButton> {
  String currentAddress = '5 Amarathunga Mawatha';
  
  void _navigateToAddresses() async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressesScreen(currentAddress: currentAddress),
      ),
    );
    
    if (selectedAddress != null) {
      setState(() {
        // Extract just the street part of the address for display
        currentAddress = selectedAddress.split(',')[0];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: _navigateToAddresses,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      currentAddress,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}