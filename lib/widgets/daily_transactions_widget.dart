import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/daily_transactions.dart';
import '../theme/colors.dart';

class DailyTransactionWidget extends StatefulWidget {
  final String title;
  final bool weekClick;
  final String uniqueKey;
  final int? selectedMonth;
  final int? selectedWeek;
  const DailyTransactionWidget(
      {this.title = 'Daily Transactions',
      required this.uniqueKey,
      this.weekClick = false,
      this.selectedMonth,
      this.selectedWeek,
      Key? key})
      : super(key: key);
  @override
  _DailyTransactionWidgetState createState() => _DailyTransactionWidgetState();
}

class _DailyTransactionWidgetState extends State<DailyTransactionWidget> {
  int activeDay = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final expense = Provider.of<DailyTransactions>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: widget.uniqueKey,
        transitionBetweenRoutes: false,
        backgroundColor: Colors.white,
        middle: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.01),
                    spreadRadius: 10,
                    blurRadius: 3,
                    // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 25),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.selectedWeek == 5
                            ? DateTime(DateTime.now().year,
                                        widget.selectedMonth!, 0)
                                    .day -
                                28
                            : 7,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeDay = index;
                              });
                            },
                            child: SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 7,
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat.E().format(
                                      !widget.weekClick
                                          ? (DateTime.now()
                                              .subtract(Duration(days: index)))
                                          : DateTime(
                                              DateTime.now().year,
                                              widget.selectedMonth!,
                                              0,
                                            ).subtract(Duration(days: index)),
                                    ),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: activeDay == index
                                            ? primary
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: activeDay == index
                                                ? primary
                                                : black.withOpacity(0.1))),
                                    child: Center(
                                      child: Text(
                                        DateFormat('d').format(
                                          widget.weekClick
                                              ? (DateTime(
                                                      DateTime.now().year,
                                                      widget.selectedMonth!,
                                                      (widget.selectedWeek == 5
                                                          ? 0
                                                          : widget.selectedWeek! *
                                                              7))
                                                  .subtract(
                                                  Duration(
                                                    days: index,
                                                  ),
                                                ))
                                              : (DateTime.now().subtract(
                                                  Duration(days: index),
                                                )),
                                        ),
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: activeDay == index
                                                ? white
                                                : black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ).reversed.toList(),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: ((widget.weekClick &&
                            expense
                                .filteredDailyExpensesBasedOnSelectedWeek(
                                    ((widget.selectedWeek! * 7) - activeDay),
                                    widget.selectedMonth!,
                                    widget.selectedWeek!)
                                .isEmpty) ||
                        (!widget.weekClick &&
                            expense.filteredDailyExpenses(activeDay).isEmpty))
                    ? [
                        const Center(
                          child: Text(
                              'No transactions recorded today, add transactions to see them here!'),
                        ),
                      ]
                    : List.generate(
                        widget.weekClick
                            ? expense
                                .filteredDailyExpensesBasedOnSelectedWeek(
                                    ((widget.selectedWeek! * 7) - activeDay),
                                    widget.selectedMonth!,
                                    widget.selectedWeek!)
                                .length
                            : expense.filteredDailyExpenses(activeDay).length,
                        (index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: UniqueKey(),
                            onDismissed: (dismissDirection) {
                              expense.deleteTransaction(expense
                                  .filteredDailyExpenses(activeDay)[index]
                                  .id);
                            },
                            background: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                              color: Theme.of(context).errorColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (size.width - 40) * 0.7,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          SizedBox(
                                            width: (size.width - 90) * 0.5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.weekClick
                                                      ? expense
                                                          .filteredDailyExpensesBasedOnSelectedWeek(
                                                              ((widget.selectedWeek! *
                                                                      7) -
                                                                  activeDay),
                                                              widget
                                                                  .selectedMonth!,
                                                              widget
                                                                  .selectedWeek!)[
                                                              index]
                                                          .title
                                                      : expense
                                                          .filteredDailyExpenses(
                                                              activeDay)[index]
                                                          .title,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  DateFormat.yMMMd().format(widget
                                                          .weekClick
                                                      ? expense
                                                          .filteredDailyExpensesBasedOnSelectedWeek(
                                                              ((widget.selectedWeek! *
                                                                      7) -
                                                                  activeDay),
                                                              widget
                                                                  .selectedMonth!,
                                                              widget
                                                                  .selectedWeek!)[
                                                              index]
                                                          .createdAt
                                                      : expense
                                                          .filteredDailyExpenses(
                                                              activeDay)[index]
                                                          .createdAt),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: black
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (size.width - 40) * 0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${widget.weekClick ? expense.filteredDailyExpensesBasedOnSelectedWeek(((widget.selectedWeek! * 7) - activeDay), widget.selectedMonth!, widget.selectedWeek!)[index].amount : expense.filteredDailyExpenses(activeDay)[index].amount}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 65, top: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if ((widget.weekClick &&
                    expense
                        .filteredDailyExpensesBasedOnSelectedWeek(
                            ((widget.selectedWeek! * 7) - activeDay),
                            widget.selectedMonth!,
                            widget.selectedWeek!)
                        .isNotEmpty) ||
                (!widget.weekClick &&
                    expense.filteredDailyExpenses(activeDay).isNotEmpty))
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 80),
                      child: Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 16,
                            color: black.withOpacity(0.4),
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 25),
                      child: Text(
                        "\$${widget.weekClick ? expense.totalSpentPerDay(widget.selectedMonth! - 1, (widget.selectedWeek! * 7 - activeDay)) : expense.totalSpentPerDay(DateTime.now().month, (DateTime.now().day - activeDay))}",
                        style: const TextStyle(
                            fontSize: 20,
                            color: black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
