import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import 'number_property_editor.dart';

/// EdgeInsets property editor widget
class EdgeInsetsPropertyEditor extends StatefulWidget {
  const EdgeInsetsPropertyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets value;
  final ValueChanged<EdgeInsets> onChanged;

  @override
  State<EdgeInsetsPropertyEditor> createState() => _EdgeInsetsPropertyEditorState();
}

class _EdgeInsetsPropertyEditorState extends State<EdgeInsetsPropertyEditor> {
  bool _isLinked = true;

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
            IconButton(
              onPressed: () {
                setState(() {
                  _isLinked = !_isLinked;
                });
              },
              icon: Icon(
                _isLinked ? Icons.link : Icons.link_off,
                size: 14,
                color: _isLinked ? AppColors.primary : AppColors.textSecondary,
              ),
              tooltip: _isLinked ? 'Unlink values' : 'Link values',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        if (_isLinked) ...[
          // Single value for all sides
          NumberPropertyEditor(
            label: 'All Sides',
            value: widget.value.top,
            onChanged: (value) {
              widget.onChanged(EdgeInsets.all(value));
            },
            min: 0,
            max: 100,
          ),
        ] else ...[
          // Individual values
          Row(
            children: [
              Expanded(
                child: NumberPropertyEditor(
                  label: 'Top',
                  value: widget.value.top,
                  onChanged: (value) {
                    widget.onChanged(widget.value.copyWith(top: value));
                  },
                  min: 0,
                  max: 100,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NumberPropertyEditor(
                  label: 'Right',
                  value: widget.value.right,
                  onChanged: (value) {
                    widget.onChanged(widget.value.copyWith(right: value));
                  },
                  min: 0,
                  max: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: NumberPropertyEditor(
                  label: 'Bottom',
                  value: widget.value.bottom,
                  onChanged: (value) {
                    widget.onChanged(widget.value.copyWith(bottom: value));
                  },
                  min: 0,
                  max: 100,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NumberPropertyEditor(
                  label: 'Left',
                  value: widget.value.left,
                  onChanged: (value) {
                    widget.onChanged(widget.value.copyWith(left: value));
                  },
                  min: 0,
                  max: 100,
                ),
              ),
            ],
          ),
        ],
        
        // Visual representation
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              // Outer box
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                ),
              ),
              
              // Inner box with padding
              Positioned(
                top: widget.value.top / 2,
                left: widget.value.left / 2,
                right: widget.value.right / 2,
                bottom: widget.value.bottom / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                ),
              ),
              
              // Labels
              if (widget.value.top > 0)
                Positioned(
                  top: 2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.value.top.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              if (widget.value.bottom > 0)
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.value.bottom.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              if (widget.value.left > 0)
                Positioned(
                  left: 2,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      widget.value.left.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              if (widget.value.right > 0)
                Positioned(
                  right: 2,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      widget.value.right.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
