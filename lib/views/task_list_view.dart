import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskListView extends StatefulWidget {
  final List<Task> tasks;
  final bool isLoading;
  final Function(String) onToggle;
  final Function(String) onDelete;
  final Function(String) onAdd;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.onToggle,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onAdd(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input field
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Digite uma nova tarefa...',
                    prefixIcon: Icon(Icons.add_task),
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),

        // Task list
        Expanded(
          child: widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : widget.tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: AppColors.coolGray400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma tarefa ainda',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.coolGray400,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione uma tarefa acima para começar',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.tasks[index];
                        return TaskItem(
                          task: task,
                          onToggle: () => widget.onToggle(task.id),
                          onDelete: () => widget.onDelete(task.id),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// Individual task item widget
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: task.done,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null,
            color: task.done ? AppColors.coolGray400 : AppColors.spaceCadet,
            fontSize: 16,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: AppColors.redPantone,
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Excluir Tarefa'),
                content: const Text('Tem certeza que deseja excluir esta tarefa?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redPantone,
                    ),
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

