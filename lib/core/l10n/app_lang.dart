import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface language. Street names stay as Night City proper nouns.
enum AppLang { uk, en }

final appLangProvider = StateNotifierProvider<AppLangController, AppLang>(
  (ref) => AppLangController(),
);

class AppLangController extends StateNotifier<AppLang> {
  AppLangController() : super(_fromSystem()) {
    _restore();
  }

  static const _key = 'cyber_corp_lang';
  var _ready = false;

  static AppLang _fromSystem() {
    final code = ui.PlatformDispatcher.instance.locale.languageCode;
    return code == 'uk' ? AppLang.uk : AppLang.en;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (_ready) return;
    _ready = true;
    if (saved == 'uk') {
      state = AppLang.uk;
    } else if (saved == 'en') {
      state = AppLang.en;
    }
  }

  Future<void> setLang(AppLang lang) async {
    _ready = true;
    state = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang.name);
  }

  /// Ignore a late restore that would clobber a choice made while loading.
  bool get restoreFinished => _ready;
}
