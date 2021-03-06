import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_admin/common/cry_root.dart';
import 'package:flutter_admin/enum/MenuDisplayType.dart';

Locale _deviceLocale;

Locale get deviceLocale => _deviceLocale;

set deviceLocale(Locale locale) {
  _deviceLocale ??= locale;
}

class Configuration {
  final Locale _locale;
  final Color themeColor;
  final MenuDisplayType menuDisplayType;

  const Configuration({
    locale,
    this.themeColor,
    this.menuDisplayType,
  }) : _locale = locale;

  Locale get locale => _locale ?? deviceLocale;

  static Configuration of(BuildContext context) {
    return CryRootScope.of(context).state.configuration;
  }

  Configuration copyWith({
    Locale locale,
    Color themeColor,
    MenuDisplayType menuDisplayType,
  }) {
    return Configuration(
      locale: locale ?? this.locale,
      themeColor: themeColor ?? this.themeColor,
      menuDisplayType: menuDisplayType ?? this.menuDisplayType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locale': locale,
      'themeColor': themeColor?.value,
      'menuDisplayType': menuDisplayType?.toString(),
    };
  }

  factory Configuration.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Configuration(
      locale: map['locale'],
      themeColor: Color(map['themeColor']),
      menuDisplayType: map['menuDisplayType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Configuration.fromJson(String source) => Configuration.fromMap(json.decode(source));

  @override
  String toString() => 'Configuration(locale: $locale, themeColor: $themeColor, menuDisplayType: $menuDisplayType)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Configuration && o.locale == locale && o.themeColor == themeColor && o.menuDisplayType == menuDisplayType;
  }

  @override
  int get hashCode => locale.hashCode ^ themeColor.hashCode ^ menuDisplayType.hashCode;
}
