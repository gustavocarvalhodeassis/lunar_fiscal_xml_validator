import 'package:fiscal_validator/pages/home_page/widgets/build_main_body.dart';
import 'package:fiscal_validator/pages/home_page/widgets/build_no_items.dart';
import 'package:fiscal_validator/providers/home_provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar XMLs'),
        actions: [
          IconButton(
            onPressed: () => homeProvider.reset(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 600),
          child: Card(
            child: Builder(
              builder: (context) {
                if (!homeProvider.isLoading) {
                  if (homeProvider.nfXmlList.isNotEmpty ||
                      homeProvider.nfcXmlList.isNotEmpty) {
                    return const MainBody();
                  } else {
                    return const NoItems();
                  }
                } else {
                  return const SizedBox(
                    width: 150,
                    height: 600,
                    child: Align(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label:  Text('Arquivo'),
        icon:  Icon(Icons.archive),
        onPressed: () => homeProvider.act(context),
      ),
    );
  }
}
