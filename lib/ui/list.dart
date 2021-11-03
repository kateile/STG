import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg/utils/handler.dart';
import 'package:stg/utils/utils.dart';

import 'ad.dart';
import 'render.dart';

enum TabState { all, favourites, recents, search }

class TopicList extends StatefulWidget {
  final String query;
  final TabState tabState;

  const TopicList({
    Key? key,
    this.query = '',
    this.tabState = TabState.all,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TopicListState();
  }
}

class TopicListState extends State<TopicList> {
  late Box<int> favoritesBox;
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
    favoritesBox.put(index, DateTime.now().millisecondsSinceEpoch);
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
          builder: (context, Box<int> fBox, _) {
            var list = all;

            if (widget.tabState == TabState.recents ||
                widget.tabState == TabState.favourites) {
              ///Here we will have different arrangements based on timestamp
              ///which topic action was done

              late Map<dynamic, int> map;
              late String msg;

              /// Here we will hold saved items
              final List<Topic> filtered = [];

              if (widget.tabState == TabState.favourites) {
                map = fBox.toMap();
                msg = 'You have no favourites yet!';
              } else if (widget.tabState == TabState.recents) {
                map = rBox.toMap();
                msg = 'You have not opened any Topic yet!';
              }

              map.forEach((key, value) {
                final item = all.firstWhere((e) => e.index == key);

                final topic = item.copyWith(timestamp: value);
                filtered.add(topic);
              });

              list = filtered;
              list.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

              if (list.isEmpty) {
                return Center(
                  child: Text(
                    msg,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
              }
            }

            return ListView.separated(
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
              separatorBuilder: (context, index) {
                if ((index != 0 && index % 5 == 0) ||
                    (widget.tabState == TabState.search && index == 0)) {
                  //return const Ad();
                }

                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              },
            );
          },
        );
      },
    );
  }
}
