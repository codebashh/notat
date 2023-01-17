import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'app_dimensions.dart';
import 'app_theme.dart';
import 'app_typography.dart';
import 'space.dart';
import 'ui.dart';
import 'ui_props.dart';

class App {
  static bool? isLtr;
  static bool showAds = false;

  static Future<void> init(BuildContext context) async{
    UI.init(context);
    AppDimensions.init();
    AppTheme.init(context);
    UIProps.init();
    Space.init();
    AppText.init();
   
    isLtr = Directionality.of(context) == TextDirection.ltr;
   
    
  }

  static String format(num number, [String? currencyPrefix]) {
    if (currencyPrefix != null && currencyPrefix.contains(" ")) {
      currencyPrefix = currencyPrefix.substring(0, currencyPrefix.length - 1);
    }
    return NumberFormat.currency(
      locale: 'ur',
      symbol: currencyPrefix ?? '£',
      decimalDigits: 0,
    ).format(
      number,
    );
  }
}
