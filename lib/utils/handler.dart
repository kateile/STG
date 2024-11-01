import 'table.dart';

class Topic {
  final String title;
  final String index;
  final bool isChapter;
  int page;

  /// This will we be used for recent/favourite feature
  final int? timestamp;

  Topic({
    required this.title,
    required this.index,
    this.isChapter = false,
    required this.page,
    this.timestamp,
  });

  Topic copyWith({
    required int timestamp,
  }) {
    return Topic(
      title: title,
      index: index,
      isChapter: isChapter,
      page: page,
      timestamp: this.timestamp ?? timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "title": title,
      "page": page,
      "isChapter": isChapter,
      "time": timestamp,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

List<Topic> handlePages() {
  final List<Topic> list = [];
  final strings = tableOfContents.split("\n");

  for (var i in strings) {
    final word = i.trim();

    final String index = word.split(" ").firstWhere(
          (e) => e.contains(RegExp("[0-9.]")),
          orElse: () => "",
        );

    final String pageNumber = word
        .split("..")
        .lastWhere(
          (e) => e.contains(RegExp("[0-9.]")),
          orElse: () => "",
        )
        .replaceAll('.', '');

    final startIndex = word.indexOf(index);
    final endIndex = word.indexOf(pageNumber);

    final title = word
        .substring(startIndex + index.length, endIndex)
        .trim()
        .replaceAll('.', '');

    final top = Topic(
      title: title,
      index: index,
      page: int.tryParse(pageNumber) ?? 0,
      isChapter: !index.contains('.'),
    );

    if (title.isNotEmpty) list.add(top);
  }

  return list;
}
