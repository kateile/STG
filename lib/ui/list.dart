import 'package:flutter/material.dart';
import 'package:stg/utils/handler.dart';

import 'render.dart';

class TopicList extends StatelessWidget {
  final String query;

  const TopicList({
    Key? key,
    this.query = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = handlePages()
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final Topic topic = list[index];

        return Card(
          child: ListTile(
            title: Text(
              topic.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(topic.index),
            tileColor: topic.isChapter ? Colors.blue.shade50 : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Render(
                    topic: topic,
                  ),
                ),
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute<void>(
              //     builder: (BuildContext context) => Reader(
              //       topic: topic,
              //     ),
              //   ),
              // );
            },
          ),
        );
      },
    );
  }
}
