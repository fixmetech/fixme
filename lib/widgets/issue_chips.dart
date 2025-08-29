import 'dart:ui';
import 'package:flutter/material.dart';

class SelectableIssueChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final void Function(bool selected)? onSelected;
  final String selectColor;

  const SelectableIssueChip({
    super.key,
    required this.label,
    required this.icon,
    this.onSelected,
    this.selectColor = 'blue',
  });

  @override
  State<SelectableIssueChip> createState() => _SelectableIssueChipState();
}

class _SelectableIssueChipState extends State<SelectableIssueChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on selectColor parameter
    final Color primaryColor = widget.selectColor == 'red' ? Colors.red : Colors.blue;
    final Color iconColor = widget.selectColor == 'red' ? Colors.red[700]! : Colors.blue[700]!;
    
    final Color glassColor = _isSelected
        ? primaryColor.withOpacity(0.35)
        : Colors.white.withOpacity(0.2);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onSelected?.call(_isSelected);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isSelected ? primaryColor : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 18, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
