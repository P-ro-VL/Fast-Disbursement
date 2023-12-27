// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:fast_disbursement/components/clickable_widget.dart';
import 'package:fast_disbursement/main.dart';
import 'package:flutter/material.dart';

class QRScan extends StatefulWidget {
  QRScan({required this.transactions});

  List<Transaction> transactions;

  @override
  State<StatefulWidget> createState() => QRScanState();
}

class QRScanState extends State<QRScan> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var transaction = widget.transactions[currentIndex];
    var url =
        "https://img.vietqr.io/image/${transaction.bank}-${transaction.account}-compact.png?amount=${transaction.amount}&addInfo=${transaction.description}";
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${currentIndex + 1}/${widget.transactions.length}"),
            Text("Đang giải ngân cho", style: TextStyle(fontSize: 16)),
            Text(transaction.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                )),
            SizedBox(
              height: 16,
            ),
            Text("Số tiền: ${transaction.amount} VNĐ"),
            Text(transaction.description),
            SizedBox(
              height: 24,
            ),
            Image(image: NetworkImage(url)),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClickableWidget(
                    onTap: () {
                      setState(() {
                        currentIndex = max(0, currentIndex - 1);
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          "< Trước",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                if (currentIndex != widget.transactions.length - 1) ...[
                  ClickableWidget(
                      onTap: () {
                        setState(() {
                          currentIndex = min(
                              currentIndex + 1, widget.transactions.length - 1);
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Tiếp >",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ] else ...[
                  ClickableWidget(
                      onTap: () {
                        MyHomePageState.transactions.clear();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => MyHomePage()));
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Hoàn thành",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
