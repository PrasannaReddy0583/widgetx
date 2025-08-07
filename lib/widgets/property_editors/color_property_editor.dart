import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

/// Color property editor widget
class ColorPropertyEditor extends StatefulWidget {
  const ColorPropertyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final Color? value;
  final ValueChanged<Color?> onChanged;

  @override
  State<ColorPropertyEditor> createState() => _ColorPropertyEditorState();
}

class _ColorPropertyEditorState extends State<ColorPropertyEditor> {
  static const List<Color> _presetColors = [
    Colors.transparent,
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Color preview
            InkWell(
              onTap: _showColorPicker,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.value ?? Colors.transparent,
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: widget.value == null || widget.value == Colors.transparent
                    ? const Icon(
                        Icons.block,
                        size: 16,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            
            // Color value text
            Expanded(
              child: Text(
                widget.value == null
                    ? 'No color'
                    : widget.value == Colors.transparent
                        ? 'Transparent'
                        : '#${widget.value!.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            
            // Clear button
            if (widget.value != null)
              IconButton(
                onPressed: () => widget.onChanged(null),
                icon: const Icon(Icons.clear, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Preset colors
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: _presetColors.map((color) {
            final isSelected = widget.value == color;
            return InkWell(
              onTap: () => widget.onChanged(color),
              borderRadius: BorderRadius.circular(2),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: color == Colors.transparent
                    ? const Icon(
                        Icons.block,
                        size: 12,
                        color: AppColors.textSecondary,
                      )
                    : isSelected
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: _getContrastColor(color),
                          )
                        : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => _ColorPickerDialog(
        initialColor: widget.value ?? Colors.blue,
        onColorChanged: widget.onChanged,
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if we should use black or white text
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Custom color picker dialog
class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({
    required this.initialColor,
    required this.onColorChanged,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;
  late double _hue;
  late double _saturation;
  late double _lightness;
  late double _alpha;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    final hsl = HSLColor.fromColor(_selectedColor);
    _hue = hsl.hue;
    _saturation = hsl.saturation;
    _lightness = hsl.lightness;
    _alpha = _selectedColor.alpha / 255.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a Color'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color preview
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedColor,
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            
            // Hue slider
            _buildSlider(
              'Hue',
              _hue,
              0,
              360,
              (value) {
                setState(() {
                  _hue = value;
                  _updateColor();
                });
              },
            ),
            
            // Saturation slider
            _buildSlider(
              'Saturation',
              _saturation,
              0,
              1,
              (value) {
                setState(() {
                  _saturation = value;
                  _updateColor();
                });
              },
            ),
            
            // Lightness slider
            _buildSlider(
              'Lightness',
              _lightness,
              0,
              1,
              (value) {
                setState(() {
                  _lightness = value;
                  _updateColor();
                });
              },
            ),
            
            // Alpha slider
            _buildSlider(
              'Opacity',
              _alpha,
              0,
              1,
              (value) {
                setState(() {
                  _alpha = value;
                  _updateColor();
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onColorChanged(_selectedColor);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(label == 'Hue' ? 0 : 2)}',
          style: const TextStyle(fontSize: 12),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _updateColor() {
    _selectedColor = HSLColor.fromAHSL(_alpha, _hue, _saturation, _lightness).toColor();
  }
}
