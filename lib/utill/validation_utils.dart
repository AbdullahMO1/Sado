import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';

class ValidationUtils {
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return getTranslated('email_is_required', context);
    }
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return getTranslated('enter_valid_email_address', context);
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return getTranslated('password_is_required', context);
    }
    if (value.length < 8) {
      return getTranslated('minimum_password_length', context);
    }
    if (!isPasswordComplex(value)) {
      return getTranslated('password_complexity_requirements', context);
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword, BuildContext context) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return getTranslated('confirm_password_must_be_required', context);
    }
    if (password != confirmPassword) {
      return getTranslated('password_did_not_match', context);
    }
    return null;
  }

  static String? validateFirstName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return getTranslated('first_name_field_is_required', context);
    }
    if (value.length < 2) {
      return getTranslated('name_must_be_at_least_2_characters', context);
    }
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return getTranslated('name_can_only_contain_letters', context);
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return getTranslated('phone_number_is_required', context);
    }
    final phoneRegExp = RegExp(r'^\+?[\d-]{10,}$');
    if (!phoneRegExp.hasMatch(value)) {
      return getTranslated('enter_valid_phone_number', context);
    }
    return null;
  }

  /// Checks password complexity requirements
  static bool isPasswordComplex(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }
}
