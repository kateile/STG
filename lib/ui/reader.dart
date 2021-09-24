import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:stg/utils/handler.dart';

class Reader extends StatefulWidget {
  final Topic topic;

  const Reader({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late PdfController _pdfController;
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;

    final page = widget.topic.page + 35; //IMPORTANT

    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/stg.pdf'),
      initialPage: page,
      viewportFraction: 8.5,
    );

    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: PdfView(
        documentLoader: const Center(child: CircularProgressIndicator()),
        pageLoader: const Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        scrollDirection: Axis.vertical,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
          });

          if (i == 0) {
            _pdfController.previousPage(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 100),
            );
          } else if (i == 1) {
            _pdfController.nextPage(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 100),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.navigate_before),
            label: "Previous Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigate_next),
            label: "Next Page",
          ),
        ],
      ),
    );
  }
}
