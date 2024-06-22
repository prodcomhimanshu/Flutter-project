import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ram/Homepage/task_update_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskFormPage extends StatefulWidget {
  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _runningTaskController = TextEditingController();
  final TextEditingController _completedTaskController =
      TextEditingController();
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
              Tab(text: 'All Task'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildScheduledTasksTab(),
            _buildRunningTasksTab(),
            _ATasksTab(),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> _fetchRunningTasks() async {
    int? userId;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      userId = prefs.getInt('user_id');
      final String apiUrl =
          'http://62.72.13.94:9081/api/ramtsksched/get/taskby/$userId';
      if (token == null) {
        print('JWT token not found. User may not be logged in.');
        return [];
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print(
            'Failed to load running tasks. Error ${response.statusCode}: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error fetching running tasks: $e');
      return [];
    }
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
    
    // Format dates using ISO 8601 format
    String formattedReminderDate = _formatDateTime(_reminderController.text);
    String formattedDueDate = _formatDateTime(_dueDateController.text);

    Map<String, dynamic> taskData = {
      "userId": userId,
      "taskName": _taskNameController.text,
      "taskDescription": _taskDescriptionController.text,
      "reminderDate": formattedReminderDate,
      "status": "OPEN", // Assuming status is always "OPEN" for new tasks
      "dueDate": formattedDueDate,
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Received ${response.statusCode} response.');
      print('Response body: ${response.body}');
      
      // Show a snackbar message for success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task created successfully!'),
          duration: Duration(seconds: 2), // Optional duration
        ),
      );

      // Optionally, refresh the list of running tasks
      _fetchRunningTasks();
    } else {
      print(
          'Failed to register task. Error ${response.statusCode}: ${response.reasonPhrase}');
      print('Response body: ${response.body}');
      
      // Show a snackbar message for failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create task. Please try again.'),
          duration: Duration(seconds: 2), // Optional duration
        ),
      );
    }
  } catch (e) {
    print('Error sending request: $e');
    
    // Show a snackbar message for error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        duration: const Duration(seconds: 2), // Optional duration
      ),
    );
  }
}


  String _formatDateTime(String dateTimeString) {
    // Parse the given string to DateTime
    DateTime parsedDateTime = DateTime.parse(dateTimeString);

    // Format DateTime to ISO 8601 format
    String formattedDateTime = parsedDateTime.toIso8601String();

    return formattedDateTime;
  }

  Future<void> _deleteTask(int taskId) async {
    final String apiUrl =
        'http://62.72.13.94:9081/api/ramtsksched/tasks/deleteBy/$taskId';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print('JWT token not found. User may not be logged in.');
        return;
      }

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully.');
        // Refresh the list of tasks after deletion
        setState(() {
          // Manually update the list of tasks or refetch them
          // Example: Call _fetchRunningTasks() again to update the UI
        });
      } else {
        print(
            'Failed to delete task. Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Widget _buildRunningTasksTab() {
    return FutureBuilder(
      future: _fetchRunningTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> runningTasks = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: runningTasks.length,
            itemBuilder: (context, index) {
              var task = runningTasks[index];
              return _buildTaskCard(task);
            },
          );
        }
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Task Name: ${task['taskName']}'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _navigateToUpdateTask(task);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(task['id']);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Text('Task Description: ${task['taskDescription']}'),
            Text('Reminder Date: ${task['reminderDate']}'),
            Text('Due Date: ${task['dueDate']}'),
            Text('Status: ${task['status']}'),
            Text('Priority: ${task['priority']}'),
          ],
        ),
      ),
    );
  }

  void _navigateToUpdateTask(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskUpdatePage(task)),
    );
  }

  void _showDeleteConfirmationDialog(int taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteTask(taskId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //  creating a task here

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
            items: ['Low', 'medium', 'High'],
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

  Widget _ATasksTab() {
    return FutureBuilder(
      future: _fetchRunningTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> runningTasks = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: runningTasks.length,
            itemBuilder: (context, index) {
              var task = runningTasks[index];
              return _buildTaskCard(task);
            },
          );
        }
      },
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
            controller.text =
                DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
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
