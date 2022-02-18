import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

class DailyTransactions with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isInit = true;
  var totalPerWeek = 0.0;
  List<Transaction> _transactionsList = [];
  void initTransactions() async {
    final prefs = await _prefs;
    if (isInit) {
      if (prefs.containsKey('transactions')) {
        for (var i = 0;
            i < jsonDecode(prefs.getString('transactions')!).length;
            i++) {
          var txJson = (jsonDecode(prefs.getString('transactions')!)
              as List<dynamic>)[i];
          _transactionsList.add(Transaction(
              id: txJson[0],
              title: txJson[1],
              amount: txJson[2],
              createdAt: DateTime.parse(txJson[3])));
        }
      } else {
        _transactionsList = [];
      }
      isInit = false;
      notifyListeners();
    }
  }

  List<Transaction> filteredDailyExpenses(int currentWeekDay) {
    if (_transactionsList.isEmpty) {
      return [];
    }
    final weekDay = DateTime.now().subtract(Duration(days: currentWeekDay));
    return [..._transactionsList]
        .where((expense) =>
            expense.createdAt.day == weekDay.day &&
            expense.createdAt.month == weekDay.month &&
            expense.createdAt.year == weekDay.year)
        .toList();
  }

  String totalSpentPerDay(int currentMonth, int currentDay) {
    final weekDay = DateTime(DateTime.now().year, currentMonth, currentDay);
    var totalPerDay = 0.0;
    for (var tx in _transactionsList) {
      if (tx.createdAt.day == weekDay.day &&
          tx.createdAt.month == weekDay.month &&
          tx.createdAt.year == weekDay.year) {
        totalPerDay += tx.amount;
      }
    }
    return totalPerDay.toStringAsFixed(2);
  }

  List<Transaction> filteredDailyExpensesBasedOnSelectedWeek(
    int currentWeekDay,
    int currentMonth,
    int currentWeek,
  ) {
    var totalDaysInWeek = 7;

    List<Transaction> filteredTxPerWeek = [];

    var weekDays = DateTime(
        DateTime.now().year, currentMonth - 1, (currentWeek * totalDaysInWeek));

    if (currentWeek == 5) {
      totalDaysInWeek = DateTime(DateTime.now().year, currentMonth, 0).day - 28;
      weekDays = DateTime(DateTime.now().year, currentMonth, 0);
    }

    for (var j = totalDaysInWeek - 1; j >= 0; j--) {
      for (var tx in _transactionsList) {
        if (tx.createdAt.day == weekDays.day - j &&
            tx.createdAt.month == weekDays.month &&
            tx.createdAt.year == weekDays.year) {
          filteredTxPerWeek.add(tx);
          totalPerWeek += tx.amount;
        }
      }
    }

    List<Transaction> newList = [];

    if (filteredTxPerWeek.isEmpty) {
      return [];
    }

    final weekDay =
        DateTime(DateTime.now().year, currentMonth - 1, currentWeekDay);

    for (var tx in filteredTxPerWeek) {
      if (tx.createdAt.day == weekDay.day &&
          tx.createdAt.month == weekDay.month &&
          tx.createdAt.year == weekDay.year) {
        newList.add(tx);
      }
    }

    return newList;
  }

  String filteredMonthlyExpenses(int currentMonth) {
    if (_transactionsList.isEmpty) {
      return '0';
    }
    final month = DateTime(DateTime.now().year, currentMonth, 0);
    final filteredList = [..._transactionsList]
        .where((expense) =>
            expense.createdAt.month == month.month &&
            expense.createdAt.year == month.year)
        .toList();
    var totalMonthlySpent = 0.0;
    for (var transaction in filteredList) {
      totalMonthlySpent += transaction.amount;
    }
    return totalMonthlySpent.toStringAsFixed(2);
  }

  int getWeeksOfMonth(int currentMonth) {
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, currentMonth, 0);
    if (lastDayOfMonth.day / 7 > 4) {
      return 5;
    }
    return 4;
  }

  String getTotalPerWeek(int currentMonth, int currentWeek) {
    filterTransactionsBasedOnWeek(currentMonth, currentWeek);
    return totalPerWeek.toStringAsFixed(2);
  }

  List<Transaction> filterTransactionsBasedOnWeek(
    int currentMonth,
    int currentWeek,
  ) {
    List<Transaction> filteredTxPerWeek = [];
    totalPerWeek = 0.0;
    var totalDaysInWeek = 7;
    var weekDays = DateTime(
        DateTime.now().year, currentMonth - 1, (currentWeek * totalDaysInWeek));
    if (currentWeek == 5) {
      totalDaysInWeek = DateTime(DateTime.now().year, currentMonth, 0).day - 28;
      weekDays = DateTime(DateTime.now().year, currentMonth, 0);
    }
    for (var j = totalDaysInWeek - 1; j >= 0; j--) {
      for (var tx in _transactionsList) {
        if (tx.createdAt.day == weekDays.day - j &&
            tx.createdAt.month == weekDays.month &&
            tx.createdAt.year == weekDays.year) {
          print('${tx.id} .. in ${tx.title}');
          filteredTxPerWeek.add(tx);
          totalPerWeek += tx.amount;
        }
      }
    }
    return filteredTxPerWeek;
  }

  Future<void> addNewTransaction(
      String title, double amount, DateTime createdAt) async {
    final prefs = await _prefs;
    try {
      final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        createdAt: createdAt,
      );
      _transactionsList.add(newTx);
      prefs.remove('transactions');
      prefs.setString(
          'transactions',
          jsonEncode(_transactionsList.map((i) => i.toJson()).toList())
              .toString());
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final prefs = await _prefs;
    try {
      _transactionsList.removeWhere((tx) => tx.id == id);
      prefs.remove('transactions');
      prefs.setString(
          'transactions',
          jsonEncode(_transactionsList.map((i) => i.toJson()).toList())
              .toString());
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }
}
