import 'package:flutter/material.dart';
import 'package:stg/utils/handler.dart';

import 'reader.dart';

class TopicList extends StatelessWidget {
  final String query;

  const TopicList({Key? key, this.query = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = handlePages()
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final Topic t = list[index];

        return Card(
          child: ListTile(
            title: Text(
              t.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(t.index),
            tileColor: t.isChapter ? Colors.blue.shade50 : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Reader(
                    topic: t,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
