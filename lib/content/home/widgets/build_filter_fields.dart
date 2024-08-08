import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/global/widgets/checkbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BuildFilterFields extends StatefulWidget {
  const BuildFilterFields({super.key});

  @override
  State<BuildFilterFields> createState() => _BuildFilterFieldsState();
}

class _BuildFilterFieldsState extends State<BuildFilterFields> {
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Obx(
              () => CheckboxWidget(
                value: _controller.mostrarAutorizadas.value,
                onChanged: _controller.handleFilterAutorizada,
                label: 'Autorizadas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: _controller.mostrarCanceladas.value,
                onChanged: _controller.handleFilterCancelada,
                label: 'Canceladas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: _controller.mostrarInutilizadas.value,
                onChanged: _controller.handleFilterInutilizada,
                label: 'Inutilizadas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: _controller.mostrarIncorretas.value,
                onChanged: _controller.handleFilterIncorreta,
                label: 'Incorretas',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: _controller.mostrarModelo55.value,
                onChanged: _controller.handleFilterModelo55,
                label: 'NF-e (Modelo 55)',
              ),
            ),
            Obx(
              () => CheckboxWidget(
                value: _controller.mostrarModelo65.value,
                onChanged: _controller.handleFilterModelo65,
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
              flex: 3,
              child: Obx(
                () => TextField(
                  onSubmitted: (value) {
                    _controller.handleFilters();
                  },
                  controller: _controller.searchController.value,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _controller.handleFilters();
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
                  onChanged: _controller.handleDateOnChanged,
                  onSubmitted: (value) => _controller.handleFilters(),
                  controller: _controller.dateController.value,
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '##/##/#### Até ##/##/####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                  ],
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _controller.handleDateRangePicker(context);
                        },
                        icon: const Icon(Icons.date_range_outlined)),
                    labelText: 'Periodo',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
