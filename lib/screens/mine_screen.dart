import 'package:fl_chart/fl_chart.dart'; // Ensure you add the fl_chart package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class MineScreen extends StatelessWidget {
  const MineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mine'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Overview
            Text(
              'Tasks Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '${taskProvider.completedTasks.length}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text('Completed Tasks'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${taskProvider.tasks.length}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text('Pending Tasks'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Task Completion Graph
            const Text('Completion of Daily Tasks'),
            const SizedBox(height: 10),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 3),
                        FlSpot(4, 2.5),
                      ],
                      isCurved: true,
                      colors: [Colors.deepPurpleAccent],
                      belowBarData: BarAreaData(
                          show: true,
                          colors: [Colors.deepPurpleAccent.withOpacity(0.3)]),
                    ),
                  ],
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tasks in Next 7 Days Section
            const Text('Tasks in Next 7 Days'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: const Text('No task data available'),
            ),
            const SizedBox(height: 20),

            // Pending Tasks in Categories Section
            const Text('Pending Tasks in Categories'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: const Text('In 30 days'),
            ),
          ],
        ),
      ),
    );
  }
}
