import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sizer/sizer.dart';

// Widget für einen NumberPicker mit einem Label
// wird in der Edit_Breathing_Screen verwendet
class LabelledNumberPicker extends StatelessWidget {
  final String label;
  final int value;
  final void Function(int) onChanged;

  const LabelledNumberPicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 45.w, child: Text(label)),
              SizedBox(
                width: 15.w,
              ),
              SizedBox(
                width: 15.w,
                child: NumberPicker(
                  value: value,
                  minValue: 1,
                  maxValue: 15,
                  step: 1,
                  axis: Axis.vertical,
                  haptics: true,
                  onChanged: onChanged,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
