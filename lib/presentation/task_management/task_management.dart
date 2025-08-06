import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/advanced_filter_panel_widget.dart';
import './widgets/quick_task_creation_widget.dart';
import './widgets/task_list_widget.dart';
import './widgets/task_stats_widget.dart';

class TaskManagement extends StatefulWidget {
  const TaskManagement({Key? key}) : super(key: key);

  @override
  State<TaskManagement> createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showAdvancedFilters = false;
  String _searchQuery = '';
  String _selectedFilter = 'all';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isRefreshing = true);
    // Simulate loading tasks
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isRefreshing = false);
  }

  void _showQuickTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickTaskCreationWidget(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          'Task Management',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _showAdvancedFilters = !_showAdvancedFilters);
            },
            icon: Icon(
              _showAdvancedFilters ? Icons.close : Icons.tune,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(51),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      hintStyle: GoogleFonts.inter(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tab bar
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurface.withAlpha(153),
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 3,
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'This Week'),
                  Tab(text: 'All Tasks'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Stats overview
              const TaskStatsWidget(),

              // Advanced filters panel
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showAdvancedFilters ? 120 : 0,
                child: _showAdvancedFilters
                    ? AdvancedFilterPanelWidget(
                        onFilterChanged: (filter) {
                          setState(() => _selectedFilter = filter);
                        },
                      )
                    : null,
              ),

              // Task list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadTasks,
                  color: Theme.of(context).colorScheme.primary,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TaskListWidget(
                        key: const ValueKey('today'),
                        filter: 'today',
                        searchQuery: _searchQuery,
                        selectedFilter: _selectedFilter,
                        isRefreshing: _isRefreshing,
                      ),
                      TaskListWidget(
                        key: const ValueKey('week'),
                        filter: 'week',
                        searchQuery: _searchQuery,
                        selectedFilter: _selectedFilter,
                        isRefreshing: _isRefreshing,
                      ),
                      TaskListWidget(
                        key: const ValueKey('all'),
                        filter: 'all',
                        searchQuery: _searchQuery,
                        selectedFilter: _selectedFilter,
                        isRefreshing: _isRefreshing,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickTaskModal,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Quick Task',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Tasks tab active
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboardHome,
                (route) => false,
              );
              break;
            case 1:
              // Already on task management
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.progressVisualization);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.marketplace);
              break;
            case 4:
              Navigator.pushNamed(context, AppRoutes.userProfile);
              break;
          }
        },
      ),
    );
  }
}
