import 'package:flutter_buku_kas/widgets/list_cash_flow.dart';
import 'package:flutter/material.dart';

class CashFlowPage extends StatefulWidget {
  const CashFlowPage({Key? key}) : super(key: key);

  @override
  State<CashFlowPage> createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Cashflow'),
        backgroundColor: Colors.grey,
      ),
      body: const Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Expanded(flex: 20, child: ListCashFlow()),
          ],
        ),
      ),
    );
  }
}
