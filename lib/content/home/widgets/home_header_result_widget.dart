import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/content/home/widgets/home_header_filters_widget.dart';
import 'package:fiscal_validator/content/home/widgets/home_missing_items_alert_dialog.dart';
import 'package:fiscal_validator/global/widgets/gap_widget.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';

class HomeHeaderResultWidget extends StatelessWidget {
  const HomeHeaderResultWidget({super.key, required this.totalValue, required this.missingNumbers, required this.controller});

  final double totalValue;
  final List<int> missingNumbers;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(
                'Valor Total: ${doubleToCurrency(totalValue)}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => HomeMissingItemsAlertDialog(
                      missingNumbers: missingNumbers,
                    ),
                  );
                },
                child: Text(
                  'Numeros Faltantes: ${missingNumbers.length}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          Gapv20(),
          const Divider(),
          Gapv20(),
          HomeHeaderFiltersWidget(
            controller: controller,
          )
        ],
      ),
    );
  }
}
