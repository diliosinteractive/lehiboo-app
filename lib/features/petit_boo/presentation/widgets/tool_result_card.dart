import 'package:flutter/material.dart';

import '../../data/models/tool_result_dto.dart';
import 'tool_cards/dynamic_tool_result_card.dart';

/// Routes tool results to the dynamic card system
/// This widget serves as the entry point for displaying tool results
/// The actual rendering is delegated to DynamicToolResultCard which
/// uses schemas from the API to determine how to display the data
class ToolResultCard extends StatelessWidget {
  final ToolResultDto result;

  const ToolResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicToolResultCard(
      toolName: result.tool,
      data: result.data,
    );
  }
}
