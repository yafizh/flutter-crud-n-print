import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/models/position.dart';
import 'package:simple_crud_n_print/services/position_service.dart';
import 'package:pdf/widgets.dart' as pw;

class PositionScreen extends StatelessWidget {
  const PositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PositionService>(builder: (context, value, child) {
      return FutureBuilder(
          future: value.getPositions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading...'));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Server Error'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Position is Empty'));
            }

            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text(snapshot.data![index].name)),
                        ],
                      ),
                    ),
                  );
                });
          });
    });
  }

  Future<Uint8List> generatePdf(context, PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final fontHeader = await PdfGoogleFonts.nunitoBold();
    final fontBody = await PdfGoogleFonts.nunitoExtraLight();

    List<Position> positions =
        await Provider.of<PositionService>(context, listen: false)
            .getPositions();

    pdf.addPage(pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Padding(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Table(border: pw.TableBorder.all(), children: [
                pw.TableRow(children: [
                  pw.Column(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Position Name',
                            style: pw.TextStyle(font: fontHeader))),
                  ])
                ]),
                ...positions.map((position) {
                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(position.name,
                          style: pw.TextStyle(font: fontBody)),
                    )
                  ]);
                })
              ]));
        }));

    return pdf.save();
  }
}
