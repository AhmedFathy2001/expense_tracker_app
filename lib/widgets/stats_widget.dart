import 'package:expense_trackerr/pages/daily_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../providers/daily_transactions.dart';
import '../theme/colors.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  int activeMonth = 6 - DateTime.now().month + 1;
  final date = DateTime.now();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final monthlyTransactions =
          Provider.of<DailyTransactions>(context, listen: false);
      monthlyTransactions.filteredMonthlyExpenses(activeMonth - date.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyTransactions = Provider.of<DailyTransactions>(context);
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: white, boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 25),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(6, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeMonth = index;
                                monthlyTransactions.filteredMonthlyExpenses(
                                    index - date.month);
                              });
                            },
                            child: SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 6,
                              child: Column(
                                children: [
                                  Text(
                                    '${DateTime(date.year, index - date.month, 0).year}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: activeMonth == index
                                            ? primary
                                            : black.withOpacity(0.02),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: activeMonth == index
                                                ? primary
                                                : black.withOpacity(0.1))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 7,
                                          bottom: 7),
                                      child: Text(
                                        DateFormat.MMM().format(DateTime(
                                            date.year, index - date.month, 0)),
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: activeMonth == index
                                                ? white
                                                : black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: (size.width - 30),
              height: 170,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: secondary),
                          child: const Center(
                              child: Icon(
                            Ionicons.calendar_outline,
                            color: white,
                          )),
                        ),
                        const Text(
                          'Monthly Expenses',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '\$${monthlyTransactions.filteredMonthlyExpenses(activeMonth - date.month).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
                spacing: 20,
                children: List.generate(
                    monthlyTransactions
                        .getWeeksOfMonth(activeMonth - date.month), (index) {
                  return GestureDetector(
                    onTap: () {
                      final currentMonthNum = activeMonth - date.month;
                      setState(() {
                        monthlyTransactions.filterTransactionsBasedOnWeek(
                            currentMonthNum, index + 1);
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => DailyTransactionPage(
                                title: 'Week ${index + 1}',
                                weekClick: true,
                                uniqueKey: 'key2',
                                selectedWeek: index + 1,
                                selectedMonth: currentMonthNum,
                              )));
                    },
                    child: Container(
                      width: (size.width - 60) / 2,
                      height: 170,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.01),
                              spreadRadius: 10,
                              blurRadius: 3,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: blue),
                              child: const Center(
                                  child: Icon(
                                Icons.arrow_forward,
                                color: white,
                              )),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Week ${index + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Color(0xff67727d)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '\$${monthlyTransactions.getTotalPerWeek(activeMonth - date.month, index + 1)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }
}
