import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Reader(
        initialPage: 90,
      ),
    );
  }
}

class Reader extends StatefulWidget {
  final int initialPage;

  const Reader({
    Key? key,
    required this.initialPage,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Reader> {
  late PdfController _pdfController;
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;

    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/stg.pdf'),
      initialPage: widget.initialPage,
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
        title: const Text('STG'),
        centerTitle: true,
      ),
      body: PdfView(
        documentLoader: const Center(child: CircularProgressIndicator()),
        pageLoader: const Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        scrollDirection: Axis.horizontal,
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
