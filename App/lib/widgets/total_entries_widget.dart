import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TotalEntriesWidget extends StatelessWidget {
  final int totalEntries;

  const TotalEntriesWidget({super.key, required this.totalEntries});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          loc.totalEntries(totalEntries), // Lokalisierter Text
          style: const TextStyle(color: ColorProvider.n1),
        ),
      ),
    );
  }
}
