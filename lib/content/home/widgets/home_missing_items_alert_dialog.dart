import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMissingItemsAlertDialog extends StatefulWidget {
  const HomeMissingItemsAlertDialog({super.key});

  @override
  State<HomeMissingItemsAlertDialog> createState() => _HomeMissingItemsAlertDialogState();
}

class _HomeMissingItemsAlertDialogState extends State<HomeMissingItemsAlertDialog> {
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Text(
            'Numeros Faltantes',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Obx(
            () => Text(
              '${_controller.missingNumbers.value.length}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 400, maxWidth: 600),
        width: 600,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
            ),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              height: 1,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _controller.missingNumbers.value.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      ListTile(
                        onTap: () => _controller.copyText(_controller.missingNumbers.value[index].toString()),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(
                          _controller.missingNumbers.value[index].toString(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          onPressed: () => _controller.copyText(_controller.missingNumbers.value[index].toString()),
                          icon: const Icon(Icons.copy),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.outline,
                        height: 1,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
