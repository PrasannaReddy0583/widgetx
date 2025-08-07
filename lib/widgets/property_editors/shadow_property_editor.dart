import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import 'color_property_editor.dart';
import 'number_property_editor.dart';

/// Shadow property editor widget
class ShadowPropertyEditor extends StatefulWidget {
  const ShadowPropertyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final BoxShadow? value;
  final ValueChanged<BoxShadow?> onChanged;

  @override
  State<ShadowPropertyEditor> createState() => _ShadowPropertyEditorState();
}

class _ShadowPropertyEditorState extends State<ShadowPropertyEditor> {
  bool _isExpanded = false;
  bool _hasShadow = false;
  Color _shadowColor = Colors.black26;
  double _blurRadius = 4.0;
  double _spreadRadius = 0.0;
  Offset _offset = const Offset(0, 2);

  @override
  void initState() {
    super.initState();
    _initializeFromValue();
  }

  @override
  void didUpdateWidget(ShadowPropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initializeFromValue();
    }
  }

  void _initializeFromValue() {
    if (widget.value != null) {
      _hasShadow = true;
      _shadowColor = widget.value!.color;
      _blurRadius = widget.value!.blurRadius;
      _spreadRadius = widget.value!.spreadRadius;
      _offset = widget.value!.offset;
    } else {
      _hasShadow = false;
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
              value: _hasShadow,
              onChanged: (value) {
                setState(() {
                  _hasShadow = value;
                });
                _updateShadow();
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        if (_hasShadow) ...[
          // Shadow preview
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: _shadowColor,
                    blurRadius: _blurRadius,
                    spreadRadius: _spreadRadius,
                    offset: _offset,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Shadow Preview',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
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
                  'Shadow Settings',
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
            
            // Shadow color
            ColorPropertyEditor(
              label: 'Color',
              value: _shadowColor,
              onChanged: (value) {
                setState(() {
                  _shadowColor = value ?? Colors.black26;
                });
                _updateShadow();
              },
            ),
            const SizedBox(height: 12),
            
            // Blur radius
            NumberPropertyEditor(
              label: 'Blur Radius',
              value: _blurRadius,
              onChanged: (value) {
                setState(() {
                  _blurRadius = value;
                });
                _updateShadow();
              },
              min: 0,
              max: 20,
              useSlider: true,
            ),
            const SizedBox(height: 12),
            
            // Spread radius
            NumberPropertyEditor(
              label: 'Spread Radius',
              value: _spreadRadius,
              onChanged: (value) {
                setState(() {
                  _spreadRadius = value;
                });
                _updateShadow();
              },
              min: -10,
              max: 10,
              useSlider: true,
            ),
            const SizedBox(height: 12),
            
            // Offset
            Row(
              children: [
                Expanded(
                  child: NumberPropertyEditor(
                    label: 'Offset X',
                    value: _offset.dx,
                    onChanged: (value) {
                      setState(() {
                        _offset = Offset(value, _offset.dy);
                      });
                      _updateShadow();
                    },
                    min: -20,
                    max: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: NumberPropertyEditor(
                    label: 'Offset Y',
                    value: _offset.dy,
                    onChanged: (value) {
                      setState(() {
                        _offset = Offset(_offset.dx, value);
                      });
                      _updateShadow();
                    },
                    min: -20,
                    max: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Preset shadows
            const Text(
              'Presets',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildPresetButton('None', null),
                _buildPresetButton(
                  'Subtle',
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ),
                _buildPresetButton(
                  'Medium',
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ),
                _buildPresetButton(
                  'Strong',
                  const BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildPresetButton(String label, BoxShadow? shadow) {
    return OutlinedButton(
      onPressed: () {
        if (shadow != null) {
          setState(() {
            _hasShadow = true;
            _shadowColor = shadow.color;
            _blurRadius = shadow.blurRadius;
            _spreadRadius = shadow.spreadRadius;
            _offset = shadow.offset;
          });
        } else {
          setState(() {
            _hasShadow = false;
          });
        }
        _updateShadow();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  void _updateShadow() {
    if (_hasShadow) {
      final shadow = BoxShadow(
        color: _shadowColor,
        blurRadius: _blurRadius,
        spreadRadius: _spreadRadius,
        offset: _offset,
      );
      widget.onChanged(shadow);
    } else {
      widget.onChanged(null);
    }
  }
}
