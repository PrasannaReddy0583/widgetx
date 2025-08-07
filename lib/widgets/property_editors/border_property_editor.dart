import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import 'color_property_editor.dart';
import 'number_property_editor.dart';
import 'dropdown_property_editor.dart';

/// Border property editor widget
class BorderPropertyEditor extends StatefulWidget {
  const BorderPropertyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final Border? value;
  final ValueChanged<Border?> onChanged;

  @override
  State<BorderPropertyEditor> createState() => _BorderPropertyEditorState();
}

class _BorderPropertyEditorState extends State<BorderPropertyEditor> {
  bool _isExpanded = false;
  bool _hasBorder = false;
  Color _borderColor = Colors.black;
  double _borderWidth = 1.0;
  BorderStyle _borderStyle = BorderStyle.solid;

  @override
  void initState() {
    super.initState();
    _initializeFromValue();
  }

  @override
  void didUpdateWidget(BorderPropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initializeFromValue();
    }
  }

  void _initializeFromValue() {
    if (widget.value != null) {
      _hasBorder = true;
      _borderColor = widget.value!.top.color;
      _borderWidth = widget.value!.top.width;
      _borderStyle = widget.value!.top.style;
    } else {
      _hasBorder = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Switch(
              value: _hasBorder,
              onChanged: (value) {
                setState(() {
                  _hasBorder = value;
                });
                _updateBorder();
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        if (_hasBorder) ...[
          // Border preview
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor,
                width: _borderWidth,
                style: _borderStyle,
              ),
            ),
            child: const Center(
              child: Text(
                'Border Preview',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Expandable controls
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Border Settings',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          if (_isExpanded) ...[
            const SizedBox(height: 8),
            
            // Border width
            NumberPropertyEditor(
              label: 'Width',
              value: _borderWidth,
              onChanged: (value) {
                setState(() {
                  _borderWidth = value;
                });
                _updateBorder();
              },
              min: 0,
              max: 10,
              useSlider: true,
            ),
            const SizedBox(height: 12),
            
            // Border color
            ColorPropertyEditor(
              label: 'Color',
              value: _borderColor,
              onChanged: (value) {
                setState(() {
                  _borderColor = value ?? Colors.black;
                });
                _updateBorder();
              },
            ),
            const SizedBox(height: 12),
            
            // Border style
            DropdownPropertyEditor<BorderStyle>(
              label: 'Style',
              value: _borderStyle,
              items: const [
                DropdownMenuItem(
                  value: BorderStyle.solid,
                  child: Text('Solid'),
                ),
                DropdownMenuItem(
                  value: BorderStyle.none,
                  child: Text('None'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _borderStyle = value ?? BorderStyle.solid;
                });
                _updateBorder();
              },
            ),
          ],
        ],
      ],
    );
  }

  void _updateBorder() {
    if (_hasBorder) {
      final border = Border.all(
        color: _borderColor,
        width: _borderWidth,
        style: _borderStyle,
      );
      widget.onChanged(border);
    } else {
      widget.onChanged(null);
    }
  }
}
