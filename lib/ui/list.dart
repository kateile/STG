import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg/utils/handler.dart';
import 'package:stg/utils/utils.dart';

import 'render.dart';

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
  late Box<int> recentsBox;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box(favoritesBoxKey);
    recentsBox = Hive.box(recentsBoxKey);
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
      valueListenable: recentsBox.listenable(),
      builder: (context, Box<int> rBox, _) {
        return ValueListenableBuilder(
          valueListenable: favoritesBox.listenable(),
          builder: (context, Box<String> fBox, _) {
            var list = all;

            if (widget.favouritesOnly) {
              list = all.where((e) => fBox.containsKey(e.index)).toList();

              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'You have no Favourites!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
              }
            } else if (widget.recentsOnly) {
              /// Here we will hold saved items
              final List<Topic> recents = [];
              final map = rBox.toMap();

              map.forEach((key, value) {
                final item = all.firstWhere((e) => e.index == key);

                final topic = item.copyWith(timestamp: value);
                recents.add(topic);
              });

              list = recents;
              list.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'You have not opened any Topic yet!',
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
                          if (fBox.containsKey(t.index)) {
                            return const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            );
                          }

                          return const Icon(Icons.favorite_outline);
                        },
                      ),
                      onTap: () => onFavoritePress(t.index),
                    ),
                    tileColor: t.isChapter ? Colors.blue.shade50 : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Render(
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
      },
    );
  }
}
