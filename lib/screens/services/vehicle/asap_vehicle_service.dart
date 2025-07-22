import 'package:fixme/screens/services/find_help.dart';
import 'package:fixme/screens/services/vehicle/vehicle_selection_screen.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/widgets/issue_chips.dart';
import 'package:flutter/material.dart';

class AsapVehicleService extends StatefulWidget {
  const AsapVehicleService({super.key});

  @override
  State<AsapVehicleService> createState() => _AsapVehicleServiceState();
}

class _AsapVehicleServiceState extends State<AsapVehicleService> {
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  List<String> selectedIssues = [];
  bool agreeToTerms = true;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FindHelp()),
      );
    }else{
      if(selectedIssues.isEmpty){
        FixMeHelperFunctions.showInfoSnackBar('Incomplete request', "Please select at least one issue.");
        return;
      }
      if(_descriptionController.text.trim().isEmpty && selectedIssues.contains("Unknown")){
        FixMeHelperFunctions.showInfoSnackBar('Incomplete request', "Please provide a description for the unknown issue.");
        return;
      }
      if(!agreeToTerms){
        FixMeHelperFunctions.showInfoSnackBar('Incomplete request', "Please agree to the terms.");
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
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleSelectionScreen(
                          onVehicleSelected: (vehicle) {
                            // Handle vehicle selection
                            // The VehicleSelectionScreen will automatically navigate back
                            // You can add additional logic here to update the selected vehicle
                          },
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Change Vehicle",
                        style: TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Vehicle Card
              Material(
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
                        foregroundColor: Colors.amber, // use real image
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/images/city.jpg"),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KX-6065",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text("Model: Toyota Corolla"),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text("Year: 2018"),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                    ],
                  ),
                ),
              ),
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
                    onSelected: (selected) => _onIssueSelected("Engine Problem", selected),
                  ),
                  SelectableIssueChip(
                    label: "Battery Issue",
                    icon: Icons.battery_alert,
                    onSelected: (selected) => _onIssueSelected("Battery Issue", selected),
                  ),
                  SelectableIssueChip(
                    label: "Flat Tire",
                    icon: Icons.circle_outlined,
                    onSelected: (selected) => _onIssueSelected("Flat Tire", selected),
                  ),
                  SelectableIssueChip(
                    label: "Break not working",
                    icon: Icons.warning_amber,
                    onSelected: (selected) => _onIssueSelected("Break not working", selected),
                  ),
                  SelectableIssueChip(
                    label: "Strange Noice",
                    icon: Icons.surround_sound,
                    onSelected: (selected) => _onIssueSelected("Strange Noice", selected),
                  ),
                  SelectableIssueChip(
                    label: "Crashed", 
                    icon: Icons.car_crash,
                    onSelected: (selected) => _onIssueSelected("Crashed", selected),
                  ),
                  SelectableIssueChip(
                    label: "Unknown", 
                    icon: Icons.help_outline, 
                    selectColor: 'red',
                    onSelected: (selected) => _onIssueSelected("Unknown", selected),
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
                  prefixIcon: const Icon(Icons.car_crash_rounded, color: Colors.blueGrey),
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
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                children: [
                  Checkbox(
                    value: agreeToTerms, 
                    onChanged: (v) {
                      setState(() {
                        agreeToTerms = v ?? false;
                      });
                    }
                  ),
                  const Expanded(
                    child: Text("I agree for the terms and conditions."),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canProceed() ? Colors.blue[300] : Colors.grey[400],
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
