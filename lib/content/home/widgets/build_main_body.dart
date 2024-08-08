import 'package:fiscal_validator/content/home/controllers/home_controller.dart';
import 'package:fiscal_validator/content/home/widgets/build_result_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
      child: Obx(
        () => ResultBody(
          xmls: _controller.currentXmlList.value,
          missingNumbers: _controller.missingNumbers.value,
        ),
      ),
    );
  }
}
