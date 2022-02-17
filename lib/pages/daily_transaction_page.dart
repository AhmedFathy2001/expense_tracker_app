import 'package:flutter/material.dart';

import '../widgets/daily_transactions_widget.dart';

class DailyTransactionPage extends StatelessWidget {
  final String title;
  final bool weekClick;
  final int? selectedMonth;
  final int? selectedWeek;
  final String uniqueKey;

  const DailyTransactionPage(
      {this.title = 'Daily Transactions',
      required this.uniqueKey,
      this.weekClick = false,
      this.selectedMonth,
      this.selectedWeek,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DailyTransactionWidget(
        title: title,
        uniqueKey: uniqueKey,
        weekClick: weekClick,
        selectedMonth: selectedMonth,
        selectedWeek: selectedWeek,
      ),
    );
  }
}
