import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/content/home/widgets/build_main_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Validador XMLs'),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: Builder(
              builder: (context) {
                if (!_controller.isLoading.value) {
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
        onPressed: () => _controller.collectArchives(),
      ),
    );
  }
}
