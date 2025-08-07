import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../core/theme/colors.dart';
import '../core/constants/widget_types.dart';
import '../models/property_model.dart';

/// Property editors for different property types
class PropertyEditors {
  /// Helper method to parse color values from various formats
  static Color _parseColorValue(dynamic value) {
    if (value == null) return Colors.blue;
    
    if (value is Color) {
      return value;
    }
    
    if (value is int) {
      return Color(value);
    }
    
    if (value is String) {
      // Handle hex color strings like "#FF0000" or "0xFFFF0000"
      if (value.startsWith('#')) {
        final hex = value.substring(1);
        final colorValue = int.parse(hex, radix: 16);
        return Color(colorValue | 0xFF000000); // Add alpha channel if missing
      } else if (value.startsWith('0x')) {
        final colorValue = int.parse(value, radix: 16);
        return Color(colorValue);
      }
    }
    
    // Default fallback
    return Colors.blue;
  }

  /// Helper method to parse EdgeInsets values
  static EdgeInsets _parseEdgeInsets(dynamic value) {
    if (value == null) return EdgeInsets.zero;
    
    if (value is EdgeInsets) {
      return value;
    }
    
    if (value is double || value is int) {
      final doubleValue = value.toDouble();
      return EdgeInsets.all(doubleValue);
    }
    
    if (value is Map) {
      return EdgeInsets.fromLTRB(
        (value['left'] as num?)?.toDouble() ?? 0,
        (value['top'] as num?)?.toDouble() ?? 0,
        (value['right'] as num?)?.toDouble() ?? 0,
        (value['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    
    // Default fallback
    return EdgeInsets.zero;
  }

  /// Helper method to parse BorderRadius values
  static BorderRadius _parseBorderRadius(dynamic value) {
    if (value == null) return BorderRadius.zero;
    
    if (value is BorderRadius) {
      return value;
    }
    
    if (value is double || value is int) {
      final doubleValue = value.toDouble();
      return BorderRadius.circular(doubleValue);
    }
    
    // Default fallback
    return BorderRadius.zero;
  }

  /// Create appropriate editor widget for property type
  static Widget createEditor({
    required PropertyDefinition definition,
    required dynamic value,
    String? errorMessage,
    required ValueChanged<dynamic> onChanged,
  }) {
    switch (definition.type) {
      case PropertyType.text:
        return _StringEditor(
          value: value?.toString() ?? '',
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
      
      case PropertyType.number:
        return _NumberEditor(
          value: value?.toDouble() ?? 0.0,
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
      
      case PropertyType.boolean:
        return _BooleanEditor(
          value: value == true,
          onChanged: onChanged,
        );
      
      case PropertyType.color:
        return _ColorEditor(
          value: _parseColorValue(value),
          onChanged: (color) => onChanged(color.value), // Convert Color to int for storage
        );
      
      case PropertyType.alignment:
        return _AlignmentEditor(
          value: value is AlignmentOption ? value : AlignmentOption.center,
          onChanged: onChanged,
        );
      
      case PropertyType.edgeInsets:
        return _EdgeInsetsEditor(
          value: _parseEdgeInsets(value),
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
      
      case PropertyType.borderRadius:
        return _BorderRadiusEditor(
          value: _parseBorderRadius(value),
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
      
      case PropertyType.icon:
        return _IconEditor(
          value: value is IconData ? value : Icons.star,
          onChanged: onChanged,
        );
      
      case PropertyType.list:
        return _ListEditor(
          value: value is List ? value : [],
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
      
      default:
        return _StringEditor(
          value: value?.toString() ?? '',
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
    }
  }
}

/// String property editor
class _StringEditor extends StatefulWidget {
  const _StringEditor({
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? errorMessage;

  @override
  State<_StringEditor> createState() => _StringEditorState();
}

class _StringEditorState extends State<_StringEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_StringEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: widget.errorMessage != null ? AppColors.error : AppColors.borderLight,
          ),
        ),
        errorText: widget.errorMessage,
        errorStyle: const TextStyle(fontSize: 10),
      ),
      onChanged: widget.onChanged,
    );
  }
}

/// Number property editor
class _NumberEditor extends StatefulWidget {
  const _NumberEditor({
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String? errorMessage;

  @override
  State<_NumberEditor> createState() => _NumberEditorState();
}

class _NumberEditorState extends State<_NumberEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NumberEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(fontSize: 12),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: widget.errorMessage != null ? AppColors.error : AppColors.borderLight,
          ),
        ),
        errorText: widget.errorMessage,
        errorStyle: const TextStyle(fontSize: 10),
      ),
      onChanged: (value) {
        final number = double.tryParse(value);
        if (number != null) {
          widget.onChanged(number);
        }
      },
    );
  }
}

/// Boolean property editor
class _BooleanEditor extends StatelessWidget {
  const _BooleanEditor({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 8),
        Text(
          value ? 'True' : 'False',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Color property editor
class _ColorEditor extends StatelessWidget {
  const _ColorEditor({
    required this.value,
    required this.onChanged,
  });

  final Color value;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showColorPicker(context),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: value,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: value,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '#${value.value.toRadixString(16).substring(2).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: value,
            onColorChanged: onChanged,
            enableAlpha: true,
            displayThumbColor: true,
            showLabel: true,
            paletteType: PaletteType.hsl,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

/// Alignment property editor
class _AlignmentEditor extends StatelessWidget {
  const _AlignmentEditor({
    required this.value,
    required this.onChanged,
  });

  final AlignmentOption value;
  final ValueChanged<AlignmentOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AlignmentOption>(
      value: value,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      items: AlignmentOption.values.map((alignment) {
        return DropdownMenuItem(
          value: alignment,
          child: Text(
            alignment.name,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}

/// Icon property editor
class _IconEditor extends StatelessWidget {
  const _IconEditor({
    required this.value,
    required this.onChanged,
  });

  final IconData value;
  final ValueChanged<IconData> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showIconPicker(context),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(value, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value.codePoint.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }

  void _showIconPicker(BuildContext context) {
    final commonIcons = [
      Icons.star, Icons.favorite, Icons.home, Icons.settings,
      Icons.search, Icons.add, Icons.remove, Icons.edit,
      Icons.delete, Icons.check, Icons.close, Icons.arrow_forward,
      Icons.arrow_back, Icons.arrow_upward, Icons.arrow_downward,
      Icons.play_arrow, Icons.pause, Icons.stop, Icons.refresh,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick an icon'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: commonIcons.length,
            itemBuilder: (context, index) {
              final icon = commonIcons[index];
              return InkWell(
                onTap: () {
                  onChanged(icon);
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: icon == value ? AppColors.primary : AppColors.borderLight,
                      width: icon == value ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(icon, size: 24),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// List property editor
class _ListEditor extends StatefulWidget {
  const _ListEditor({
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final List<dynamic> value;
  final ValueChanged<List<dynamic>> onChanged;
  final String? errorMessage;

  @override
  State<_ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends State<_ListEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value.join(', '),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: widget.errorMessage != null ? AppColors.error : AppColors.borderLight,
          ),
        ),
        hintText: 'Enter comma-separated values',
        hintStyle: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
        errorText: widget.errorMessage,
        errorStyle: const TextStyle(fontSize: 10),
      ),
      onChanged: (value) {
        final items = value.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
        widget.onChanged(items);
      },
    );
  }
}

/// EdgeInsets property editor
class _EdgeInsetsEditor extends StatelessWidget {
  const _EdgeInsetsEditor({
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final EdgeInsets value;
  final ValueChanged<EdgeInsets> onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: errorMessage != null ? AppColors.error : AppColors.borderLight,
              ),
            ),
            hintText: 'All sides (e.g., 16.0)',
            hintStyle: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
            errorText: errorMessage,
            errorStyle: const TextStyle(fontSize: 10),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (text) {
            final number = double.tryParse(text);
            if (number != null) {
              onChanged(EdgeInsets.all(number));
            }
          },
        ),
      ],
    );
  }
}

/// BorderRadius property editor
class _BorderRadiusEditor extends StatelessWidget {
  const _BorderRadiusEditor({
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final BorderRadius value;
  final ValueChanged<BorderRadius> onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: errorMessage != null ? AppColors.error : AppColors.borderLight,
              ),
            ),
            hintText: 'Radius (e.g., 8.0)',
            hintStyle: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
            errorText: errorMessage,
            errorStyle: const TextStyle(fontSize: 10),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (text) {
            final number = double.tryParse(text);
            if (number != null) {
              onChanged(BorderRadius.circular(number));
            }
          },
        ),
      ],
    );
  }
}
