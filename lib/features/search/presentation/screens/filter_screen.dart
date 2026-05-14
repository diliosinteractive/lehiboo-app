import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.searchFiltersTitle),
      ),
      body: Center(
        child: Text(context.l10n.searchFiltersTitle),
      ),
    );
  }
}
