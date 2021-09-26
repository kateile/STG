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

    int page = widget.topic.page + 35; //IMPORTANT

    if (widget.topic.page > 417) {
      page = page - 16;
    }

    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/stg.pdf'),
      initialPage: page,
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.info),
        //     onPressed: () {
        //       _showMyDialog(context);
        //     },
        //   )
        // ],
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

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Disclaimer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'This is app uses cropped pages of the original STG pdf to '
                  'avoid unnecessary white spaces and improve user experience. '
                  'In doing so some of pages may have been cropped inaccurately '
                  'resulting to some contents being missing. \n'
                  'So please always refer to original STG book or PDF. '
                  'This should be used for educational purposes only. \n\n'
                  'I would love everything here to be as accurate as possible '
                  'so if you find something missing please send me a screenshot '
                  'via stg@kateile.com or telegram group. \n\n',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
