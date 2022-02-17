import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/daily_transactions.dart';
import '../theme/colors.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key}) : super(key: key);

  @override
  _CreateTransactionPageState createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  int activeCategory = 0;
  final _transactionTitle = TextEditingController();
  final _transactionAmount = TextEditingController(text: "\$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    final _transactions = Provider.of<DailyTransactions>(context);
    var _selectedDate = DateTime.now();
    var size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: Text(
          "Create a Transaction",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
                child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime.now(),
              onDateChanged: (DateTime value) {
                _selectedDate = value;
              },
            )),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Transaction Title",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xff67727d)),
                  ),
                  TextField(
                    controller: _transactionTitle,
                    cursorColor: black,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: black),
                    decoration: const InputDecoration(
                        hintText: "Enter Transaction title",
                        border: InputBorder.none),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (size.width - 140),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Amount spent",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d)),
                            ),
                            TextField(
                              controller: _transactionAmount,
                              cursorColor: black,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              decoration: const InputDecoration(
                                  hintText: "Enter Transaction Amount",
                                  border: InputBorder.none),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          try {
                            _transactions.addNewTransaction(
                                _transactionTitle.text.trim(),
                                double.parse(_transactionAmount.text
                                    .trim()
                                    .substring(1,
                                        _transactionAmount.text.trim().length)),
                                _selectedDate);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Transaction added successfully.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {
                              _transactionTitle.clear();
                              _transactionAmount.text = '\$';
                            });
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to save transaction.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
