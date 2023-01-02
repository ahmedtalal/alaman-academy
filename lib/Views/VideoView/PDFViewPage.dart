import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:alaman/utils/widgets/AppBarWidget.dart';
import 'package:alaman/utils/widgets/connectivity_checker_widget.dart';

class PDFViewPage extends StatefulWidget {
  final String pdfLink;
  PDFViewPage({this.pdfLink});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
      '${widget.pdfLink}',
      cacheManager: CacheManager(
        Config(
          "${widget.pdfLink}",
          stalePeriod: const Duration(days: 2),
          maxNrOfCacheObjects: 10,
        ),
      ),
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionCheckerWidget(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document, zoomSteps: 1),
        ),
      ),
    );
  }
}
