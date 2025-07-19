import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalizationViewModel extends StateNotifier<Locale> {
  LocalizationViewModel() : super(const Locale('en', ''));

  void setLocale(Locale locale) {
    if (state != locale) {
      state = locale;
    }
  }
}

final localizationViewModelProvider = StateNotifierProvider<LocalizationViewModel, Locale>(
      (ref) => LocalizationViewModel(),
);