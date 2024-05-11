import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fiscal_validator/models/xml_model.dart';
import 'package:fiscal_validator/pages/home_page/widgets/build_missing_items_modal.dart';
import 'package:fiscal_validator/providers/home_provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultBody extends StatefulWidget {
  const ResultBody(
      {super.key,
      required this.xmls,
      required this.totalValue,
      required this.missingNumbers});

  final List<XMLModel> xmls;
  final double totalValue;
  final List<int> missingNumbers;

  @override
  State<ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<ResultBody> {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    locale: 'pt-BR',
    decimalDigits: 2,
    symbol: 'R\$ ',
  );

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor Total: ${_formatter.format(widget.totalValue.toStringAsFixed(2))}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        MissingItems(missingItems: widget.missingNumbers),
                  );
                },
                child: Text(
                  'Numeros Faltantes: ${widget.missingNumbers.length}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.xmls.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    leading: TextButton(
                      onPressed: () => homeProvider.copyText(context,
                          text: widget.xmls[index].numero.toString()),
                      child: Text(
                        widget.xmls[index].numero.toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => homeProvider.copyText(context,
                              text: widget.xmls[index].chave),
                          child: Text(
                            widget.xmls[index].chave,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () => homeProvider.copyText(context,
                          text: _formatter.format(
                              widget.xmls[index].valor.toStringAsFixed(2))),
                      child: Text(
                        _formatter.format(
                            widget.xmls[index].valor.toStringAsFixed(2)),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                    height: 1,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
