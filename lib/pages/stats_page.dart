import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../widgets/stats_widget.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        heroTag: 'navbar2',
        transitionBetweenRoutes: false,
        backgroundColor: Colors.white,
        middle: Text(
          "Monthly Report",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      backgroundColor: grey.withOpacity(0.05),
      child: const StatsWidget(),
    );
  }
}
