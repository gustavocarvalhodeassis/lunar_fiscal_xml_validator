import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/content/home/widgets/build_filter_fields.dart';
import 'package:fiscal_validator/content/home/widgets/build_missing_items_modal.dart';
import 'package:fiscal_validator/global/models/xml_model.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultBody extends StatefulWidget {
  const ResultBody({super.key, required this.xmls, required this.missingNumbers});

  final List<XMLModel> xmls;
  final List<int> missingNumbers;

  @override
  State<ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Valor Total: ${doubleToCurrency(_controller.calculateTotal(_controller.currentXmlList.value))}',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => MissingItems(missingItems: widget.missingNumbers),
                      );
                    },
                    child: Text(
                      'Numeros Faltantes: ${widget.missingNumbers.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              const BuildFilterFields()
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Divider(),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            child: Builder(
              builder: (context) {
                if (!_controller.isLoading.value) {
                  return SingleChildScrollView(
                    child: DataTable(
                      border: TableBorder.all(width: 1, borderRadius: BorderRadius.circular(15), color: Theme.of(context).colorScheme.outline),
                      columns: const [
                        DataColumn(label: Text('Chave')),
                        DataColumn(label: Text('Numero')),
                        DataColumn(label: Text('Tipo')),
                        DataColumn(label: Text('Data de Emissão')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Valor')),
                      ],
                      rows: _controller.currentXmlList.value.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item.chave != null
                              ? item.chave!
                              : item.inutilizada
                                  ? 'INUTILIZAÇÃO ${item.numeroInutIni} ATÉ ${item.numeroInutFin}'
                                  : item.incorreta
                                      ? 'NOTA INCORRETA - ${item.chave}'
                                      : '')),
                          DataCell(Text(item.numero.isNotEmpty ? item.numero : '${item.numeroInutIni} - ${item.numeroInutFin}')),
                          DataCell(Text(item.modelo)),
                          DataCell(Text(dateToString(item.dataEmissao) ?? '')),
                          DataCell(Text(item.status)),
                          DataCell(Text(doubleToCurrency(item.valor) ?? '')),
                        ]);
                      }).toList(),
                    ),
                  );
                  // return ExpandableTable(
                  //   expanded: true,
                  //   firstHeaderCell: ExpandableTableCell(
                  //     child: Text('Chave'),
                  //   ),
                  //   firstColumnWidth: 300,
                  //   headers: [
                  //     ExpandableTableHeader(
                  //       cell: ExpandableTableCell(child: Text('Número')),
                  //     ),
                  //     ExpandableTableHeader(
                  //       cell: ExpandableTableCell(child: Text('Modelo')),
                  //     ),
                  //     ExpandableTableHeader(
                  //       cell: ExpandableTableCell(child: Text('Data de emissão')),
                  //     ),
                  //     ExpandableTableHeader(
                  //       cell: ExpandableTableCell(child: Text('Status')),
                  //     ),
                  //     ExpandableTableHeader(
                  //       cell: ExpandableTableCell(child: Text('Valor')),
                  //     ),
                  //   ],
                  //   rows: _controller.currentXmlList.value.map(
                  //     (item) {
                  //       return ExpandableTableRow(
                  //         firstCell: ExpandableTableCell(
                  //             child: Text(item.chave != null
                  //                 ? item.chave!
                  //                 : item.inutilizada
                  //                     ? 'INUTILIZAÇÃO ${item.numeroInutIni} ATÉ ${item.numeroInutFin}'
                  //                     : item.incorreta
                  //                         ? 'NOTA INCORRETA - ${item.chave}'
                  //                         : '')),
                  //         cells: [
                  //           ExpandableTableCell(child: Text(item.numero.isNotEmpty ? item.numero : '${item.numeroInutIni} - ${item.numeroInutFin}')),
                  //           ExpandableTableCell(child: Text(item.modelo)),
                  //           ExpandableTableCell(child: Text(dateToString(item.dataEmissao) ?? '')),
                  //           ExpandableTableCell(
                  //             child: Text(item.status),
                  //           ),
                  //           ExpandableTableCell(child: Text(doubleToCurrency(item.valor) ?? '')),
                  //         ],
                  //       );
                  //     },
                  //   ).toList(),
                  // );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
