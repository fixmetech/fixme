import 'package:fixme/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class ServiceCenterAppointmentPage extends StatefulWidget {
  final String serviceCenterId;

  const ServiceCenterAppointmentPage({
    Key? key,
    this.serviceCenterId = 'qlDkCV4HUFNGoFMX1WAjdfnqPg42',
  }) : super(key: key);

  @override
  State<ServiceCenterAppointmentPage> createState() => _ServiceCenterAppointmentPageState();
}

class _ServiceCenterAppointmentPageState extends State<ServiceCenterAppointmentPage> {
  DateTime? selectedDate;
  String? selectedTime;

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  int selectedDuration = 30;
  DateTime currentMonth = DateTime.now();

  // Generate time slots from 9 AM to 5 PM
  List<String> get timeSlots {
    List<String> slots = [];
    for (int hour = 9; hour <= 17; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour == 17 && minute > 0) break;
        slots.add('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }
    return slots;
  }

  Future<void> handleSubmit() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    if (customerNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        serviceNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final appointment = {
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'customerName': customerNameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
      'serviceName': serviceNameController.text,
      'notes': notesController.text,
      'duration': selectedDuration,
      'date': selectedDate!.toIso8601String(),
      'time': selectedTime,
      'status': 'Pending',
      'scdeleted': false,
      'servicecenterid': widget.serviceCenterId,
      'serviceid': '', // can be filled by backend if needed
      'userid': '', // can be filled by backend if needed
    };

    try {
      // Update with your backend URL
      final url = Uri.parse('http://10.0.2.2:3000/api/appointments');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointment),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form
        setState(() {
          selectedDate = null;
          selectedTime = null;
          customerNameController.clear();
          emailController.clear();
          phoneNumberController.clear();
          serviceNameController.clear();
          notesController.clear();
          selectedDuration = 30;
        });
        Get.offAll(const MainScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create appointment: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  void dispose() {
    customerNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    serviceNameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.blue.shade700),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Back',
                    ),
                  ),
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade700],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book an Appointment',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select a date and time for your service',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Content
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 900) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildCalendarSection()),
                            const SizedBox(width: 16),
                            Expanded(child: _buildFormSection()),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildCalendarSection(),
                            const SizedBox(height: 16),
                            _buildFormSection(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      children: [
        _buildCalendar(),
        const SizedBox(height: 16),
        _buildTimeSlots(),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 8),
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            DateFormat('MMMM yyyy').format(currentMonth),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final today = DateTime.now();

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((day) => SizedBox(
            width: 40,
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar days
        ...List.generate((lastDayOfMonth.day + startingWeekday) ~/ 7 + 1, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - startingWeekday + 1;
                if (dayNumber < 1 || dayNumber > lastDayOfMonth.day) {
                  return const SizedBox(width: 40, height: 40);
                }

                final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
                final isSelected = selectedDate != null &&
                    date.year == selectedDate!.year &&
                    date.month == selectedDate!.month &&
                    date.day == selectedDate!.day;

                return InkWell(
                  onTap: isPast ? null : () => setState(() => selectedDate = date),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isPast
                          ? Colors.transparent
                          : isSelected
                          ? Colors.blue.shade600
                          : isToday
                          ? Colors.blue.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected || isToday
                          ? null
                          : Border.all(color: Colors.grey.shade200),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.blue.shade300, blurRadius: 8, offset: Offset(0, 2))]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isPast
                              ? Colors.grey.shade300
                              : isSelected
                              ? Colors.white
                              : isToday
                              ? Colors.blue.shade700
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 8),
              Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: timeSlots.map((time) {
                  final isSelected = selectedTime == time;
                  return InkWell(
                    onTap: () => setState(() => selectedTime = time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade600 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.blue.shade300, blurRadius: 8)]
                            : null,
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 8),
              Text(
                'Appointment Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: customerNameController,
            label: 'Customer Name',
            icon: Icons.person_outline,
            hint: 'Enter your name',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            hint: 'your.email@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: phoneNumberController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            hint: '07XXXXXXXX',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: serviceNameController,
            label: 'Service Name',
            icon: Icons.build_outlined,
            hint: 'e.g., Vehicle Repairing',
          ),
          const SizedBox(height: 16),
          _buildDurationDropdown(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: notesController,
            label: 'Notes',
            icon: Icons.note_outlined,
            hint: 'Describe the issue or any special requests...',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          if (selectedDate != null && selectedTime != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Selected: ${DateFormat('MMM dd, yyyy').format(selectedDate!)} at $selectedTime',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(
              'Duration (minutes)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedDuration,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              items: const [
                DropdownMenuItem(value: 30, child: Text('30 minutes')),
                DropdownMenuItem(value: 60, child: Text('1 hour')),
                DropdownMenuItem(value: 90, child: Text('1.5 hours')),
                DropdownMenuItem(value: 120, child: Text('2 hours')),
              ],
              onChanged: (value) => setState(() => selectedDuration = value!),
            ),
          ),
        ),
      ],
    );
  }
}