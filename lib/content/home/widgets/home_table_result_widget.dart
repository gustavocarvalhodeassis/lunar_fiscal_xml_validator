import 'package:fiscal_validator/global/models/xml_model.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';

class HomeTableResultWidget extends StatelessWidget {
  const HomeTableResultWidget({super.key, required this.xmlList});

  final List<XMLModel> xmlList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
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
            rows: xmlList.map(
              (item) {
                return DataRow(
                  cells: [
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
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
