import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

class HomeMissingItemsAlertDialog extends StatelessWidget {
  const HomeMissingItemsAlertDialog({super.key, required this.missingNumbers});

  final List<int> missingNumbers;

  @override
  Widget build(BuildContext context) {
    final _controller = HomeController();
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Text(
            'Numeros Faltantes',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            '${missingNumbers.length}',
            style: Theme.of(context).textTheme.displayLarge,
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
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: missingNumbers.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onTap: () => _controller.copyText(missingNumbers[index].toString()),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(
                        missingNumbers[index].toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        onPressed: () => _controller.copyText(missingNumbers[index].toString()),
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
