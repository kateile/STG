import 'package:flutter/material.dart';

import 'list.dart';

class SearchTopicDelegate extends SearchDelegate {
  SearchTopicDelegate({
    String? hintText,
  }) : super(
          searchFieldLabel: 'Search Topic',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        super.close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return TopicList(
      query: query,
      tabState: TabState.search,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return TopicList(
      query: query,
      tabState: TabState.search,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [];
}
