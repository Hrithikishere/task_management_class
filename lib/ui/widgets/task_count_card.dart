import 'package:flutter/material.dart';

class TaskCountCard extends StatelessWidget {
  TaskCountCard({
    required this.count,
    required this.title,
    super.key,
  });

  String count;
  String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width / 4.3,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(count, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 10),),
            ],
          ),
        ),
      ),
    );
  }
}
