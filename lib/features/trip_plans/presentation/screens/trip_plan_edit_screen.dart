import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/trip_plan.dart';
import '../providers/trip_plans_provider.dart';

class TripPlanEditScreen extends ConsumerStatefulWidget {
  final String planUuid;

  const TripPlanEditScreen({
    super.key,
    required this.planUuid,
  });

  @override
  ConsumerState<TripPlanEditScreen> createState() => _TripPlanEditScreenState();
}

class _TripPlanEditScreenState extends ConsumerState<TripPlanEditScreen> {
  late TextEditingController _titleController;
  DateTime? _selectedDate;
  List<TripStop> _stops = [];
  bool _isLoading = false;
  bool _hasChanges = false;
  bool _initialized = false;

  static const Color _accentColor = Color(0xFF27AE60);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  void _initFromPlan(TripPlan plan) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = plan.title;
    _selectedDate = plan.plannedDate;
    _stops = List.from(plan.stops);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(tripPlansProvider);

    return plansAsync.when(
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: const Text('Modifier'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF2D3748),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator(color: _accentColor)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: const Text('Modifier'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF2D3748),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (plans) {
        final plan = plans.where((p) => p.uuid == widget.planUuid).firstOrNull;
        if (plan == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F8FA),
            appBar: AppBar(
              title: const Text('Modifier'),
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: const Color(0xFF2D3748),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Plan non trouvé')),
          );
        }

        // Initialize form data from plan
        if (!_initialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initFromPlan(plan);
            setState(() {});
          });
        }

        return _buildEditScreen(context, plan);
      },
    );
  }

  Widget _buildEditScreen(BuildContext context, TripPlan plan) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Modifier'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF2D3748),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _onBack(context),
        ),
        actions: [
          TextButton(
            onPressed: _hasChanges && !_isLoading ? _onSave : null,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _accentColor,
                    ),
                  )
                : Text(
                    'Enregistrer',
                    style: TextStyle(
                      color: _hasChanges ? _accentColor : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator(color: _accentColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  _buildSectionLabel('Titre'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _accentColor, width: 2),
                      ),
                      hintText: 'Nom de la sortie',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (_) => _checkChanges(),
                  ),
                  const SizedBox(height: 24),

                  // Date picker
                  _buildSectionLabel('Date'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: _accentColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? _formatDate(_selectedDate!)
                                : 'Sélectionner une date',
                            style: TextStyle(
                              fontSize: 15,
                              color: _selectedDate != null
                                  ? const Color(0xFF2D3748)
                                  : Colors.grey[500],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stops reorderable list
                  Row(
                    children: [
                      _buildSectionLabel('Étapes'),
                      const Spacer(),
                      Text(
                        'Glisser pour réorganiser',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: _stops.length,
                      onReorder: _onReorder,
                      itemBuilder: (context, index) {
                        final stop = _stops[index];
                        return _buildStopItem(
                          key: ValueKey(stop.eventUuid ?? index),
                          index: index,
                          stop: stop,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildStopItem({
    required Key key,
    required int index,
    required TripStop stop,
  }) {
    final isLast = index == _stops.length - 1;

    return Container(
      key: key,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Drag handle
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                  size: 22,
                ),
              ),
            ),
            // Order number
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: _accentColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.eventTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (stop.locationString.isNotEmpty)
                    Text(
                      stop.locationString,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Time
            if (stop.arrivalTime != null)
              Text(
                stop.arrivalTime!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _accentColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _stops.removeAt(oldIndex);
      _stops.insert(newIndex, item);

      // Update order numbers
      _stops = _stops.asMap().entries.map((entry) {
        return entry.value.copyWith(order: entry.key + 1);
      }).toList();

      _hasChanges = true;
    });
  }

  Future<void> _pickDate() async {
    HapticFeedback.selectionClick();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3748),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && date != _selectedDate) {
      setState(() {
        _selectedDate = date;
        _hasChanges = true;
      });
    }
  }

  void _checkChanges() {
    final plan = ref.read(tripPlansProvider.notifier).getTripPlan(widget.planUuid);
    if (plan == null) return;

    final titleChanged = _titleController.text != plan.title;
    final dateChanged = _selectedDate != plan.plannedDate;
    final stopsChanged = _stopsOrderChanged(plan.stops);

    setState(() {
      _hasChanges = titleChanged || dateChanged || stopsChanged;
    });
  }

  bool _stopsOrderChanged(List<TripStop> originalStops) {
    if (_stops.length != originalStops.length) return true;
    for (int i = 0; i < _stops.length; i++) {
      if (_stops[i].eventUuid != originalStops[i].eventUuid) return true;
    }
    return false;
  }

  Future<void> _onSave() async {
    if (!_hasChanges) return;

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    try {
      final stopsOrder = _stops
          .where((s) => s.eventUuid != null)
          .map((s) => s.eventUuid!)
          .toList();

      await ref.read(tripPlansProvider.notifier).updateTripPlan(
        uuid: widget.planUuid,
        title: _titleController.text.trim(),
        plannedDate: _selectedDate,
        stopsOrder: stopsOrder.isNotEmpty ? stopsOrder : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Plan mis à jour'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onBack(BuildContext context) {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Abandonner les modifications ?'),
          content: const Text('Vos modifications ne seront pas sauvegardées.'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continuer',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Abandonner'),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    final formatted = formatter.format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}
