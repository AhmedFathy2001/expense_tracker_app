import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/root_app.dart';
import 'providers/daily_transactions.dart';
import 'theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return ChangeNotifierProvider(
      create: (ctx) => DailyTransactions(),
      child: MaterialApp(
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: primary,
            secondary: secondary,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<DailyTransactions>(
          builder: (ctx, expense, _) {
            expense.initTransactions();
            return const RootApp();
          },
        ),
      ),
    );
  }
}
