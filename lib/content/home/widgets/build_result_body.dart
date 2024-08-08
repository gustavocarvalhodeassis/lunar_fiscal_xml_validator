import 'package:fiscal_validator/content/home/controllers/home_provider.dart';
import 'package:fiscal_validator/content/home/widgets/build_filter_fields.dart';
import 'package:fiscal_validator/content/home/widgets/build_missing_items_modal.dart';
import 'package:fiscal_validator/models/xml_model.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultBody extends StatefulWidget {
  const ResultBody({super.key, required this.xmls, required this.missingNumbers});

  final List<XMLModel> xmls;
  final List<int> missingNumbers;

  @override
  State<ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  Text(
                    'Valor Total: ${doubleToCurrency(homeProvider.calculateTotal(homeProvider.nfXmlList))}',
                    style: Theme.of(context).textTheme.displaySmall,
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
        Expanded(
          child: SizedBox(
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  if (!homeProvider.isLoading) {
                    return SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Chave')),
                          DataColumn(label: Text('Numero')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Data de Emissão')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Valor')),
                        ],
                        rows: homeProvider.nfXmlList.map((item) {
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
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ),
      ],
    );
  }
}
