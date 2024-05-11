import 'package:fiscal_validator/providers/home_provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissingItems extends StatelessWidget {
  const MissingItems({super.key, required this.missingItems});

  final List<int> missingItems;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Text(
            'Numeros Faltantes',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            '${missingItems.length}',
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
                itemCount: missingItems.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onTap: () => homeProvider.copyText(context,
                          text: missingItems[index].toString()),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      title: Text(
                        missingItems[index].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        onPressed: () => homeProvider.copyText(context,
                            text: missingItems[index].toString()),
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
            child: const Text('Fechar'))
      ],
    );
  }
}
