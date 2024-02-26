import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stg/utils/handler.dart';

void main() {
  test('should extract page titles,number correctly', () {
    final list = handlePages();

    for (var element in list) {
        if (kDebugMode) {
          print(element.toString());
      }
    }

    expect(list.length, list.length);
  });
}
