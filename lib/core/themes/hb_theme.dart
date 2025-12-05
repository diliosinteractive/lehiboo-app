import 'package:flutter/material.dart';
import 'lehiboo_tokens.dart';
import 'spacing.dart';

class HbTheme {
  static LeHibooTokens tokens(BuildContext context) =>
      Theme.of(context).extension<LeHibooTokens>()!;

  static HbSpacing spacing(BuildContext context) =>
      tokens(context).spacing;
}
