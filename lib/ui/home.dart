import 'package:flutter/material.dart';
import 'package:stg/utils/handler.dart';

import 'reader.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STG'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: _buildList(),
    );
  }

  _buildList() {
    final list = handlePages();

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
