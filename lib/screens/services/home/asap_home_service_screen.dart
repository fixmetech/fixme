import 'package:fixme/screens/Profile/customer_edit_home.dart';
import 'package:fixme/screens/services/find_help.dart';
import 'package:fixme/screens/services/home/home_selection_screen.dart';
import 'package:fixme/screens/services/vehicle/terms_and_conditions.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/widgets/issue_chips.dart';
import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:fixme/models/job_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsapHomeServiceScreen extends StatefulWidget {
  final String serviceType;
  final String serviceCategory;

  const AsapHomeServiceScreen({
    super.key,
    required this.serviceType,
    required this.serviceCategory,
  });

  @override
  State<AsapHomeServiceScreen> createState() => _AsapHomeServiceScreenState();
}

class _AsapHomeServiceScreenState extends State<AsapHomeServiceScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = Get.put(ProfileController());

  List<String> selectedIssues = [];
  bool agreeToTerms = true;

  @override
  void initState() {
    super.initState();
    _loadHomes();
  }

  Future<void> _loadHomes() async {
    await _profileController.loadUserHomes();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showTermsAndConditionsDialog() {
    TermsAndConditionsDialog.show(context);
  }

  void _editHome(HomeProfile home) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditHome(homeProfile: home),
      ),
    ).then((_) {
      _profileController.loadUserHomes();
    });
  }

  void _showEditHomeConfirmation(HomeProfile home) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Text(
                'Edit Property',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you want to edit this property?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
                _editHome(home);
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
                'Edit Property',
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

    if (selectedIssues.contains("Unknown")) {
      if (description.isEmpty) {
        return 'Description is required when "Unknown" issue is selected';
      }
      if (description.length < 20) {
        return 'Description must be at least 20 characters long';
      }
    }

    if (description.isNotEmpty && description.length < 20) {
      return 'Description must be at least 20 characters long';
    }

    return null;
  }

  bool _canProceed() {
    if (selectedIssues.isEmpty) return false;
    if (!agreeToTerms) return false;
    if (_profileController.getDefaultHome() == null) return false;

    final description = _descriptionController.text.trim();
    if (selectedIssues.contains("Unknown")) {
      return description.isNotEmpty && description.length >= 20;
    }

    if (description.isNotEmpty) {
      return description.length >= 20;
    }

    return true;
  }

  void _handleFindTap() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      FixMeHelperFunctions.showInfoSnackBar(
        'Not Logged In',
        "Please log in to proceed.",
      );
      return;
    }

    if (_formKey.currentState!.validate() && _canProceed()) {
      final selectedHome = _profileController.getSelectedHome();
      if (selectedHome == null) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Property Required',
          "Please select a property before proceeding.",
        );
        return;
      }
      final jobRequest = JobRequest(
        status: 'pending',
        customerId: FirebaseAuth.instance.currentUser?.uid ?? '',
        propertyInfo: PropertyInfo.fromHome(selectedHome),
        selectedIssues: selectedIssues,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        createdAt: DateTime.now(),
        serviceCategory: widget.serviceCategory,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FindHelp(jobRequest: jobRequest)),
      );
    } else {
      if (selectedIssues.isEmpty) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Incomplete request',
          "Please select at least one issue.",
        );
        return;
      }
      if (_profileController.getDefaultHome() == null) {
        FixMeHelperFunctions.showInfoSnackBar(
          'Property Required',
          "Please select a property before proceeding.",
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

  List<Map<String, dynamic>> _getIssuesForService() {
    switch (widget.serviceCategory.toLowerCase()) {
      case 'plumbing':
        return [
          {"label": "Leaking Pipe", "icon": Icons.water_drop},
          {"label": "Clogged Drain", "icon": Icons.cleaning_services},
          {"label": "Water Heater Issue", "icon": Icons.hot_tub},
          {"label": "Faucet Repair", "icon": Icons.plumbing},
          {"label": "Toilet Problem", "icon": Icons.wc},
          {"label": "Low Water Pressure", "icon": Icons.water},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'electrical':
        return [
          {"label": "Power Outage", "icon": Icons.power_off},
          {"label": "Switch/Socket Issue", "icon": Icons.power},
          {"label": "Wiring Problem", "icon": Icons.cable},
          {"label": "Light Fixture", "icon": Icons.lightbulb},
          {"label": "Circuit Breaker", "icon": Icons.electrical_services},
          {"label": "Fan Installation", "icon": Icons.air},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'carpentry':
        return [
          {"label": "Door Repair", "icon": Icons.door_front_door},
          {"label": "Window Repair", "icon": Icons.window},
          {"label": "Furniture Assembly", "icon": Icons.chair},
          {"label": "Cabinet Work", "icon": Icons.kitchen},
          {"label": "Flooring", "icon": Icons.layers},
          {"label": "Custom Woodwork", "icon": Icons.handyman},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'cleaning':
        return [
          {"label": "Deep Cleaning", "icon": Icons.cleaning_services},
          {"label": "Regular Cleaning", "icon": Icons.clean_hands},
          {"label": "Carpet Cleaning", "icon": Icons.layers},
          {"label": "Window Cleaning", "icon": Icons.window},
          {"label": "Kitchen Cleaning", "icon": Icons.kitchen},
          {"label": "Bathroom Cleaning", "icon": Icons.bathtub},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'painting':
        return [
          {"label": "Interior Painting", "icon": Icons.format_paint},
          {"label": "Exterior Painting", "icon": Icons.home},
          {"label": "Wall Repair", "icon": Icons.construction},
          {"label": "Ceiling Painting", "icon": Icons.roofing},
          {"label": "Staining/Varnish", "icon": Icons.brush},
          {"label": "Touch-up Work", "icon": Icons.colorize},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'landscaping':
        return [
          {"label": "Lawn Mowing", "icon": Icons.grass},
          {"label": "Tree Trimming", "icon": Icons.park},
          {"label": "Garden Design", "icon": Icons.local_florist},
          {"label": "Irrigation System", "icon": Icons.water_drop},
          {"label": "Weed Control", "icon": Icons.eco},
          {"label": "Hardscaping", "icon": Icons.terrain},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'appliance':
        return [
          {"label": "Refrigerator Repair", "icon": Icons.kitchen},
          {"label": "Washing Machine", "icon": Icons.local_laundry_service},
          {"label": "Oven/Stove", "icon": Icons.outdoor_grill},
          {"label": "Dishwasher", "icon": Icons.countertops},
          {"label": "Air Conditioner", "icon": Icons.ac_unit},
          {"label": "Microwave", "icon": Icons.microwave},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      case 'renovation':
        return [
          {"label": "Bathroom Renovation", "icon": Icons.bathtub},
          {"label": "Kitchen Renovation", "icon": Icons.kitchen},
          {"label": "Room Addition", "icon": Icons.add_home},
          {"label": "Flooring Replacement", "icon": Icons.layers},
          {"label": "Roofing", "icon": Icons.roofing},
          {"label": "General Remodeling", "icon": Icons.construction},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
      default:
        return [
          {"label": "General Issue", "icon": Icons.build},
          {"label": "Unknown", "icon": Icons.help_outline},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final issues = _getIssuesForService();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Find a ${widget.serviceType} Technician',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                "Your Property Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                "Please check whether your property details are correct",
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
                                builder: (context) => HomeSelectionScreen(
                                  currentSelectedHome:
                                      _profileController.getSelectedHome(),
                                  onHomeSelected: (home) {
                                    // Home selection is handled in the screen itself
                                  },
                                ),
                              ),
                            );
                          },
                    child: Row(
                      children: [
                        Text(
                          _profileController.isLoading.value
                              ? "Loading Properties..."
                              : "Change Property",
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

              // Home Card
              Obx(() {
                HomeProfile? currentHome = _profileController.getSelectedHome();
                _profileController.setCurrentHome(currentHome);

                if (currentHome == null) {
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
                              Icons.home,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No Property Selected",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text("Please add a property to continue"),
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
                          backgroundImage: currentHome.imageUrl.isNotEmpty
                              ? NetworkImage(currentHome.imageUrl)
                              : const AssetImage("assets/images/city.jpg")
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentHome.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      currentHome.address,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text("${currentHome.city}, ${currentHome.postalCode}"),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditHomeConfirmation(currentHome);
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
                children: issues.map((issue) {
                  final bool isUnknown = issue['label'] == "Unknown";
                  return SelectableIssueChip(
                    label: issue['label'],
                    icon: issue['icon'],
                    selectColor: isUnknown ? 'red' : 'blue',
                    onSelected: (selected) =>
                        _onIssueSelected(issue['label'], selected),
                  );
                }).toList(),
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
                    Icons.description,
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
                  setState(() {});
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
                    backgroundColor:
                        _canProceed() ? Colors.blue[300] : Colors.grey[400],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
