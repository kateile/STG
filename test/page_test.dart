import 'package:flutter_test/flutter_test.dart';
import 'package:stg/table.dart';

class Chapter {
  final String title;
  final double index;
  final int page;

  Chapter({
    required this.title,
    required this.index,
    required this.page,
  });
}

class Topic {
  final String title;
  final double index;
  final int? chapter;
  final int page;

  Topic({
    required this.title,
    required this.index,
    this.chapter,
    required this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "title": title,
      "page": page,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

void main() {
  test('should extract page titles,number correctly', () {
    const str = tableOfContents;

    final list = str.split("\n");

    for (var i in list) {
      final word = i.trim();

      final String index = word.split(" ").firstWhere(
            (e) => e.contains(RegExp("[0-9.]")),
            orElse: () => "",
          );

      if (word.isNotEmpty) {
        print(index);

        // final startIndex = word.indexOf(start);
        // final firstDot = word.lastIndexOf(start);
        // final lastDot = word.lastIndexOf('.') + 2;
        // final end = word.substring(firstDot , lastDot);
        //
        // print('start: $start');
        // print('dots: $end');
        // final endIndex = word.indexOf(end, startIndex + start.length);
        //
        // final title =
        //     word.substring(startIndex + start.length, endIndex).trim();
        //
        // final obj =
        //     Topic(title: title, index: double.tryParse(start) ?? 0, page: 9);
        //
        // print(obj);

        //break;
      }
    }

    expect(str.length, str.length);
  });
}
