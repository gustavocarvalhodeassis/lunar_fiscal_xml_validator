import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/content/home/widgets/home_header_filters_widget.dart';
import 'package:fiscal_validator/content/home/widgets/home_missing_items_alert_dialog.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeHeaderResultWidget extends StatefulWidget {
  const HomeHeaderResultWidget({super.key});

  @override
  State<HomeHeaderResultWidget> createState() => _HomeHeaderResultWidgetState();
}

class _HomeHeaderResultWidgetState extends State<HomeHeaderResultWidget> {
  final _controller = Get.put(HomeController());

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
              Obx(
                () => Text(
                  'Valor Total: ${doubleToCurrency(_controller.calculateTotal(_controller.currentXmlList.value))}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Obx(
                () => TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => HomeMissingItemsAlertDialog(),
                    );
                  },
                  child: Text(
                    'Numeros Faltantes: ${_controller.missingNumbers..value.length}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          const HomeHeaderFiltersWidget()
        ],
      ),
    );
  }
}
