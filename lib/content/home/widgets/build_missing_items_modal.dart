import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissingItems extends StatefulWidget {
  const MissingItems({super.key, required this.missingItems});

  final List<int> missingItems;

  @override
  State<MissingItems> createState() => _MissingItemsState();
}

class _MissingItemsState extends State<MissingItems> {
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
          Text(
            '${widget.missingItems.length}',
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
                itemCount: widget.missingItems.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onTap: () => _controller.copyText(widget.missingItems[index].toString()),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(
                        widget.missingItems[index].toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        onPressed: () => _controller.copyText(widget.missingItems[index].toString()),
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
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
    );
  }
}
