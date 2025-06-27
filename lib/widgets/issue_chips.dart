import 'dart:ui';
import 'package:flutter/material.dart';

class SelectableIssueChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final void Function(bool selected)? onSelected;

  const SelectableIssueChip({
    super.key,
    required this.label,
    required this.icon,
    this.onSelected,
  });

  @override
  State<SelectableIssueChip> createState() => _SelectableIssueChipState();
}

class _SelectableIssueChipState extends State<SelectableIssueChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final Color glassColor = _isSelected
        ? Colors.blue.withOpacity(0.35)
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
                color: _isSelected ? Colors.blue : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 18, color: Colors.blue[700]),
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
