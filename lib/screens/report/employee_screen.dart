import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/models/employee.dart';
import 'package:simple_crud_n_print/services/employee_service.dart';
import 'package:pdf/widgets.dart' as pw;

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeService>(builder: (context, value, child) {
      return FutureBuilder(
          future: value.employees(withPosition: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading...'));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Server Error'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Employee is Empty'));
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
                          Expanded(
                              child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(snapshot.data![index].posotion!.name)
                            ],
                          )),
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

    List<Employee> employees =
        await Provider.of<EmployeeService>(context, listen: false)
            .employees(withPosition: true);

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
                        child: pw.Text('Emmployee Name',
                            style: pw.TextStyle(font: fontHeader))),
                  ]),
                  pw.Column(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Position Name',
                            style: pw.TextStyle(font: fontHeader))),
                  ])
                ]),
                ...employees.map((employee) {
                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(employee.name,
                          style: pw.TextStyle(font: fontBody)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(employee.posotion!.name,
                          style: pw.TextStyle(font: fontBody)),
                    )
                  ]);
                })
              ]));
        }));

    return pdf.save();
  }
}
