import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TechnicianRequestScreen extends StatefulWidget {
  final String technicianName;
  final String technicianImage;
  final double visitingFee;

  const TechnicianRequestScreen({
    super.key,
    required this.technicianName,
    required this.technicianImage,
    this.visitingFee = 50.0,
  });

  @override
  State<TechnicianRequestScreen> createState() => _TechnicianRequestScreenState();
}

class _TechnicianRequestScreenState extends State<TechnicianRequestScreen> {
  final TextEditingController _jobDescriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  String? selectedCar;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  List<File> selectedImages = [];
  DateTime currentCalendarDate = DateTime.now();
  
  // Sample unavailable dates (red dates)
  final List<DateTime> unavailableDates = [
    DateTime(2025, 7, 25),
    DateTime(2025, 7, 28),
    DateTime(2025, 8, 1),
    DateTime(2025, 8, 5),
    DateTime(2025, 8, 15),
    DateTime(2025, 9, 3),
    DateTime(2025, 9, 10),
  ];
  
  // Sample time slots
  final List<String> timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM'
  ];
  
  // Sample saved cars
  final List<Map<String, String>> savedCars = [
    {'name': 'Toyota Camry 2020', 'type': 'Sedan'},
    {'name': 'Honda Civic 2019', 'type': 'Hatchback'},
    {'name': 'BMW X5 2021', 'type': 'SUV'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: Column(
        children: [
          // Header with back button
          Container(
            height: screenHeight * 0.12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[700]!, Colors.blue[600]!],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Send Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Technician Details Card
                  _buildTechnicianCard(),
                  
                  const SizedBox(height: 25),
                  
                  // Job Information Section
                  _buildJobInformationSection(),
                  
                  const SizedBox(height: 25),
                  
                  // Calendar Section
                  _buildCalendarSection(),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          
          // Fixed Send Request Button at bottom
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: _buildSendRequestButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.lightBlueAccent,
            backgroundImage: AssetImage(widget.technicianImage),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.technicianName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Professional Technician",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      "4.5",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Visiting Fee: Rs.400",
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobInformationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.work_outline, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 15),
              const Text(
                "Job Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Select Car Button
          InkWell(
            onTap: _showCarSelectionDialog,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedCar ?? "Select a car",
                      style: TextStyle(
                        color: selectedCar != null ? Colors.black87 : Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Job Description
          const Text(
            "Job Description",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _jobDescriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Describe the issue or service you need...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Selected Date and Time Display
          if (selectedDate != null || selectedTimeSlot != null)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selected Schedule:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (selectedDate != null)
                    Text("Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  if (selectedTimeSlot != null)
                    Text("Time: $selectedTimeSlot"),
                ],
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Upload Images Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upload Images",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Add Images"),
              ),
            ],
          ),
          
          if (selectedImages.isNotEmpty)
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            selectedImages[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 15),
              const Text(
                "Select Date & Time",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Simple Calendar Grid
          _buildSimpleCalendar(),
          
          const SizedBox(height: 20),
          
          // Time Slots
          if (selectedDate != null) ...[
            const Text(
              "Available Time Slots",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            _buildTimeSlots(),
          ],
        ],
      ),
    );
  }

  Widget _buildSimpleCalendar() {
    final daysInMonth = DateTime(currentCalendarDate.year, currentCalendarDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentCalendarDate.year, currentCalendarDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    final now = DateTime.now();

    return Column(
      children: [
        // Month/Year Header with navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentCalendarDate = DateTime(
                    currentCalendarDate.month == 1 
                        ? currentCalendarDate.year - 1 
                        : currentCalendarDate.year,
                    currentCalendarDate.month == 1 
                        ? 12 
                        : currentCalendarDate.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left),
              color: Colors.blue,
            ),
            Text(
              "${_getMonthName(currentCalendarDate.month)} ${currentCalendarDate.year}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentCalendarDate = DateTime(
                    currentCalendarDate.month == 12 
                        ? currentCalendarDate.year + 1 
                        : currentCalendarDate.year,
                    currentCalendarDate.month == 12 
                        ? 1 
                        : currentCalendarDate.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right),
              color: Colors.blue,
            ),
          ],
        ),
        
        const SizedBox(height: 5),
        
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            const Text("Unavailable", style: TextStyle(fontSize: 12)),
            const SizedBox(width: 15),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            const Text("Selected", style: TextStyle(fontSize: 12)),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Days of week header
        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        
        const SizedBox(height: 10),
        
        // Calendar Grid
        ...List.generate((daysInMonth + firstWeekday - 1) ~/ 7 + 1, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 2;
              
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 40));
              }
              
              final date = DateTime(currentCalendarDate.year, currentCalendarDate.month, dayNumber);
              final isUnavailable = unavailableDates.any((unavailableDate) =>
                  unavailableDate.year == date.year &&
                  unavailableDate.month == date.month &&
                  unavailableDate.day == date.day);
              final isSelected = selectedDate != null &&
                  selectedDate!.year == date.year &&
                  selectedDate!.month == date.month &&
                  selectedDate!.day == date.day;
              final isPast = date.isBefore(DateTime(now.year, now.month, now.day));

              return Expanded(
                child: GestureDetector(
                  onTap: isPast || isUnavailable ? null : () {
                    setState(() {
                      selectedDate = date;
                      selectedTimeSlot = null; // Reset time slot when date changes
                    });
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : isUnavailable
                              ? Colors.red
                              : isPast
                                  ? Colors.grey.shade200
                                  : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isPast || isUnavailable || isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isUnavailable
                                  ? Colors.white
                                  : isPast
                                      ? Colors.grey
                                      : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: timeSlots.map((timeSlot) {
        final isSelected = selectedTimeSlot == timeSlot;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeSlot = timeSlot;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              timeSlot,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSendRequestButton() {
    final canSendRequest = selectedCar != null &&
        _jobDescriptionController.text.isNotEmpty &&
        selectedDate != null &&
        selectedTimeSlot != null;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: Colors.blue.withOpacity(0.4),
        ),
        onPressed: () {
          if (canSendRequest) {
            _showRequestSummary();
          } else {
            _showFormIncompleteError();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send, size: 20),
            const SizedBox(width: 8),
            const Text(
              "Send Request",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFormIncompleteError() {
    List<String> missingFields = [];
    
    if (selectedCar == null) {
      missingFields.add("Car selection");
    }
    if (_jobDescriptionController.text.isEmpty) {
      missingFields.add("Job description");
    }
    if (selectedDate == null) {
      missingFields.add("Date selection");
    }
    if (selectedTimeSlot == null) {
      missingFields.add("Time slot selection");
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[600]),
            const SizedBox(width: 10),
            const Text("Please Complete Form"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "The following fields are required to send your request:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...missingFields.map((field) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(field, style: const TextStyle(color: Colors.red)),
                ],
              ),
            )),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showRequestSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestSummaryScreen(
          technicianName: widget.technicianName,
          technicianImage: widget.technicianImage,
          visitingFee: widget.visitingFee,
          selectedCar: selectedCar!,
          jobDescription: _jobDescriptionController.text,
          selectedDate: selectedDate!,
          selectedTimeSlot: selectedTimeSlot!,
          selectedImages: selectedImages,
          onConfirm: _sendRequest,
        ),
      ),
    );
  }

  void _showCarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Select Your Car"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: savedCars.map((car) {
            return ListTile(
              leading: const Icon(Icons.directions_car, color: Colors.blue),
              title: Text(car['name']!),
              subtitle: Text(car['type']!),
              onTap: () {
                setState(() {
                  selectedCar = car['name'];
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  void _sendRequest() {
    // Handle sending the request
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600]),
            const SizedBox(width: 10),
            const Text("Request Sent!"),
          ],
        ),
        content: Text(
          "Your request has been sent to ${widget.technicianName}. They will respond soon.",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close summary screen
              Navigator.of(context).pop(); // Go back to technician profile
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    super.dispose();
  }
}

// Request Summary Screen
class RequestSummaryScreen extends StatelessWidget {
  final String technicianName;
  final String technicianImage;
  final double visitingFee;
  final String selectedCar;
  final String jobDescription;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final List<File> selectedImages;
  final VoidCallback onConfirm;

  const RequestSummaryScreen({
    super.key,
    required this.technicianName,
    required this.technicianImage,
    required this.visitingFee,
    required this.selectedCar,
    required this.jobDescription,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.selectedImages,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: Column(
        children: [
          // Header
          Container(
            height: screenHeight * 0.12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[700]!, Colors.blue[600]!],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Request Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Technician Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightBlueAccent,
                          backgroundImage: AssetImage(technicianImage),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                technicianName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Visiting Fee: Rs.400",
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Request Details Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Request Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // Car Information
                        _buildDetailRow(Icons.directions_car, "Car", selectedCar),
                        const SizedBox(height: 12),
                        
                        // Date and Time
                        _buildDetailRow(
                          Icons.calendar_today,
                          "Date",
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        ),
                        const SizedBox(height: 12),
                        
                        _buildDetailRow(Icons.access_time, "Time", selectedTimeSlot),
                        const SizedBox(height: 15),
                        
                        // Job Description
                        const Text(
                          "Job Description:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            jobDescription,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        
                        // Images if any
                        if (selectedImages.isNotEmpty) ...[
                          const SizedBox(height: 15),
                          const Text(
                            "Attached Images:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      selectedImages[index],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cost Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cost Summary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Visiting Fee:",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Rs.400",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Visiting Fee + Job amount",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Note: Job amount and additional charges for parts and labor will be discussed after inspection.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      shadowColor: Colors.blue.withOpacity(0.3),
                    ),
                    onPressed: onConfirm,
                    child: const Text(
                      "Confirm & Send Request",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}