import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/notification_model.dart';
import 'package:intl/intl.dart'; // Untuk format waktu

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationBox = Hive.box<NotificationModel>(
        'notifications'); // Gunakan box yang sudah dibuka

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ValueListenableBuilder(
        valueListenable: notificationBox.listenable(),
        builder: (context, Box<NotificationModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No Notifications'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final notification = box.getAt(index);

              // Menggunakan format waktu untuk lebih mudah dibaca
              final formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                  .format(notification?.dateTime ?? DateTime.now());

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    notification?.title ?? 'No Title',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification?.description ?? 'No Description',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formattedDate,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => box.deleteAt(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
