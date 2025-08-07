import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

/// Alignment property editor widget
class AlignmentPropertyEditor extends StatelessWidget {
  const AlignmentPropertyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final Alignment value;
  final ValueChanged<Alignment> onChanged;

  static const List<AlignmentOption> _alignmentOptions = [
    AlignmentOption(Alignment.topLeft, 'Top Left'),
    AlignmentOption(Alignment.topCenter, 'Top Center'),
    AlignmentOption(Alignment.topRight, 'Top Right'),
    AlignmentOption(Alignment.centerLeft, 'Center Left'),
    AlignmentOption(Alignment.center, 'Center'),
    AlignmentOption(Alignment.centerRight, 'Center Right'),
    AlignmentOption(Alignment.bottomLeft, 'Bottom Left'),
    AlignmentOption(Alignment.bottomCenter, 'Bottom Center'),
    AlignmentOption(Alignment.bottomRight, 'Bottom Right'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        
        // Visual alignment picker
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(4),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final option = _alignmentOptions[index];
              final isSelected = option.alignment == value;
              
              return InkWell(
                onTap: () => onChanged(option.alignment),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        
        // Selected alignment text
        Text(
          _getAlignmentName(value),
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getAlignmentName(Alignment alignment) {
    for (final option in _alignmentOptions) {
      if (option.alignment == alignment) {
        return option.name;
      }
    }
    return 'Custom';
  }
}

class AlignmentOption {
  const AlignmentOption(this.alignment, this.name);
  
  final Alignment alignment;
  final String name;
}
