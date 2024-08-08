import 'package:fiscal_validator/content/home/controllers/home_provider.dart';
import 'package:fiscal_validator/content/home/widgets/build_result_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
      child: ResultBody(
        xmls: homeProvider.nfXmlList,
        missingNumbers: homeProvider.missingNumber,
      ),
    );
  }
}
