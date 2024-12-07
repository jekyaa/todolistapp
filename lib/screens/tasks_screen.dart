import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function onDelete;
  final Function onMarkAsDone;
  final Function onEditDate;
  final Function onTogglePriority;
  final Function onToggleFlag;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onMarkAsDone,
    required this.onEditDate,
    required this.onTogglePriority,
    required this.onToggleFlag,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        task.time != null ? task.time!.format(context) : 'No Time';

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Move the flag icon to the right side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('${task.category} - $formattedTime'),
              ],
            ),
          ),
          // Row of action buttons (Star, Date, Delete)
          Row(
            children: [
              // Star icon wrapped in a colored box
              Container(
                decoration: BoxDecoration(
                  color: task.isStarred ? Colors.yellow[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.star,
                      color: task.isStarred ? Colors.white : Colors.black),
                  onPressed: () {
                    onTogglePriority(
                        task.id); // Toggle priority (starred status)
                  },
                ),
              ),
              SizedBox(width: 8),
              // Date icon wrapped in a colored box
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: task.dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      onEditDate(task.id, pickedDate); // Edit task date
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              // Delete icon wrapped in a colored box
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () => onDelete(task.id), // Delete task
                ),
              ),
              SizedBox(width: 8),
              // Flag icon moved to the right side of the task item
              IconButton(
                icon: Icon(
                  Icons.flag,
                  color: task.isFlagged ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  onToggleFlag(task.id); // Call onToggleFlag here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Work'),
            Tab(text: 'Personal'),
            Tab(text: 'Wishlist'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(taskProvider.tasks),
          _buildTaskList(taskProvider.tasks
              .where((task) => task.category == 'Work')
              .toList()),
          _buildTaskList(taskProvider.tasks
              .where((task) => task.category == 'Personal')
              .toList()),
          _buildTaskList(taskProvider.tasks
              .where((task) => task.category == 'Wishlist')
              .toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, taskProvider),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) => TaskItem(
        task: tasks[index],
        onDelete: Provider.of<TaskProvider>(ctx, listen: false).deleteTask,
        onMarkAsDone:
            Provider.of<TaskProvider>(ctx, listen: false).markTaskAsDone,
        onEditDate: Provider.of<TaskProvider>(ctx, listen: false).editTaskDate,
        onTogglePriority:
            Provider.of<TaskProvider>(ctx, listen: false).togglePriority,
        onToggleFlag: Provider.of<TaskProvider>(ctx, listen: false).toggleFlag,
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final titleController = TextEditingController();
    String selectedCategory = 'Work';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Task'),
        content: StatefulBuilder(
          builder: (ctx, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input for task name
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                ),

                // Dropdown for category selection
                DropdownButton<String>(
                  value: selectedCategory,
                  items: ['Work', 'Personal', 'Wishlist']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value; // Update selected category
                      });
                    }
                  },
                ),

                // Date picker
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate; // Update selected date
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
                // Display selected date only if a date has been selected
                if (selectedDate != null)
                  Text(
                      'Selected Date: ${DateFormat.yMMMd().format(selectedDate!)}'),

                // Time picker
                TextButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime; // Update selected time
                      });
                    }
                  },
                  child: Text('Select Time'),
                ),
                // Display selected time
                if (selectedTime != null)
                  Text('Selected Time: ${selectedTime?.format(context)}'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              taskProvider.addTask(
                titleController.text,
                selectedCategory,
                selectedDate!,
                selectedTime,
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
