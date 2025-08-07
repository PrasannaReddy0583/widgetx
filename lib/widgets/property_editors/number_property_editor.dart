import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';

/// Number property editor widget
class NumberPropertyEditor extends StatefulWidget {
  const NumberPropertyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.divisions,
    this.useSlider = false,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double? min;
  final double? max;
  final int? divisions;
  final bool useSlider;

  @override
  State<NumberPropertyEditor> createState() => _NumberPropertyEditorState();
}

class _NumberPropertyEditorState extends State<NumberPropertyEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _sliderValue = widget.value;
  }

  @override
  void didUpdateWidget(NumberPropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value.toString();
      _sliderValue = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _submitValue();
    }
  }

  void _submitValue() {
    final text = _controller.text.trim();
    final value = double.tryParse(text);
    if (value != null) {
      final clampedValue = _clampValue(value);
      widget.onChanged(clampedValue);
      if (clampedValue != value) {
        _controller.text = clampedValue.toString();
      }
    } else {
      _controller.text = widget.value.toString();
    }
  }

  double _clampValue(double value) {
    if (widget.min != null && value < widget.min!) {
      return widget.min!;
    }
    if (widget.max != null && value > widget.max!) {
      return widget.max!;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final shouldUseSlider = widget.useSlider || 
        (widget.min != null && widget.max != null && (widget.max! - widget.min!) <= 100);

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
        
        if (shouldUseSlider) ...[
          // Slider with text field
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _sliderValue.clamp(widget.min ?? 0, widget.max ?? 100),
                  min: widget.min ?? 0,
                  max: widget.max ?? 100,
                  divisions: widget.divisions,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      _controller.text = value.toStringAsFixed(
                        value % 1 == 0 ? 0 : 2,
                      );
                    });
                    widget.onChanged(value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                  ),
                  onSubmitted: (_) => _submitValue(),
                  onChanged: (value) {
                    final numValue = double.tryParse(value);
                    if (numValue != null) {
                      setState(() {
                        _sliderValue = numValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ] else ...[
          // Text field only
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    isDense: true,
                    suffixText: _getSuffix(),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                  onSubmitted: (_) => _submitValue(),
                ),
              ),
              
              // Increment/Decrement buttons
              Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 16,
                    child: IconButton(
                      onPressed: () => _increment(),
                      icon: const Icon(Icons.keyboard_arrow_up, size: 12),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    height: 16,
                    child: IconButton(
                      onPressed: () => _decrement(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 12),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        
        // Min/Max indicators
        if (widget.min != null || widget.max != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.min != null)
                  Text(
                    'Min: ${widget.min}',
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (widget.max != null)
                  Text(
                    'Max: ${widget.max}',
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String? _getSuffix() {
    // Add appropriate suffix based on the property type
    if (widget.label.toLowerCase().contains('width') || 
        widget.label.toLowerCase().contains('height') ||
        widget.label.toLowerCase().contains('size')) {
      return 'px';
    }
    if (widget.label.toLowerCase().contains('rotation') ||
        widget.label.toLowerCase().contains('angle')) {
      return '°';
    }
    if (widget.label.toLowerCase().contains('opacity') ||
        widget.label.toLowerCase().contains('alpha')) {
      return '%';
    }
    return null;
  }

  void _increment() {
    final currentValue = double.tryParse(_controller.text) ?? widget.value;
    final step = _getStep();
    final newValue = _clampValue(currentValue + step);
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  void _decrement() {
    final currentValue = double.tryParse(_controller.text) ?? widget.value;
    final step = _getStep();
    final newValue = _clampValue(currentValue - step);
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  double _getStep() {
    // Determine appropriate step size based on the range
    if (widget.min != null && widget.max != null) {
      final range = widget.max! - widget.min!;
      if (range <= 1) return 0.01;
      if (range <= 10) return 0.1;
      if (range <= 100) return 1;
      return 10;
    }
    return 1;
  }
}
