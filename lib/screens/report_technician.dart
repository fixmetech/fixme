import 'package:flutter/material.dart';
import 'file_complaint_screen.dart';

class ReportTechnicianScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedService;
  final Map<String, dynamic>? selectedTechnician;

  const ReportTechnicianScreen({
    Key? key, 
    this.selectedService,
    this.selectedTechnician,
  }) : super(key: key);

  @override
  _ReportTechnicianScreenState createState() => _ReportTechnicianScreenState();
}

class _ReportTechnicianScreenState extends State<ReportTechnicianScreen> {
  @override
  Widget build(BuildContext context) {
    return FileComplaintScreen(
      selectedService: widget.selectedService,
      selectedTechnician: widget.selectedTechnician,
    );
  }
}