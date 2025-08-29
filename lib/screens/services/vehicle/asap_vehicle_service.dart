import 'package:fixme/screens/Profile/customer_edit_vehicle.dart';
import 'package:fixme/screens/services/find_help.dart';
import 'package:fixme/screens/services/vehicle/vehicle_selection_screen.dart';
import 'package:fixme/screens/services/vehicle/terms_and_conditions.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/widgets/issue_chips.dart';
import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/models/job_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsapVehicleService extends StatefulWidget {
  const AsapVehicleService({super.key});

  @override
  State<AsapVehicleService> createState() => _AsapVehicleServiceState();
}

class _AsapVehicleServiceState extends State<AsapVehicleService> {
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = Get.put(ProfileController());

  List<String> selectedIssues = [];
  bool agreeToTerms = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    await _profileController.loadUserVehicles();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showTermsAndConditionsDialog() {
    TermsAndConditionsDialog.show(context);
  }

  void _editVehicle(VehicleProfile vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditVehicle(vehicleProfile: vehicle),
      ),
    ).then((_) {
      _profileController.loadUserVehicles();
    });
  }

  void _showEditVehicleConfirmation(VehicleProfile vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Text(
                'Edit Vehicle',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Do you want to edit this vehicle?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to edit screen
                _editVehicle(vehicle);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Edit Vehicle',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onIssueSelected(String issue, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedIssues.add(issue);
      } else {
        selectedIssues.remove(issue);
      }
    });
  }

  String? _validateDescription(String? value) {
    final description = value?.trim() ?? '';

    // If "Unknown" is selected, description is mandatory
    if (selectedIssues.contains("Unknown")) {
      if (description.isEmpty) {
        return 'Description is required when "Unknown" issue is selected';
      }
      if (description.length < 20) {
        return 'Description must be at least 20 characters long';
      }
    }

    // If description is provided, it must be at least 20 characters
    if (description.isNotEmpty && description.length < 20) {
      return 'Description must be at least 20 characters long';
    }

    return null;
  }

  bool _canProceed() {
    // Must select at least one issue
    if (selectedIssues.isEmpty) return false;

    // Must agree to terms
    if (!agreeToTerms) return false;

    // Must have a vehicle selected
    if (_profileController.getDefaultVehicle() == null) return false;

    // Validate description
    final description = _descriptionController.text.trim();
    if (selectedIssues.contains("Unknown")) {
      return description.isNotEmpty && description.length >= 20;
    }

    // If description is provided, it must meet minimum length
    if (description.isNotEmpty) {
      return description.length >= 20;
    }

    return true;
  }

  void _handleFindTap() {
    if (_formKey.currentState!.validate() && _canProceed()) {
      // Create job request object
      final selectedVehicle = _profileController.getSelectedVehicle();
      if (selectedVehicle == null) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Vehicle Required',
          "Please select a vehicle before proceeding.",
        );
        return;
      }

      final jobRequest = JobRequest(
        status: 'pending',
        customerId: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        propertyInfo: PropertyInfo.fromVehicle(selectedVehicle),
        selectedIssues: selectedIssues,
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        createdAt: DateTime.now(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FindHelp(jobRequest: jobRequest),
        ),
      );
    } else {
      if (selectedIssues.isEmpty) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Incomplete request',
          "Please select at least one issue.",
        );
        return;
      }
      if (_profileController.getDefaultVehicle() == null) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Vehicle Required',
          "Please select a vehicle before proceeding.",
        );
        return;
      }
      if (_descriptionController.text.trim().isEmpty &&
          selectedIssues.contains("Unknown")) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Incomplete request',
          "Please provide a description for the unknown issue.",
        );
        return;
      }
      if (!agreeToTerms) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Incomplete request',
          "Please agree to the terms.",
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Find a Technician',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Your Vehicle Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                "Please check whether your vehicle details are correct",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),

              Center(
                child: Obx(
                  () => TextButton(
                    onPressed: _profileController.isLoading.value
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VehicleSelectionScreen(
                                  currentSelectedVehicle: _profileController
                                      .getSelectedVehicle(),
                                  onVehicleSelected: (vehicle) {
                                    // Vehicle selection is handled in the screen itself
                                    // The ProfileController will be updated automatically
                                  },
                                ),
                              ),
                            );
                          },
                    child: Row(
                      children: [
                        Text(
                          _profileController.isLoading.value
                              ? "Loading Vehicles..."
                              : "Change Vehicle",
                          style: TextStyle(
                            color: _profileController.isLoading.value
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (_profileController.isLoading.value)
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Vehicle Card
              Obx(() {
                VehicleProfile? currentVehicle = _profileController
                    .getSelectedVehicle();
                _profileController.setCurrentVehicle(currentVehicle);

                if (currentVehicle == null) {
                  // Show loading or no vehicle message
                  return Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No Vehicle Selected",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text("Please add a vehicle to continue"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          foregroundColor: Colors.amber,
                          backgroundColor: Colors.transparent,
                          backgroundImage: currentVehicle.imageUrl != null
                              ? NetworkImage(currentVehicle.imageUrl!)
                              : const AssetImage("assets/images/city.jpg")
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentVehicle.plateNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.directions_car,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "Model: ${currentVehicle.make} ${currentVehicle.model}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text("Year: ${currentVehicle.year}"),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditVehicleConfirmation(currentVehicle);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              const Text(
                "What's the issue?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SelectableIssueChip(
                    label: "Engine Problem",
                    icon: Icons.build,
                    onSelected: (selected) =>
                        _onIssueSelected("Engine Problem", selected),
                  ),
                  SelectableIssueChip(
                    label: "Battery Issue",
                    icon: Icons.battery_alert,
                    onSelected: (selected) =>
                        _onIssueSelected("Battery Issue", selected),
                  ),
                  SelectableIssueChip(
                    label: "Flat Tire",
                    icon: Icons.circle_outlined,
                    onSelected: (selected) =>
                        _onIssueSelected("Flat Tire", selected),
                  ),
                  SelectableIssueChip(
                    label: "Break not working",
                    icon: Icons.warning_amber,
                    onSelected: (selected) =>
                        _onIssueSelected("Break not working", selected),
                  ),
                  SelectableIssueChip(
                    label: "Strange Noice",
                    icon: Icons.surround_sound,
                    onSelected: (selected) =>
                        _onIssueSelected("Strange Noice", selected),
                  ),
                  SelectableIssueChip(
                    label: "Crashed",
                    icon: Icons.car_crash,
                    onSelected: (selected) =>
                        _onIssueSelected("Crashed", selected),
                  ),
                  SelectableIssueChip(
                    label: "Unknown",
                    icon: Icons.help_outline,
                    selectColor: 'red',
                    onSelected: (selected) =>
                        _onIssueSelected("Unknown", selected),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                validator: _validateDescription,
                decoration: InputDecoration(
                  hintText: selectedIssues.contains("Unknown")
                      ? "Describe the issue (required for unknown issues)"
                      : "Describe the issue (optional)",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(
                    Icons.car_crash_rounded,
                    color: Colors.blueGrey,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update validation
                },
              ),

              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    const Text(
                      "Upload any Supporting Images",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    IconButton(
                      icon: const Icon(
                        Icons.drive_folder_upload,
                        size: 30,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (v) {
                      setState(() {
                        agreeToTerms = v ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black87),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _showTermsAndConditionsDialog,
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canProceed()
                        ? Colors.blue[300]
                        : Colors.grey[400],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleFindTap,
                  child: const Text(
                    "Find",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ), // Wrap ElevatedButton with Obx
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IssueChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const IssueChip({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.redAccent),
      label: Text(label),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
