import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stg/utils/handler.dart';

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
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/stg.pdf', 'stg.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            if (pathPDF.isNotEmpty) {
              return PDFScreen(
                path: pathPDF,
                currentPage: widget.topic.page,
              );
            }

            return const CircularProgressIndicator.adaptive();
          },
        ),
      ),
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
  late int? pages;

  bool isReady = false;
  String errorMessage = '';

  @override
  initState() {
    pages = widget.currentPage + 34;

    if (widget.currentPage > 417) {
      pages = pages! - 16;
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
            defaultPage: pages!,
            fitPolicy: FitPolicy.HEIGHT,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
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
                pages = page;
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
      // bottomNavigationBar: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, k) {
      //     return BottomNavigationBar(
      //       showSelectedLabels: false,
      //       showUnselectedLabels: false,
      //       onTap: (i) {
      //         late int dd;
      //
      //         if (i == 0) {
      //           dd = pages! - 1;
      //         } else if (i == 1) {
      //           dd = pages! + 1;
      //         }
      //
      //         k.data?.setPage(dd);
      //       },
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.navigate_before),
      //           label: "Previous Page",
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.navigate_next),
      //           label: "Next Page",
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}