import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

/// Task list screen dengan ListView.builder
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Dummy data untuk P5
  late List<TaskModel> tasks;

  // Filter state - null means "All"
  TaskStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    tasks = TaskModel.getDummyTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myTasks,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Column(
        children: [
          // Filter chips section
          _buildFilterChips(),
          const SizedBox(height: 8),
          // Task list
          Expanded(
            child: _getFilteredTasks().isEmpty
                ? _buildEmptyState()
                : _buildTaskList(),
          ),
        ],
      ),
      // NEW: Add FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        tooltip: AppStrings.addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Get filtered tasks based on selected filter
  List<TaskModel> _getFilteredTasks() {
    if (_selectedFilter == null) {
      return tasks; // "All" filter
    }
    return tasks.where((task) => task.status == _selectedFilter).toList();
  }

  /// Build filter chips for task status filtering
  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // "All" filter chip
          _buildFilterChip(
            label: 'All',
            isSelected: _selectedFilter == null,
            onTap: () => setState(() => _selectedFilter = null),
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),

          // "Pending" filter chip
          _buildFilterChip(
            label: AppStrings.statusPending,
            isSelected: _selectedFilter == TaskStatus.pending,
            onTap: () => setState(() => _selectedFilter = TaskStatus.pending),
            color: AppColors.statusPending,
          ),
          const SizedBox(width: 8),

          // "Overdue" filter chip
          _buildFilterChip(
            label: AppStrings.statusOverdue,
            isSelected: _selectedFilter == TaskStatus.overdue,
            onTap: () => setState(() => _selectedFilter = TaskStatus.overdue),
            color: AppColors.statusOverdue,
          ),
          const SizedBox(width: 8),

          // "Completed" filter chip
          _buildFilterChip(
            label: AppStrings.statusCompleted,
            isSelected: _selectedFilter == TaskStatus.completed,
            onTap: () => setState(() => _selectedFilter = TaskStatus.completed),
            color: AppColors.statusCompleted,
          ),
        ],
      ),
    );
  }

  /// Build individual filter chip with visual indicator
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.onSurface.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    // Determine empty message based on filter
    String emptyMessage;
    if (_selectedFilter == null) {
      emptyMessage = AppStrings.noTasks;
    } else {
      emptyMessage = 'No tasks with "${_getFilterLabel()}" status';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Get current filter label for empty state message
  String _getFilterLabel() {
    switch (_selectedFilter) {
      case TaskStatus.pending:
        return AppStrings.statusPending;
      case TaskStatus.overdue:
        return AppStrings.statusOverdue;
      case TaskStatus.completed:
        return AppStrings.statusCompleted;
      default:
        return 'All';
    }
  }

  Widget _buildTaskList() {
    final filteredTasks = _getFilteredTasks();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return _buildDismissibleTaskCard(task);
      },
    );
  }

  Widget _buildDismissibleTaskCard(TaskModel task) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      confirmDismiss: (direction) => _showDeleteConfirmation(task),
      onDismissed: (direction) => _deleteTask(task),
      child: InkWell(
        onTap: () => _navigateToDetail(task),
        borderRadius: BorderRadius.circular(12),
        child: TaskCard(task: task),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 32),
    );
  }

  Future<bool?> _showDeleteConfirmation(TaskModel task) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteTask),
        content: const Text(AppStrings.deleteTaskConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _deleteTask(TaskModel task) {
    setState(() {
      tasks.removeWhere((t) => t.id == task.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.taskDeleted),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToDetail(TaskModel task) {
    Navigator.pushNamed(context, AppRoutes.taskDetail, arguments: task);
  }

  // NEW: Navigate to add task screen
  void _navigateToAddTask() {
    Navigator.pushNamed(context, AppRoutes.addTask);
  }
}
