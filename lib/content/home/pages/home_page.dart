import 'package:fiscal_validator/content/home/controllers/home_provider.dart';
import 'package:fiscal_validator/content/home/widgets/build_main_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Validador XMLs'),
        actions: [
          IconButton(
            onPressed: () => homeProvider.reset(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: Builder(
              builder: (context) {
                if (!homeProvider.isLoading) {
                  return const MainBody();
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
        label: const Text('Arquivo'),
        icon: const Icon(Icons.archive),
        onPressed: () => homeProvider.act(context),
      ),
    );
  }
}
