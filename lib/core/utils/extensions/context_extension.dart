import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  /// Returns the current locale of the app.
  Locale get localeExt => Localizations.localeOf(this);

  /// Returns the current theme of the app.
  ThemeData get themeExt => Theme.of(this);

  /// Returns the cyrrent size of the screen.
  Size get sizeExt => MediaQuery.sizeOf(this);

  /// Returns the current padding of the screen.
  EdgeInsets get paddingExt => MediaQuery.paddingOf(this);
}
