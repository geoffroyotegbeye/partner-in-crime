import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskFiltersWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const TaskFiltersWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'id': 'all', 'label': 'All', 'icon': Icons.list},
      {'id': 'high', 'label': 'High Priority', 'icon': Icons.priority_high},
      {'id': 'medium', 'label': 'Medium', 'icon': Icons.remove},
      {'id': 'low', 'label': 'Low Priority', 'icon': Icons.keyboard_arrow_down},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter['id'];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              onSelected: (_) => onFilterChanged(filter['id'] as String),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(179),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(179),
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withAlpha(51),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
