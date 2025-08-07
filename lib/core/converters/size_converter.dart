import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class SizeConverter implements JsonConverter<Size, Map<String, dynamic>> {
  const SizeConverter();

  @override
  Size fromJson(Map<String, dynamic> json) {
    return Size(json['width'] as double, json['height'] as double);
  }

  @override
  Map<String, dynamic> toJson(Size size) => {
        'width': size.width,
        'height': size.height,
      };
}
