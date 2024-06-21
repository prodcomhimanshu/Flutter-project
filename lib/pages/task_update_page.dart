import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskUpdatePage extends StatefulWidget {
  final Map<String, dynamic> task;

  TaskUpdatePage(this.task);

  @override
  _TaskUpdatePageState createState() => _TaskUpdatePageState();
}

class _TaskUpdatePageState extends State<TaskUpdatePage> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _reminderController;
  late TextEditingController _dueDateController;
  late TextEditingController _priorityController;
  late String _status; // Initialize _status with task's current status

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.task['taskName']);
    _taskDescriptionController = TextEditingController(text: widget.task['taskDescription']);
    _reminderController = TextEditingController(text: widget.task['reminderDate']);
    _dueDateController = TextEditingController(text: widget.task['dueDate']);
    _priorityController = TextEditingController(text: widget.task['priority']);
    _status = widget.task['status']; // Initialize _status with current task status
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    _reminderController.dispose();
    _dueDateController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(controller: _taskNameController, label: 'Task Name', icon: Icons.task),
            const SizedBox(height: 16),
            _buildTextField(controller: _taskDescriptionController, label: 'Task Description', icon: Icons.description),
            const SizedBox(height: 16),
            _buildDateTimeField(controller: _reminderController, label: 'Reminder', icon: Icons.alarm),
            const SizedBox(height: 16),
            _buildDateTimeField(controller: _dueDateController, label: 'Due Date', icon: Icons.date_range),
            const SizedBox(height: 16),
            _buildTextField(controller: _priorityController, label: 'Priority', icon: Icons.priority_high),
            const SizedBox(height: 16),
            _buildDropdownField(
              value: _status,
              label: 'Status',
              icon: Icons.check_circle_outline,
              items: ['OPEN', 'OVERDUE', 'CLOSE'],
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask() async {
    // Construct JSON data for update
    Map<String, dynamic> taskData = {
      "id": widget.task['id'],
      "userId": widget.task['userId'],
      "taskName": _taskNameController.text,
      "taskDescription": _taskDescriptionController.text,
      "reminderDate": _reminderController.text,
      "status": _status.toUpperCase(), // Use selected status
      "dueDate": _dueDateController.text,
      "priority": _priorityController.text.toUpperCase(),
    };

    // Convert data to JSON format
    String jsonBody = jsonEncode(taskData);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print('JWT token not found. User may not be logged in.');
        // Handle token not found scenario
        return;
      }

      final response = await http.put(
        Uri.parse('http://62.72.13.94:9081/api/ramtsksched/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,  
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Task updated successfully');
        Navigator.pop(context); // Navigate back to previous screen after update
      } else {
        print('Failed to update task. Error ${response.statusCode}: ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        // Handle error as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Failed'),
              content: Text('Failed to update task. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error updating task: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while updating the task. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
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
  }) {
    return GestureDetector(
      onTap: () async {
        
        // DateTime? pickedDateTime = await showDatePicker(
        //   context: context,
        //   initialDate: DateTime.now(),
        //   firstDate: DateTime(2000),
        //   lastDate: DateTime(2101),
        // );

        // if (pickedDateTime != null) {
        //   final TimeOfDay? pickedTime = await showTimePicker(
        //     context: context,
        //     initialTime: TimeOfDay.now(),
        //   );

        //   if (pickedTime != null) {
        //     final DateTime combinedDateTime = DateTime(
        //       pickedDateTime.year,
        //       pickedDateTime.month,
        //       pickedDateTime.day,
        //       pickedTime.hour,
        //       pickedTime.minute,
        //     );
        //     controller.text =
        //         DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        //   }
        // }

      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
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
