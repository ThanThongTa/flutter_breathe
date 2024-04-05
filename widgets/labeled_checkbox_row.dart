import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Widget für eine Checkbox mit einem Label
// wird in der Edit_Breathing_Screen verwendet
class LabeledCheckboxRow extends StatelessWidget {
  final String label; // "Show Texts in animation: "
  final bool value; // state.showTexts
  final String semanticLabel; // "Show texts for breathing phases?"
  final Function(bool?)? onChanged;

  const LabeledCheckboxRow({
    super.key,
    required this.label,
    required this.value,
    required this.semanticLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 2.w),
            width: 60.w,
            child: Text(label),
          ),
          Container(
            width: 20.w,
            alignment: Alignment.centerRight,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              semanticLabel: semanticLabel,
            ),
          ),
        ],
      ),
    );
  }
}
