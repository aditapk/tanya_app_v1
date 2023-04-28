import 'dart:io';

import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfAPI {
  static Future<File> generatePDFReport(String pdfName) async {
    final pdf = Document();
    pdf.addPage(Page(build: (context) {
      return Center(child: Text('Simple PDF'));
    }));
    //var name = 'example.pdf';
    // save
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$pdfName');

    await file.writeAsBytes(bytes);

    return file;
  }
}
