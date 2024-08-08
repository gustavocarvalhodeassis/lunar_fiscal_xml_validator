import 'package:fiscal_validator/content/home/controllers/home_provider.dart';
import 'package:fiscal_validator/global/widgets/checkbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class BuildFilterFields extends StatelessWidget {
  const BuildFilterFields({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            CheckboxWidget(
              value: homeProvider.isFilterAutorizadas,
              onChanged: homeProvider.handleFilterAutorizada,
              label: 'Autorizadas',
            ),
            CheckboxWidget(
              value: homeProvider.isFilterCanceladas,
              onChanged: homeProvider.handleFilterCancelada,
              label: 'Canceladas',
            ),
            CheckboxWidget(
              value: homeProvider.isFilterInutilizadas,
              onChanged: homeProvider.handleFilterInutilizada,
              label: 'Inutilizadas',
            ),
            CheckboxWidget(
              value: homeProvider.isFilterIncorretas,
              onChanged: homeProvider.handleFilterIncorreta,
              label: 'Incorretas',
            ),
            CheckboxWidget(
              value: homeProvider.isFilterModelo55,
              onChanged: homeProvider.handleFilterModelo55,
              label: 'NF-e (Modelo 55)',
            ),
            CheckboxWidget(
              value: homeProvider.isFilterModelo65,
              onChanged: homeProvider.handleFilterModelo65,
              label: 'NFC-e (Modelo 65)',
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
              child: TextField(
                onSubmitted: (value) {
                  homeProvider.handleFilters();
                },
                controller: homeProvider.searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        homeProvider.handleFilters();
                      },
                      icon: const Icon(Icons.search_outlined)),
                  labelText: 'Pesquisar',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 1,
              child: TextField(
                onChanged: homeProvider.handleDateOnChanged,
                onSubmitted: (value) => homeProvider.handleFilters(),
                controller: homeProvider.dateController,
                inputFormatters: [
                  MaskTextInputFormatter(mask: '##/##/#### Até ##/##/####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                ],
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        homeProvider.setDateRange(context);
                      },
                      icon: const Icon(Icons.date_range_outlined)),
                  labelText: 'Periodo',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
