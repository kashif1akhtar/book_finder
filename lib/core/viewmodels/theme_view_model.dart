import 'package:book_finder/core/viewmodels/theme_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeViewModel extends StateNotifier<ThemeModel> {
  ThemeViewModel() : super(ThemeModel(isDark: false));

  void toggleTheme() {
    state = ThemeModel(isDark: !state.isDark);
  }
}

final themeViewModelProvider = StateNotifierProvider<ThemeViewModel, ThemeModel>(
      (ref) => ThemeViewModel(),
);