import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';

/// Fallback card for unknown tool types
/// Displays minimal information when no schema is available
class UnknownToolCard extends StatelessWidget {
  final String toolName;
  final Map<String, dynamic> data;

  const UnknownToolCard({
    super.key,
    required this.toolName,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Try to extract some meaningful info from the data
    final itemCount = _extractItemCount();
    final message = _extractMessage();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.extension,
              color: HbColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatToolName(toolName),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
                if (message != null)
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: HbColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                else if (itemCount != null)
                  Text(
                    '$itemCount élément${itemCount != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color: HbColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Try to extract a count from common keys
  int? _extractItemCount() {
    // Try common count keys
    for (final key in ['total', 'count', 'total_count']) {
      final value = data[key];
      if (value is int) return value;
    }

    // Try to count list items
    for (final key in data.keys) {
      final value = data[key];
      if (value is List) return value.length;
    }

    return null;
  }

  /// Try to extract a message from the data
  String? _extractMessage() {
    // Check for message or error
    for (final key in ['message', 'error', 'description', 'summary']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  /// Format camelCase tool name to readable text
  String _formatToolName(String name) {
    // Remove common prefixes
    var formatted = name;
    for (final prefix in ['get', 'list', 'search', 'find']) {
      if (formatted.toLowerCase().startsWith(prefix)) {
        formatted = formatted.substring(prefix.length);
        break;
      }
    }

    // Convert camelCase to spaces
    final buffer = StringBuffer();
    for (var i = 0; i < formatted.length; i++) {
      final char = formatted[i];
      if (i > 0 && char == char.toUpperCase() && char != char.toLowerCase()) {
        buffer.write(' ');
      }
      buffer.write(i == 0 ? char.toUpperCase() : char);
    }

    return buffer.toString();
  }
}
