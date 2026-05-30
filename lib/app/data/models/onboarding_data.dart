import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final String? image;
  final IconData? icon;

  OnboardingData({
    required this.title,
    required this.description,
    this.image,
    this.icon,
  });
}