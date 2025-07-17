import 'package:fixme/screens/services/find_help.dart';
import 'package:fixme/screens/services/vehicle/vehicle_selection_screen.dart';
import 'package:fixme/widgets/issue_chips.dart';
import 'package:flutter/material.dart';

class AsapVehicleService extends StatelessWidget {
  const AsapVehicleService({super.key});

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
      body: SingleChildScrollView(
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
              children: const [
                SelectableIssueChip(label: "Engine Problem", icon: Icons.build),
                SelectableIssueChip(
                  label: "Battery Issue",
                  icon: Icons.battery_alert,
                ),
                SelectableIssueChip(
                  label: "Flat Tire",
                  icon: Icons.circle_outlined,
                ),
                SelectableIssueChip(
                  label: "Break not working",
                  icon: Icons.warning_amber,
                ),
                SelectableIssueChip(
                  label: "Strange Noice",
                  icon: Icons.surround_sound,
                ),
                SelectableIssueChip(label: "Crashed", icon: Icons.car_crash),
              ],
            ),

            const SizedBox(height: 24),

            TextFormField(
              maxLines: 4,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Describe the issue (optional)",
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
              ),
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
                Checkbox(value: true, onChanged: (v) {}),
                const Expanded(
                  child: Text("I agree for the terms and conditions."),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FindHelp()),
                  );
                },
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
