// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:excel/excel.dart' as excelIns;
import 'package:fast_disbursement/components/clickable_widget.dart';
import 'package:fast_disbursement/qr_scan.dart';
import 'package:fast_disbursement/utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống hỗ trợ giải ngân nhanh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static List<Transaction> transactions = [];
  static String selectedFile = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("HỆ THỐNG HỖ TRỢ GIẢI NGÂN NHANH FADIS",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue[800])),
            SizedBox(
              height: 24,
            ),
            if (transactions.isEmpty) ...[
              ClickableWidget(
                  onTap: () {
                    html.window.open(
                        "https://github.com/P-ro-VL/Fast-Disbursement/raw/main/FILE%20D%E1%BB%AE%20LI%E1%BB%86U%20M%E1%BA%AAU%20FADIS.xlsx",
                        "_blank");
                  },
                  child: Text(
                    "Tải file dữ liệu mẫu",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decorationColor: Colors.blue,
                        decoration: TextDecoration.underline),
                  )),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ClickableWidget(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ["xlsx"]);

                      if (result != null) {
                        try {
                          final fileBytes = result.files.first.bytes;
                          selectedFile = result.files.first.name;
                          var excel = excelIns.Excel.decodeBytes(fileBytes!);
                          bool bypassHeader = false;
                          for (var table in excel.tables.keys) {
                            for (var row in excel.tables[table]!.rows) {
                              try {
                                if (!bypassHeader) {
                                  bypassHeader = true;
                                  continue;
                                }
                                var name = (row[0]!.value!.toString());
                                var stk = (row[1]!.value!.toString());
                                var bank = (row[2]!.value!.toString());
                                var amount =
                                    (int.parse(row[3]!.value!.toString()));
                                var description = (row[4]!.value!.toString());
                                transactions.add(Transaction(
                                    name: name,
                                    account: stk,
                                    bank: bank,
                                    amount: amount,
                                    description: description));
                              } catch (_) {
                                continue;
                              }
                            }
                          }

                          setState(() {});
                        } catch (e) {
                          print(e);
                          SnackbarUtils.showSnackbar(
                              SnackbarLevel.ERROR,
                              context,
                              "Đã có lỗi xảy ra. Vui lòng đảm bảo đã chọn file dữ liệu đúng định dạng mẫu.");
                        }
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          "Chọn file dữ liệu",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )),
              )
            ] else
              Text(
                "Tệp đã chọn: ${selectedFile}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            SizedBox(
              height: 24,
            ),
            if (transactions.isNotEmpty) ...[
              buildDataGrid(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClickableWidget(
                      onTap: () {
                        setState(() {
                          transactions.clear();
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Chọn lại",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )),
                  SizedBox(width: 20),
                  ClickableWidget(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) =>
                                QRScan(transactions: transactions)));
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Thực hiện",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget buildDataGrid() {
    return SfDataGrid(
      source: TransactionDataSource(transactions: transactions),
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'name',
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text(
                  'Tên',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
        GridColumn(
            columnName: 'account',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Số tài khoản',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'bank',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'Ngân hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'amount',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Số tiền',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        GridColumn(
            columnName: 'description',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'Nội dung chuyển khoản',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ))),
      ],
    );
  }
}

class Transaction {
  Transaction(
      {required this.name,
      required this.account,
      required this.bank,
      required this.amount,
      required this.description});

  String name;
  String account;
  String bank;
  int amount;
  String description;
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource({required List<Transaction> transactions}) {
    _employeeData = transactions
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'account', value: e.account),
              DataGridCell<String>(columnName: 'bank', value: e.bank),
              DataGridCell<int>(columnName: 'amount', value: e.amount),
              DataGridCell<String>(
                  columnName: 'description', value: e.description),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
