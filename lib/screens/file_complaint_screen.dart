import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/complaint_model.dart';
import '../services/complaint_service.dart';

class FileComplaintScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedService;
  final Map<String, dynamic>? selectedTechnician;

  const FileComplaintScreen({
    Key? key, 
    this.selectedService,
    this.selectedTechnician,
  }) : super(key: key);

  @override
  _FileComplaintScreenState createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  String? selectedService;
  ComplaintCategory? selectedCategory;
  ComplaintSeverity selectedSeverity = ComplaintSeverity.medium;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> evidenceFiles = [];
  List<EvidenceFile> evidenceFilesList = [];
  bool isSubmitting = false;
  bool isConnected = false;
  bool isCheckingConnection = false;

  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> recentServices = [
    {
      'id': '1',
      'name': 'Engine Repair',
      'date': '2024-03-15',
      'time': '10:00 AM',
      'service': 'Engine Repair',
      'price': 15000.0,
      'technician': {
        'id': 'tech1',
        'name': 'Kamindu Mendis',
        'email': 'kamindu@email.com',
        'phone': '+94 77 234 5678',
        'profession': 'Mechanic',
        'badge': 'professional',
        'rating': 4.2
      }
    },
    {
      'id': '2',
      'name': 'Brake Service',
      'date': '2024-03-10',
      'time': '2:00 PM',
      'service': 'Brake Service',
      'price': 8000.0,
      'technician': {
        'id': 'tech2',
        'name': 'Dumini Dehigoda',
        'email': 'dumini@email.com',
        'phone': '+94 77 456 7890',
        'profession': 'Mechanic',
        'badge': 'experience',
        'rating': 4.8
      }
    },
    {
      'id': '3',
      'name': 'Oil Change & Tune-up',
      'date': '2024-03-08',
      'time': '11:00 AM',
      'service': 'Oil Change & Tune-up',
      'price': 5000.0,
      'technician': {
        'id': 'tech3',
        'name': 'Parami Jayasinghe',
        'email': 'parami@email.com',
        'phone': '+94 77 678 9012',
        'profession': 'Mechanic',
        'badge': 'probation',
        'rating': 3.9
      }
    },
  ];

  Map<String, dynamic>? selectedServiceData;

  @override
  void initState() {
    super.initState();
    if (widget.selectedService != null) {
      selectedServiceData = widget.selectedService;
      selectedService = '${widget.selectedService!['name']} - ${widget.selectedService!['service']} (${widget.selectedService!['date']})';
    }
    _checkServerConnection();
  }

  Future<void> _checkServerConnection() async {
    setState(() {
      isCheckingConnection = true;
    });

    try {
      final connected = await ComplaintService.testConnection();
      setState(() {
        isConnected = connected;
        isCheckingConnection = false;
      });

      if (!connected) {
        _showError('Unable to connect to server. Please check if the backend server is running.');
      }
    } catch (e) {
      setState(() {
        isConnected = false;
        isCheckingConnection = false;
      });
      _showError('Connection test failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'File a Complaint',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection status indicator
                  // Container(
                  //   padding: const EdgeInsets.all(12),
                  //   margin: const EdgeInsets.only(bottom: 16),
                  //   decoration: BoxDecoration(
                  //     color: isCheckingConnection
                  //         ? Colors.orange.withOpacity(0.1)
                  //         : isConnected
                  //             ? Colors.green.withOpacity(0.1)
                  //             : Colors.red.withOpacity(0.1),
                  //     border: Border.all(
                  //       color: isCheckingConnection
                  //           ? Colors.orange
                  //           : isConnected
                  //               ? Colors.green
                  //               : Colors.red,
                  //     ),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       if (isCheckingConnection)
                  //         const SizedBox(
                  //           width: 16,
                  //           height: 16,
                  //           child: CircularProgressIndicator(strokeWidth: 2),
                  //         )
                  //       else
                  //         Icon(
                  //           isConnected ? Icons.wifi : Icons.wifi_off,
                  //           color: isConnected ? Colors.green : Colors.red,
                  //           size: 16,
                  //         ),
                  //       const SizedBox(width: 8),
                  //       Text(
                  //         isCheckingConnection
                  //             ? 'Checking server connection...'
                  //             : isConnected
                  //                 ? 'Server connected'
                  //                 : 'Server connection failed',
                  //         style: TextStyle(
                  //           color: isCheckingConnection
                  //               ? Colors.orange
                  //               : isConnected
                  //                   ? Colors.green
                  //                   : Colors.red,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       const Spacer(),
                  //       if (!isConnected && !isCheckingConnection)
                  //         TextButton(
                  //           onPressed: _checkServerConnection,
                  //           child: const Text('Retry'),
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  // Service Selection Card
                  _buildServiceSelectionCard(),
                  SizedBox(height: 16),

                  // Complaint Details Card
                  _buildComplaintDetailsCard(),
                  SizedBox(height: 16),

                  // Severity Selection Card
                  _buildSeveritySelectionCard(),
                  SizedBox(height: 16),

                  // Evidence Upload Card
                  _buildEvidenceUploadCard(),
                  SizedBox(height: 80), // Space for fixed submit button
                ],
              ),
            ),
          ),

          // Submit Button - Fixed at bottom
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC10D0D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Submit Complaint',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelectionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: _showServiceSelection,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.car_repair, color: Color(0xFF6B46C1), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedService ?? 'Select a recent service',
                        style: TextStyle(
                          color: selectedService != null
                              ? Colors.black87
                              : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
            // Service details if selected
            if (selectedServiceData != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Text(
                          'Technician: ${selectedServiceData!['technician']['name']}',
                          style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 16, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Text(
                          'Amount: LKR ${selectedServiceData!['price'].toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // Category Dropdown
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<ComplaintCategory>(
              value: selectedCategory,
              decoration: InputDecoration(
                hintText: 'Select complaint category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF6B46C1)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: ComplaintCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Title Field
            Text(
              'Subject',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter a brief subject line',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF6B46C1)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 16),

            // Description Field
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Please describe the issue in detail...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF6B46C1)),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeveritySelectionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Severity Level',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ComplaintSeverity.values.map((severity) {
                final isSelected = selectedSeverity == severity;
                Color severityColor = _getSeverityColor(severity);
                
                return ChoiceChip(
                  label: Text(
                    severity.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : severityColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedSeverity = severity;
                    });
                  },
                  selectedColor: severityColor,
                  backgroundColor: severityColor.withOpacity(0.1),
                  side: BorderSide(color: severityColor),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceUploadCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attach Evidence',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // Upload Buttons
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickMedia(ImageSource.camera),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF6B46C1)),
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF6B46C1).withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, color: Color(0xFF6B46C1), size: 24),
                          SizedBox(height: 4),
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: Color(0xFF6B46C1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickMedia(ImageSource.gallery),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF6B46C1)),
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF6B46C1).withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library, color: Color(0xFF6B46C1), size: 24),
                          SizedBox(height: 4),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              color: Color(0xFF6B46C1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            Text(
              'JPG, PNG, MP4 files up to 10MB each (Max 5 files)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),

            // Show selected files
            if (evidenceFiles.isNotEmpty) ...[
              SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: evidenceFiles.length,
                itemBuilder: (context, index) {
                  final file = evidenceFiles[index];
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _isImageFile(file.path)
                              ? Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.videocam,
                                    color: Colors.grey[600],
                                    size: 32,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeEvidence(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(ComplaintSeverity severity) {
    switch (severity) {
      case ComplaintSeverity.low:
        return Colors.blue;
      case ComplaintSeverity.medium:
        return Colors.orange;
      case ComplaintSeverity.high:
        return Colors.red;
      case ComplaintSeverity.urgent:
        return Colors.red[800]!;
    }
  }

  bool _isImageFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  void _showServiceSelection() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Recent Service',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              ...recentServices.map((service) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF6B46C1),
                    child: Icon(Icons.car_repair, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    service['name']!,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${service['service']} - ${service['date']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        'Technician: ${service['technician']['name']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedServiceData = service;
                      selectedService = '${service['name']} - ${service['service']} (${service['date']})';
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia(ImageSource source) async {
    if (evidenceFiles.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum 5 files allowed'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          evidenceFiles.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking media: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeEvidence(int index) {
    setState(() {
      evidenceFiles.removeAt(index);
    });
  }

  Future<void> _submitComplaint() async {
    // First check if we have a valid connection
    if (!isConnected) {
      _showError('Cannot submit complaint: No server connection. Please check your connection and try again.');
      return;
    }

    // Validation
    if (selectedServiceData == null) {
      _showError('Please select a service');
      return;
    }

    if (selectedCategory == null) {
      _showError('Please select a complaint category');
      return;
    }

    if (titleController.text.trim().isEmpty) {
      _showError('Please enter a subject');
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter a description');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Test connection again before submitting
      final connected = await ComplaintService.testConnection();
      if (!connected) {
        setState(() {
          isConnected = false;
          isSubmitting = false;
        });
        _showError('Lost connection to server. Please check your connection and try again.');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError('User not authenticated');
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      // Create complaint model
      final complaint = ComplaintModel(
        customer: CustomerInfo(
          name: user.displayName ?? 'Unknown User',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          userId: user.uid,
          avatar: user.photoURL ?? '',
        ),
        technician: TechnicianInfo(
          name: selectedServiceData!['technician']['name'],
          email: selectedServiceData!['technician']['email'],
          phone: selectedServiceData!['technician']['phone'],
          profession: selectedServiceData!['technician']['profession'],
          badge: selectedServiceData!['technician']['badge'],
          rating: selectedServiceData!['technician']['rating'].toDouble(),
          userId: selectedServiceData!['technician']['id'],
        ),
        service: ServiceInfo(
          name: selectedServiceData!['name'],
          date: selectedServiceData!['date'],
          time: selectedServiceData!['time'],
          price: selectedServiceData!['price'].toDouble(),
          serviceId: selectedServiceData!['id'],
        ),
        complaint: ComplaintDetails(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: selectedCategory!.value,
          severity: selectedSeverity.value,
          submittedAt: DateTime.now().toIso8601String(),
          evidence: [],
          status: 'pending',
        ),
        resolution: ResolutionInfo(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Submit complaint with evidence in a single request
      final result = await ComplaintService.createComplaintWithEvidence(
        complaint,
        evidenceFiles,
      );

      if (result['success']) {
        final complaintId = result['complaintId'];
        final evidenceCount = result['evidenceCount'] ?? 0;
        
        print('✅ Complaint submitted successfully: $complaintId');
        print('📎 Evidence files uploaded: $evidenceCount');

        _showSuccess('Complaint submitted successfully! ${evidenceCount > 0 ? "($evidenceCount files uploaded)" : ""}');
        Navigator.pop(context);
      } else {
        _showError(result['message'] ?? 'Failed to submit complaint');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
