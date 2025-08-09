import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvancedFilterPanelWidget extends StatefulWidget {
  final Function(String) onFilterChanged;

  const AdvancedFilterPanelWidget({
    Key? key,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<AdvancedFilterPanelWidget> createState() =>
      _AdvancedFilterPanelWidgetState();
}

class _AdvancedFilterPanelWidgetState extends State<AdvancedFilterPanelWidget> {
  String _sortBy = 'due_date';
  String _filterBy = 'all';
  bool _showCompleted = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(26),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Filters',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Sort by dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort by',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(179),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withAlpha(77),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        value: _sortBy,
                        onChanged: (value) => setState(() => _sortBy = value!),
                        underline: const SizedBox(),
                        isExpanded: true,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'due_date', child: Text('Due Date')),
                          DropdownMenuItem(
                              value: 'priority', child: Text('Priority')),
                          DropdownMenuItem(
                              value: 'category', child: Text('Category')),
                          DropdownMenuItem(
                              value: 'coin_value', child: Text('Coin Value')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Filter by category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(179),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withAlpha(77),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        value: _filterBy,
                        onChanged: (value) {
                          setState(() => _filterBy = value!);
                          widget.onFilterChanged(value!);
                        },
                        underline: const SizedBox(),
                        isExpanded: true,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'all', child: Text('All Categories')),
                          DropdownMenuItem(value: 'work', child: Text('Work')),
                          DropdownMenuItem(
                              value: 'health', child: Text('Health')),
                          DropdownMenuItem(
                              value: 'learning', child: Text('Learning')),
                          DropdownMenuItem(
                              value: 'personal', child: Text('Personal')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Show completed toggle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completed',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(179),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Switch(
                    value: _showCompleted,
                    onChanged: (value) =>
                        setState(() => _showCompleted = value),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
