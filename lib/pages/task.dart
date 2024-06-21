import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskFormPage extends StatefulWidget {
  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _runningTaskController = TextEditingController();
  final TextEditingController _completedTaskController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String _priority = 'Low';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Scheduled'),
              Tab(text: 'Running'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildScheduledTasksTab(),
            _buildRunningTasksTab(),
            _buildCompletedTasksTab(),
          ],
        ),
      ),
    );
  }

  Future<void> _AddTask() async {
    int? userId;
    const String apiUrl = 'http://62.72.13.94:9081/api/ramtsksched/create';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      userId = prefs.getInt('user_id');

      if (token == null) {
        print('JWT token not found. User may not be logged in.');
        return;
      }
      
      Map<String, dynamic> taskData = {
        "userId": userId,
        "taskName": _taskNameController.text,
        "taskDescription": _taskDescriptionController.text,
        "reminderDate":  "2024-05-22T18:30:00.000Z",
        "status": "open",
        "dueDate": "2024-05-28T18:30:00.000Z",
        "priority": _priority.toUpperCase()  
      };

      String jsonBody = jsonEncode(taskData);
      print(taskData);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        print('Task registered successfully!');
      } else {
        print('Failed to register task. Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  Widget _buildScheduledTasksTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _taskNameController,
            label: 'Task Name',
            icon: Icons.task,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _taskDescriptionController,
            label: 'Task Description',
            icon: Icons.description,
          ),
          const SizedBox(height: 16),
          _buildDateTimeField(
            controller: _reminderController,
            label: 'Reminder',
            icon: Icons.alarm,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildDateTimeField(
            controller: _dueDateController,
            label: 'Due Date',
            icon: Icons.date_range,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _priority,
            label: 'Priority',
            icon: Icons.priority_high,
            items: ['Low', 'Medium', 'High'],
            onChanged: (value) {
              setState(() {
                _priority = value!;
              });
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _AddTask,
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningTasksTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _taskNameController,
            label: 'Task Name',
            icon: Icons.task,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _taskDescriptionController,
            label: 'Task Description',
            icon: Icons.description,
          ),
          const SizedBox(height: 16),
          _buildDateTimeField(
            controller: _reminderController,
            label: 'Reminder Date',
            icon: Icons.alarm,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _statusController,
            label: 'Status',
            icon: Icons.info,
          ),
          const SizedBox(height: 16),
          _buildDateTimeField(
            controller: _dueDateController,
            label: 'Due Date',
            icon: Icons.date_range,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _priority,
            label: 'Priority',
            icon: Icons.priority_high,
            items: ['Low', 'medium', 'High'],
            onChanged: (value) {
              setState(() {
                _priority = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _AddTask,
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTasksTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _completedTaskController,
            label: 'Completed Task',
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _AddTask,
            child: const Text('Save Completed Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDateTime != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            final DateTime combinedDateTime = DateTime(
              pickedDateTime.year,
              pickedDateTime.month,
              pickedDateTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            controller.text = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
          }
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
