import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg/utils/handler.dart';
import 'package:stg/utils/utils.dart';

import 'reader.dart';

class TopicList extends StatefulWidget {
  final String query;
  final bool favouritesOnly;
  final bool recentsOnly;

  const TopicList({
    Key? key,
    this.query = '',
    this.favouritesOnly = false,
    this.recentsOnly = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TopicListState();
  }
}

class TopicListState extends State<TopicList> {
  late Box<String> favoritesBox;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box(favoritesBoxKey);
  }

  void onFavoritePress(String index) {
    if (favoritesBox.containsKey(index)) {
      favoritesBox.delete(index);
      return;
    }
    favoritesBox.put(index, index);
  }

  @override
  Widget build(BuildContext context) {
    final all = handlePages()
        .where(
            (e) => e.title.toLowerCase().contains(widget.query.toLowerCase()))
        .toList();

    return ValueListenableBuilder(
      valueListenable: favoritesBox.listenable(),
      builder: (context, Box<String> box, _) {
        var list = all;

        if (widget.favouritesOnly) {
          list = all.where((e) => box.containsKey(e.index)).toList();

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'You have no bookmarks!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          }
        }

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
                trailing: InkWell(
                  child: Builder(
                    builder: (context) {
                      if (box.containsKey(t.index)) {
                        return Icon(
                          Icons.bookmark,
                          color: Theme.of(context).primaryColor,
                        );
                      }

                      return const Icon(Icons.bookmark_outline);
                    },
                  ),
                  onTap: () => onFavoritePress(t.index),
                ),
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
      },
    );
  }
}
