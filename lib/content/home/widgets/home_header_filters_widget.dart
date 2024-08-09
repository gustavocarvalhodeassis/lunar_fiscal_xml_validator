import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/global/widgets/checkbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeHeaderFiltersWidget extends StatelessWidget {
  const HomeHeaderFiltersWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          children: [
            Obx(
              () => CheckboxWidget(
                value: controller.mostrarAutorizadas.value,
                onChanged: controller.handleFilterAutorizada,
                label: 'Autorizadas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: controller.mostrarCanceladas.value,
                onChanged: controller.handleFilterCancelada,
                label: 'Canceladas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: controller.mostrarInutilizadas.value,
                onChanged: controller.handleFilterInutilizada,
                label: 'Inutilizadas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: controller.mostrarIncorretas.value,
                onChanged: controller.handleFilterIncorreta,
                label: 'Incorretas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: controller.mostrarModelo55.value,
                onChanged: controller.handleFilterModelo55,
                label: 'NF-e (Modelo 55)',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: controller.mostrarModelo65.value,
                onChanged: controller.handleFilterModelo65,
                label: 'NFC-e (Modelo 65)',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Obx(
                () => TextField(
                  onSubmitted: (value) {
                    controller.handleFilters();
                  },
                  onChanged: controller.handleSearchOnChanged,
                  controller: controller.searchController.value,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.handleFilters();
                        },
                        icon: const Icon(Icons.search_outlined)),
                    labelText: 'Pesquisar',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 1,
              child: Obx(
                () => TextField(
                  onChanged: controller.handleDateOnChanged,
                  onSubmitted: (value) => controller.handleFilters(),
                  controller: controller.dateController.value,
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '##/##/#### Até ##/##/####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                  ],
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.handleDateRangePicker(context);
                        },
                        icon: const Icon(Icons.date_range_outlined)),
                    labelText: 'Periodo',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
