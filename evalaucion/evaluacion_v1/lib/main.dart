import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Task> _tasks = [];

  void _addTask() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La tarea no puede estar vacía')),
      );
      return;
    }

    setState(() {
      _tasks.add(Task(title: text));
      _controller.clear();
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  int get completedTasks => _tasks.where((t) => t.completed).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestor de Tareas',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Completadas: $completedTasks / ${_tasks.length}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (_tasks.isEmpty) {
      return const Center(
        child: Text('No hay tareas registradas', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (_) => _toggleTask(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _deleteTask(task),
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva tarea'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Escribe tu tarea aquí',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

class Task {
  String title;
  bool completed;

  Task({required this.title, this.completed = false});
}
