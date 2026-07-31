import '../../data/models/tool_result_dto.dart';

/// Removes intermediate empty event searches from one assistant turn.
///
/// Petit Boo may retry `searchEvents` with progressively broader filters. Each
/// attempt is useful to the agent, but rendering every empty attempt produces
/// repeated "No events found" cards before the final result. Other tools are
/// deliberately left untouched because repeated actions can be intentional.
List<ToolResultDto> visiblePetitBooToolResults(
  List<ToolResultDto> results,
) {
  final emptySearchIndexes = <int>{};
  var hasNonEmptySearch = false;

  for (var index = 0; index < results.length; index++) {
    final result = results[index];
    if (!_isEventSearch(result.tool)) continue;

    switch (_eventSearchState(result.data)) {
      case _EventSearchState.empty:
        emptySearchIndexes.add(index);
      case _EventSearchState.nonEmpty:
        hasNonEmptySearch = true;
      case _EventSearchState.unknown:
        break;
    }
  }

  if (emptySearchIndexes.isEmpty) return results;

  // If every search was empty, retain only the most recent empty state. When
  // a later search succeeded, all earlier empty attempts are intermediate.
  final retainedEmptyIndex = hasNonEmptySearch
      ? null
      : emptySearchIndexes.reduce((a, b) => a > b ? a : b);

  return [
    for (var index = 0; index < results.length; index++)
      if (!emptySearchIndexes.contains(index) || index == retainedEmptyIndex)
        results[index],
  ];
}

bool _isEventSearch(String tool) =>
    tool == 'searchEvents' || tool == 'search_events';

enum _EventSearchState { empty, nonEmpty, unknown }

_EventSearchState _eventSearchState(Map<String, dynamic> result) {
  if (result['success'] == false) return _EventSearchState.unknown;

  var payload = result;
  final nestedData = payload['data'];
  if (nestedData is Map) {
    payload = Map<String, dynamic>.from(nestedData);
  }
  if (payload['success'] == false) return _EventSearchState.unknown;

  final events = payload['events'];
  if (events is List) {
    return events.isEmpty
        ? _EventSearchState.empty
        : _EventSearchState.nonEmpty;
  }

  final total = payload['total'];
  if (total is num && total == 0) return _EventSearchState.empty;
  if (total is String) {
    final parsed = num.tryParse(total.trim());
    if (parsed == 0) return _EventSearchState.empty;
  }

  // Unknown/error payloads remain visible instead of being mistaken for an
  // empty successful search.
  return _EventSearchState.unknown;
}
