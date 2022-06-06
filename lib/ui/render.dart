import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg/ui/render_cubit.dart';
import 'package:stg/utils/utils.dart';

class Render extends StatefulWidget {
  final Topic topic;

  const Render({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _RenderState createState() => _RenderState();
}

class _RenderState extends State<Render> {
  late Box<int> favoritesBox;
  late Box<int> recentsBox;

  @override
  void initState() {
    super.initState();

    favoritesBox = Hive.box(favoritesBoxKey);
    recentsBox = Hive.box(recentsBoxKey);

    recentsBox.put(widget.topic.index, DateTime.now().millisecondsSinceEpoch);
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
    return ValueListenableBuilder(
      valueListenable: favoritesBox.listenable(),
      builder: (context, Box<int> box, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.topic.title),
            actions: [
              IconButton(
                icon: Builder(
                  builder: (context) {
                    if (box.containsKey(widget.topic.index)) {
                      return const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      );
                    }

                    return const Icon(Icons.favorite_outline);
                  },
                ),
                onPressed: () => onFavoritePress(widget.topic.index),
              ),
            ],
          ),
          body: Center(
            child: BlocBuilder<RenderCubit, RenderResult>(
              builder: (BuildContext context, state) {
                if (state.state == ResultState.success) {
                  return PDFScreen(
                    path: state.file?.path,
                    currentPage: widget.topic.page,
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        );
      },
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;
  final int currentPage;

  const PDFScreen({
    Key? key,
    this.path,
    required this.currentPage,
  }) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  late int? _currentPage;

  bool isReady = false;
  String errorMessage = '';

  @override
  initState() {
    _currentPage = widget.currentPage + 34;

    if (widget.currentPage > 417) {
      _currentPage = _currentPage! - 16;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: _currentPage!,
            fitPolicy: FitPolicy.HEIGHT,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_page) {
              setState(() {
                _currentPage = _page;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      bottomNavigationBar: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, k) {
          return BottomNavigationBar(
            //showSelectedLabels: false,
            //showUnselectedLabels: false,
            onTap: (i) {
              late int dd;

              k.data?.getCurrentPage().then((value) {
                if (i == 1) {
                  openSTGPro();
                } else {
                  if (i == 0) {
                    dd = value! - 1;
                  } else if (i == 2) {
                    dd = value! + 1;
                  }
                  k.data?.setPage(dd);
                }
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.navigate_before,
                ),
                label: "Previous",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.upgrade,
                ),
                label: "Upgrade",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.navigate_next,
                ),
                label: "Next",
              ),
            ],
          );
        },
      ),
    );
  }
}
