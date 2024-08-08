import 'package:fiscal_validator/content/home/controllers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoItems extends StatelessWidget {
  const NoItems({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => homeProvider.act(context),
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selecionar pasta',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'A Organização dos arquivos deve ser XML/NFC/Emitidas ou XML/NF/Emitidas',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
