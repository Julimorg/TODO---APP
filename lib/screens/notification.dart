import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Message',
      'subtitle': 'You have received a new message from John.',
      'timestamp': DateTime.now(), //-> Giả định thời gian hiện tại đi
    },
    {
      'title': 'System Update',
      'subtitle': 'Your system update has been successfully installed.',
      'timestamp': DateTime.now(),
    },
    {
      'title': 'Meeting Reminder',
      'subtitle': 'Don\'t forget the team meeting at 3:00 PM.',
      'timestamp': DateTime.now(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final timestamp = notification['timestamp'] ?? DateTime.now();
            return NotificationCard(
              title: notification['title']!,
              subtitle: notification['subtitle']!,
              timestamp: timestamp,
              onPressed: () {
                // Xử lý khi bấm vào card
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Seen: ${notification['title']}'),
                  ),
                );
              },
            ).animate().slideX(
                  begin: 1,
                  duration: 300.ms,
                  curve: Curves.easeOut,
                );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final VoidCallback onPressed;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    //? Chọn format time
    final timeFormat = DateFormat('hh:mm a');
    return InkWell(
      onTap: onPressed,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  title[0],
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeFormat.format(timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
