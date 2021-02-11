import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFView extends StatelessWidget {

    final String path;

    PDFView(this.path);

    @override
    Widget build(BuildContext context) {
        return PDFViewerScaffold(path: path);
    }
}