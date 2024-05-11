import 'package:fiscal_validator/pages/home_page/widgets/build_result_body.dart';
import 'package:fiscal_validator/providers/home_provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                text: 'NFC-e',
              ),
              Tab(
                text: 'NF-e',
              ),
            ],
          ),
          Container(
            height: 520,
            padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
            child: TabBarView(
              children: [
                ResultBody(
                  xmls: homeProvider.nfcXmlList,
                  totalValue: homeProvider.totalNFCE,
                  missingNumbers: homeProvider.missingNumberNFC,
                ),
                ResultBody(
                  xmls: homeProvider.nfXmlList,
                  totalValue: homeProvider.totalNFE,
                  missingNumbers: homeProvider.missingNumberNF,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
