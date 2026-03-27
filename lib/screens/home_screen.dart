import 'package:flutter/material.dart';
import 'package:to_do_ufpso/utils/app_theme.dart';
import 'package:to_do_ufpso/models/task.dart';
import 'package:to_do_ufpso/widgets/eco_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Estudiar para el parcial de matemáticas',
      description: 'Repasar los temas del capítulo 3 y 4',
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Entregar proyecto de programación',
      description: 'Terminar la implementación de la base de datos',
      isCompleted: true,
    ),
    Task(
      id: '3',
      title: 'Comprar materiales para la tarea',
      description: 'Hojas, marcadores y pegamento',
      isCompleted: false,
    ),
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_titleController.text.trim().isEmpty) return;

    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          isCompleted: false,
        ),
      );
    });

    _titleController.clear();
    _descriptionController.clear();
    Navigator.of(context).pop();
  }

  void _toggleTask(String taskId) {
    setState(() {
      final task = _tasks.firstWhere((task) => task.id == taskId);
      task.toggleCompleted();
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _addTask,
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final totalTasks = _tasks.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo y estadísticas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const EcoLogo(size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Eco-Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.exit_to_app, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total', '$totalTasks', Colors.blue),
                      _buildStatCard('Completadas', '$completedTasks', Colors.green),
                      _buildStatCard('Pendientes', '${totalTasks - completedTasks}', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            // Lista de tareas
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay tareas aún',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '¡Agrega tu primera tarea!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 4,
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) => _toggleTask(task.id),
                              activeColor: AppColors.primary,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: task.description.isNotEmpty
                                ? Text(
                                    task.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  )
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(task.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
